import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum StatusSate { INPROCCES, DECLINED, SUCCSESSFULL }

class OrderHistory extends StatefulWidget {
  OrderHistory({Key key}) : super(key: key);
  @override
  _OrderHistoryState createState() => new _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  // FirebaseServices _firebaseServices = FirebaseServices();

  List g1 = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
