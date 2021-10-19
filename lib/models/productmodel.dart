import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/cart/counterCard.dart';
import 'package:graffitineeds/product/count.dart';
import 'package:graffitineeds/product/itemscreen.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
//import 'package:provider/provider.dart';
import '../main.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

// ignore: must_be_immutable
class ProductItemZ extends StatefulWidget {
  String id;
  String imageUrl;
  String title;
  String name;
  String category;
  String price;
  String description;
  String quantity;

  Map<dynamic, dynamic> opt;
  int qpak;
  int minKolvo;
  PageController page;
  ProductItemZ({
    this.id,
    this.imageUrl,
    this.name,
    this.title,
    this.category,
    this.price,
    this.opt,
    this.description,
    this.quantity,
    this.minKolvo,
    this.qpak,
    this.page,
  });

  Map toMap() => {
        "id": id,
        "imageUrl": imageUrl,
        "name": title,
        "price": price,
        "опт": opt,
        "qpak": qpak,
        "мин_кол-во": minKolvo,
        "quantity": quantity,
      };
  _ProductItemZState createState() => new _ProductItemZState();
}

class _ProductItemZState extends State<ProductItemZ> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  bool _flag = false;
  void _doSomething() async {
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        icon: null,
        message: "+1 ${widget.name} добавлен в корзину",
      ),
      displayDuration: Duration(milliseconds: 100),
    );
    _btnController.success();

    print("clickedz");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showCupertinoModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => ItemScreen(
                id: widget.id,
                imageUrl: widget.imageUrl,
                title: widget.name,
//qpak: widget.qpak,
                price: "224"),
          );
        },
        child: Container(
            width: 122,
            height: 250,
            margin: EdgeInsets.only(
              left: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  Image.asset(
                    "${widget.imageUrl}",
                    height: 122,
                    width: 133,
                  ),
                  new Positioned(
                    top: 5,
                    right: 0.1,
                    child: IconButton(
                        onPressed: () async {
                          print("clicked");
                          // _btnController.stop();
                        },
                        icon: RoundedLoadingButton(
                          animateOnTap: false,
                          borderRadius: 4,
                          loaderSize: 20,
                          height: 30,
                          width: 30,
                          color: Colors.white,
                          successColor: Color(4278249078),
                          child: Icon(
                            CupertinoIcons.add,
                            size: 16,
                            color: Colors.grey,
                          ),
                          controller: _btnController,
                          onPressed: () {
                            setState(() {
                              _flag = true;
                            });
                            _doSomething();
                          },
                        )),
                    /* decoration: BoxDecoration(
                            /*color: Colors.white,
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6)),*/
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.16),
                                spreadRadius: 0.8,
                                blurRadius: 0.1,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ]),*/
                  ),
                ]),
                Text(
                  widget.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                _flag
                    ? Container(

                        // width: 00,
                        padding: EdgeInsets.only(left: 10, top: 2),
                        alignment: Alignment.center,
                        // margin: EdgeInsets.only(top: 10, right: 20),
                        child: CounterCart(
                          count: 1,
                          price: 0,
                          kolvo: 1,
                          quantity: 10,
                        ))
                    : Text(
                        "${widget.price}₽",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
              ],
            )));
  }
}
