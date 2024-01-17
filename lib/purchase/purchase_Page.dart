import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/boxberry/api_boxberry.dart';
import 'package:graffitineeds/purchase/boxberryListCities.dart';
import 'package:graffitineeds/boxberry/deliveryCostModel.dart';
import 'package:graffitineeds/boxberry/pvzModel.dart';
import 'package:graffitineeds/helpers/notifications.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/models/cartItemModel.dart';
import 'package:graffitineeds/models/orderListModel.dart';
import 'package:graffitineeds/models/product.dart';
import 'package:graffitineeds/services/api_orderSbis.dart';
import 'package:graffitineeds/services/api_yookassa.dart';
import 'package:graffitineeds/services/apitest.dart';
import 'package:graffitineeds/services/order_services.dart';
import 'package:graffitineeds/services/user_service.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:requests/requests.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class OrderConfirm extends StatefulWidget {
  List<CartItemModel> cartList;
  int? summary;
  String? userId;
  Map<String, dynamic>? clientInfo;
  OrderConfirm(
      {Key? key,
      required this.cartList,
      this.summary,
      this.userId,
      this.clientInfo});

  OrderConfirmState createState() => new OrderConfirmState();
}

TextStyle topMenulight = TextStyle(
  color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
  fontSize: 16,
);

enum DeliveryMethod { del, loc }

enum PayMethod { mon, apple, card }

class OrderConfirmState extends State<OrderConfirm> {
  String? orderId;
  DeliveryMethod _deliveryMethod = DeliveryMethod.del;
  PayMethod _payMethod = PayMethod.card;
  bool deliveryCheck = false;
  List<OrderListModel> convertedCart = [];
  User user = FirebaseAuth.instance.currentUser!;
  String? deliveryAddress = "";
  int deliveryCost = 0;
  Pvz? selectedPvz;
  OrderServices _orderServices = OrderServices();
  convertCart(List<CartItemModel> cartList) {
    cartList.forEach((cart) {
      convertedCart.add(OrderListModel(
        id: cart.id!,
        price: cart.price!,
        name: cart.name,
        categoryName: cart.categoryName!,
        hexColor: cart.hexColor!,
        quantity: cart.quantity!,
        imageUrl: cart.imageUrl!,
        modifier: cart.modifiers ?? false,
        modifiers: cart.modifiersList ?? [],
        description: cart.description!,
        hierarchicalId: cart.nomNumber!,
        searchString: cart.searchString!,
        brandName: cart.brandName!,
        hierarchicalParent: cart.categoryId!,
        nomNumber: cart.nomNumber!,
      ));
    });
  }

  TextEditingController firstnameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  Future<bool> _checkBalance(List<CartItemModel> cartList) async {
    ProductApi? productApi;
    bool _available = true;
    cartList.forEach((cart) async {
      productApi = await ApiTest.getProducts(cart.nomNumber!, 0, 2);

      if (double.parse(productApi!.nomenclatures!.last.balance!).toInt() <
          cart.quantity!) {
        setState(() {
          _available = false;
          print(_available);
        });
      }
    });

    return _available;
  }

  DeliveryCost? _deliveryCost;
  int delivery_period = 0;
  deliveryCostApi(String pvzCode, int weight) async {
    setState(() {
      deliveryCheck = true;
    });
    await ApiBoxberry.deliveryCost(pvzCode, weight).then((value) {
      setState(() {
        _deliveryCost = value;
      });
    });
    setState(() {
      deliveryCheck = false;
      deliveryCost = double.parse(_deliveryCost!.Price!).toInt() + 100;
    });
  }

  int weightDelivery = 0;
  weightCount() {
    widget.cartList.forEach((element) {
      weightDelivery += element.weight! * element.quantity!;
    });
    print(weightDelivery);
  }

