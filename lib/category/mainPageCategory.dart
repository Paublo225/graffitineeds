import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';

import 'package:graffitineeds/models/mainpageCover.dart';

import 'package:graffitineeds/models/product.dart';

import 'package:graffitineeds/product/filter.dart';
import 'package:graffitineeds/product/productuiCard.dart';

import 'package:graffitineeds/services/apitest.dart';

import 'package:sliver_tools/sliver_tools.dart';

// ignore: must_be_immutable
class MainPageCategoryProducts extends StatefulWidget {
  String? id;
  List<dynamic>? nomList;
  int? hierarchicalParent;
  String? name;
  String? imageUrl;
  List<dynamic>? searchList;
  bool? searchFlag;
  bool? modifiers;
  MainPageCategoryProducts(
      {required this.name,
      this.nomList,
      this.id,
      this.imageUrl,
      this.modifiers,
      this.hierarchicalParent,
      this.searchList,
      this.searchFlag});
  @override
  _MainPageCategoryProductsState createState() =>
      new _MainPageCategoryProductsState();
}

class _MainPageCategoryProductsState extends State<MainPageCategoryProducts> {
  late TextEditingController _textController;

  List<MainPageCover> categoryList = [];
  List<ProductItemUI> productsCategoryList = [];
  List<ProductItemUI> searchList = [];
  Future<List<ProductItemUI>>? futureList;
  bool loading = false;

  Future<ProductItemUI>? _getData(String nom) async {
    List<ProductItemUI> productList = [];
    ProductApi? productApi;
    ProductItemUI? productItem;

    productApi = await ApiTest.getProducts(nom.toString(), 0, 5);
    var i = productApi.nomenclatures!;
    if (widget.modifiers!) {
      i.forEach(
        (i) {
          if (i.cost.toString() != 'null') {
            productItem = ProductItemUI(
              title: i.name,
              id: i.id.toString(),
              productView: false,
              modifiersList: i.modifiers,
              externalId: i.externalId!,
              modifiers: widget.modifiers,
              categoryId: i.hierarchicalParent.toString(),
              image: i.images != null
                  ? APILINKIMAGE + i.images![0].toString()
                  : gnLogo,
              price: i.cost.toString() != 'null'
                  ? double.parse(i.cost!.toString()).toInt()
                  : double.parse("0").toInt(),
              nomNumber: i.nomNumber.toString(),
              searchString: i.name,
              quantity: 99999,
              description: i.description ?? "",
              brandName: 'n/a',
              categoryName: 'n/a',
            );
          }
        },
      );
    } else
      i.forEach(
        (i) {
          if (i.cost.toString() != 'null') {
            productItem = ProductItemUI(
              title: i.name,
              id: i.id.toString(),
              productView: false,
              externalId: i.externalId!,
              categoryId: i.hierarchicalParent.toString(),
              image: i.images != null
                  ? APILINKIMAGE + i.images![0].toString()
                  : gnLogo,
              price: i.cost.toString() != 'null'
                  ? double.parse(i.cost!.toString()).toInt()
                  : double.parse("0").toInt(),
              nomNumber: i.nomNumber.toString(),
              searchString: i.name,
              quantity: double.parse(i.balance!.toString()).toInt(),
              description: i.description ?? "",
              brandName: 'n/a',
              categoryName: 'n/a',
            );
          }
        },
      );

    return productItem!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  ooop() async {
    if (mounted)
      setState(() {
        loading = true;
      });
    widget.nomList!.forEach((nom) async {
      if (mounted)
        await _getData(nom.toString())!.then((value) {
          productsCategoryList.add(value);
        });
      if (productsCategoryList.length == widget.nomList!.length) {
        if (mounted)
          setState(() {
            loading = false;
          });
      }
    });
  }

  _getProducts(String name) async {
    ProductApi? productApi;
    List<ProductItemUI> productsCategoryList2 = [];
    productApi = await ApiTest.getProducts(name, 0, 20);
    if (widget.modifiers!) {
      productApi.nomenclatures!.forEach((i) {
        // if (i.hierarchicalParent == widget.hierarchicalParent)

        if (i.modifiers!.isNotEmpty == true) {
          productsCategoryList2.add(ProductItemUI(
            title: i.name,
            id: i.id.toString(),
            productView: false,
            modifiersList: i.modifiers,
            modifiers: widget.modifiers,
            externalId: i.externalId!,
            categoryId: i.hierarchicalParent.toString(),
            image: i.images != null
                ? APILINKIMAGE + i.images![0].toString()
                : gnLogo,
            price: i.cost.toString() != 'null'
                ? double.parse(i.cost!.toString()).toInt()
                : double.parse("0").toInt(),
            nomNumber: i.nomNumber.toString(),
            searchString: i.name,
            quantity: 99999,
            description: i.description ?? "",
            brandName: 'n/a',
            categoryName: 'n/a',
          ));
        }
      });
    } else {
      productApi.nomenclatures!.forEach((i) {
        // if (i.hierarchicalParent == widget.hierarchicalParent)
        if (i.nomNumber != 'null') {
          if ((i.cost.toString() != 'null') &&
              double.parse(i.balance!).toInt() > 0) {
            productsCategoryList2.add(ProductItemUI(
              title: i.name,
              id: i.id.toString(),
              productView: false,
              externalId: i.externalId!,
              categoryId: i.hierarchicalParent.toString(),
              image: i.images != null
                  ? APILINKIMAGE + i.images![0].toString()
                  : gnLogo,
              price: i.cost.toString() != 'null'
                  ? double.parse(i.cost!.toString()).toInt()
                  : double.parse("0").toInt(),
              nomNumber: i.nomNumber.toString(),
              searchString: i.name,
              quantity: double.parse(i.balance!.toString()).toInt(),
              description: i.description ?? "",
              brandName: 'n/a',
              categoryName: 'n/a',
            ));
          }
        }
      });
    }
    return productsCategoryList2;
  }

  ooop2() async {
    if (mounted)
      setState(() {
        loading = true;
      });
    await Future.forEach(widget.searchList!, (nom) async {
      if (mounted)
        await _getProducts(nom.toString()).then((val) {
          if (mounted)
            setState(() {
              productsCategoryList += val;
            });
        });
    });
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) widget.searchFlag! ? ooop2() : ooop();
    _textController = TextEditingController();
  }

