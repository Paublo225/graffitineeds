import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/models/itemModel.dart';
import 'package:graffitineeds/models/product.dart';

import 'package:requests/requests.dart';

class SbisUser {
  static Future login() async {
    var _login = '4769398';
    var _pass = 'GraffitiNeeds2016**';
    var pp = await (invoke(
      "СБИС.Аутентифицировать",
      {
        "Параметр": {"Логин": _login, "Пароль": _pass}
      },
      "",
    ));
    return pp;
  }

  static Future<Map<String, dynamic>> invoke(
      String method, Map params, String auth_sid) async {
    String url;
    Map<String, dynamic> payload = {
      "jsonrpc": "2.0",
      "method": method,
      "params": params,
      "protocol": 2,
      "id": 0,
    };

    Map<String, String>? headers = {
      "Host": "online.sbis.ru",
      "Content-Type": "application/json-rpc; charset=utf-8",
      "Accept": "application/json-rpc",
    };

    if (auth_sid != "") {
      headers["X-SBISSessionID"] = auth_sid;
      print(headers);
      url = "https://online.sbis.ru/service/?x_version=20.7202-3";
      print("gsgsg");
    } else {
      url = "https://online.sbis.ru/auth/service/";
    }

    var r = await Requests.post(url, headers: headers, json: payload);
    print(r.json());
    return r.json();
  }

////////////////////////CREATE CUSTOMER////////////////////////////////////
  static Future<Map<String, dynamic>> create_customer(
      String sid, Map input_param) async {
    String url;
    var contacts = {
      "d": [
        [input_param['Мобильный телофон'] ?? null, "mobile_phone", null],
        [input_param['Электронная почта'] ?? null, "email", null]
      ],
      "s": [
        {"t": "Строка", "n": "Value"},
        {"t": "Строка", "n": "Type"},
        {"t": "Строка", "n": "Priority"}
      ]
    };
    var params = {
      "CustomerData": {
        "s": {
          "UUID": "UUID",
          "Surname": "Строка",
          "Name": "Строка",
          "Patronymic": "Строка",
          "Gender": "Число целое",
          "Address": "Строка",
          "ContactData": "Выборка"
        },
        "d": {
          "UUID": input_param["UUID"],
          "Surname": input_param["Surname"],
          "Name": input_param["Name"],
          // "Patronymic": input_param["Patronymic"],
          // "Gender": input_param["Gender"],
          //"Address": input_param["Address"],
          "ContactData": contacts
        },
        "_type": "record",
        "f": 0
      }
    };

    Map<String, dynamic> payload = {
      "jsonrpc": "2.0",
      "method": "CRMClients.SaveCustomer",
      "params": params,
      "protocol": 2,
      "id": 0,
    };

    Map<String, String>? headers = {
      "Host": "online.sbis.ru",
      "Content-Type": "application/json-rpc; charset=utf-8",
      "Accept": "application/json-rpc",
    };

    if (sid != "") {
      headers["X-SBISSessionID"] = sid;
      print(headers);
      url = "https://online.sbis.ru/service/?x_version=20.7202-3";
      print("gsgsg");
    } else {
      url = "https://online.sbis.ru/auth/service/";
    }
    var r = await Requests.post(url, headers: headers, json: payload);
    print(r.json());
    return r.json();
  }

//////////////////////////////SEARCH CUSTOMER
  static search_customer(String sid, Map input_param) async {
    Map<String, dynamic>? call;

    print(input_param);
    var customer_id = input_param['Внутренний идентификатор'] ?? null;
    var customer_uuid = input_param['Идентификатор пользователя'] ?? null;
    var external_id = input_param['Внешний идентификатор'] ?? null;
    // var inn = input_param['ИНН'];
    // var snils = input_param['СНИЛС'];
    var last_name = input_param['Фамилия'] ?? null;
    var first_name = input_param['Имя'] ?? null;
    //  var second_name = input_param['Отчество'];
    var contacts = {
      "d": [
        [input_param['Мобильный телофон'] ?? null, "mobile_phone", null],
        [input_param['Электронная почта'] ?? null, "email", null]
      ],
      "s": [
        {"t": "Строка", "n": "Value"},
        {"t": "Строка", "n": "Type"},
        {"t": "Строка", "n": "Priority"}
      ]
    };
    ;
    var params = {
      "client_data": {
        "d": {
          "CustomerID": customer_id,
          "UUID": customer_uuid,
          "ExternalId": external_id,
          //  "INN": inn,
          ///  "SNILS": snils,
          "FirstName": first_name,
          "LastName": last_name,
          "ContactData": contacts
        },
        "s": {
          "CustomerID": "Число целое",
          "UUID": "UUID",
          "INN": "Строка",
          "SNILS": "Строка",
          "FirstName": "Строка",
          "LastName": "Строка",
          "SecondName": "Строка",
          "ExternalId": "Строка",
          "ContactData": "Выборка"
        }
      },
      "options": null
    };

    call = await invoke('CRMClients.GetCustomerByParams', params, sid);

    return call;
  }
}
