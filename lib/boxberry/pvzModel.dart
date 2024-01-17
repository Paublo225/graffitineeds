import 'dart:convert';

import 'package:flutter/material.dart';

List<Pvz> pvzFromJson(String str) =>
    List<Pvz>.from(json.decode(str).map((dynamic x) {
      return Pvz.fromJson(x);
    }));

String pvzToJson(List<Pvz> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pvz {
  String Code;
  String? Name;
  String? Address;
  String? Phone;
  String? WorkShcedule;
  String? CityCode;
  String? CityName;

  static const String CODE = "Code";
  static const String NAME = "Name";
  static const String ADDRESS = "Address";
  static const String PHONE = "Phone";
  static const String WORKSCHEDULE = "WorkShcedule";
  static const String CITYCODE = "CityCode";
  static const String CITYNAME = "CityName";

  Pvz(
      {required this.Code,
      this.Address,
      this.CityCode,
      this.CityName,
      this.Name,
      this.Phone,
      this.WorkShcedule});

  factory Pvz.fromJson(Map<String, dynamic> json) {
    return Pvz(
        Code: json[CODE] ?? "",
        Name: json[NAME] ?? "",
        Phone: json[PHONE] ?? "",
        Address: json[ADDRESS] ?? "",
        WorkShcedule: json[WORKSCHEDULE] ?? "",
        CityCode: json[CITYCODE] ?? "",
        CityName: json[CITYNAME] ?? "");
  }

  Map<String, dynamic> toJson() => {
        CODE: Code,
        NAME: Name,
        ADDRESS: Address,
        PHONE: Phone,
        WORKSCHEDULE: WorkShcedule,
        CITYCODE: CityCode,
        CITYNAME: CityName
      };
}

class PvzWidget extends StatefulWidget {
  Pvz pvzItem;
  PvzWidget(this.pvzItem);

  @override
  _PvzWidgetState createState() => _PvzWidgetState();
}

class _PvzWidgetState extends State<PvzWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.pvzItem.Name!),
    );
  }
}
