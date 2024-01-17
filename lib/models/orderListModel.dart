import 'package:flutter/material.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/helpers/paint_icons.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/models/product.dart';

import 'package:graffitineeds/services/api_services.dart';

// ignore: must_be_immutable
class OrderListModel extends StatefulWidget {
  String id;
  String hierarchicalParent;
  String hierarchicalId;
  String name;
  String hexColor;
  String imageUrl;
  int price;
  int quantity;
  bool modifier;
  List<dynamic> modifiers;
  String searchString;
  String categoryName;
  String brandName;
  String nomNumber;
  String description;

  OrderListModel({
    Key? key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.hierarchicalParent,
    required this.quantity,
    required this.hexColor,
    required this.modifiers,
    required this.modifier,
    required this.brandName,
    required this.nomNumber,
    required this.categoryName,
    required this.searchString,
    required this.description,
    required this.hierarchicalId,
  });
  Map toMap() => {
        ID: id,
        IMAGEURL: imageUrl,
        NAME: name,
        PRICE: price,
        QUANTITY: quantity,
        ISMODIFIER: modifier,
        DESCRIPTION: DESCRIPTION,
        HEXCOLOR: hexColor,
        HIERARCHICALPARENT: hierarchicalParent,
        BRANDNAME: brandName,
        CATEGORYNAME: categoryName,
        NOMNUMBER: nomNumber
      };

  _OrderListModelState createState() => new _OrderListModelState();
}

class _OrderListModelState extends State<OrderListModel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16),
        height: 125,
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
        child: Row(children: <Widget>[
          Stack(children: [
            Container(
              height: 125,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    fit: BoxFit.contain,
                    height: 125,
                    width: 90,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Image.asset(
                        "lib/assets/gn_loading.png",
                        height: 115,
                        width: 90,
                        fit: BoxFit.contain,
                      );
                    },
                    errorBuilder: (contex, object, tyy) => Image.asset(
                          "lib/assets/gn_loading.png",
                          height: 115,
                          width: 90,
                          fit: BoxFit.contain,
                        ),
                    image: NetworkImage(widget.imageUrl,
                        headers: ApiServices.headers))),
          ]),
          SizedBox(
            height: 10,
            width: 5,
          ),
          Flexible(
            child: Stack(
              children: [
                if (widget.categoryName == "аэрозоль")
                  Positioned(
                      child: Container(
                          margin: EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            PaintIcon.paint,
                            size: 60,
                            color: Color(int.parse("0xff" + widget.hexColor)),
                          ))),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 5),
                    child: Text(widget.name,
                        style: TextStyle(
                            fontSize: 14,
                            color: ThemaMode.isDarkMode
                                ? Colors.white
                                : Colors.black)),
                  ),
                  //FutureBuilder(builder: (builder, snap) {}),

                  Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text("${widget.price * widget.quantity} руб ",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: ThemaMode.isDarkMode
                                  ? Colors.white
                                  : Colors.black))),
                ]),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Кол-во: " + widget.quantity.toString(),
                          style: TextStyle(
                              color: ThemaMode.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        )
                      ]),
                )
              ],
            ),
          ),
        ]));
  }
}
