import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';

import 'package:graffitineeds/helpers/styles.dart';

import 'package:graffitineeds/models/product.dart';
import 'package:graffitineeds/product/productuiCard.dart';
import 'package:graffitineeds/services/apitest.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ProductItem extends StatefulWidget {
  String categoryId;
  String title;
  String brandName;
  String categoryName;
  bool productView;
  String searchString;
  ProductItem(
      {required this.categoryId,
      required this.title,
      required this.brandName,
      required this.categoryName,
      required this.searchString,
      required this.productView});
  @override
  _ProductItemState createState() => new _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  List<ProductItemUI> productItemUIList = [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  int totalPages = 200;
  int defaultQuantity = 999999;
  bool loadingData = true;

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));
    refreshController.loadFailed();

    print("refresh");
  }

  int pageNumber = 0;
  void _onLoading() async {
    // monitor network fetch
    if (mounted)
      setState(() {
        pageNumber += 1;
      });
    print("onLoading");
    await Future.delayed(Duration(milliseconds: 300));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    await _getProducts(page: pageNumber)
        .then((value) => productItemUIList += value)
        .whenComplete(() {
      print("CUMPLETE");
    }).catchError((onError) {
      print(onError);
      refreshController.loadFailed();

      // ignore: invalid_return_type_for_catch_error
      return Future.error(Exception("ff"));
    }).onError((error, stackTrace) {
      refreshController.loadFailed();

      return Future.error(Exception("ff"));
    });

    print("complete");
    if (mounted) setState(() {});
    refreshController.loadComplete();
  }

  bool isRefresh = false;
  Future<List<ProductItemUI>> _getProducts({int? page}) async {
    List<ProductItemUI> productList = [];
    if (!isRefresh) if (mounted)
      await FirebaseFirestore.instance
          .collection("категории")
          .doc("бренды")
          .collection("бренды")
          .doc(widget.brandName)
          .collection("подкатегории")
          .doc(widget.categoryName)
          .collection(widget.categoryName)
          .get()
          .then((value) {
        value.docs.forEach((snap) {
          if (mounted)
            setState(() {
              productList.add(ProductItemUI(
                id: snap.id,
                title: snap.data()["наименование"],
                image: snap.data()["картинка"],
                price: snap.data()["цена"],
                externalId: snap.data()["externalId"] ?? "666666",
                weight: snap.data()["вес"]! ?? 300,
                categoryId: snap.data()["categoryId"],
                nomNumber: snap.data()["nomNumber"],
                productView: snap.data()["productView"],
                searchString: snap.data()["searchString"],
                categoryName: widget.categoryName,
                brandName: widget.brandName,
                description: snap.data()["описание"].toString(),
                quantity: defaultQuantity,
              ));
            });
        });
      }).whenComplete(() => isRefresh = true);

    if (!widget.productView) {
      ProductApi? productApi;
      productApi =
          await ApiTest.getProducts(widget.searchString, page!, totalPages)
              .catchError((onError) {
        print(onError);
        // ignore: invalid_return_type_for_catch_error
        refreshController.loadFailed();

        // ignore: invalid_return_type_for_catch_error
        return Future.error(Exception("ff"));
      }).onError((error, stackTrace) {
        refreshController.loadFailed();
        print(error);
        return Future.error(Exception("ff"));
      });
      try {
        productApi.nomenclatures!.forEach((i) {
          if (i.hierarchicalParent == int.parse(widget.categoryId) &&
              i.nomNumber != null &&
              i.id != null &&
              (i.cost != 'null') &&
              double.parse(i.balance!).toInt() > 0) {
            productList.add(ProductItemUI(
              title: i.name,
              id: i.id.toString(),
              brandName: widget.brandName,
              nomNumber: i.nomNumber,
              categoryName: widget.categoryName,
              productView: false,
              externalId: i.externalId!,
              weight: i.attributes![WEIGHT] == null
                  ? 350
                  : int.parse(i.attributes![WEIGHT].toString()),
              categoryId: i.hierarchicalParent.toString(),
              image: i.images != null
                  ? APILINKIMAGE + i.images![0].toString()
                  : gnLogo,
              price: double.parse(i.cost!).toInt(),
              searchString: widget.searchString,
              quantity: double.parse(i.balance!).toInt(),
              description: i.description ?? "",
            ));
          }
        });
      } catch (e) {
        productApi.nomenclatures!.forEach((i) {
          if (i.hierarchicalParent == int.parse(widget.categoryId) &&
              i.nomNumber != null &&
              i.id != null &&
              (i.cost != 'null') &&
              double.parse(i.balance!).toInt() > 0) {
            productList.add(ProductItemUI(
              title: i.name,
              id: i.id.toString(),
              brandName: widget.brandName,
              nomNumber: i.nomNumber,
              externalId: i.externalId!,
              categoryName: widget.categoryName,
              productView: false,
              weight: 350,
              categoryId: i.hierarchicalParent.toString(),
              image: i.images != null
                  ? APILINKIMAGE + i.images![0].toString()
                  : gnLogo,
              price: double.parse(i.cost!).toInt(),
              searchString: widget.searchString,
              quantity: double.parse(i.balance!).toInt(),
              description: i.description ?? "",
            ));
          }
        });
      }
    } else {}
    if (mounted) loadingData = false;

    return productList;
  }

  @override
  void initState() {
    super.initState();
    productItemUIList = [];
    _getProducts(page: pageNumber)
        .then((value) => productItemUIList = value)
        .whenComplete(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  color: Colors.transparent,
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.arrow_back,
                    color: mainColor,
                    size: 28.0,
                  ))),
          title: Text(
            widget.title.toUpperCase(),
            style: TextStyle(fontFamily: "Circe", fontWeight: FontWeight.w700),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: !loadingData
            ? SmartRefresher(
                controller: refreshController,
                enablePullDown: false,
                enablePullUp: true,
                footer: ClassicFooter(
                  loadingText: "Обновляется",
                  // releaseText: "Обновляется",
                  noDataText: "Каталог закончился",
                  noMoreIcon: Icon(
                    Icons.cancel_outlined,
                    color: mainColor,
                  ),
                  canLoadingText: "Можно отпустить",
                  loadStyle: LoadStyle.ShowWhenLoading,
                  idleText: "Потяните вниз",
                  completeDuration: const Duration(milliseconds: 300),
                  failedText: "Не удалось получить данные",
                  //   noDataText: "Ничего не нашлось, попробуйте еще раз",
                  // completeText: "Обновлено",
                ),
                onLoading: !widget.productView
                    ? _onLoading
                    : () {
                        refreshController.loadNoData();
                      },
                onRefresh: !widget.productView
                    ? _onRefresh
                    : () {
                        refreshController.loadNoData();
                      },
                child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 0.6,
                    children: productItemUIList))
            : Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                ),
              ));
  }
}
