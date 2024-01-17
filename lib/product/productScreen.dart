import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:graffitineeds/auth/authentication.dart';

import 'package:graffitineeds/counter/colorsCounter.dart';
import 'package:graffitineeds/counter/counterProduct.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/models/colorsModel.dart';
import 'package:graffitineeds/models/modifierUi.dart';
import 'package:graffitineeds/models/product.dart';

import 'package:graffitineeds/product/colorsList.dart';
import 'package:graffitineeds/product/filter.dart';
import 'package:graffitineeds/product/productuiCard.dart';
import 'package:graffitineeds/provider/user_pr.dart';
import 'package:graffitineeds/services/api_services.dart';
import 'package:graffitineeds/services/apitest.dart';
import 'package:graffitineeds/services/productServices.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ItemScreen extends StatefulWidget {
  String id;
  String? nomNumber;
  String categoryId;
  String? imageUrl;
  bool? modifiers;
  String externalId;
  List<Modifiers>? modifiersList;
  String title;
  String? searchString;
  String? description;
  bool productView;
  int? price;
  Attributes? attributes;
  String brandName;

  int? qpak;
  int? minKolvo;

  int? weight;
  String categoryName;
  int? quantity;
  bool? cartItem;
  PageController? page;
  ItemScreen(
      {required this.id,
      required this.categoryId,
      required this.nomNumber,
      this.description,
      this.searchString,
      required this.productView,
      this.imageUrl,
      required this.title,
      required this.externalId,
      required this.price,
      this.quantity,
      this.attributes,
      this.weight,
      this.modifiers,
      this.modifiersList,
      required this.brandName,
      this.cartItem,
      required this.categoryName});

  _ItemScreenState createState() => new _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen>
    with SingleTickerProviderStateMixin {
  int count = 1;
  int kolvo = 1;
  int summa = 0;

  late TabController tabController;
  bool _addedTocart = true;

  bool _tabHeight = true;

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("пользователи");

  Future _addToCart(
      String id,
      String categoryId,
      String nomNumber,
      String title,
      String externalId,
      int quantity,
      int price,
      String categoryName,
      String brandName,
      User? _user,
      int? weight,
      {String? hex,
      String? searchString,
      String? imageUrl}) async {
    List<Map<String, dynamic>> convertModifiers = [];
    if (widget.modifiersList != null) {
      widget.modifiersList!.forEach((element) {
        convertModifiers.add(element.toMap());
      });
    }
    return _usersRef.doc(_user!.uid).collection("корзина").doc(id).set({
      "id": id,
      "categoryId": categoryId,
      "nomNumber": nomNumber,
      "brandId": categoryId,
      "brandName": brandName,
      "imageUrl": imageUrl ?? "",
      "searchString": searchString ?? title,
      "categoryName": categoryName,
      "наименование": title,
      "externalId": externalId,
      "количество": quantity,
      "цена": price,
      "описание": widget.description ?? "",
      "hex": hex ?? "",
      "вес": weight,
      "modifiers": widget.modifiers ?? false,
      'modifiersList': convertModifiers
    });
  }

  Future<List<ColorsModel>>? colorList;
  int? quantityProduct;
  String? description;
  int defaultQuantity = 999999;
  String? hexColor;
  int _price = 0;
  bool _isLoading = false;
  void _getData() async {
    List<Nomenclature>? productsList = [];
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    ProductApi? productApi;

    productApi = await ApiTest.getProducts(widget.nomNumber!, 0, 5)
        .catchError((onError) {
      // ignore: invalid_return_type_for_catch_error
      return Future.error(Exception("failed load product 1"));
    }).onError((error, stackTrace) {
      return Future.error(Exception("failed load product 2"));
    });
    if (this.mounted)
      setState(() {
        productsList = productApi?.nomenclatures;
      });
    var element = productsList!.last;

    if (this.mounted)
      setState(() {
        //  hexColor = value.toString().replaceAll(RegExp("#"), "");
        _price = double.parse(element.cost!).toInt();
        description = element.description;

        quantityProduct = double.parse(element.balance!).toInt();
      });
    /* element.attributes!.forEach((key, value) {
        if (this.mounted)
          setState(() {
            print(element.cost);
            //  hexColor = value.toString().replaceAll(RegExp("#"), "");
            _price = element.cost;
            description = element.description;
            // quantityProduct = element.balance;
          });
      });*/

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  bool colorLoading = false;
  List<ColorsModel> colorsListMain = [];
  getColorList() async {
    colorsListMain = [];
    if (mounted)
      setState(() {
        colorLoading = true;
      });

    await ProductService.getData(widget.searchString!, widget.categoryId,
            widget.brandName, widget.description!, widget.categoryName)
        .then((value) {
      if (mounted)
        setState(() {
          colorsListMain.addAll(value);
        });
      return colorsListMain;
    });

    if (mounted)
      setState(() {
        colorLoading = false;
      });
  }

///////RELATED PRODUCTS////////
  bool relatedLoading = false;
  List<RelatedProducts> relatedProductsList = [];
  Future<List<RelatedProducts>> relatedProducts() async {
    List<RelatedProducts> relatedProductsList1 = [];
    await ApiTest.getRelatedProduct(widget.externalId).then((value) {
      if (value.relatedProducts!.isNotEmpty) {
        relatedProductsList1 = value.relatedProducts!;
      } else {
        throw Exception("fail");
      }
    });
    return relatedProductsList1;
  }

  /////TRANSFORMING INTO PRODUCTUICARD/////
  List<Nomenclature> relatedNomenclatures = [];
  List<ProductItemUI> relatedUiList = [];
  Future<Nomenclature> transformRelatedProduct(String nomNumber) async {
    var nomGet = await ApiTest.getProducts(nomNumber, 0, 5);
    return nomGet.nomenclatures!.last;
  }

  bool relateduiloading = false;
  ooop() async {
    if (mounted)
      setState(() {
        relateduiloading = true;
      });
    await relatedProducts().then((value) {
      if (value.isNotEmpty) {
        value.forEach((nom) async {
          if (mounted)
            await transformRelatedProduct(nom.nomNumber!).then((i) {
              print(i.name);

              relatedUiList.add(ProductItemUI(
                title: i.name,
                id: i.id.toString(),
                productView: false,
                modifiersList: [],
                externalId: i.externalId!,
                modifiers: false,
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
            });
          print(relatedUiList.length);
          if (relatedUiList.length == value.length) {
            if (mounted)
              setState(() {
                relateduiloading = false;
              });
          }
        });
      } else
        throw Exception("failss");
    });
  }

////MODIFIERS////
  List<ModifierUi> modifiersList = [];
  getModifiers(List<Modifiers>? modList) {
    print(modList!.length);
    modList.forEach((element) {
      modifiersList.add(ModifierUi(modifier: element));
    });
  }

  @override
  void initState() {
    super.initState();

    if (!widget.productView) {
      _getData();
    } else {
      _price = widget.price!;
      getColorList();
    }
    if (widget.modifiers!) {
      getModifiers(widget.modifiersList!);
    }
    if (widget.externalId.isNotEmpty || widget.externalId != "666666") {
      ooop();
    }
    tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool state = true;
  @override
  Widget build(BuildContext context) {
    final userpr = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
        bottomNavigationBar:
            !widget.productView ? _bottomInfo(context) : SizedBox(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: NeumorphicButton(
            margin: EdgeInsets.only(top: 10),
            onPressed: () => Navigator.of(context).pop(),
            style: NeumorphicStyle(
              depth: 4,
              shadowLightColor: Colors.transparent,
              color: ThemaMode.isDarkMode ? mainColor : Colors.white54,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            child: NeumorphicIcon(
              Icons.close,
              style: NeumorphicStyle(
                color: !ThemaMode.isDarkMode ? Colors.black : Colors.white,
                depth: 10,
              ),
            )),
        body: SingleChildScrollView(
            clipBehavior: Clip.antiAlias,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            child: Column(
              children: <Widget>[
                Container(
                  //alignment: Alignment.center,
                  color: Colors.white,
                  height: 320,
                  width: double.infinity,
                  child: Hero(
                      tag: "image",
                      child: Image(
                          fit: BoxFit.contain,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Image.asset(
                              "lib/assets/gn_loading.png",
                              fit: BoxFit.contain,
                            );
                          },
                          errorBuilder: (contex, object, tyy) => Image.asset(
                                "lib/assets/gn_loading.png",
                                fit: BoxFit.contain,
                              ),
                          image: NetworkImage(widget.imageUrl!,
                              headers: ApiServices.headers))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Container(
                            margin: EdgeInsets.only(left: 20, top: 5),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ))),
                    Container(
                        margin: EdgeInsets.only(right: 20, top: 5),
                        alignment: Alignment.bottomLeft,
                        child: new Text(
                          widget.price.toString() + " " + "₽",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
                !widget.modifiers!
                    ? widget.productView
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 30, bottom: 10),
                                    child: CounterProduct(
                                      count: count,
                                      price: 0,
                                      kolvo: 1,
                                      color: hexColor,
                                      quantity:
                                          widget.quantity == defaultQuantity
                                              ? _isLoading
                                                  ? 0
                                                  : quantityProduct!
                                              : widget.quantity,
                                      onSelected1: (value) {
                                        if (value > 0) if (mounted)
                                          setState(() {
                                            state = true;
                                            count = value;
                                            kolvo = count;
                                            summa = widget.price! * kolvo;
                                          });

                                        if (value < 1) if (mounted)
                                          setState(() {
                                            count = value;
                                            state = false;
                                          });
                                      },
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: widget.quantity == defaultQuantity
                                        ? _isLoading
                                            ? LoadingAnimationWidget
                                                .horizontalRotatingDots(
                                                color: mainColor,
                                                size: 20,
                                              )
                                            : quantityProduct != null ||
                                                    quantityProduct != 0
                                                ? Text(
                                                    "В наличии ${quantityProduct!} шт.")
                                                : Text("В наличии ${0} шт.")
                                        : Text(
                                            "В наличии ${widget.quantity!} шт.")),
                              ])
                    : SizedBox(),
                widget.productView
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Container(
                                padding: EdgeInsets.only(left: 20, top: 15),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Выбрать цвет:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            GestureDetector(
                              onTap: () {
                                colorLoading
                                    ? print("object")
                                    : showCupertinoModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => ColorsListPage(
                                          colorsList: colorsListMain,
                                          id: widget.id,
                                          imageUrl: widget.imageUrl,
                                          searchString: widget.searchString,
                                          categoryName: widget.categoryName,
                                          hierarchicalParent: widget.categoryId,
                                          brandId: widget.id,
                                          brandName: widget.brandName,
                                          weight: widget.weight,
                                          description: widget.description,
                                        ),
                                      ).then((value) {
                                        if (mounted)
                                          setState(() {
                                            print("added");
                                            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                            userpr.notifyListeners();
                                          });
                                      });
                              },
                              child: Container(
                                  padding: EdgeInsets.only(left: 10, top: 15),
                                  alignment: Alignment.topLeft,
                                  child: Row(children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Text(
                                        "|",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                    ),
                                    colorLoading
                                        ? LoadingAnimationWidget
                                            .horizontalRotatingDots(
                                            color: mainColor,
                                            size: 20,
                                          )
                                        : Text(
                                            "Доступно ${colorsListMain.length}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ])),
                            )
                          ])
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: TabBar(
                          controller: tabController,
                          indicatorColor: mainColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Tab(
                              child: Text(
                                !widget.modifiers!
                                    ? "Описание"
                                    : "Состав набора",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: ThemaMode.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            /* Tab(
                                    child: Text(
                                      "Характеристики",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )*/
                          ],
                          onTap: (index) {
                            print(index);
                            if (index == 0) {
                              if (mounted)
                                setState(() {
                                  _tabHeight = true;
                                });
                            } else {
                              if (mounted)
                                setState(() {
                                  _tabHeight = false;
                                });
                            }
                            print(_tabHeight);
                          },
                        ),
                      ),

                      !widget.modifiers!
                          ? Container(
                              margin: EdgeInsets.only(top: 5, left: 5),
                              //  height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: new Column(children: [
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.title,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Container(
                                              child: Text(
                                            widget.description!
                                                .replaceAll("\\n", "\n")
                                                .replaceAll(
                                                    RegExp(r'<[^>]*>|&[^;]+;'),
                                                    ''),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ))
                                        ])),

                                /*Text(
                                      "- Объем: 250 мл\n- Цвет: Черный\n- В наличии 124 штук\n",
                                      style: TextStyle(color: Colors.black),
                                      // softWrap: true,
                                    )*/
                              ]),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: modifiersList.length,
                              itemBuilder: (contex, i) {
                                return Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    height: 150,
                                    child: modifiersList[i]);
                              }),

                      relateduiloading == true
                          ? SizedBox()
                          : relatedUiList.isEmpty
                              ? SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 15, top: 12),
                                        child: Text(
                                          "C этим товаром покупают",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      new Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20.0),
                                          height: 300.0,
                                          child: GridView.count(
                                              scrollDirection: Axis.horizontal,
                                              crossAxisCount: 1,
                                              mainAxisSpacing: 10.0,
                                              crossAxisSpacing: 60.0,
                                              childAspectRatio: 1.6,
                                              children: relatedUiList))
                                    ])

                      // )
                    ],
                  ),
                ),
              ],
            )));
  }

  void _successTop(User? _user) async {
    await _addToCart(
        widget.id,
        widget.categoryId,
        widget.nomNumber!,
        widget.title,
        widget.externalId,
        count,
        widget.price!,
        widget.categoryName,
        widget.brandName,
        _user,
        widget.weight ?? 350,
        searchString: widget.searchString,
        imageUrl: widget.imageUrl);
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        textStyle: TextStyle(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
        icon: Icon(null),
        message:
            "+${kolvo == 0 ? widget.qpak : kolvo} ${widget.title} добавлен в корзину",
      ),
      displayDuration: Duration(milliseconds: 500),
      onTap: () {},
    );
  }

  void _warningTop() async {
    // await _addToCart();
    showTopSnackBar(
      context,
      CustomSnackBar.error(
        icon: Icon(null),
        textStyle: TextStyle(decoration: TextDecoration.underline),
        message: "Зарегистрируйтесь или войдите в профиль",
      ),
      displayDuration: Duration(milliseconds: 500),
      onTap: () {
        showCupertinoModalPopup(
            context: context, builder: (builder) => AuthPage());
      },
    );
  }

  Widget _bottomInfo(BuildContext contextz) {
    List<int>? total;

    return state
        ? BottomAppBar(
            child: Container(
                height: 80,
                child: new Row(
                    //  mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  "${widget.price! * count} руб",
                                  style: TextStyle(fontSize: 22),
                                ),
                                new Text(
                                  "Количество ${count} шт.",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                )
                              ])),
                      new Container(
                          margin: EdgeInsets.only(right: 20),
                          width: 120,
                          height: 40,
                          // ignore: deprecated_member_use
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(4.0),
                                ),
                                backgroundColor: mainColor,
                              ),
                              onPressed: () async {
                                User? _user = FirebaseAuth.instance.currentUser;
                                if (_user == null)
                                  _warningTop();
                                else {
                                  _successTop(_user);
                                  Provider.of<UserProvider>(contextz,
                                          listen: false)
                                      .changeLoading();
                                }
                              },
                              child: Text("В корзину",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))))
                    ])))
        : SizedBox();
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate({required this.child, required this.height});

  final Widget child;
  final double height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
