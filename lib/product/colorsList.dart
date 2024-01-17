import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/auth/authentication.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/models/colorsModel.dart';
import 'package:graffitineeds/models/preCartModel.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ColorsListPage extends StatefulWidget {
  String id;
  String? searchString;
  String? brandName;
  String? categoryName;
  String? brandId;
  String? description;
  List<ColorsModel>? colorsList;
  String? imageUrl;
  int? count;
  String hierarchicalParent;
  int? weight;

  ColorsListPage(
      {required this.id,
      this.count,
      this.searchString,
      this.brandId,
      this.brandName,
      this.categoryName,
      this.description,
      this.imageUrl,
      this.colorsList,
      this.weight,
      required this.hierarchicalParent});
  _ColorsListPageState createState() => new _ColorsListPageState();
}

class _ColorsListPageState extends State<ColorsListPage>
    with AutomaticKeepAliveClientMixin {
  List<ColorsModel> MainColorsList = [];

  formatColorList() {
    for (var element in widget.colorsList!) {
      MainColorsList.add(ColorsModel(
        id: element.id,
        hierarchicalParent: element.hierarchicalParent.toString(),
        colorName: element.colorName,
        hexColor: element.hexColor,
        externalId: element.externalId,
        nomNumber: element.nomNumber,
        brandName: element.brandName,
        weight: element.weight,
        size: element.size,
        description: element.description,
        categoryName: element.categoryName,
        price: element.price,
        balance: element.balance,
        checked: false,
        onCount: (el) {
          preCartList!.forEach((itm) {
            if (itm.id == element.id) {
              itm.quantity = el;
              _summaryCount();
            }
          });
        },
        onChecked: (check) {
          if (check) {
            preCartList!.add(PreCartItemModel(
              id: element.id,
              hierarchicalParent: element.hierarchicalParent.toString(),
              colorName: element.colorName,
              weight: int.parse(element.weight!),
              size: element.size,
              externalId: element.externalId,
              hexColor: element.hexColor,
              nomNumber: element.nomNumber,
              brandName: element.brandName,
              description: element.description,
              categoryName: element.categoryName,
              price: element.price,
              quantity: 1,
            ));

            print(preCartList!.length);
          }

          if (!check) {
            preCartList!.removeWhere((elementz) => element.id == elementz.id);
          }

          _summaryCount();
        },
      ));
    }
  }

  List<PreCartItemModel>? preCartList = [];

  /*Future<List<ColorsModel>> _getData() async {
    List<ColorsModel> colorsList = [];
    List<Nomenclature>? productsList = [];

    ProductApi? productApi;

    productApi = await ApiTest.getProducts(widget.searchString!, 0, 350);
    if (this.mounted)
      setState(() {
        productsList = productApi?.nomenclatures;
      });

    print("Всего в номенклатуре: ${productApi?.nomenclatures!.length}");

    productsList!.forEach((element) {
      if (element.hierarchicalParent == int.parse(widget.hierarchicalParent)) {
        String hexz = "#FFFFFF";
        String hex;
        // print(element.attributes);
        element.attributes!.forEach((key, value) {
          if (this.mounted)
            setState(() {
              value != null
                  ? hex = value.toString().replaceAll(RegExp("#"), "")
                  : hex = hexz.toString().replaceAll(RegExp("#"), "");
              ; //value
              colorsList.add(ColorsModel(
                id: element.id,
                hierarchicalParent: element.hierarchicalParent.toString(),
                colorName: element.name,
                hexColor: hex,
                nomNumber: element.nomNumber,
                brandName: widget.brandName,
                description: widget.description,
                categoryName: widget.categoryName,
                price: double.parse(element.cost!).toInt(),
                balance: double.parse(element.balance!).toInt(),
                checked: false,
                onCount: (el) {
                  preCartList!.forEach((itm) {
                    if (itm.id == element.id) {
                      setState(() {
                        itm.quantity = el;
                        _summaryCount();
                      });
                    }
                  });
                },
                onChecked: (check) {
                  if (check) {
                    preCartList!.add(PreCartItemModel(
                        id: element.id,
                        hierarchicalParent: element.hierarchicalId.toString(),
                        colorName: element.name,
                        price: double.parse(element.cost!).toInt(),
                        hexColor: hex,
                        quantity: 1));
                    setState(() {});
                    print(preCartList!.length);
                  }

                  if (!check) {
                    preCartList!
                        .removeWhere((elementz) => element.id == elementz.id);
                  }

                  _summaryCount();
                },
              ));
            });
        });
      }
    });
    return colorsList;
  }*/

  @override
  void initState() {
    super.initState();
    formatColorList();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("пользователи");

  String _searchString = "";
  Future _addToCart(PreCartItemModel cart, User? _user) async {
    return _usersRef
        .doc(_user!.uid)
        .collection("корзина")
        .doc(cart.id.toString())
        .set({
      "id": cart.id.toString(),
      "categoryId": cart.hierarchicalParent,
      "brandId": widget.brandId,
      "nomNumber": cart.nomNumber,
      "brandName": cart.brandName,
      "externalId": cart.externalId,
      "imageUrl": widget.imageUrl,
      "searchString": widget.searchString,
      "categoryName": cart.categoryName,
      "наименование": cart.colorName,
      "количество": cart.quantity,
      "цена": cart.price,
      "вес": cart.weight ?? 350,
      // "размер": cart.size ?? "20х7х7",
      "описание": cart.description,
      HEX: cart.hexColor,
      "modifiers": false,
      'modifiersList': []
    });
  }

  int summary = 0;
  int _summaryCount() {
    summary = 0;
    preCartList!.forEach((l) {
      setState(() {
        summary += l.price! * l.quantity!;
      });
    });
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        bottomNavigationBar: preCartList!.length > 0
            ? Container(
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, top: 5),
                            child: Text(
                              "Выбрано (${preCartList!.length}) шт.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10, top: 5),
                            child: Text(
                              "На сумму ${summary}₽",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          )
                        ]),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  User? _user =
                                      FirebaseAuth.instance.currentUser;
                                  if (_user != null) {
                                    preCartList!.forEach((cart) async {
                                      await _addToCart(cart, _user)
                                          .whenComplete(() {
                                        if (mounted)
                                          setState(() {
                                            print("added");
                                          });
                                      });
                                    });
                                    Navigator.pop(context);
                                    showTopSnackBar(
                                      context,
                                      CustomSnackBar.success(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                        icon: Icon(null),
                                        message:
                                            "+${preCartList?.length} шт. на сумму ${summary}₽ добавлено в корзину",
                                      ),
                                      displayDuration:
                                          Duration(milliseconds: 500),
                                      onTap: () {},
                                    );
                                  } else
                                    _warningTop();
                                },
                                child: Container(
                                  width: 200,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 0.8,
                                        blurRadius: 0.1,
                                        offset: Offset(
                                            0, 5), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                      child: Text(
                                    "ПРИМЕНИТЬ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "Circe",
                                    ),
                                  )),
                                ))))
                  ],
                ),
              )
            : Container(
                height: 0,
              ),
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          leading: SizedBox(),
          flexibleSpace: Container(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      color: Colors.transparent,
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.arrow_downward_rounded,
                        size: 28.0,
                      )))),
          backgroundColor: Colors.transparent,
          title: Text(
            "Выбрать цвет",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: Column(children: [
          _searchBar(_searchString),
          Flexible(
              child: GridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 3.0,
                  children: _searchString == "" ? MainColorsList : searchList))
        ]));
  }

  late TextEditingController _textController;
  void _warningTop() async {
    // await _addToCart();
    showTopSnackBar(
      context,
      CustomSnackBar.error(
        icon: Icon(null),
        message: "Зарегистрируйтесь или войдите в профиль",
      ),
      displayDuration: Duration(milliseconds: 500),
      onTap: () {
        showCupertinoModalPopup(
            context: context, builder: (builder) => AuthPage());
      },
    );
  }

  List<ColorsModel> searchList = [];
  _searchBar(String searchString) {
    double widthSize = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(children: [
      Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 10, bottom: 5),
        width: widthSize,
        height: 40,
        child: CupertinoSearchTextField(
          controller: _textController,
          itemColor: Colors.black45,
          //  prefixInsets: EdgeInsets.only(left: 8, right: 3),
          placeholder: "Поиск",
          //   placeholderStyle: TextStyle(color: Colors.black),
          style:
              TextStyle(color: Colors.black, fontFamily: "Circe", fontSize: 14),
          decoration: BoxDecoration(
            color: Color(0xFFE4E4E4),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          onChanged: (val) {
            searchList = [];
            if (mounted)
              setState(() {
                _searchString = val.toLowerCase();
              });

            if (mounted)
              setState(() {
                searchList = MainColorsList.where((t) =>
                        t.colorName!.toLowerCase().contains(val.toLowerCase()))
                    .toList();
              });
            didUpdateWidget(ColorsListPage(
              id: widget.id,
              hierarchicalParent: widget.hierarchicalParent,
              colorsList: widget.colorsList,
            ));
            didChangeDependencies();
          },
          onTap: () {
            didChangeDependencies();
          },
          onSuffixTap: () {
            didChangeDependencies();
            if (mounted)
              setState(() {
                _searchString = "";
              });
            _textController.clear();
            didChangeDependencies();
          },
        ),
      )
    ]));
  }

  bottomBarCheck(ColorsModel item) {
    if (item.checked) print(item.checked);
  }

  @override
  bool get wantKeepAlive => true;
}
