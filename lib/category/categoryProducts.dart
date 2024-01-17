import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:graffitineeds/helpers/styles.dart';

import 'package:graffitineeds/models/product.dart';
import 'package:graffitineeds/product/filter.dart';
import 'package:graffitineeds/product/productuiCard.dart';

import 'package:graffitineeds/services/apitest.dart';

import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'package:sliver_tools/sliver_tools.dart';

class CategoryProducts extends StatefulWidget {
  List<ProductItemUI> productsList;
  String title;
  List<dynamic>? searchList;
  CategoryProducts(
      {required this.productsList, required this.title, this.searchList});
  @override
  _CategoryProductsState createState() => new _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
    productsList.addAll(widget.productsList);
    ooop2();
  }

  List<ProductItemUI> productsList = [];
  List<ProductItemUI> searchList = [];
  bool productSearch = false;
  int pageNumber = 0;
  int searchPageNumber = 0;

  Future<List<ProductItemUI>> _getProducts(String searchString, int? page,
      {bool isRefresh = false, String? name}) async {
    List<ProductItemUI> productList = [];
    ProductApi? productApi;
    if (mounted)
      setState(() {
        productSearch = true;
      });
    productApi = await ApiTest.getProducts(
            searchString == "" ? name! : searchString,
            pageNumber,
            widget.title == "аэрозольная краска" ? 300 : 50)
        .catchError((onError) {
      // ignore: invalid_return_type_for_catch_error
      return Future.error(Exception("e1"));
    }).onError((error, stackTrace) {
      _refreshController.loadFailed();
      return Future.error(Exception("e2"));
    });

    productApi.nomenclatures!.forEach((i) {
      if (i.published! &&
          i.nomNumber != 'null' &&
          (i.cost.toString() != 'null') &&
          double.parse(i.balance!).toInt() > 0) {
        productList.add(ProductItemUI(
          title: i.name!,
          id: i.id!.toString(),
          brandName: "sbis",
          nomNumber: i.nomNumber!,
          externalId: i.externalId!,
          categoryName: widget.title,
          productView: false,
          categoryId: i.hierarchicalParent!.toString(),
          image: i.images != null
              ? APILINKIMAGE + i.images![0].toString()
              : gnLogo,
          price: double.parse(i.cost!.toString()).toInt(),
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
    print(productsList.length);
    print(pageNumber.toString() + " " + searchPageNumber.toString());
    return productList;
  }

  bool loading = true;
  ooop2() async {
    await Future.forEach(widget.searchList!, (nom) async {
      await _getProducts(_searchString, pageNumber, name: nom.toString())
          .then((val) {
        productsList += val;
      });
    }).onError((error, stackTrace) {
      print(error);
      if (mounted)
        setState(() {
          _refreshController.loadFailed();
          loading = false;
        });
    }).whenComplete(() => loading = false);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

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
        _searchString == "" ? pageNumber += 1 : searchPageNumber += 1;
      });
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _searchString != ""
        ? await _getProducts(_searchString, searchPageNumber).then((value) =>
            _searchString == "" ? productsList += value : searchList += value)
        : await ooop2();
    ;

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  String _searchString = "";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  color: Colors.transparent,
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.arrow_back,
                    size: 28.0,
                    color: mainColor,
                  ))),
          title: Text(
            widget.title.toUpperCase(),
            style: TextStyle(fontFamily: "Circe", fontWeight: FontWeight.w700),
          ),
          elevation: 0.0,
        ),
        body: Column(children: [
          _searchBar(_searchString),

          /* StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (builder) {
                            return CupertinoActionSheet(
                              actions: [
                                CupertinoActionSheetAction(
                                    onPressed: () {
                                      widget.productsList.sort((a, b) =>
                                          a.price!.compareTo(b.price!));
                                      setState(() {});
                                      //Navigator.pop(context);
                                    },
                                    isDefaultAction: true,
                                    child: Text("По возрастанию")),
                                CupertinoActionSheetAction(
                                    onPressed: () {},
                                    isDestructiveAction: true,
                                    child: Text("По убыванию")),
                                CupertinoActionSheetAction(
                                    onPressed: () {},
                                    isDestructiveAction: true,
                                    child: Text("Сбросить"))
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  isDestructiveAction: true,
                                  child: Text("Отмена")),
                            );
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.sort_down,
                            color: Colors.black,
                            size: 24,
                          ),
                        ],
                      ),
                    ));
              })*/
          Expanded(
              child: !loading
                  ? SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: false,
                      enablePullUp: true,
                      footer: ClassicFooter(
                        loadingText: "Обновляется",
                        // releaseText: "Обновляется",
                        canLoadingText: "Можно отпустить",
                        idleText: "Потяните вниз",
                        failedText: "Не удалось загрузить, попробуйте еще",
                        // completeText: "Обновлено",
                      ),
                      onLoading: _onLoading,
                      onRefresh: _onRefresh,
                      child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 20.0,
                          childAspectRatio: 0.6,
                          children:
                              _searchString == "" ? productsList : searchList))
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(mainColor),
                      ),
                    )),
        ]));
  }

  _searchField() {
    return SafeArea(
        child: productSearch
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                ),
              )
            : productsList.length != 0
                ? GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 0.6,
                    children: productsList)
                : Container(
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.not_interested,
                            size: 70,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Ничего не нашлось, попробуйте еще раз",
                            style: TextStyle(
                              fontFamily: mainFontFamily,
                              fontSize: 16,
                              color: Colors.black45,
                            ),
                          ),
                        ])));
  }

  _sort(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return GestureDetector(
          onTap: () {
            showCupertinoModalPopup(
                context: context,
                builder: (builder) {
                  return CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                          onPressed: () {
                            widget.productsList
                                .sort((a, b) => a.price!.compareTo(b.price!));
                            setState(() {});
                            //Navigator.pop(context);
                          },
                          isDefaultAction: true,
                          child: Text("По возрастанию")),
                      CupertinoActionSheetAction(
                          onPressed: () {},
                          isDestructiveAction: true,
                          child: Text("По убыванию")),
                      CupertinoActionSheetAction(
                          onPressed: () {},
                          isDestructiveAction: true,
                          child: Text("Сбросить"))
                    ],
                    cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        isDestructiveAction: true,
                        child: Text("Отмена")),
                  );
                });
          },
          child: Container(
            margin: EdgeInsets.only(top: 10),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.sort_down,
                  color: Colors.black,
                  size: 24,
                ),
              ],
            ),
          ));
    });
  }

  _searchBar(String searchString) {
    double widthSize = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(children: [
      Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 10),
        width: widthSize,
        height: 40,
        child: CupertinoSearchTextField(
          controller: _textController,
          itemColor: Colors.black45,
          //  prefixInsets: EdgeInsets.only(left: 8, right: 3),
          placeholder: "Введите товар",
          //   placeholderStyle: TextStyle(color: Colors.black),
          style:
              TextStyle(color: Colors.black, fontFamily: "Circe", fontSize: 14),
          decoration: BoxDecoration(
            color: Color(0xFFE4E4E4),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          onChanged: (val) async {
            searchPageNumber = 0;
            if (mounted)
              setState(() {
                _searchString = val.toLowerCase();
              });
            if (mounted)
              await _getProducts(_searchString, searchPageNumber, name: "")
                  .then((value) => searchList = value)
                  .whenComplete(() {
                print("CUMPLETE");
              }).catchError((onError) {
                // ignore: invalid_return_type_for_catch_error
                return Future.error(Exception("a1"));
              }).onError((error, stackTrace) {
                _refreshController.loadFailed();
                return Future.error(Exception("a2"));
              });
            ;
          },

          onSuffixTap: () {
            searchPageNumber = 0;
            searchList.clear();
            _textController.clear();
            if (mounted)
              setState(() {
                _searchString = "";
              });
          },
        ),
      )
    ]));
  }

  Widget _titlePinned(String title) {
    return SliverPinnedHeader(
        child: Container(
      margin: EdgeInsets.only(bottom: 10, left: 20),
      height: 40,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));
  }

  _filter() {
    return Row(children: [
      GestureDetector(
          onTap: () {
            showBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => FilterView(),
            );
          },
          child: Container(
            margin: EdgeInsets.only(left: 15),
            width: 82,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 2,
                ),
                Icon(
                  Icons.color_lens_outlined,
                  color: Colors.black,
                  size: 17,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Фильтр",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )),
      SizedBox(
        width: 15,
      ),
      Container(
        // margin: EdgeInsets.only(left: 15, bottom: 10),
        width: 105,
        height: 25,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 2,
            ),
            Icon(
              CupertinoIcons.sort_down,
              color: Colors.black,
              size: 17,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              "Сортировка",
              style: TextStyle(
                //fontSize: 11,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
