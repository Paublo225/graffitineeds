import 'dart:io';

import 'package:graffitineeds/models/cartItemModel.dart';
import 'package:graffitineeds/models/itemModel.dart';
import 'package:graffitineeds/models/product.dart';

import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/services/api_settings.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:requests/requests.dart';
import 'package:uuid/uuid.dart';

class ApiYookassa {
  static String? token;
  static String _testToken =
      '980261:test_W88yNoYXjj0m_reqpNi26XSVHiBpk3vkrDjhEFO1OSg';
  static Stream<String?> payStatus(String pay_id) async* {
    String url = "https://api.yookassa.ru/v3/payments/$pay_id";
    String basicAuth = 'Basic ' + base64.encode(utf8.encode('$_testToken'));

    var headers = {
      "Authorization": basicAuth,
      'Idempotence-Key': Uuid().v4(),
      'Content-Type': "application/json"
    };
    Response response = await Future.delayed(
        Duration(seconds: 1), () => Requests.get(url, headers: headers));
    print(response.json());
    yield response.json()["status"].toString();
  }

  static Future payTest() async {
    String url = "https://api.yookassa.ru/v3/payments";
    String basicAuth = 'Basic ' +
        base64.encode(utf8
            .encode('980261:test_W88yNoYXjj0m_reqpNi26XSVHiBpk3vkrDjhEFO1OSg'));

    var headers = {
      "Authorization": basicAuth,
      'Idempotence-Key': Uuid().v4(),
      'Content-Type': "application/json"
    };
    var parameters = {
      "amount": {"value": "2.00", "currency": "RUB"},
      //"payment_method_data": {"type": "bank_card"},
      "confirmation": {
        "type": "redirect",
        "return_url": "https://www.example.com/return_url"
      },
      "description": "Заказ №72"
    };
    var response = await Requests.post(
      url,
      json: parameters,
      headers: headers,
    );
    print(response.json());
    return {
      "url": response.json()["confirmation"]["confirmation_url"],
      "id": response.json()["id"]
    };
  }

  static Future payCheck(
    Map<String, dynamic> customer,
    List<CartItemModel> nomenclatures,
    int summary,
    String orderNumber,
  ) async {
    String url = "https://api.yookassa.ru/v3/payments";
    String basicAuth = 'Basic ' + base64.encode(utf8.encode('$token'));

    var headers = {
      "Authorization": basicAuth,
      'Idempotence-Key': Uuid().v4(),
      'Content-Type': "application/json"
    };

    var items = [];
    for (var element in nomenclatures) {
      items.add({
        "description": element.name,
        "quantity": element.quantity!.toDouble().toString(),
        "amount": {
          "value": element.price!.toDouble().toString(),
          "currency": "RUB"
        },
        "vat_code": "2",
        "payment_mode": "full_prepayment",
        "payment_subject": "commodity"
      });
    }

    print(items);

    var parameters = {
      "description": "Заказ №$orderNumber",
      "amount": {"value": summary.toDouble().toString(), "currency": "RUB"},
      "confirmation": {
        "type": "redirect",
        "return_url": "https://vk.com/graffitineeds"
      },
      "receipt": {
        "customer": {
          "full_name": customer["lastname"] + " " + customer["name"],
          "phone": customer["phone"],
          "email": customer["email"],
        },
        "items": items
      }
    };
    var response = await Requests.post(
      url,
      json: parameters,
      headers: headers,
    );
    print(response.json());
    return {
      "url": response.json()["confirmation"]["confirmation_url"],
      "id": response.json()["id"]
    };
  }
}
