import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:flutter/cupertino.dart';
import '../main.dart';

// ignore: must_be_immutable
class OrderScreen extends StatefulWidget {
  String orderID;
  int indexs;
  String title;
  OrderScreen({this.orderID, this.title, this.indexs});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
