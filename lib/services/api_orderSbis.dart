import 'package:graffitineeds/services/api_settings.dart';
import 'package:http/http.dart';
import 'package:requests/requests.dart';
import 'package:intl/intl.dart';

class SbisOrder {
  static var headers = {"X-SBISAccessToken": ApiKey.sbisToken.toString()};
  static String url = "https://api.sbis.ru/retail/order/create";
  static String saleUrl = "https://api.sbis.ru/retail/sale/create";

  static Future createOrder(
      Map<String, dynamic> customer,
      String addressFull,
      bool pickUp,
      List<Map<String, dynamic>> nomenclatures,
      String yooPayId) async {
    String dateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(
            DateTime.now().toUtc().add(const Duration(hours: 3, minutes: 2)))
        .toString();

    dynamic dates = {
      "product": "delivery",
      "pointId": 157,
      "comment": yooPayId,
      "customer": customer,
      "nomenclatures": nomenclatures,
      "datetime": dateTime,
      "delivery": {
        "addressJSON": null,
        "addressFull": addressFull,
        "persons": 0,
        "district": 0,
        "changeAmount": 0,
        "paymentType": "card",
        "isPickup": pickUp
      },
    };
    Response response = await Requests.post(url, json: dates, headers: headers);
    print(response.json().toString());
    return {
      "saleKey": response.json()["saleKey"],
      "message": response.json()["message"].toString()
    };
  }

  static getLink() async {
    var paramz = {
      "externalId": "152c9b49-7050-46bc-a467-92b167c3f3b4",
      "shopURL":
          "https://yoomoney.ru/checkout/payments/v2/contract?orderId=2b6a5ad3-000f-5000-9000-17144a5e34b6",
      "successURL": "https://yoomoney.ru/",
      "errorURL": "https://yoomoney.ru/",
    };
    Response response = await Requests.get(
        "https://api.sbis.ru/retail/order/152c9b49-7050-46bc-a467-92b167c3f3b4/payment-link",
        headers: headers,
        queryParameters: paramz);
    print(response.json());
  }

  static Future getOrderState(String saleKey) async {
    Response response =
        await Requests.get("https://api.sbis.ru/retail/order/$saleKey/state");

    return response.json()["state"];
  }

  static registerCheck() async {
    dynamic params = {
      "externalId": "471a89cf-a1bd-4c81-a5d8-78284265ef57",
      "nonFiscal": true,
      "cashSum": 400,
      "paymentType": "full",
    };
    Response response = await Requests.post(
        "https://api.sbis.ru/retail/order/1c8780c0-2f51-45eb-b9f8-2d5478312e31/register-payment",
        json: params);
    print(response.json());
  }

  static createSale() async {
    dynamic saleParameters = {
      "companyID": ApiKey.pointId.toString(),
      "kktRegNumber": "0005104605015058",
      "cashierFIO": "Кабицкая Татьяна Юрьевна",
      "operationType": "1",
      "cashSum": "100",
      "bankSum": null,
      "internetSum": null,
      "accountSum": null,
      "postpaySum": null,
      "prepaySum": null,
      "vatNone": null,
      "vatSum0": null,
      "vatSum10": null,
      "vatSum20": null,
      "vatSum110": null,
      "vatSum120": "100",
      "allowRetailPayed": "1",
      "nomenclatures": [
        {
          "nameNomenclature": "Аэрозольная краска 101A ARTON Chicken 400мл",
          "barcodeNomenclature": "X8154481",
          "priceNomenclature": "100",
          "quantityNomenclature": "1",
          "measureNomenclature": "ШТ",
          "kindNomenclature": "Т",
          "totalPriceNomenclature": "100",
          "taxRateNomenclature": "10",
          "totalVat": "16.67"
        }
      ],
      "customerFIO": "Плиев Иван",
      "customerEmail": null,
      "customerPhone": null,
      "customerINN": null,
      "customerExtId": "a901c895-5a71-42ef-ae24-5195727aadce",
      "taxSystem": "1",
      "sendEmail": "airlounj@gmail.com",
      "propName": null,
      "propVal": null,
      "comment": "тестовый чек",
      "payMethod": "4"
    };
    Response response =
        await Requests.post(saleUrl, json: saleParameters, headers: headers);
    print(response.json());
  }
}
