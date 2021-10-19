import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/cart/cartitem.dart';

import 'package:graffitineeds/main.dart';
import 'package:graffitineeds/models/itemModel.dart';

import 'orderconfirm.dart';

// ignore: must_be_immutable
class Cart extends StatefulWidget with ChangeNotifier {
  List<CartItem> cartList;
  Cart({Key key, this.cartList});

  CartPageState createState() => new CartPageState();
}

class CartPageState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    print(widget.cartList);
    return new Scaffold(
        bottomNavigationBar: _bottomInfo(),
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Row(children: [
              Text(
                "Корзина",
                style: TextStyle(
                    //  fontFamily: 'Avenir next',
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              )
            ])),
        body: ListView(
          children: [Column(children: cartItems)],
        ));
  }

  Widget _bottomInfo() {
    // print(_cartState);

    return BottomAppBar(
        child: Container(
            height: MediaQuery.of(context).size.height / 6,
            child: new Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Column(children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                        alignment: Alignment.topLeft,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ИТОГ:",
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(
                                "${1240} руб",
                                style: TextStyle(fontSize: 22),
                              ),
                            ])),
                    new Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 40,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                            disabledColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            color: mainColor,
                            onPressed: () async {
                              showCupertinoModalPopup(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return OrderConfirm();
                                  });
                            },
                            child: Text("Перейти к оформлению",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))),
                  ]))
                ])));
  }
}
