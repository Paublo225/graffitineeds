// ignore_for_file: dead_code

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:graffitineeds/product/products.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

// ignore: must_be_immutable
class SubCategoryModel extends StatefulWidget {
  String id;
  String imageUrl;
  String brand;
  String name;
  String category;
  bool productView;
  String? price;
  String? searchString;

  SubCategoryModel(
      {required this.id,
      required this.imageUrl,
      required this.name,
      required this.brand,
      required this.category,
      this.searchString,
      required this.productView,
      this.price});

  _SubCategoryModelState createState() => new _SubCategoryModelState();
}

class _SubCategoryModelState extends State<SubCategoryModel> {
  final Color coverColor = Color.fromRGBO(217, 217, 217, 1);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (builder) => ProductItem(
                    categoryId: widget.id,
                    title: widget.name,
                    brandName: widget.brand,
                    categoryName: widget.category,
                    productView: widget.productView,
                    searchString: widget.searchString!,
                  ))),
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
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              fit: BoxFit.fill,
                              height: 120,
                              width: double.infinity,
                              placeholder: (context, str) {
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
                              })))
                ])),
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  widget.name.toUpperCase(),
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
}
