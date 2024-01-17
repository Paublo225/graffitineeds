import 'package:flutter/material.dart';

import 'package:graffitineeds/main.dart';

class CustomerModel {
  String externalId;
  String name;
  String lastname;
  String email;

  CustomerModel(
      {required this.externalId,
      required this.name,
      required this.email,
      required this.lastname});
}
