import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graffitineeds/helpers/firebase_cache.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/helpers/styles.dart';

import 'package:graffitineeds/models/mainpageCover.dart';
import 'package:graffitineeds/models/product.dart';
import 'package:graffitineeds/product/productuiCard.dart';
import 'package:graffitineeds/services/apitest.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({String? title});
  @override
  _CategoryPageState createState() => new _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    _getCategories();
  }

  List<MainPageCover> categoryList = [];

  bool onSearchTap = false;
  @override
  void dispose() {
    super.dispose();
  }

  bool productSearch = false;
  int pageNumber = 0;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    print("refresh");
  }

  void _onLoading() async {
    // monitor network fetch
    if (mounted)
      setState(() {
        pageNumber += 1;
      });
    print("onLoading");
    await Future.delayed(Duration(milliseconds: 300));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted)
      await _getProducts(_searchString, page: pageNumber)
          .then((value) => productsList += value)
          .whenComplete(() {
        print("CUMPLETE");
      });
    print("complete");
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<List<ProductItemUI>> _getProducts(String searchString,
      {bool isRefresh = false, int? page}) async {
    List<ProductItemUI> productList = [];
    ProductApi? productApi;
    if (mounted)
      setState(() {
        productList = [];
        productSearch = true;
      });
    productApi = await ApiTest.getProducts(searchString, page!, 50)
        .catchError((onError) {
      // ignore: invalid_return_type_for_catch_error
      return Future.error(Exception("ff"));
    }).onError((error, stackTrace) => Future.error(Exception("ff")));
    ;

    productApi.nomenclatures!.forEach((i) {
      if (i.nomNumber != null &&
          i.id != null &&
          (i.cost != 'null') &&
          double.parse(i.balance!).toInt() > 0) {
        productList.add(ProductItemUI(
          title: i.name!,
          id: i.id!.toString(),
          brandName: "sbis",
          externalId: i.externalId!,
          nomNumber: i.nomNumber!,
          categoryName: "search",
          productView: false,
          categoryId: i.hierarchicalParent?.toString(),
          image: i.images != null
              ? APILINKIMAGE + i.images![0].toString()
              : gnLogo,
          price: double.parse(i.cost!).toInt(),
          searchString: i.nomNumber!,
          quantity: double.parse(i.balance!).toInt(),
          description: i.description ?? "",
        ));
      }
    });
    if (mounted)
      setState(() {
        productSearch = false;
      });
    return productList;
  }

  bool _loading = false;
  _getCategories() async {
    categoryList = [];
    _loading = true;

    await FirebaseFirestore.instance
        .collection("категории")
        .doc("подкатегории")
        .collection("подкатегории")
        .orderBy("номер")
        .getCacheFirst()
        .then((val) {
      val.docs.forEach(
        (document) {
          if (document.get("published") as bool == true)
            setState(() {
              categoryList.add(MainPageCover(
                id: document.get("номер"),
                imageUrl: document.get("картинка"),
                title: document.get("название"),
                categories: document.id,
                searchList: document.get(SEARCHLIST),
              ));
            });
        },
      );
    });
    _loading = false;
  }

  List<ProductItemUI> productsList = [];
  String _searchString = "";
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return new Scaffold(
        resizeToAvoidBottomInset: false,
        // key: _scaffoldKey,

        appBar: AppBar(
            foregroundColor: mainColor,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            flexibleSpace: SafeArea(
                child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                width: double.infinity,
                height: 40,
                child: CupertinoSearchTextField(
                  controller: _textController,
                  itemColor: Colors.black45,
                  placeholder: "Введите товар",
                  style: TextStyle(
                      color: Colors.black, fontFamily: "Circe", fontSize: 14),
                  decoration: BoxDecoration(
                    color: Color(0xFFE4E4E4),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  onChanged: (val) async {
                    if (mounted)
                      setState(() {
                        _searchString = val.toLowerCase();
                        pageNumber = 0;
                      });
                    if (mounted)
                      await _getProducts(_searchString, page: pageNumber)
                          .then((value) => productsList = value);
                    print(pageNumber);
                  },
                  onSuffixTap: () {
                    pageNumber = 0;
                    productsList.clear();
                    _textController.clear();
                    setState(() {
                      _searchString = "";
                    });
                  },
                ),
              )
            ]))),
        body: _searchString == ""
            ? !_loading
                ? SafeArea(
                    child: ListView(
                        padding: EdgeInsets.only(bottom: 10),
                        children: categoryList))
                : Center(
                    child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                  ))
            : _searchField());
  }

  _searchField() {
    return productsList.length != 0
        ? SmartRefresher(
            controller: _refreshController,
            enablePullDown: false,
            enablePullUp: true,
            footer: ClassicFooter(
              loadingText: "Обновляется",
              // releaseText: "Обновляется",
              idleText: "Потяните вниз",
              canLoadingText: "Можно отпустить",
              completeDuration: const Duration(milliseconds: 300),
              failedText: "Не удалось получить данные",
              //   noDataText: "Ничего не нашлось, попробуйте еще раз",
              // completeText: "Обновлено",
            ),
            onLoading: _onLoading,
            onRefresh: _onRefresh,
            child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 0.6,
                children: productsList))
        : Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
