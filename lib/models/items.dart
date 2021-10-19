import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/models/productmodel.dart';
import 'package:graffitineeds/product/filter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//import 'package:provider/provider.dart';
import '../main.dart';
import 'package:sliver_tools/sliver_tools.dart';

// ignore: must_be_immutable
class ItemZ extends StatefulWidget {
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
  ItemZ({
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
  _ItemZState createState() => new _ItemZState();
}

List<ProductItemZ> products = [
  ProductItemZ(
    id: "1",
    imageUrl: 'lib/assets/m1.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "2",
    imageUrl: 'lib/assets/m2.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "3",
    imageUrl: 'lib/assets/m3.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "4",
    imageUrl: 'lib/assets/m4.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "1",
    imageUrl: 'lib/assets/m1.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "2",
    imageUrl: "lib/assets/m2.jpg",
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "3",
    imageUrl: 'lib/assets/m3.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "4",
    imageUrl: 'lib/assets/m4.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "1",
    imageUrl: 'lib/assets/m1.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "2",
    imageUrl: 'lib/assets/m2.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "3",
    imageUrl: 'lib/assets/m3.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "4",
    imageUrl: 'lib/assets/m4.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
];

List<ProductItemZ> products2 = [
  ProductItemZ(
    id: "1",
    imageUrl: 'lib/assets/a1.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "2",
    imageUrl: 'lib/assets/a2.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "3",
    imageUrl: 'lib/assets/a3.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "4",
    imageUrl: 'lib/assets/a4.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "4",
    imageUrl: 'lib/assets/k5.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "4",
    imageUrl: 'lib/assets/a10.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
  ProductItemZ(
    id: "4",
    imageUrl: 'lib/assets/a7.jpg',
    price: "370",
    name: "LP-367 BALTIMORE 400 ML",
  ),
];

class _ItemZState extends State<ItemZ> {
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
            elevation: 0.0,
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            leading: Container(
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    CupertinoIcons.back,
                    size: 28.0,
                    color: mainColor,
                  )),
            )),*/
        body: CustomScrollView(slivers: [
      SliverAppBar(
          //  elevation: 0.0,
          //  expandedHeight: 60,
          centerTitle: true,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                CupertinoIcons.back,
                size: 28.0,
                color: mainColor,
              )),
          pinned: true,
          floating: false,
          //  forceElevated: innerBoxIsScrolled,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(bottom: 20),
            centerTitle: true,
            title: Container(
                /*margin: EdgeInsets.only(
                  right: 40,
                ),*/
                child: Text(
              widget.name.toUpperCase(),
              textScaleFactor: 0.9,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            )),
          )),

      /*  Padding(
                padding: EdgeInsets.only(left: 20, bottom: 20),
                child: Text(
                  widget.name.toUpperCase(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                )),*/

      SliverPinnedHeader(
          child: Container(
              //   margin: EdgeInsets.only(bottom: 15, left: 20),
              color: Colors.white,
              width: 70,
              height: 30,
              child: Row(children: [
                GestureDetector(
                    onTap: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => FilterView(),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      width: 70,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 2,
                          ),
                          Icon(
                            Icons.color_lens_outlined,
                            color: Colors.black,
                            size: 17,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Фильтр",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  width: 15,
                ),
                Container(
                  // margin: EdgeInsets.only(left: 15, bottom: 10),
                  width: 95,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 2,
                      ),
                      Icon(
                        CupertinoIcons.sort_down,
                        color: Colors.black,
                        size: 17,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Сортировка",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ]))),
      SliverGrid.count(
        crossAxisCount: 2,
        children: products,
      ),
    ]));
  }
}
