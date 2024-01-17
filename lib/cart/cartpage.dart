import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/models/cartItemModel.dart';
import 'package:graffitineeds/provider/user_pr.dart';
import 'package:graffitineeds/purchase/purchase_Page.dart';
import 'package:graffitineeds/services/apitest.dart';
import 'package:graffitineeds/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:connection_notifier/connection_notifier.dart';

// ignore: must_be_immutable
class Cart extends StatefulWidget {
  Cart({
    Key? key,
  });

  CartPageState createState() => CartPageState();
}

class CartPageState extends State<Cart> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String getUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

  ///REFRESH CONTROLLER
  bool _isLoading = false;
  bool _cartLoading = false;

  String? quantityProduct;
  String? description;
  String? hexColor;

  ///FIREBASE

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("пользователи");
  Future<List<CartItemModel>>? cartItemList;

  List<CartItemModel> MainCartList = [];
  List<CartItemModel> orderList = [];

  int totalAmount = 0;
  List<int> cartInfo = [0, 0];
  void calculateTotalAmount(Future<List<CartItemModel>> list) async {
    double res = 0;
    List<CartItemModel> superList = await list;
    superList.forEach((element) {
      res = res + element.price! * element.quantity!;
    });
    totalAmount = res.toInt();
  }

  bool userFound = true;
  Future<List<CartItemModel>> getCart() async {
    List<CartItemModel> cartList = [];
    cartList.clear();

    final userpr = Provider.of<UserProvider>(context, listen: false);
    try {
      await usersRef.doc(getUserId()).collection("корзина").get().then((value) {
        cartList.clear();
        MainCartList.clear();
        value.docs.forEach((doc) async {
          cartList.add(CartItemModel(
            id: doc.id,
            nomNumber: doc.get("nomNumber"),
            categoryId: doc.get("categoryId"),
            name: doc.get("наименование"),
            quantity: doc.get("количество"),
            price: doc.get("цена"),
            weight: doc.get("вес"),
            externalId: doc.get("externalId"),
            //  balance: await userpr.getBalance(doc.get("nomNumber")),
            hexColor: doc.get("hex"),
            imageUrl: doc.get("imageUrl"),
            categoryName: doc.get("categoryName"),
            searchString: doc.get("наименование"),
            brandName: doc.get("brandName"),
            description: doc.get("описание"),
            modifiers: doc.get("modifiers"),
            modifiersList: doc.data()["modifiersList"] ?? null,
            onBalance: (value) {},
            onDelete: () async {
              if (mounted)
                setState(() {
                  _cartLoading = true;
                });
              await UserServices()
                  .usersRef
                  .doc(UserServices().getUserId())
                  .collection("корзина")
                  .doc(doc.get("id"))
                  .delete();
              // cartList.clear();
              //cartItemList = getCart();
              cartList.removeWhere((element) => element.id == doc.get("id"));

              userpr.calculateTotalAmount(cartItemList!);
              userFound = true;
              userpr.changeLoading();
            },
            onMinus: (z) async {
              await UserServices()
                  .usersRef
                  .doc(UserServices().getUserId())
                  .collection("корзина")
                  .doc(doc.get("id"))
                  .update({'количество': z});
              userpr.calculateTotalAmount(cartItemList!);
              userpr.changeLoading();
            },
            onPlus: (z) async {
              await UserServices()
                  .usersRef
                  .doc(UserServices().getUserId())
                  .collection("корзина")
                  .doc(doc.get("id"))
                  .update({'количество': z});
              userpr.calculateTotalAmount(cartItemList!);
              userpr.changeLoading();
              if (mounted)
                setState(() {
                  _cartLoading = false;
                });
            },
          ));
        });
      });
    } catch (e) {
      userFound = false;
    }
    return cartList;
  }

  cartShit() async {
    cartItemList!.then((value) => value.clear());
    cartItemList = getCart();
  }

  int quantityTotal(List<CartItemModel> cartList) {
    int totalQuantity = 0;

    cartList.forEach((element) {
      totalQuantity += element.quantity!;
    });
    return totalQuantity;
  }

  int? okkk;
  @override
  void initState() {
    super.initState();

    cartItemList = getCart();

    okkk = quantityTotal(MainCartList);
    //getCartTotalSum();
    calculateTotalAmount(cartItemList!);
    curMode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Provider.of<ConnectivityProvider>(context, listen: false).dispose();
    super.dispose();
    // refreshController.dispose();
  }

  BuildContext? dialogContext;
  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    final RefreshController refreshController =
        RefreshController(initialRefresh: false);
    cartShit();
    return new ConnectionNotifierToggler(
        disconnected: _nointernet(),
        connected: Scaffold(
            bottomNavigationBar: _bottomInfo(),
            appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: Row(children: [
                  Text(
                    "Корзина",
                    style: TextStyle(
                        //  fontFamily: 'Avenir next',
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  )
                ])),
            body: _user != null
                ? FutureBuilder(
                    future: getCart(),
                    initialData: MainCartList,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CartItemModel>> snapshot) {
                      MainCartList = snapshot.requireData;

                      //  MainCartLisSt = snapshot.requireData;
                      return snapshot.requireData.isNotEmpty
                          ? SmartRefresher(
                              header: ClassicHeader(
                                refreshingText: "Обновляется",
                                releaseText: "Обновляется",
                                idleText: "Потяните вниз",
                                completeText: "Обновлено",
                              ),
                              onRefresh: () async {
                                try {
                                  await Future.delayed(
                                          Duration(milliseconds: 600))
                                      .then((value) {
                                    if (mounted) setState(() {});
                                  });
                                  refreshController.refreshCompleted();
                                } catch (e) {
                                  refreshController.refreshFailed();
                                }
                              },
                              controller: refreshController,
                              child: ListView(children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: MainCartList,
                                )
                              ]))
                          : _emptycart(
                              "Корзина пуста. Перейдите в меню и выберете понравившийся товар");
                    })
                : _emptycart(
                    "Зарегистрируйтесь, чтобы добавить товар в корзину")));

    //  : _nointernet();
  }

  _nointernet() {
    return Scaffold(
        body: Container(
      color: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("lib/assets/internet_check.png"))),
          ),
          Text(
            "Какие-то проблемы с соединением.\nПопробуйте обновить или подключиться к сети.",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
            //style: textStyle,
          ),
          GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.only(top: 45),
              width: 90,
              height: 40,
              child: Center(
                child: Text(
                  "Обновить",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black54)),
            ),
          )
        ],
      ),
    ));
  }

  bool orderBtn = true;
  Widget _bottomInfo() {
    final userpr = Provider.of<UserProvider>(context);
    List<int>? total;
    cartShit();

    cartItemList = getCart();

    return FutureBuilder(
        initialData: cartInfo,
        future: userpr.calculateTotalAmount(cartItemList!),
        builder: (builder, AsyncSnapshot<List<int>> snapshot) {
          if (snapshot.hasData) total = snapshot.data!;
          if (total![0] != 0)
            return BottomAppBar(
                child: Container(
                    height: 80,
                    child: new Row(
                        //  mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 1, left: 10),
                              child: snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                          new Text(
                                            "${total![0]} руб",
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          new Text(
                                            "Количество ${total![1]} шт.",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          )
                                        ])
                                  : new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                          new Text(
                                            "${snapshot.data![0]} руб",
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          new Text(
                                            "Количество ${snapshot.data![1]} шт.",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          )
                                        ])),
                          new Container(
                              margin: EdgeInsets.only(right: 20),
                              width: 120,
                              height: 40,
                              // ignore: deprecated_member_use
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(4.0),
                                    ),
                                    backgroundColor: mainColor,
                                  ),
                                  onPressed: () async {
                                    int timeout = 2000;

                                    int _totalCount = 0;
                                    bool _warng = false;
                                    await _getClientInfo();
                                    await Timer(Duration(milliseconds: timeout),
                                        () async {
                                      for (var element in MainCartList) {
                                        if (element.balance == null) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          _warng = true;
                                          //dialogWarning();
                                          print(
                                              "У одной из позиции не достаточно количества");
                                        }

                                        if (element.balance! >=
                                            element.quantity!) {
                                          orderList.add(element);
                                          _totalCount += (element.price! *
                                              element.quantity!);
                                        }
                                      }
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    });

                                    showCupertinoModalPopup(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return !_isLoading
                                              ? Dialog(
                                                  elevation: 0.0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          new AlwaysStoppedAnimation<
                                                              Color>(mainColor),
                                                    ),
                                                  ))
                                              : SizedBox.shrink();
                                        }).whenComplete(() => orderList
                                                .isNotEmpty &&
                                            !_warng
                                        ? showCupertinoModalPopup(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return OrderConfirm(
                                                  cartList: orderList,
                                                  userId: userorderId,
                                                  clientInfo: inputparams,
                                                  summary: _totalCount);
                                            }).whenComplete(() {
                                            if (mounted) setState(() {});
                                          })
                                        : _warng
                                            ? dialogWarning2()
                                            : dialogWarning());
                                    _totalCount = 0;
                                    setState(() {
                                      _warng = false;
                                    });
                                    orderList.clear();
                                  },
                                  child: Text("Оформить",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))))
                        ])));
          else
            return SizedBox();
        });
  }

  List<CartItemModel>? preOrderList = [];
  Future<List<CartItemModel>> orderComputation(CartItemModel el) async {
    await ApiTest.getProducts(el.nomNumber!, 0, 5).then((value) {
      if (double.parse(value.nomenclatures!.last.balance!).toInt() >=
          el.quantity!) {
        print(el.name);
        totalAmount += el.quantity! * el.price!;
        setState(() {
          preOrderList!.add(el);
        });
      }
      return null;
    });

    return preOrderList!;
  }

  Map<String, dynamic> inputparams = {};
  String? userorderId;
  _getClientInfo() async {
    await UserServices()
        .usersRef
        .doc(UserServices().getUserId())
        .get()
        .then((value) {
      setState(() {
        value.get("id") != null
            ? userorderId = value.get("id").toString()
            : userorderId =
                Uuid().v1().toUpperCase().substring(0, 4).toString();
        inputparams = {
          "lastname": value.get("Surname"),
          "name": value.get("Name"),
          'externalid':
              value.get("ExternalId"), //"a901c895-5a71-42ef-ae24-5195727aadce",
          'email': value.get("Электронная почта"),
          'phone': value.get("Телефон"),
        };
      });
    });
    /* Map<String, dynamic> outputParams = {};

    Map sid = await SbisUser.login().then(
            (value) => SbisUser.search_customer(value["result"], inputparams))
        as Map;

    await Future.delayed(Duration(seconds: 5)).then((value) {
      setState(() {
        outputParams = SbisUser.search_customer(sid["result"], inputparams);
      });
      SbisUser.search_customer(sid["result"], inputparams);
    });*/
    return inputparams;
  }

  _emptycart(String name) {
    return new Container(
      width: double.infinity,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          invertColors: ThemaMode.isDarkMode ? true : false,
          image: new AssetImage("lib/assets/подложка.JPG"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              //  margin: EdgeInsets.only(top: 15),
              child: Text(
            "Здесь пустовато...",
            style: TextStyle(
              fontSize: 26,
              color: ThemaMode.isDarkMode ? Colors.white : Colors.grey[600],
            ),
          )),
          Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: ThemaMode.isDarkMode ? Colors.white : Colors.grey[600],
                ),
              ))
        ],
      ),
    );
  }

  dialogWarning() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text('Возникла ошибка'),
            ),
            actions: [
              Center(
                child: Container(

                    //  margin: EdgeInsets.only(right: 10),
                    //height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        child: Text('ОК'),
                        onPressed: () {
                          Navigator.pop(context);
                        })),
              ),
            ],
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "При оформлении заказа\nНе оказалось в наличии товара",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          );
        });
  }

  dialogWarning2() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text('Возникла ошибка'),
            ),
            actions: [
              Center(
                child: Container(

                    //  margin: EdgeInsets.only(right: 10),
                    //height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        child: Text('ОК'),
                        onPressed: () {
                          Navigator.pop(context);
                        })),
              ),
            ],
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Не удалось перейти к оформлению\nПопробуйте еще раз",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
