/*import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';

import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flutter/material.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helpers/count_widget.dart';
import 'package:flutter/cupertino.dart';
import '../main.dart';

// ignore: must_be_immutable
class FlowerScreen extends StatefulWidget {
  String flowersID;
  int indexs;
  String title;
  int qpak;
  String price;
  FlowerScreen(
      {this.flowersID, this.title, this.indexs, this.qpak, this.price});

  @override
  _FlowerScreenState createState() => _FlowerScreenState();
}

class _FlowerScreenState extends State<FlowerScreen>
    with
        AutomaticKeepAliveClientMixin<FlowerScreen>,
        SingleTickerProviderStateMixin {
  int count = 0;
  FirebaseServices _firebaseServices = FirebaseServices();
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("users");
  User _user = FirebaseAuth.instance.currentUser;
  int _selectedTabbar = 0;
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  int kolvo = 0;
  int summa = 1;
  final controller = PageController();
  Future _addToCart() async {
    return _usersRef
        .doc(_user.uid)
        .collection("cart")
        .doc(widget.flowersID)
        .set({
      "name": widget.title,
      "cartid": widget.flowersID,
      "kolvo": kolvo == 0 ? widget.qpak : kolvo,
      "summa": summa == 1 ? int.parse(widget.price) * widget.qpak : summa,
    });
  }

  void _successTop() async {
    // await _addToCart();
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        icon: null,
        message:
            "+${kolvo == 0 ? widget.qpak : kolvo} ${widget.title} добавлен в корзину",
      ),
      displayDuration: Duration(milliseconds: 1500),
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
      displayDuration: Duration(milliseconds: 1500),
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

  _bottombtn(int size) {
    return Container(
      height: 100,
      //  padding: EdgeInsets.only(bottom: 50),
      child: Center(
        child: new Container(
            width: MediaQuery.of(context).size.height * 0.4,
            height: 40,
            child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    //side: BorderSide(color: Colors.black38),
                    // borderRadius: new BorderRadius.circular(30.0)
                    ),
                disabledColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: Colors.white,
                onPressed: () async {
                  // print(count);
                  // print(kolvo);
                  /// print(summa);
                  /*  if (size > count) {
                    await _addToCart();

                    _successTop();
                  }*/
                  if (count != 0) {
                    await _addToCart();

                    _successTop();
                    Navigator.pop(context);
                  } else {
                    print(count);
                    _warningTop();
                  }
                },
                child: Text("ДОБАВИТЬ В КОРЗИНУ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Avenir next')))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    count = widget.qpak;
    kolvo = widget.qpak;
    summa = int.parse(widget.price) * kolvo;

    return Scaffold(
      backgroundColor: mainColor,
      /* appBar: AppBar(
          elevation: 0.0,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          leading: Align(
            alignment: Alignment.bottomCenter,
            child: RawMaterialButton(
              padding: EdgeInsets.all(8.0),
              elevation: 0.0,
              onPressed: () => Navigator.pop(context),
              shape: CircleBorder(),
              fillColor: Colors.white,
              child: Icon(
                CupertinoIcons.back,
                size: 22.0,
                color: mainColor,
              ),
            ),
          ),
        ),*/
      body: FutureBuilder(
        future: _firebaseServices.productsRef.doc(widget.flowersID).get(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // Firebase Document Data Map
            Map<String, dynamic> documentData = snapshot.data.data();

            var _price = int.parse(documentData["price"]);
            var _quantity = int.parse(documentData["quantity"]);
            String _optString = documentData['опт'];
            Map<dynamic, dynamic> _opt = jsonDecode(_optString);

            // var _minKolvo = documentData['мин_кол-во'];
            int qpak = documentData['qpak'];

            return CustomScrollView(slivers: [
              SliverAppBar(
                  leading: GestureDetector(onTap: () => Navigator.pop(context)),
                  collapsedHeight: 320,
                  flexibleSpace: Stack(
                    children: <Widget>[
                      Container(
                          color: Colors.white,
                          height: 320.0,
                          width: double.infinity,
                          child: Center(
                              child: Hero(
                                  tag: "assetPath",
                                  child: Image(
                                      image: FirebaseImage(
                                          documentData["imageUrl"]),
                                      height: 320.0,
                                      width: double.infinity,
                                      fit: BoxFit.fill)))),
                      Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            alignment: Alignment.topRight,
                            height: 35,
                            width: 35,
                            child: RawMaterialButton(
                              //padding: EdgeInsets.only(right: 10, top: 5),
                              elevation: 1.0,
                              onPressed: () => Navigator.pop(context),
                              shape: CircleBorder(),
                              fillColor: Colors.black38,
                              child: Icon(
                                Icons.close,
                                size: 22.0,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ],
                  )),

              /////Нижняя часть//////////////////////////////////
              SliverPersistentHeader(
                  //   pushPinnedChildren: true,
                  delegate: _SliverPersistentHeaderDelegate(
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 5),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Stack(children: [
                          Container(
                              width: 200,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black38,
                                              offset: Offset(3.0, 3.0),
                                            ),
                                          ]),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          left: 3,
                                        ),
                                        child: Text(
                                          'В наличии: $_quantity штук',
                                          style: TextStyle(
                                            color: Colors.grey[50],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                            /* shadows: [
                                              Shadow(
                                                blurRadius: 5.0,
                                                color: Colors.black38,
                                                offset: Offset(3.0, 3.0),
                                              ),
                                            ]*/
                                          ),
                                        )),
                                  ])),
                          Container(
                              alignment: Alignment.topRight,
                              child: _priceText(_price)),
                        ]),
                      ),
                    ),
                    TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.white,
                      labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      controller: tabController,
                      onTap: (index) {
                        print(index);
                        setState(() {
                          _selectedTabbar = index;
                        });
                      },
                      tabs: [
                        Tab(
                          text: "Описание",
                        ),
                        Tab(
                          text: "Характеристики",
                        ),
                      ],
                    ),
                    Container(
                      height: 100,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          Container(
                              //height: 60,
                              padding: EdgeInsets.only(top: 10, left: 20),
                              child: Stack(children: [
                                _description(
                                    _opt,
                                    _opt.values.toList(),
                                    _opt.keys.toList(),
                                    documentData["description"])
                              ])),
                          Container(child: Text("fafAFAa"))
                        ],
                      ),
                    ),
                    /* Builder(builder: (_) {
                      if (_selectedTabbar == 0) {
                        return Text("fafa"); //1st custom tabBarView
                      } else {
                        return Text("fafAFAa"); //2nd tabView
                      }
                    }),*/
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Divider(
                            height: 20,
                            color: Colors.grey,
                            indent: 20,
                            endIndent: 20,
                          ),

                          /////COUNT WIDGET////////
                          Padding(
                              padding: EdgeInsets.only(top: 10, left: 30),
                              child: CountWidget(
                                quantity: _quantity,
                                count: qpak,
                                optKolvo: _opt.values.toList(),
                                optPrices: _opt.keys.toList(),
                                price: _price,
                                opt: _opt,
                                kolvo: kolvo,
                                onSelected: (size) {
                                  count = size;
                                  kolvo = count;
                                  summa = (_price * kolvo);
                                  print(" MAIN $_price");
                                },
                                onSelected1: (size) {
                                  count = size;
                                  kolvo = count;
                                  summa = _price * kolvo;

                                  print(" MAIN $_price");
                                },
                                onSelected2: (pr) {
                                  _price = pr;
                                  summa = _price * kolvo;
                                },
                              )),
                          _bottombtn(qpak),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
            ]);
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _priceText(int _price) {
    return Text(
      '$_price₽ ',
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.height / 15,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.black38,
              offset: Offset(3.0, 3.0),
            ),
          ]),
    );
  }

  Widget _description(Map<dynamic, dynamic> opt, List<dynamic> optPrices,
      List<dynamic> optKolvo, String description) {
    List k = [];
    opt.keys.forEach((element) {
      k.add(int.parse(element));
    });
    List v = opt.values.toList();
    k.sort();
    v.sort((b, a) => a.compareTo(b));
    print(k);
    print(v);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // for (int i = 0; i < optKolvo.length; i++)

      // if (optKolvo[i + 1] != null || optPrices[i + 1] != null)

      for (int i = 0; i < opt.length; i++)
        Text(
          "от ${k[i]} штук - ${v[i]}₽",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      Text(
        description,
        style: TextStyle(fontSize: 14, color: Colors.white),
      )
    ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate(this.child);

  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 550;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
*/