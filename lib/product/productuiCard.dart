// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/models/product.dart';

import 'package:graffitineeds/product/productScreen.dart';
import 'package:graffitineeds/services/api_services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:octo_image/octo_image.dart';

class ProductItemUI extends StatefulWidget {
  String? id;
  String? title;
  String? image;
  int? salePrice;
  String? categoryId;
  String? categoryName;
  String? searchString;
  String? description;
  String? brandName;
  String? nomNumber;
  String externalId;

  int? weight;
  int? price;
  bool? modifiers;
  bool? productView;
  List<Modifiers>? modifiersList;
  int? quantity;
  int? balance;

  ProductItemUI(
      {required this.id,
      required this.title,
      this.image,
      this.salePrice,
      required this.price,
      required this.categoryId,
      required this.externalId,
      required this.searchString,
      required this.productView,
      required this.categoryName,
      required this.brandName,
      this.modifiersList,
      this.description,
      this.modifiers,
      this.weight,
      required this.nomNumber,
      this.quantity,
      this.balance});
  @override
  _ProductItemUIState createState() => new _ProductItemUIState();
}

class _ProductItemUIState extends State<ProductItemUI> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showCupertinoModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => ItemScreen(
              id: widget.id!,
              nomNumber: widget.nomNumber,
              imageUrl: widget.image!,
              title: widget.title!,
              price: widget.price!,
              externalId: widget.externalId,
              categoryId: widget.categoryId!,
              modifiers: widget.modifiers ?? false,
              modifiersList: widget.modifiersList ?? [],
              productView: widget.productView!,
              searchString: widget.searchString,
              categoryName: widget.categoryName!,
              brandName: widget.brandName!,
              quantity: widget.quantity!,
              weight: widget.weight ?? 350,
              description: widget.description,
            ),
          );
        },
        child: Column(children: [
          Container(
              margin: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 0.8,
                    blurRadius: 0.1,
                    offset: Offset(1, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  height: 200,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: OctoImage(
                          height: 200,
                          width: double.infinity,
                          progressIndicatorBuilder: (context, progress) {
                            double? value;
                            if (progress != null &&
                                progress.expectedTotalBytes != null) {
                              value = progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!;
                            }
                            return Image.asset(
                              "lib/assets/gn_loading.png",
                              fit: BoxFit.contain,
                            );
                          },
                          image: NetworkImage(widget.image!,
                              headers: ApiServices.headers))),
                )
              ])),
          Flexible(
              child: Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                    left: 15,
                    right: 15,
                  ),
                  child: Text(
                    widget.title!,
                    textScaleFactor: 0.8,
                    textAlign: TextAlign.center,
                  ))),
          widget.salePrice != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.price.toString() + "₽",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.salePrice.toString() + "₽",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                  widget.price.toString() + "₽",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
        ]));
  }
}
