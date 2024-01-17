import 'package:flutter/material.dart';

import 'package:graffitineeds/main.dart';
import 'package:graffitineeds/models/customerModel.dart';
import 'package:graffitineeds/models/product.dart';

class OrderSbisModel {
  String product;
  String pointId;
  String? comment;
  List<CustomerModel> customer;
  String datetime;
  List<Nomenclature> nomenclatures;

  OrderSbisModel(
      {required this.product,
      required this.pointId,
      this.comment,
      required this.customer,
      required this.datetime,
      required this.nomenclatures});
}