  String? paymentStatus;
  String? pay_id;
  Stream<String?> payStatus(
    String pay_id,
    String id,
    int total,
    String userId,
    List<CartItemModel> cartList,
  ) async* {
    String _token = ApiYookassa.token!;
    String url = "https://api.yookassa.ru/v3/payments/$pay_id";
    String basicAuth = 'Basic ' + base64.encode(utf8.encode('$_token'));
    var headers = {
      "Authorization": basicAuth,
      'Idempotence-Key': Uuid().v4(),
      'Content-Type': "application/json"
    };
    for (int i = 0; i <= 300; i++) {
      await Future.delayed(Duration(seconds: 1));
      Response response = await Requests.get(url, headers: headers);

      setState(() {
        paymentStatus = response.json()["status"];
      });
      print(paymentStatus);
      yield paymentStatus;
      if (response.json()["status"] == "succeeded" ||
          response.json()["status"] == "waiting_for_capture") {
        await _checkBalance(cartList).then((value) {
          if (!value) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            dialogWarning(
                "При оформлении заказа\nНе оказалось в наличии товара");
          } else {
            _conformationState(id, userId, total, payid!);
          }
        });
        break;
      }
    }
  }

  _onSubmit(
    String id,
    int total,
    String userId,
    List<CartItemModel> cartList,
  ) async {
    setState(() {});

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(child: Text('Подтвердите заказ')),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Рекомендуется не закрывать приложение. Вы уверены?",
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                              child: Text(
                                'Да',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                //Navigator.pop(context);
                                Uri? yooUrl;
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(mainColor),
                                            ),
                                          ),
                                          Center(
                                            child: Text("Начало обработки...",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 14,
                                                    color: Colors.white)),
                                          )
                                        ],
                                      );
                                    });
                                await ApiYookassa.payCheck(
                                        userInfo,
                                        widget.cartList,
                                        widget.summary!,
                                        orderId!)
                                    .then((val) async {
                                  print(val);
                                  setState(() {
                                    yooUrl = Uri.parse(val["url"]);
                                    payid = val["id"];
                                    startPay = true;
                                  });
                                  Navigator.of(context).pop();
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StreamBuilder<String?>(
                                            stream: payStatus(
                                                payid!,
                                                orderId!,
                                                widget.summary!,
                                                UserServices().getUserId(),
                                                widget.cartList),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData)
                                                paymentStatus = snapshot.data;

                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          new AlwaysStoppedAnimation<
                                                              Color>(mainColor),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: snapshot.hasData
                                                        ? Column(children: [
                                                            Text(
                                                              "Статус платежа: ${snapshot.data!}",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              10),
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 90,
                                                                  child: Center(
                                                                      child:
                                                                          Text(
                                                                    "Отменить",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        decoration:
                                                                            TextDecoration
                                                                                .none,
                                                                        color: Colors
                                                                            .white),
                                                                  )),
                                                                  height: 30,
                                                                ))
                                                          ])
                                                        : Text(
                                                            "Обработка заказа",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white)),
                                                  )
                                                ],
                                              );
                                            });
                                      });
                                });

                                if (await canLaunchUrl(yooUrl!)) {
                                  await launchUrl(yooUrl!).whenComplete(() {
                                    print("complete");
                                  });
                                }
                              }),
                        ),
                      ]),
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Отмена',
                          style: TextStyle(color: Colors.black),
                        ),
                      ))
                ],
              )
            ]);
      },
    );
  }

  _popUp(String id) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 35,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child:
                Text("Заказ №${id} оформлен!", style: TextStyle(fontSize: 20)),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                child: Text(
                  'ОК',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  setState(() {});
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState(() {});
                  Navigator.pop(context);
                }),
            /*   SizedBox(
              width: 10,
            ),
            RaisedButton(
                color: Colors.white,
                child: Text(
                  'Узнать статус',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return DefaultTabBar();
                      });
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => OrderHistory(),
                      fullscreenDialog: true));
                }),*/
          ])
        ])));
  }

  String mainPhone = "";
  String mainAddress = "";
  String mainEmail = "";
  String mainText = "";
  _getMainEmail() async {
    await FirebaseFirestore.instance
        .collection("контакты")
        .doc("контакты")
        .get()
        .then((value) {
      setState(() {
        mainEmail = value.data()!["почта"];
        mainAddress = value.data()!["адрес"];
        mainText = value.data()!["текст"];
        mainPhone = value.data()!["номер"];
      });
    });
  }

  List<Modifiers>? modList = [];
  convertModifiers(List<dynamic> mod, int price) {
    double modPrice = 0, countMod = 0;
    modPrice = price.toDouble();

    mod.forEach((element) {
      modList!.add(Modifiers.fromMap(element));
    });

    if (modList!.isNotEmpty) {
      modList!.forEach((element) {
        countMod += element.baseCount!;
      });
      modPrice = (price / countMod);
      modList!.forEach((element) {
        cartOrderFinal.add({
          "nomNumber": element.nomNumber!,
          "count": element.baseCount,
          "cost": modPrice,
          "priceListId": 116,
          "name": element.name,
        });
      });
    }
  }

  List<Map<String, dynamic>> cartOrderFinal = [];
  _cartMapList() {
    List<dynamic> modifikators = [];
    int price = 0;
    for (var element in widget.cartList) {
      if (element.modifiers == false) {
        cartOrderFinal.add({
          "nomNumber": element.nomNumber!,
          "count": element.quantity!,
          "cost": element.price!,
          "priceListId": 116,
          "name": element.name,
        });
      } else {
        price += element.price!;
        modifikators.addAll(element.modifiersList!);
      }
    }

    if (modifikators.isNotEmpty) {
      convertModifiers(modifikators, price);
    }

    print(cartOrderFinal);
  }

  Map<String, dynamic> userInfo = {};
  @override
  void initState() {
    super.initState();
    _getMainEmail();
    convertedCart.clear();
    convertCart(widget.cartList);
    orderId = widget.userId! + "-" + Uuid().v1().toUpperCase().substring(0, 6);
    userInfo = widget.clientInfo!;

    weightCount();
    _cartMapList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  dialogWarning(String text) {
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
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ThemaMode.isDarkMode ? Color.fromRGBO(20, 20, 20, 1) : Colors.white,
      appBar: AppBar(
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            iconSize: 24,
            color: mainColor,
            icon: Icon(
              Icons.close,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          elevation: 0.0,
          backgroundColor:
              !ThemaMode.isDarkMode ? Colors.white : Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            "ОФОРМИТЬ ЗАКАЗ",
            style: TextStyle(
                color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          )),
      body: ListView(
        children: [
          for (int i = 0; i < convertedCart.length; i++) convertedCart[i],
          Container(
              margin: EdgeInsets.all(16),
              height: _deliveryMethod == DeliveryMethod.loc ? 220 : 285,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: !ThemaMode.isDarkMode ? Colors.white : darkBackColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(1.0, 3.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Способ получения",
                        style: TextStyle(
                          color: ThemaMode.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                        ),
                      )),
                  Theme(
                      data: ThemeData(
                        unselectedWidgetColor: ThemaMode.isDarkMode
                            ? Colors.white70
                            : Colors.black,
                      ),
                      child: RadioListTile<DeliveryMethod>(
                          activeColor: mainColor,
                          toggleable: true,
                          title: Container(
                              child: Text("Доставка Boxberry",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: ThemaMode.isDarkMode
                                          ? Colors.white
                                          : Colors.black))),
                          value: DeliveryMethod.del,
                          groupValue: _deliveryMethod,
                          onChanged: (DeliveryMethod? value) {
                            setState(() {
                              _deliveryMethod = value!;
                              // print(_deliveryMethod);
                            });
                          })),
                  if (_deliveryMethod == DeliveryMethod.del)
                    Expanded(
                        //  fit: FlexFit.loose,
                        child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: Column(children: [
                              Expanded(
                                flex: 0,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.map_outlined,
                                      size: 18,
                                      color: ThemaMode.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                        child: Text(
                                      selectedPvz?.Address == null
                                          ? "Выберите пункт доставки"
                                          : selectedPvz!.Address.toString(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: ThemaMode.isDarkMode
                                              ? Colors.white
                                              : Colors.black54),
                                    )),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    deliveryCheck
                                        ? LoadingAnimationWidget
                                            .horizontalRotatingDots(
                                            color: mainColor,
                                            size: 20,
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                                Text(
                                                    _deliveryCost != null
                                                        ? "+${double.parse(_deliveryCost!.Price!).toInt() + 100}₽"
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: ThemaMode
                                                                .isDarkMode
                                                            ? Colors.white
                                                            : Colors.black)),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                        _deliveryCost != null
                                                            ? "~ ${_deliveryCost!.DeliveryPeriod} суток"
                                                            : "",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: ThemaMode
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors
                                                                    .black)))
                                              ])
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Divider(
                                    height: 1,
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    BuildContext buildContext = context;
                                    showCupertinoModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          BoxBerryCitiesListPage(
                                        buildContext: buildContext,
                                      ),
                                    ).then((value) {
                                      if (!mounted) return;
                                      if (value != null)
                                        setState(() {
                                          selectedPvz = value;
                                          deliveryAddress =
                                              selectedPvz?.Address!;
                                          deliveryCostApi(selectedPvz!.Code,
                                              weightDelivery);
                                        });
                                    });
                                  },
                                  child: Container(
                                      height: 35,
                                      width: 135,
                                      margin: EdgeInsets.only(top: 30),
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                      ),
                                      child: Center(
                                          child: Text('Изменить',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ))))),
                            ])))
                  else
                    Container(),
                  Theme(
                      data: ThemeData(
                        unselectedWidgetColor: ThemaMode.isDarkMode
                            ? Colors.white70
                            : Colors.black,
                      ),
                      child: RadioListTile<DeliveryMethod>(
                          toggleable: true,
                          activeColor: mainColor,
                          title: Text(
                            "Cамовывоз",
                            style: TextStyle(
                                fontSize: 16,
                                color: ThemaMode.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          value: DeliveryMethod.loc,
                          groupValue: _deliveryMethod,
                          onChanged: (DeliveryMethod? value) {
                            setState(() {
                              _deliveryMethod = value!;
                            });
                            print(_deliveryMethod);
                          })),
                  if (_deliveryMethod == DeliveryMethod.loc)
                    GestureDetector(
                        onTap: () async {
                          await _openMaps();
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 35),
                            child: Column(children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "г. Краснодар, ул. Карасунская, 95",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ThemaMode.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Divider(
                                    height: 1,
                                  )),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Это где?",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: ThemaMode.isDarkMode
                                          ? Colors.white
                                          : Colors.black38,
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            ])))
                  else
                    Container()
                ],
              )),
          Container(
              margin: EdgeInsets.all(16),
              height: 90,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ThemaMode.isDarkMode ? darkBackColor : Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(1.0, 3.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Способ оплаты",
                        style: TextStyle(
                          color: ThemaMode.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                        ),
                      )),
                  /*  RadioListTile<PayMethod>(
                      activeColor: mainColor,
                      title: Container(
                          child: Text(
                        "Карта",
                      )),
                      value: PayMethod.card,
                      groupValue: _payMethod,
                      onChanged: (PayMethod? value) {
                        setState(() {
                          _payMethod = value!;
                          print(_payMethod);
                        });
                      }),*/
                  RadioListTile<PayMethod>(
                      activeColor: mainColor,
                      title: Container(
                          child: Text(
                        "Картой",
                        style: TextStyle(
                            color: ThemaMode.isDarkMode
                                ? Colors.white
                                : Colors.black),
                      )),
                      value: PayMethod.card,
                      groupValue: _payMethod,
                      onChanged: (PayMethod? value) {
                        setState(() {
                          _payMethod = value!;
                          print(_payMethod);
                        });
                      }),
                ],
              )),
          contatctPerson(),
          Container(
              // height: MediaQuery.of(context).size.height / 5.5,
              child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                Container(
                    child: Column(children: <Widget>[
                  _deliveryMethod != DeliveryMethod.loc
                      ? Container(
                          margin: EdgeInsets.only(left: 25, right: 30),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "Доставка:",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ThemaMode.isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                    )),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Row(children: [
                                      Text(
                                        "~$deliveryCost руб ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: ThemaMode.isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      Tooltip(
                                          margin: EdgeInsets.only(
                                              left: 30, right: 20),
                                          textAlign: TextAlign.center,
                                          message:
                                              "Доставка оплачивается отдельно при получении в пункте выдачи",
                                          child: Icon(Icons.info_outline,
                                              size: 16,
                                              color: ThemaMode.isDarkMode
                                                  ? Colors.white24
                                                  : Colors.black54))
                                    ]))
                              ]))
                      : Text(""),
                  Container(
                      margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "ИТОГ:",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: ThemaMode.isDarkMode
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Column(children: [
                                  Text(
                                    "${widget.summary} руб",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: ThemaMode.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ])
                              ]))),
                  new Container(
                      margin: EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 40),
                      width: double.infinity,
                      height: 50,
                      // ignore: deprecated_member_use
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // disabledBackgroundColor: Colors.transparent,
                            backgroundColor: mainColor,
                          ),
                          onPressed: () async {
                            //  await yookassa();

                            if ((_deliveryMethod == DeliveryMethod.del &&
                                (selectedPvz?.Address == null))) {
                              dialogWarning("Выберите пункт доставки");
                            } else if (firstnameController.text.length < 2) {
                              dialogWarning("Заполните ФИО");
                            } else
                              await _onSubmit(orderId!, widget.summary!,
                                  UserServices().getUserId(), widget.cartList);
                          },
                          child: Text("Перейти к оплате",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)))),
                ]))
              ]))
        ],
      ),
    );
  }

  String? payid;
  bool startPay = false;

  /*String _mainEmail = "";
  _getMainEmail() async {
    await FirebaseFirestore.instance
        .collection("контакты")
        .doc("текст")
        .get()
        .then((value) {
      setState(() {
        _mainEmail = value.data()!["почта"];
      });
    });
  }*/

  contatctPerson() {
    return Container(
        margin: EdgeInsets.all(16),
        height: 180,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ThemaMode.isDarkMode ? darkBackColor : Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1.0, 3.0),
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                margin: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  "Получатель",
                  style: TextStyle(
                    color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                )),
            /* Padding(
                            padding: EdgeInsets.only(top: 10, right: 20),
                            child: Icon(
                              CupertinoIcons.pencil,
                              color: mainColor,
                            ),
                          )*/
          ]),
          Row(children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 15),
              child: Icon(
                CupertinoIcons.person,
                size: 14,
                color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 3, top: 15),
                child: Text(
                  "Заполните ФИО",
                  style: TextStyle(
                    fontSize: 13,
                    color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
          ]),
          Flexible(
              flex: 0,
              child: Row(children: [
                Flexible(
                    child: inputBox("Иванов Иван Иванович", firstnameController,
                        TextInputType.name)),
              ])),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Icon(
                CupertinoIcons.phone,
                size: 14,
                color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 3, top: 10),
                child: Text(
                  "Номер телефона:",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
            Container(
                margin: EdgeInsets.only(left: 5, top: 10),
                child: Text(
                  "${userInfo["phone"]}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Icon(
                CupertinoIcons.mail,
                size: 14,
                color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 3, top: 10),
                child: Text(
                  "Почта:",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
            Container(
                margin: EdgeInsets.only(left: 5, top: 10),
                child: Text(
                  "${userInfo["email"]}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
          ]),
        ]));
  }

  void _conformationState(
      String id, String userId, int total, String payid) async {
    print(userId);
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                ),
              ),
              Center(
                child: Text("Оформление заказа",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                        fontSize: 14,
                        color: Colors.white)),
              )
            ],
          );
        });

    await SbisOrder.createOrder(
            userInfo,
            deliveryAddress!,
            _deliveryMethod == DeliveryMethod.del ? false : true,
            cartOrderFinal,
            payid)
        .then((value) async {
      print(cartOrderFinal);
      if (value["message"] == "null") {
        _orderServices.createOrder(
            userId,
            id,
            "В обработке",
            convertedCart,
            _timeToString(_payMethod),
            widget.summary!,
            value["saleKey"],
            payid,
            "");
        if (_deliveryMethod == DeliveryMethod.del) {
          await ApiBoxberry.createDelivery(
              orderId!,
              convertedCart,
              {
                "fio": firstnameController.text,
                "phone": userInfo["phone"].toString().substring(2, 12),
                "email": userInfo["email"],
              },
              selectedPvz!,
              weightDelivery,
              deliveryCost);
        }
        convertedCart.clear();

        await UserServices()
            .usersRef
            .doc(UserServices().getUserId())
            .collection("корзина")
            .get()
            .then((value) {
          for (DocumentSnapshot sn in value.docs) {
            sn.reference.delete();
          }
        });

        showCupertinoModalPopup(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return _popUp(id);
            });
      } else {
        Navigator.pop(context);
        dialogWarning("При оформлении заказа\nНе оказалось в наличии товара");
      }
    });

    //CREATING ORDER

    /* ApiUnisender.sendEmail(
        user.email!,
        mainEmail,
        _mailOrder(newId, convertedCart, user.email!, widget.summary!,
            number: mainPhone, text: mainText),
        "Спасибо за заказ! №$newId");*/
    //CLEARING CART
    /* await FirebaseFirestore.instance.collection("mail").add({
      "to": _mainEmail,
      "message": {
        "subject": 'Новый заказ №${id.toUpperCase().substring(0, 7)}',
        "html": _mailOrder(id.toUpperCase().substring(0, 7), convertedCart,
            user.email!, widget.summary!),
      },
    });
    /////// ОТПРАВЛЯЕТ ИНФО КЛИЕНТУ
    await FirebaseFirestore.instance.collection("mail").add({
      "to": user.email,
      "message": {
        "subject": 'Заказ №${id.toUpperCase().substring(0, 7)} оформлен',
        "html": _mailOrder(
          id.toUpperCase().substring(0, 7),
          convertedCart,
          user.email!,
          widget.summary!,
        )
      },
    });*/
  }

  Future<void> _openMaps() async {
    if (await canLaunchUrl(Uri.parse("https://yandex.com/maps/-/CCU7r4r1cB"))) {
      await launchUrl(Uri.parse("https://yandex.com/maps/-/CCU7r4r1cB"),
          mode: LaunchMode.externalApplication);
    } else {
      NotificationsToast().displayErrorMotionToast(
          "По какой-то причине не удалось перейти по ссылке", context);
    }
  }

  Widget inputBox(String title, TextEditingController texEditingController,
      TextInputType textInputType,
      {bool? secure}) {
    return Container(
        height: 30,
        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
        decoration: BoxDecoration(
          color: ThemaMode.isDarkMode ? darkBackColor : Colors.white,
          border: Border(
            top: BorderSide(color: borderColor),
            bottom: BorderSide(color: borderColor),
            left: BorderSide(color: borderColor),
            right: BorderSide(color: borderColor),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: TextFormField(
          onChanged: (value) {
            if (mounted) setState(() {});
          },
          cursorColor: mainColor,
          keyboardType: textInputType,
          autofocus: false,
          style: TextStyle(
            fontSize: 13,
            color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
          ),
          autocorrect: false,
          controller: texEditingController,
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(
              fontSize: 12,
              color: ThemaMode.isDarkMode ? Colors.white : Colors.black,
            ),
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: mainColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ));
  }

  String _mailOrder(
      String nordder, List<OrderListModel> items, String email, int itog,
      {String? number, String? text}) {
    var message =
        '<center><img src="https://vk.cc/cgpmtc"></center></br><h3>Заказ оформлен</h3><p>$text.</p><p>Если у вас возникнут вопросы, вы можете связаться с нами по телефону $number или ответить на это сообщение.</p><center><h2>Заказ №$nordder</h2></center></br><table><table border="1" width="100%" cellpadding="5"><tr><th>Товар</th><th>Цена</th><th>Кол-во</th><th>Сумма</th></tr>';
    var row = '';
    for (int i = 0; i < items.length; i++) {
      row +=
          '<tr><td>${items[i].name}</td><td>${items[i].price}, руб.</td><td>${items[i].quantity} шт.</td><td>${items[i].price}, руб.</td></tr>';
    }
    var itogo =
        '<tr><td colspan="3" style="text-align:left"><b>ИТОГО:</b></td><td><b>$itog, руб.</b></td></tr></table>';
    var info = '<h3>Ваши данные</h3><p><b>Почта:</b> $email</p>';
    print("mail send");

    return message + row + itogo + info;
  }

  String _timeToString(PayMethod pay) {
    switch (pay) {
      case PayMethod.apple:
        return "Apple Pay";
      case PayMethod.mon:
        return "Наличные";
      case PayMethod.card:
        return "Карта";

      default:
        return "Наличные";
    }
  }
}
