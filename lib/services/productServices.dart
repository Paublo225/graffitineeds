import 'package:flutter/material.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/models/colorsModel.dart';
import 'package:graffitineeds/models/preCartModel.dart';
import 'package:graffitineeds/models/product.dart';
import 'package:graffitineeds/services/apitest.dart';

class ProductService {
  List<ColorsModel> MainColorsList = [];
  bool mainFlag = false;
  static List<PreCartItemModel>? preCartList = [];
  int count = 0;
  static int summary = 0;
  static int _summaryCount() {
    summary = 0;
    preCartList!.forEach((l) {
      summary += l.price! * l.quantity!;
    });
    return summary;
  }

  static Future<List<ColorsModel>> getData(
      String searchString,
      String hierarchicalParent,
      String brandName,
      String description,
      String categoryName) async {
    List<ColorsModel> colorsList = [];
    List<Nomenclature>? productsList = [];

    ProductApi? productApi;

    productApi = await ApiTest.getProducts(searchString, 0, 350);

    productsList = productApi.nomenclatures;

    // print("Всего в номенклатуре: ${productApi.nomenclatures!.length}");

    productsList!.forEach((element) {
      if (element.nomNumber != "null") {
        if (element.hierarchicalParent == int.parse(hierarchicalParent) &&
            double.parse(element.balance!).toInt() > 0) {
          String hexz = "#FFFFFF";

          colorsList.add(ColorsModel(
            id: element.id,
            externalId: element.externalId!,
            hierarchicalParent: element.hierarchicalParent.toString(),
            colorName: element.name,
            hexColor: element.attributes![HEX]
                        .toString()
                        .replaceAll(RegExp("#"), "") ==
                    'null'
                ? hexz.toString().replaceAll(RegExp("#"), "")
                : element.attributes!["hex"]
                    .toString()
                    .replaceAll(RegExp("#"), ""),
            nomNumber: element.nomNumber,
            brandName: brandName,
            description: description,
            categoryName: categoryName,
            weight: element.attributes![WEIGHT].toString(),
            price: double.parse(element.cost!).toInt(),
            balance: double.parse(element.balance!).toInt(),
            checked: false,
            onCount: (el) {
              preCartList!.forEach((itm) {
                if (itm.id == element.id) {
                  itm.quantity = el;
                  _summaryCount();
                }
              });
            },
            onChecked: (check) {
              if (check) {
                preCartList!.add(PreCartItemModel(
                    id: element.id,
                    hierarchicalParent: element.hierarchicalId.toString(),
                    colorName: element.name,
                    price: double.parse(element.cost!).toInt(),
                    hexColor: element.attributes![HEX]
                                .toString()
                                .replaceAll(RegExp("#"), "") ==
                            'null'
                        ? hexz.toString().replaceAll(RegExp("#"), "")
                        : element.attributes!["hex"]
                            .toString()
                            .replaceAll(RegExp("#"), ""),
                    weight: element.attributes![WEIGHT],
                    size: element.attributes![PRODUCTSIZE],
                    quantity: 1));

                print(preCartList!.length);
              }

              if (!check) {
                preCartList!
                    .removeWhere((elementz) => element.id == elementz.id);
              }

              _summaryCount();
            },
          ));
        }
      }
    });
    print(colorsList.length);
    return colorsList;
  }
}
