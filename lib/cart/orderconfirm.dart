import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/cart/cartitem.dart';

import 'package:graffitineeds/main.dart';
import 'package:graffitineeds/models/itemModel.dart';

// ignore: must_be_immutable
class OrderConfirm extends StatefulWidget with ChangeNotifier {
  List<CartItem> cartList;
  OrderConfirm({Key key, this.cartList});

  OrderConfirmState createState() => new OrderConfirmState();
}

TextStyle topMenulight = TextStyle(
  color: Colors.black,
  fontSize: 16,
);
enum DeliveryMethod { del, loc }
enum PayMethod { mon, apple, card }

class OrderConfirmState extends State<OrderConfirm> {
  DeliveryMethod _deliveryMethod = DeliveryMethod.del;
  PayMethod _payMethod = PayMethod.card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            iconSize: 24,
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "ОФОРМИТЬ ЗАКАЗ",
            style: TextStyle(
                //  fontFamily: 'Avenir next',
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          )),
      body: ListView(
        children: [
          Container(
              margin: EdgeInsets.all(16),
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(1.0, 3.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Способ получения",
                        style: topMenulight,
                      )),
                  RadioListTile<DeliveryMethod>(
                      activeColor: mainColor,
                      title: Container(
                          child: Text("Доставка в пункт выдачи Boxberry",
                              style: TextStyle(fontSize: 14))),
                      value: DeliveryMethod.del,
                      groupValue: _deliveryMethod,
                      onChanged: (DeliveryMethod value) {
                        setState(() {
                          _deliveryMethod = value;
                          print(_deliveryMethod);
                        });
                      }),
                  if (_deliveryMethod == DeliveryMethod.del)
                    Container(
                        margin: EdgeInsets.only(left: 35),
                        child: Column(children: [
                          Row(
                            children: [
                              Icon(
                                Icons.map_outlined,
                                size: 18,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "г. Воронеж, ул. Ленина, 158/3",
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text("+ 283,73", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Divider(
                                height: 1,
                              )),
                          GestureDetector(
                              child: Container(
                                  height: 30,
                                  width: 118,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 0.8,
                                        blurRadius: 0.1,
                                        offset: Offset(
                                            0, 5), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                      child: Text('Изменить',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ))))),
                        ]))
                  else
                    Container(),
                  RadioListTile<DeliveryMethod>(
                      activeColor: mainColor,
                      title: Text(
                        "Cамовывоз",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: DeliveryMethod.loc,
                      groupValue: _deliveryMethod,
                      onChanged: (DeliveryMethod value) {
                        setState(() {
                          _deliveryMethod = value;
                          print(_deliveryMethod);
                        });
                      }),
                  if (_deliveryMethod == DeliveryMethod.loc)
                    Container(
                        margin: EdgeInsets.only(left: 35),
                        child: Column(children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "г. Краснодар, ул. Карасунская, 95",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Divider(
                                height: 1,
                              )),
                        ]))
                  else
                    Container()
                ],
              )),
          Container(
              margin: EdgeInsets.all(16),
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(1.0, 3.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Товары (3)",
                        style: topMenulight,
                      )),
                  Row(children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 15),
                      //decoration: BoxDecoration(border: Border()),
                      child: Column(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            height: 70,
                            width: 70,
                            image: AssetImage("lib/assets/m1.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          "5 шт.",
                          style: TextStyle(fontSize: 12),
                        )
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 15),
                      //decoration: BoxDecoration(border: Border()),
                      child: Column(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            height: 70,
                            width: 70,
                            image: AssetImage("lib/assets/m2.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          "1 шт.",
                          style: TextStyle(fontSize: 12),
                        )
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 15),
                      //decoration: BoxDecoration(border: Border()),
                      child: Column(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            height: 70,
                            width: 70,
                            image: AssetImage("lib/assets/m4.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          "2 шт.",
                          style: TextStyle(fontSize: 12),
                        )
                      ]),
                    ),
                  ])
                ],
              )),
          Container(
              margin: EdgeInsets.all(16),
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(1.0, 3.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Способ оплаты",
                        style: topMenulight,
                      )),
                  RadioListTile<PayMethod>(
                      activeColor: mainColor,
                      title: Container(
                          child: Text("Карта", style: TextStyle(fontSize: 12))),
                      value: PayMethod.card,
                      groupValue: _payMethod,
                      onChanged: (PayMethod value) {
                        setState(() {
                          _payMethod = value;
                          print(_payMethod);
                        });
                      }),
                  RadioListTile<PayMethod>(
                      activeColor: mainColor,
                      title: Container(
                          child: Text("Apple Pay",
                              style: TextStyle(fontSize: 12))),
                      value: PayMethod.apple,
                      groupValue: _payMethod,
                      onChanged: (PayMethod value) {
                        setState(() {
                          _payMethod = value;
                          print(_payMethod);
                        });
                      }),
                  RadioListTile<PayMethod>(
                      activeColor: mainColor,
                      title: Container(
                          child: Text("Наличными",
                              style: TextStyle(fontSize: 12))),
                      value: PayMethod.mon,
                      groupValue: _payMethod,
                      onChanged: (PayMethod value) {
                        setState(() {
                          _payMethod = value;
                          print(_payMethod);
                        });
                      }),
                ],
              )),
          Container(
              height: MediaQuery.of(context).size.height / 5.5,
              child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          margin: EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 50,
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                              disabledColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              color: mainColor,
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (builder) => OrderConfirm()));
                              },
                              child: Text("Оформить заказ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)))),
                    ]))
                  ]))
        ],
      ),
    );
  }
}
