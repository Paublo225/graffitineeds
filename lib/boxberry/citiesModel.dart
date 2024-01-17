import 'dart:convert';

import 'package:flutter/material.dart';

List<City> cityFromJson(String str) =>
    List<City>.from(json.decode(str).map((dynamic x) {
      return City.fromJson(x);
    }));

String cityToJson(List<City> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class City {
  String Code;
  String? CountryCode;
  String? Name;
  String? Prefix;
  String? Region;
  String? UniqName;

  static const String CODE = "Code";
  static const String REGION = "Region";
  static const String COUNTRYCODE = "CountryCode";
  static const String PREFIX = "Prefix";
  static const String NAME = "Name";
  static const String UNIQNAME = "UniqName";

  City(
      {required this.Code,
      this.CountryCode,
      this.Name,
      this.Region,
      this.Prefix,
      this.UniqName});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
        Code: json[CODE],
        Region: json[REGION],
        Name: json[NAME],
        Prefix: json[PREFIX],
        UniqName: json[UNIQNAME],
        CountryCode: json[COUNTRYCODE]);
  }

  Map<String, dynamic> toJson() => {
        CODE: Code,
        NAME: Name,
      };
}
