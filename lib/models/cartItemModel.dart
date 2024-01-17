import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/counter/counterCard.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/helpers/paint_icons.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';

import 'package:graffitineeds/models/product.dart';
import 'package:graffitineeds/product/productScreen.dart';
import 'package:graffitineeds/provider/user_pr.dart';
import 'package:graffitineeds/services/api_services.dart';
import 'package:graffitineeds/services/apitest.dart';
import 'package:graffitineeds/services/user_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CartItemModel extends StatefulWidget {
  String? id;
  String? categoryId;
  String? nomNumber;
  String name;
  String? hexColor;
  String? imageUrl;
  int? price;
  int? quantity;
  String? searchString;
  String? categoryName;
  String? externalId;
  String? brandName;
  String? description;
  int? balance;
  bool? modifiers;
  int? weight;
  String? size;
  List<dynamic>? modifiersList;
  Function()? onDelete;
  Function(int)? onPlus;
  Function(int)? onBalance;
  Function(int)? onMinus;
  //bool? isAvailable;
  CartItemModel(
      {Key? key,
      this.id,
      this.nomNumber,
      required this.name,
      this.imageUrl,
      this.price,
      this.categoryId,
      this.quantity,
      this.modifiers,
      this.modifiersList,
      this.externalId,
      this.hexColor,
      this.brandName,
      required this.categoryName,
      this.searchString,
      this.balance,
      this.size,
      this.weight,
      this.description,
      this.onBalance,
      this.onDelete,
      this.onPlus,
      this.onMinus});

  _CartItemModelState createState() => new _CartItemModelState();
}

class _CartItemModelState extends State<CartItemModel> {
  int? quantityProduct;
  String? description;
  String? hexColor;
  int? _price = 0;
  bool _isLoading = true;
  UserServices userServices = new UserServices();

  void _getData() async {
    print(widget.nomNumber);
    List<Nomenclature>? productsList = [];

    ProductApi? productApi;

    productApi = await ApiTest.getProducts(widget.nomNumber!, 0, 5);
    if (this.mounted)
      setState(() {
        productsList = productApi?.nomenclatures;
      });
    print(productsList!.last.name);
    try {
      _price = double.parse(productsList!.last.cost!).toInt();
    } catch (r) {
      print(r);
    }
    if (mounted)
      setState(() {
        quantityProduct = double.parse(productsList!.last.balance!).toInt();
        // print(quantityProduct);
        description = productsList!.last.description;
      });
    await updatePrice(_price!);
    /*element.attributes!.forEach((key, value) async {
          if (this.mounted)
            setState(() {
              hexColor = value.toString().replaceAll(RegExp("#"), "");
            });
          if (_price.toString() != "0") await updatePrice(_price!);
        });*/

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  updatePrice(int price) async {
    if (widget.price != price) {
      await UserServices()
          .usersRef
          .doc(UserServices().getUserId())
          .collection("корзина")
          .doc(widget.id)
          .update({'цена': price}).then((value) => setState(() {
                widget.price = price;
                print("price update");
              }));
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.modifiersList != null) convertModifiers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Modifiers>? convertModifiers() {
    List<Modifiers> modList = [];
    widget.modifiersList!.forEach((element) {
      modList.add(Modifiers.fromMap(element));
    });
    return modList;
  }

  int defaultQuantity = 999999;
  @override
  Widget build(BuildContext context) {
    final userpr = Provider.of<UserProvider>(context);
    if (_isLoading) _getData();
    return GestureDetector(
      onTap: () {
        showCupertinoModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => ItemScreen(
            id: widget.id!,
            nomNumber: widget.nomNumber,
            imageUrl: widget.imageUrl!,
            modifiers: widget.modifiers ?? false,
            modifiersList: convertModifiers() ?? [],
            title: widget.name,
            externalId: widget.externalId!,
            weight: widget.weight,
            price: widget.price,
            categoryId: widget.categoryId!,
            productView: false,
            brandName: widget.brandName!,
            searchString: widget.name,
            categoryName: widget.categoryName!,
            description: widget.description,
            cartItem: true,
            quantity: defaultQuantity,
            //  quantity: quantityProduct!
          ),
        );
      },
      child: FutureBuilder(
          future: userpr.getBalance(widget.modifiers!
              ? widget.modifiersList![0][NOMNUMBER]
              : widget.nomNumber!),
          builder: (builder, AsyncSnapshot<int> snap) {
            if (snap.hasData) widget.balance = snap.requireData;
            return Container(
                margin: EdgeInsets.all(16),
                height: 135,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ThemaMode.isDarkMode ? darkBackColor : Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1.0, 3.0),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Row(children: <Widget>[
                  Stack(children: [
                    Container(
                      height: 135,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: OctoImage(
                            height: 135,
                            width: 90,
                            fit: BoxFit.contain,
                            progressIndicatorBuilder: (context, progress) {
                              double? value;
                              if (progress != null &&
                                  progress.expectedTotalBytes != null) {
                                value = progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!;
                              }
                              return Image.asset(
                                "lib/assets/gn_loading.png",
                                fit: BoxFit.contain,
                              );
                            },
                            image: NetworkImage(widget.imageUrl!,
                                headers: ApiServices.headers))),
                  ]),
                  SizedBox(
                    height: 10,
                    width: 5,
                  ),
                  Flexible(
                    child: Stack(
                      children: [
                        if (widget.categoryName == "аэрозоль")
                          Positioned(
                              child: Container(
                                  margin: EdgeInsets.only(right: 45),
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    PaintIcon.paint,
                                    size: 60,
                                    color: Color(
                                        int.parse("0xff" + widget.hexColor!)),
                                  ))),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10, left: 5),
                                child: Text(widget.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                    )),
                              ),
                              !snap.hasData
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                          "${widget.price! * widget.quantity!} руб ",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600)))
                                  : snap.requireData < widget.quantity!
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                              "Нет в наличии\nДоступно: ${snap.requireData} шт.",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)))
                                      : Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                              "${widget.price! * widget.quantity!} руб ",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600)))
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CounterCart(
                                          count: widget.quantity,
                                          price: 0,
                                          kolvo: 1,
                                          quantity: snap.hasData
                                              ? snap.requireData
                                              : widget.quantity,
                                          onSelected1: (num) {
                                            widget.onMinus!(num);
                                            setState(() {
                                              widget.quantity = num;
                                            });
                                          },
                                          onSelected2: (num) {
                                            widget.onPlus!(num);
                                            setState(() {
                                              widget.quantity = num;
                                            });
                                          },
                                        ),
                                        IconButton(
                                            splashRadius: 0.1,
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            padding: EdgeInsets.only(right: 20),
                                            alignment: Alignment.centerRight,
                                            icon: Icon(
                                              CupertinoIcons.trash,
                                              color: Colors.grey[400],
                                              size: 20,
                                            ),
                                            onPressed: widget.onDelete)
                                      ]))
                            ]),
                      ],
                    ),
                  ),
                ]));
          }),
    );
  }
}
