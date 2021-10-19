import 'package:flutter/material.dart';

import 'package:graffitineeds/main.dart';

class Item extends StatefulWidget {
  String id;
  String imageUrl;
  String title;
  String categories;
  String price;
  String description;
  String quantity;

  Map<dynamic, dynamic> opt;
  int qpak;
  int minKolvo;
  PageController page;
  Item({
    this.id,
    this.imageUrl,
    this.title,
    this.categories,
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
  _ItemState createState() => new _ItemState();
}

class _ItemState extends State<Item> {
  inistate() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
