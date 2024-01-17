import 'package:graffitineeds/boxberry/citiesModel.dart';
import 'package:graffitineeds/boxberry/deliveryCostModel.dart';
import 'package:graffitineeds/boxberry/pvzModel.dart';
import 'package:graffitineeds/models/orderListModel.dart';
import 'dart:convert';
import 'package:requests/requests.dart';

class ApiBoxberry {
  static String bxToken = "608cf10edb9e10fe85d8a108e41409f5";
  static Future<List<Pvz>> getPVZ(String CityCode) async {
    String requestUrl =
        "https://api.boxberry.ru/json.php?token=$bxToken&method=ListPoints&prepaid=1CountryCode=643&CityCode=$CityCode";
    var response = await Requests.get(requestUrl);

    var io = json.encode(response.json());

    return pvzFromJson(io);
  }

  static Future<List<City>> getCities() async {
    String requestUrl =
        "https://api.boxberry.ru/json.php?token=$bxToken&method=ListCities&CountryCode=643";
    var response = await Requests.get(requestUrl);

    var io = json.encode(response.json());

    return cityFromJson(io);
  }

  static Future<DeliveryCost> deliveryCost(String pvzCode, int weight) async {
    String requestUrl =
        "https://api.boxberry.ru/json.php?token=$bxToken&method=DeliveryCosts&weight=$weight&target=$pvzCode&ordersum=0&deliverysum=0&&paysum=100";
    var response = await Requests.get(requestUrl);

    var io = json.encode(response.json());
    print(response.json());
    return deliveryCostFromJson(io);
  }

  static Future createDelivery(String orderId, List<OrderListModel> items,
      Map customer, Pvz pvz, int weight, int deliveryCost) async {
    List<Map<String, dynamic>> itemsList = [];
    items.forEach((i) {
      itemsList.add({
        "id": i.nomNumber,
        "name": i.name,
        "price": i.price,
        "quantity": i.quantity
      });
    });
    var parameters = {
      "token": bxToken,
      "method": "ParselCreate",
      "sdata": json.encode({
        "order_id": orderId,
        "vid": "1",
        "delivery_sum": deliveryCost.toString(),
        "shop": {"name": pvz.Code.toString(), "name1": ""},
        "customer": customer,
        "weights": {"weight": weight},
        "items": itemsList
      }),
    };
    print(orderId);
    print(customer);
    print(pvz.Code);
    var headers = {'Content-Type': "application/x-www-form-urlencoded"};

    String requestUrl = "https://api.boxberry.ru/json.php";
    var response = await Requests.post(requestUrl,
        bodyEncoding: RequestBodyEncoding.FormURLEncoded,
        body: parameters,
        headers: headers);

    print(response.body);
  }

  static trackDelivery(String trackNumber) async {
    String requestUrl = "https://boxberry.ru/tracking-page?id=$trackNumber";
  }
}
