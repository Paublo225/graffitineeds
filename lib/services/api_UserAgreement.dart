import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/services/api_settings.dart';
import 'package:http/http.dart';
import 'package:requests/requests.dart';
import 'package:intl/intl.dart';

class SbisUserDocs {
  static var headers = {"X-SBISAccessToken": ApiKey.sbisToken.toString()};
  static String url = "https://api.sbis.ru/retail/order/create";
  static String saleUrl = "https://api.sbis.ru/retail/sale/create";

  static Future createOrder(Map<String, dynamic> customer,
      List<Map<String, dynamic>> nomenclatures) async {
    String datTime = DateFormat('yyyy-MM-dd hh:mm:ss')
        .format(
            DateTime.now().toUtc().add(const Duration(hours: 3, minutes: 2)))
        .toString();
    dynamic dates = {
      "product": "delivery",
      "pointId": 157,
      "comment": "",
      "customer": customer,
      "nomenclatures": nomenclatures,
      "datetime": datTime,
      "delivery": {
        "addressJSON": null,
        "addressFull": "",
        "persons": 0,
        "district": 0,
        "changeAmount": 0,
        "paymentType": "cash",
        "isPickup": true
      },
    };
    Response response = await Requests.post(url, json: dates, headers: headers);
    print(response.json());
    return response.json()["saleKey"];
  }

  static getUserAgreement() async {
    var paramz = {
      "jsonrpc": "2.0",
      "method": "ClientUserAgreements.GetDocumentViewLink",
      "params": {
        "InputData": {"TypeName": "Клиентскоесоглашение"}
      },
      "id": 0
    };
    Response response = await Requests.get(
        "https://online.sbis.ru/service/?srv=1",
        headers: headers,
        queryParameters: paramz);
    print(response.json());
  }

  static Future<String> getLink() async {
    String? link;
    await FirebaseFirestore.instance
        .collection(TEX_RABOTI)
        .doc("docs")
        .get()
        .then((value) {
      return link = value.get("userAgreement");
    });
    return link!;
  }
}
