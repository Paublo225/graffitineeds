import 'package:flutter/material.dart';
import 'package:graffitineeds/counter/colorsCounter.dart';
import 'package:graffitineeds/models/preCartModel.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ColorsModel extends StatefulWidget {
  int? id;
  String? hierarchicalParent;
  String? colorName;
  String? hexColor;
  String? description;
  String? nomNumber;
  String externalId;
  int? price;
  String? brandName;
  String? categoryName;
  String? weight;
  int? size;
  int? balance;
  bool checked;

  final Function(int)? onCount;
  final Function(bool)? onChecked;

  ColorsModel(
      {this.id,
      this.hierarchicalParent,
      this.colorName,
      this.hexColor,
      this.weight,
      this.size,
      this.price,
      required this.externalId,
      this.balance,
      this.brandName,
      this.categoryName,
      this.description,
      this.nomNumber,
      required this.checked,
      this.onCount,
      this.onChecked});
  _ColorsModelState createState() => new _ColorsModelState();
}

class _ColorsModelState extends State<ColorsModel> {
  String? colorName;
  String? hexColor;
  List<PreCartItemModel> preCartList = [];
  bool flag = false;
  int count = 1;
  int? checkCount;
  Color? colorMain;
  Color? backgroundColor = Colors.black;
  @override
  void initState() {
    super.initState();

    hexColor = "0xff" + widget.hexColor!;
  }

  @override
  Widget build(BuildContext context) {
    hexColor = "0xff" + widget.hexColor!;
    backgroundColor = Color(int.parse(hexColor!));
    colorMain = ThemeData.estimateBrightnessForColor(backgroundColor!) ==
            Brightness.light
        ? Colors.black
        : Colors.white;
    return Container(
      margin: EdgeInsets.all(10),
      color: backgroundColor,
      width: double.infinity,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Flexible(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.colorName!, //.substring(0, 6),

                        style: TextStyle(
                          fontSize: 14,
                          // overflow: TextOverflow.ellipsis,
                          color: colorMain,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "В наличии: ${widget.balance} шт.",
                          style: TextStyle(
                            color: colorMain,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      flag
                          ? Text("")
                          : Expanded(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Text("${widget.price} ₽ ",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            overflow: TextOverflow.clip,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: colorMain,
                                          ))))),
                    ]),
              ])),
          GestureDetector(
              onTap: () {
                if (widget.balance! > 0) {
                  setState(() {
                    flag = true;
                    widget.checked = flag;
                    widget.onChecked!(flag);
                  });
                }
              },
              child: flag
                  ? ColorsProduct(
                      count: count,
                      price: 0,
                      kolvo: 1,
                      color: hexColor,
                      quantity: widget.balance,
                      onSelected1: (value) {
                        widget.onCount!(value);

                        if (value < 1)
                          setState(() {
                            flag = !flag;
                            widget.checked = flag;
                            widget.onChecked!(flag);
                          });
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.add,
                        color: colorMain,
                      )))
        ],
      ),
    );
  }
}
