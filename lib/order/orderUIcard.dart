import 'package:flutter/material.dart';

import 'package:graffitineeds/helpers/paint_icons.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';

import 'package:graffitineeds/models/product.dart';
import 'package:graffitineeds/product/productScreen.dart';
import 'package:graffitineeds/product/productuiCard.dart';
import 'package:graffitineeds/provider/user_pr.dart';
import 'package:graffitineeds/services/api_services.dart';
import 'package:graffitineeds/services/apitest.dart';
import 'package:graffitineeds/services/user_service.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:octo_image/octo_image.dart';

import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

// ignore: must_be_immutable
class OrderUiCard extends StatefulWidget {
  String? id;
  String? categoryId;
  String? nomNumber;
  String name;
  String? hexColor;
  String? imageUrl;
  int? price;
  int? quantity;
  int? weight;
  String? saleKey;
  String? searchString;
  String? categoryName;
  String? brandName;
  String? status;

  Future<int>? balance;
  Function()? onDelete;
  Function(int)? onPlus;
  Function(int)? onMinus;
  //bool? isAvailable;
  OrderUiCard(
      {Key? key,
      this.id,
      this.nomNumber,
      required this.name,
      this.imageUrl,
      this.price,
      this.categoryId,
      this.quantity,
      this.status,
      this.saleKey,
      this.hexColor,
      this.brandName,
      this.categoryName,
      this.searchString,
      this.balance,
      this.weight,
      //  this.isAvailable,
      this.onDelete,
      this.onPlus,
      this.onMinus});

  _OrderUiCardState createState() => new _OrderUiCardState();
}

class _OrderUiCardState extends State<OrderUiCard> {
  int? quantityProduct;
  String? description;
  String? hexColor;
  int? _price;
  bool _isLoading = false;
  UserServices userServices = new UserServices();
  ProductItemUI? productOrder;
  void _getData() async {
    if (mounted)
      setState(() {
        _isLoading = true;
      });
    ProductApi? productApi;

    productApi =
        await ApiTest.getProducts(widget.nomNumber!, 0, 5).then((value) {
      var i = value.nomenclatures!.last;
      print(i.name);
      productOrder = (ProductItemUI(
        title: i.name,
        externalId: i.externalId!,
        id: widget.id,
        brandName: widget.brandName,
        weight: 350,
        nomNumber: i.nomNumber,
        categoryName: widget.categoryName,
        modifiers: false,
        modifiersList: [],
        productView: false,
        categoryId: i.hierarchicalParent.toString(),
        image: widget.imageUrl,
        price: double.parse(i.cost!).toInt(),
        searchString: widget.name,
        quantity: double.parse(i.balance!).toInt(),
        description: i.description ?? "",
      ));
      return value;
    });

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userpr = Provider.of<UserProvider>(context);

    return GestureDetector(
        onTap: () {
          _isLoading
              ? print("loading")
              : showCupertinoModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ItemScreen(
                    title: productOrder!.title!,
                    id: productOrder!.id.toString(),
                    externalId: productOrder!.externalId,
                    brandName: "",
                    nomNumber: productOrder!.nomNumber,
                    categoryName: widget.categoryName!,
                    productView: false,
                    modifiers: false,
                    modifiersList: [],
                    imageUrl: widget.imageUrl!,
                    weight: widget.weight ?? 350,
                    price: productOrder!.price,
                    searchString: widget.searchString,
                    quantity: productOrder!.quantity,
                    description: productOrder!.description ?? "",
                    categoryId: widget.categoryId!,
                  ),
                );
        },

        ////live_gzdTqtoXmQ10Vl0AKIF7NPWC_0JgTmdaUlLzIJA9fKk
        child: _isLoading
            ? SkeletonLoader(
                items: 1,
                baseColor: ThemaMode.isDarkMode ? darkBackColor : Colors.white,
                period: Duration(seconds: 2),
                highlightColor:
                    ThemaMode.isDarkMode ? Colors.white24 : mainColor,
                direction: SkeletonDirection.ltr,
                builder: Container(
                  margin: EdgeInsets.all(16),
                  height: 105,
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
                ))
            : Container(
                margin: EdgeInsets.all(16),
                height: 105,
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
                child: Row(children: [
                  Stack(children: [
                    Container(
                      height: 105,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: OctoImage(
                            height: 105,
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
                                  margin: EdgeInsets.only(right: 20),
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    PaintIcon.paint,
                                    size: 80,
                                    color: Color(
                                        int.parse("0xff" + widget.hexColor!)),
                                  ))),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(widget.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                    )),
                              ),
                              Text("${widget.price! * widget.quantity!} руб ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Количество: ${widget.quantity} шт.",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ))
                            ]),
                      ],
                    ),
                  ),
                ])));
  }
}
