import 'package:flutter/material.dart';

class PreCartItemModel {
  int? id;
  String? hierarchicalParent;
  String? imageUrl;
  String? colorName;
  String? hexColor;
  String? externalId;
  int? weight;
  int? price;
  int? quantity;
  int? size;
  String? brandName;
  String? nomNumber;
  String? categoryName;
  String? description;

  PreCartItemModel(
      {this.id,
      this.hierarchicalParent,
      this.brandName,
      this.categoryName,
      this.description,
      this.nomNumber,
      this.externalId,
      this.colorName,
      this.weight,
      this.size,
      this.imageUrl,
      this.hexColor,
      this.price,
      this.quantity});
}
