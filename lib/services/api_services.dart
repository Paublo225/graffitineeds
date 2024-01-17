import 'package:graffitineeds/models/itemModel.dart';
import 'package:requests/requests.dart';
import 'dart:convert';
import 'package:graffitineeds/services/api_settings.dart';

class ApiServices {
  static var parameters = {
    'pointId': ApiKey.pointId,
    'priceListId': ApiKey.priceListId,
    'withBalance': 'true',
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
    print(response.content());
  }

  static Future<List<Product>> getRepo() async {
    //requestSbis();
    var response = await Requests.get(
      ApiKey.urlNomList,
      queryParameters: parameters,
      headers: headers,
    );
    if (response.statusCode == 200) {
      String io = json
          .encode(response.json())
          .replaceAll('{', '{')
          .replaceAll(': ', '": "')
          .replaceAll(', ', '", "')
          .replaceAll('}', '}');

      return productFromJson(io);
    } else {
      throw Exception('Failed to load album');
    }
  }
}
