import 'dart:convert';

DeliveryCost deliveryCostFromJson(String str) =>
    DeliveryCost.fromJson(json.decode(str));

class DeliveryCost {
  String? Price;
  String? PriceBase;
  int? PriceService;
  int? DeliveryPeriod;

  static const String PRICE = "price";
  static const String PRICEBASE = "price_base";
  static const String PRICESERVICE = "price_service";
  static const String DELIVERYPERIOD = "delivery_period";

  DeliveryCost(
      {this.Price, this.PriceBase, this.PriceService, this.DeliveryPeriod});

  factory DeliveryCost.fromJson(Map<String, dynamic> json) {
    return DeliveryCost(
      Price: json[PRICE].toString(),
      PriceBase: json[PRICEBASE].toString(),
      PriceService: json[PRICESERVICE] ?? 0,
      DeliveryPeriod: json[DELIVERYPERIOD] ?? 0,
    );
  }
}
