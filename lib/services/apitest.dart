import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/models/itemModel.dart';
import 'package:graffitineeds/models/product.dart';
import 'dart:convert';
import 'package:graffitineeds/services/api_settings.dart';
import 'package:requests/requests.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class ApiTest {
  static var parameters = {
    'pointId': ApiKey.pointId,
    'priceListId': ApiKey.priceListId,
    'withBalance': true,
    'searchString': '',
    'page': '0',
    'pageSize': '20'
  };
  static var headers = {"X-SBISAccessToken": ApiKey.sbisToken.toString()};
  static Future<String> sbisApi = FirebaseFirestore.instance
      .collection(TEX_RABOTI)
      .doc("tokens")
      .get()
      .then((value) {
    print(value.get("sbisToken"));
    return value.get("sbisToken");
  });
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

  static Future getRepo(String searchString, int page, int pageSize) async {
    var parameterz = {
      'pointId': ApiKey.pointId.toString(),
      'priceListId': ApiKey.priceListId,
      'searchString': searchString,
      'withBalance': true,
      'onlyPublished': true,
      'page': page,
      'pageSize': pageSize
    };

    var response = await Requests.get(
      ApiKey
          .urlNomList, //'https://api.sbis.ru/retail/nomenclature/98e50217-9509-32f7-9acf-cbdc3b35e686',
      queryParameters: parameterz,
      headers: headers,
    );

    if (response.statusCode == 200) {
      var io = json.encode(response.json());

      // print(productApiFromMap(io).nomenclatures!);
      //return productFromJson(io);
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future getBalance(List<int> nomenclatures) async {
    final String url = "https://api.sbis.ru/retail/nomenclature/balances?'";
    var parameters = {
      'nomenclatures': nomenclatures,
      'warehouses': [166],
      'companies': [157]
    };
    var response =
        await Requests.get(url, headers: headers, queryParameters: parameters);

    print(response.json());
  }

  static Future<ProductApi> getProducts(
      String searchString, int page, int pageSize) async {
    var parameterz = {
      'pointId': ApiKey.pointId,
      'priceListId': ApiKey.priceListId,
      'searchString': searchString,
      'withBalance': true,
      'onlyPublished': true,
      'page': page,
      'pageSize': pageSize
    };
    var response = await Requests.get(
      ApiKey.urlNomList,
      queryParameters: parameterz,
      headers: headers,
    );

    if (response.statusCode == 200) {
      var io = json.encode(response.json());

      return productApiFromMap(io);
    } else {
      throw Exception('Failed to load nomenclature');
    }
  }

  static getProducts2(String searchString, int page, int pageSize) async {
    var parameterz = {
      'pointId': ApiKey.pointId,
      'priceListId': ApiKey.priceListId,
      'withBalance': true,
      'searchString': searchString,
      'onlyPublished': true,
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
      // print(response.json()["nomenclatures"][3]["externalId"]);
      return productApiFromMap(io);
    }
  }

  static Future<RelatedProductApi> getRelatedProduct(String externalId) async {
    var parameterz = {
      'pointId': ApiKey.pointId,
      'priceListId': ApiKey.priceListId,
      'withBalance': true,
      'onlyPublished': true,
    };
    var response = await Requests.get(
      "https://api.sbis.ru/retail/nomenclature/" + externalId,
      queryParameters: parameterz,
      headers: headers,
    );

    if (response.statusCode == 200) {
      try {
        var io = json.encode(response.json());

        return relatedProductApiFromMap(io);
      } catch (e) {
        throw Exception('Related_product is null');
      }
    } else {
      throw Exception('Failed to load related product');
    }
  }

  static getDifferentProducts() async {
    var parameterz = {
      'pointId': ApiKey.pointId,
      'priceListId': ApiKey.priceListId,
      'withBalance': true,
      'onlyPublished': true,
    };
    var response = await Requests.get(
      "https://api.sbis.ru/retail/nomenclature/ae5d06d5-ca02-3c32-a9c0-72dba28c4c3b",
      queryParameters: parameterz,
      headers: headers,
    );
    if (response.statusCode == 200) {
      var io = json.encode(response.json());
      printWrapped(response.json().toString());
    }
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
//ae5d06d5-ca02-3c32-a9c0-72dba28c4c3b