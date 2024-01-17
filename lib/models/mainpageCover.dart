import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/category/categoryProducts.dart';
import 'package:graffitineeds/main.dart';
import 'package:graffitineeds/product/productuiCard.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';

final TextStyle topMenuStyle = new TextStyle(
    fontFamily: 'Avenir next',
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w600);

// ignore: must_be_immutable
class MainPageCover extends StatefulWidget {
  String? id;
  String? imageUrl;
  String? title;
  String? categories;
  List<dynamic>? searchList;
  MainPageCover({
    this.id,
    this.imageUrl,
    this.title,
    this.categories,
    this.searchList,
  });

  _MainPageCoverState createState() => new _MainPageCoverState();
}

class _MainPageCoverState extends State<MainPageCover>
    with AutomaticKeepAliveClientMixin {
  final Color coverColor = Color.fromRGBO(217, 217, 217, 1);
  int defaultQuantity = 999999;
  bool loading = false;
  List<ProductItemUI>? productsCategory = [];
  List<String> brandsList = [];
  _getProducts() async {
    await FirebaseFirestore.instance
        .collection("категории")
        .doc("бренды")
        .collection("бренды")
        .get()
        .then((valueMain) {
      valueMain.docs.forEach((element) {
        brandsList.add(element.id);
      });
    });
    brandsList.forEach((brand) async {
      await FirebaseFirestore.instance
          .collection("категории")
          .doc("бренды")
          .collection("бренды")
          .doc(brand)
          .collection("подкатегории")
          .doc(widget.categories)
          .collection(widget.categories!)
          .get()
          .then((value) {
        value.docs.forEach((snap) {
          productsCategory!.add(ProductItemUI(
            id: snap.id,
            title: snap.data()["наименование"],
            image: snap.data()["картинка"],
            price: snap.data()["цена"],
            externalId: "666666",
            categoryId: snap.data()["categoryId"],
            nomNumber: snap.data()["nomNumber"],
            productView: snap.data()["productView"],
            searchString: snap.data()["searchString"],
            categoryName: widget.categories,
            brandName: brand,
            description: snap.data()["описание"].toString(),
            quantity: defaultQuantity,
          ));
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getProducts();

    //   _futureLoading();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () async {
        // await _getProducts();
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (builder) => CategoryProducts(
                      title: widget.title!,
                      productsList: productsCategory!,
                      searchList: widget.searchList,
                    )));
      },
      child: Container(
        width: double.infinity,
        // height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: coverColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Stack(children: [
                  Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: coverColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl!,
                            fit: BoxFit.fill,
                            height: 120,
                            width: double.infinity,
                            placeholder: (context, sr) {
                              return SkeletonLoader(
                                  // items: 1,
                                  period: Duration(seconds: 2),
                                  highlightColor: coverColor,
                                  direction: SkeletonDirection.ltr,
                                  builder: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: coverColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                  ));
                            },
                          )))
                ])),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  widget.title!.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Circe"),
                )),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
