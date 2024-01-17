// To parse this JSON data, do
//
//     final productApi = productApiFromMap(jsonString);

import 'dart:convert';

import 'package:graffitineeds/helpers/firebase_names.dart';

ProductApi productApiFromMap(String str) =>
    ProductApi.fromMap(json.decode(str));

String productApiToMap(ProductApi data) => json.encode(data.toMap());

class ProductApi {
  ProductApi({
    this.nomenclatures,
    this.outcome,
  });

  List<Nomenclature>? nomenclatures;
  Outcome? outcome;

  factory ProductApi.fromMap(Map<String, dynamic> json) => ProductApi(
        nomenclatures: List<Nomenclature>.from(json["nomenclatures"].map((x) {
          return Nomenclature.fromMap(x);
        })),
        outcome: Outcome.fromMap(json["outcome"]),
      );

  Map<String, dynamic> toMap() => {
        "nomenclatures":
            List<dynamic>.from(nomenclatures!.map((x) => x.toMap())),
        "outcome": outcome!.toMap(),
      };
}

class Nomenclature {
  Nomenclature({
    this.attributes,
    this.balance,
    this.cost,
    this.description,
    this.externalId,
    this.hierarchicalId,
    this.hierarchicalParent,
    this.id,
    this.images,
    this.indexNumber,
    this.modifiers,
    this.name,
    this.nomNumber,
    this.published,
    this.unit,
  });

  Map<dynamic, dynamic>? attributes;
  String? balance;
  String? cost;
  String? description;
  String? externalId;
  int? hierarchicalId;
  int? hierarchicalParent;
  int? id;
  List<dynamic>? images;
  int? indexNumber;
  List<Modifiers>? modifiers;
  String? name;
  String? nomNumber;
  bool? published;
  String? unit;

  factory Nomenclature.fromMap(Map<String, dynamic> json) => Nomenclature(
        attributes: json["attributes"],
        balance: json["balance"].toString(),
        cost: json["cost"].toString(),
        description: json["description"],
        externalId: json["externalId"],
        hierarchicalId: json["hierarchicalId"],
        hierarchicalParent: json["hierarchicalParent"],
        id: json["id"],
        images: json["images"],
        indexNumber: json["indexNumber"],
        modifiers: List<Modifiers>.from(json["modifiers"].map((x) {
          return Modifiers.fromMap(x);
        })),
        name: json["name"],
        nomNumber: json["nomNumber"],
        published: json["published"],
        unit: json["unit"],
      );

  Map<String, dynamic> toMap() => {
        "attributes": attributes,
        "balance": balance,
        "cost": cost,
        "description": description,
        "externalId": externalId,
        "hierarchicalId": hierarchicalId,
        "hierarchicalParent": hierarchicalParent,
        "id": id,
        "images": List<dynamic>.from(images!.map((x) => x)).toList(),
        "indexNumber": indexNumber,
        "modifiers": List<dynamic>.from(modifiers!.map((x) => x)),
        "name": name,
        "nomNumber": nomNumber,
        "published": published,
        "unit": unit,
      };
}

class Attributes {
  Attributes({
    this.hex,
    this.weight,
    this.productSize,
  });

  String? hex;
  String? weight;
  String? productSize;

  factory Attributes.fromMap(Map<String, dynamic> json) => Attributes(
      hex: json[HEX], weight: json[WEIGHT], productSize: json[PRODUCTSIZE]);

  Map<String, dynamic> toMap() => {
        HEX: hex,
        WEIGHT: weight,
        PRODUCTSIZE: productSize,
      };
}

class Outcome {
  Outcome({
    this.hasMore,
  });

  bool? hasMore;

  factory Outcome.fromMap(Map<String, dynamic> json) => Outcome(
        hasMore: json["hasMore"],
      );

  Map<String, dynamic> toMap() => {
        "hasMore": hasMore,
      };
}

RelatedProductApi relatedProductApiFromMap(String str) =>
    RelatedProductApi.fromMap(json.decode(str));

class RelatedProductApi {
  List<RelatedProducts>? relatedProducts;

  RelatedProductApi({this.relatedProducts});

  factory RelatedProductApi.fromMap(Map<String, dynamic> json) =>
      RelatedProductApi(
        relatedProducts:
            List<RelatedProducts>.from(json["related_products"].map((x) {
          return RelatedProducts.fromMap(x);
        })),
      );
}

class RelatedProducts {
  int? id;
  String? cost;
  String? extetnalId;
  String? name;
  String? nomNumber;
  RelatedProducts({
    this.cost,
    this.extetnalId,
    this.id,
    this.name,
    this.nomNumber,
  });
  factory RelatedProducts.fromMap(Map<String, dynamic> json) => RelatedProducts(
      cost: json["cost"].toString(),
      extetnalId: json[" extetnalId"],
      name: json["name"],
      id: json["id"],
      nomNumber: json["nomNumber"]);
}

class Modifiers {
  int? id;
  int? baseCount;
  int? cost;
  String? externalId;
  String? hierarchicalId;
  List<dynamic>? images;
  String? name;
  String? nomNumber;
  String? hierarchicalParent;
  String? description;

  Modifiers(
      {this.id,
      this.hierarchicalParent,
      this.baseCount,
      this.cost,
      this.description,
      this.externalId,
      this.hierarchicalId,
      this.images,
      this.name,
      this.nomNumber});

  factory Modifiers.fromMap(Map<String, dynamic> json) => Modifiers(
        id: json["id"],
        baseCount: double.parse(json["baseCount"].toString()).toInt(),
        cost: double.parse(json["cost"].toString()).toInt(),
        externalId: json["externalId"],
        hierarchicalId: json["hierarchicalId"].toString(),
        hierarchicalParent: json["hierarchicalParent"].toString(),
        description: json["description"],
        name: json["name"],
        nomNumber: json["nomNumber"],
        images: json["images"],
      );
  Map<String, dynamic> toMap() => {
        'baseCount': baseCount,
        "cost": cost,
        "description": description,
        "externalId": externalId,
        "hierarchicalId": hierarchicalId,
        "hierarchicalParent": hierarchicalParent,
        "id": id,
        "images": List<dynamic>.from(images!.map((x) => x)).toList(),
        "name": name,
        "nomNumber": nomNumber,
      };
}
