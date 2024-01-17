import 'package:graffitineeds/models/itemModel.dart';
import 'package:graffitineeds/models/product.dart';

import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/services/api_settings.dart';

import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';

class ApiUnisender {
  static sendEmail(
      String userMail, String senderMail, String htmlBody, String subject) {
    String requestUrl =
        "https://api.unisender.com/ru/api/sendEmail?format=json&api_key=${ApiKey.unisenderToken}&email=$userMail&sender_name=Магазин+GraffitiNeeds&sender_email=$senderMail&subject=$subject&body=$htmlBody&list_id=1";
    http.post(Uri.parse(requestUrl)).then((value) {
      print(value.body);
    });
  }

  static getList() {
    String requestUrl =
        "https://api.unisender.com/ru/api/getLists?format=json&api_key=${ApiKey.unisenderToken}";
    http.post(Uri.parse(requestUrl)).then((value) {
      print(value.body);
    });
  }

  static var parameters = {
    'pointId': ApiKey.pointId,
    'priceListId': ApiKey.priceListId,
    'withBalance': 'true',
    'searchString': '',
    'page': '0',
    'pageSize': '20'
  };
  static var headers = {"X-SBISAccessToken": ApiKey.sbisToken.toString()};

  static requestSbis() async {
    var parameterz = {'pointId': 157, 'actualDate': '02.03.22'};
    String url = 'https://api.sbis.ru/retail/nomenclature/price-list?';

    var headersz = {
      "X-SBISAccessToken":
          "uxPSTLFSYINMofPyApK6pJaA8USknERsTMWLdrsaD16xBj3gfANaqxUb67flWHKmBPmSLZnEuPfa0taDuTSdw05GDcDmqUGkfiRsvwKToKvdnONheJS6jH"
    };
    var response =
        await Requests.get(url, queryParameters: parameterz, headers: headersz);
  }

  String mainUrl =
      'https://api.sbis.ru/retail/nomenclature/list?product=delivery&pointId=123&priceListId=123&withBalance=true&page=0&pageSize=50';

  static getRepoTest() async {
    var response = await Requests.get(
      ApiKey.urlNomList,
      queryParameters: parameters,
      headers: headers,
    );
    print(response.url);
    if (response.statusCode == 200) {
      var io = json.encode(response.json());
      // .replaceAll('{', '{')
      //  .replaceAll(': ', '": "')
      // .replaceAll(', ', '", "')
      // .replaceAll('}', '}');
      return productApiFromMap(io);
    }
  }

  static Future<List<Product>> getRepo() async {
    //requestSbis();
    var response = await Requests.get(
      ApiKey.urlNomList,
      queryParameters: parameters,
      headers: headers,
    );
    if (response.statusCode == 200) {
      var io = json
          .encode(response.json()["nomenclatures"])
          .replaceAll('{', '{')
          .replaceAll(': ', '": "')
          .replaceAll(', ', '", "')
          .replaceAll('}', '}');

      return productFromJson(io);
    } else {
      throw Exception('Failed to load album');
    }
  }

  static getProducts(String searchString, int page, int pageSize) async {
    var parameterz = {
      'pointId': ApiKey.pointId,
      'priceListId': ApiKey.priceListId,
      'withBalance': 'true',
      'searchString': searchString,
      'page': page.toString(),
      'pageSize': pageSize.toString()
    };
    var response = await Requests.get(
      ApiKey.urlNomList,
      queryParameters: parameterz,
      headers: headers,
    );
    if (response.statusCode == 200) {
      var io = json.encode(response.json());

      return productApiFromMap(io);
    }
  }
}