  int selectedIndex = 0;
  bool _folded = true;
  String _searchString = "";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        // key: _scaffoldKey,

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
            widget.name!.toUpperCase(),
            style: TextStyle(fontFamily: "Circe", fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Column(children: [
          _searchBar(_searchString),
          !loading
              ? Flexible(
                  child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 0.6,
                  children:
                      _searchString == "" ? productsCategoryList : searchList,
                ))
              : Flexible(
                  child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                  ),
                ))
        ]));
  }

  _sort() {
    return GestureDetector(
        onTap: () {},
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
          placeholder: "Поиск",
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
          onChanged: (val) {
            searchList = [];
            if (mounted)
              setState(() {
                _searchString = val.toLowerCase();
                searchList = productsCategoryList
                    .where((t) => t.title!
                        .toLowerCase()
                        .contains(searchString.toLowerCase()))
                    .toList();
              });
          },

          onSuffixTap: () {
            searchList.clear();
            _textController.clear();
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

  _searchField() {
    return Center(
      child: Container(
          height: MediaQuery.of(context).size.width + 50,
          width: MediaQuery.of(context).size.width * 0.9,
          alignment: Alignment.topCenter,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                // padding: EdgeInsets.only(top: 10, bottom: 50),
                child: Icon(
              Icons.search_rounded,
              size: 80,
              color: Colors.grey[400],
            )),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Введите интересующий Вас товар",
                  style: TextStyle(
                    fontFamily: 'Avenir next',
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                )),
          ])),
    );
  }

  _filter() {
    return Row(children: [
      GestureDetector(
          onTap: () {
            showModalBottomSheet(
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
