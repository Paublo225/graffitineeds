import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

final TextStyle topMenuStyle = new TextStyle(
    fontFamily: 'Avenir next',
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w600);

// ignore: must_be_immutable
class MainPageCover extends StatefulWidget {
  String id;
  String imageUrl;
  String title;
  String categories;
  String price;
  String description;
  String quantity;
  Function onTap;
  Map<dynamic, dynamic> opt;
  int qpak;
  int minKolvo;
  PageController page;
  MainPageCover({
    this.id,
    this.imageUrl,
    this.title,
    this.categories,
    this.price,
    this.onTap,
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
  _MainPageCoverState createState() => new _MainPageCoverState();
}

class _MainPageCoverState extends State<MainPageCover> {
  final Color coverColor = Colors.black12;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        // margin: EdgeInsets.only(top: 10),
        child: Stack(
          children: [
            Center(child: Image.asset(widget.imageUrl)),
            Center(
                child: Container(width: 316, height: 130, color: coverColor)),
            Center(
              //heightFactor: 5,
              child: Text(
                widget.title.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    shadows: [Shadow(color: Colors.black, blurRadius: 7)]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
