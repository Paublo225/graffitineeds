import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/cart/counterCard.dart';
import 'package:graffitineeds/models/productmodel.dart';
import 'package:graffitineeds/product/count.dart';
import 'package:graffitineeds/product/filter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
//import 'package:provider/provider.dart';
import '../main.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:expandable/expandable.dart';

// ignore: must_be_immutable
class ItemScreen extends StatefulWidget {
  String id;
  String imageUrl;
  String title;
  String name;
  String category;
  String price;
  String description;
  String quantity;

  Map<dynamic, dynamic> opt;
  int qpak;
  int minKolvo;

  PageController page;
  ItemScreen({
    this.id,
    this.imageUrl,
    this.name,
    this.title,
    this.category,
    this.price,
    this.opt,
    this.description,
    this.quantity,
    this.minKolvo,
    this.qpak,
    this.page,
  });

  Map toMap() => {
        "id": id,
        "imageUrl": imageUrl,
        "name": title,
        "price": price,
        "опт": opt,
        "qpak": qpak,
        "мин_кол-во": minKolvo,
        "quantity": quantity,
      };
  _ItemScreenState createState() => new _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen>
    with SingleTickerProviderStateMixin {
  int count = 1;
  int kolvo = 1;
  int summa = 0;
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  bool _state = false;
  @override
  Widget build(BuildContext context) {
    List<String> images = [
      widget.imageUrl,
      "lib/assets/lv4.jpg",
    ];
    return Scaffold(
        bottomNavigationBar: _bottombtn(),
        body: CustomScrollView(slivers: [
          SliverAppBar(
            collapsedHeight: 320,
            flexibleSpace: Stack(
              children: <Widget>[
                /*  Center(
                      child: Hero(
                          tag: "assetPath",
                          child: Image(
                              image: AssetImage(widget.imageUrl),
                              //   height: 350.0,
                              fit: BoxFit.fill))),*/
                Container(
                  child: Hero(
                      tag: "assetPath",
                      child: Image(
                        height: 320.0,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        image: AssetImage(images[0]),
                      )),
                ),
                /* Padding(
                    padding: EdgeInsets.only(left: 30, top: 210),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[Text(widget.price)]),
                    ),
                  ),*/
                /* Padding(
                    padding: EdgeInsets.only(right: 10, top: 250),
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        'В наличии: 124 штук',
                        style: TextStyle(
                            //   color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black38,
                                offset: Offset(3.0, 3.0),
                              ),
                            ]),
                      ),
                    ),
                  )*/

                Container(
                  height: 45,
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  alignment: Alignment.topRight,
                  child: RawMaterialButton(
                    //  padding: EdgeInsets.all(10.0),
                    elevation: 1.0,
                    onPressed: () => Navigator.pop(context),
                    shape: CircleBorder(),
                    fillColor: mainColor,
                    child: Icon(
                      Icons.close,
                      size: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          MultiSliver(
            pushPinnedChildren: true,
            children: [
              Column(
                children: <Widget>[
                  /////Нижняя часть//////////////////////////////////
                  /*   Container(
                  margin: EdgeInsets.only(left: 20, top: 5),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20, top: 5),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20, top: 5),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "${widget.price} ₽ ",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 30, bottom: 10),
                      child: CounterCart(
                        quantity: 1240,
                        count: 1,
                        price: 245,
                        kolvo: 1,
                        onSelected: (size) {
                          count = size;
                          kolvo = count;
                          summa = (int.parse(widget.price) * kolvo);
                          // print(" MAIN ${widget.price}");
                        },
                        onSelected1: (size) {
                          count = size;
                          kolvo = count;
                          summa = int.parse(widget.price) * kolvo;

                          //print(" MAIN $_price");
                        },
                        onSelected2: (pr) {
                          // _price = pr;
                          // summa = _price * kolvo;
                        },
                      )),
                  Container(
                      padding: EdgeInsets.only(left: 10, top: 15),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Палитра",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      )),
                  Row(children: colors),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            // height: 0,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                //                   <--- left side
                                color: Colors.grey[350],
                                width: 1.0,
                              ),
                              top: BorderSide(
                                //                   <--- left side
                                color: Colors.grey[350],
                                width: 1.0,
                              ),
                            )),
                            margin:
                                EdgeInsets.only(top: 20, left: 20, bottom: 5),
                            //   child: Padding(
                            // padding: EdgeInsets.only(top: 15),
                            child: ExpandablePanel(
                                collapsed: null,
                                header: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Описание",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    )),
                                expanded: Text(
                                  "Отличный бюджетный вариант для граффити и покраски различных пластиковых, железных, бетонных, деревянных конструкций, подойдет для рекламы на асфальте.\n- Краска не растрескивается\n- Быстрое время высыхания\n- Бесперебойная работа\n- Высокая скорость нанесения\n- Нанесение на все виды поверхностей\n",
                                  softWrap: true,
                                ))),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            // height: 0,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                //                   <--- left side
                                color: Colors.grey[350],
                                width: 1.0,
                              ),
                            )),
                            margin: EdgeInsets.only(left: 20, bottom: 100),
                            //   child: Padding(
                            // padding: EdgeInsets.only(top: 15),
                            child: ExpandablePanel(
                                collapsed: null,
                                header: Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Характеристики",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    )),
                                expanded: Text(
                                  "- Объем: 250 мл\n- Цвет: Черный\n- В наличии 124 штук\n",
                                  softWrap: true,
                                ))),
                        // )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ]));
  }

  Widget _bottombtn() {
    // print(_cartState);

    return BottomAppBar(
        child: Container(
            height: MediaQuery.of(context).size.height / 8,
            child: new Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Column(children: <Widget>[
                    new Container(
                        //  margin: EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 40,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                            disabledColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            color: mainColor,
                            onPressed: () async {
                              _successTop();
                            },
                            child: Text("Добавить в корзину",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)))),
                  ]))
                ])));
  }

  void _successTop() async {
    // await _addToCart();
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        textStyle: TextStyle(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
        icon: null,
        message:
            "+${kolvo == 0 ? widget.qpak : kolvo} ${widget.title} добавлен в корзину",
      ),
      displayDuration: Duration(milliseconds: 500),
      onTap: () {
        /* Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation1, animation2) => Cart(
                    // indexTab: 1,
                    )));*/
      },
    );
    //_btnController.success();
    //  print("clicked");
  }

  void _warningTop() async {
    // await _addToCart();
    showTopSnackBar(
      context,
      CustomSnackBar.error(
        icon: null,
        message: "Выберите количество",
      ),
      displayDuration: Duration(milliseconds: 500),
      onTap: () {
        /* Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation1, animation2) => Cart(
                    // indexTab: 1,
                    )));*/
      },
    );
    //_btnController.error();
    //  print("clicked");
  }
}

List<ColorsStuff> colors = [
  ColorsStuff(
    color: Color(0xff31FF46),
  ),
  ColorsStuff(
    color: Color(0xff3161FF),
  ),
  ColorsStuff(
    color: Color(0xffF831FF),
  ),
  ColorsStuff(
    color: Color(0xffDFEFE9),
  ),
  ColorsStuff(
    color: Color(0xffFF3138),
  ),
];
