import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/order/orderListTile.dart';
import 'package:graffitineeds/services/order_services.dart';

enum StatusSate { INPROCCES, DECLINED, SUCCSESSFULL }

class OrderHistory extends StatefulWidget {
  OrderHistory({Key? key}) : super(key: key);
  @override
  _OrderHistoryState createState() => new _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List g1 = [];
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<OrderListTile> orderListTile = [];
  bool _loading = false;
  getUserOrders() async {
    setState(() {
      _loading = true;
    });

    await OrderServices()
        .orderRef
        .where(USERID, isEqualTo: _firebaseAuth.currentUser!.uid)
        .orderBy(CREATEDAT, descending: true)
        .get()
        .then((value) {
      if (value.size > 0)
        value.docs.forEach((i) {
          orderListTile.add(OrderListTile(
              orderId: i.get(ORDERID),
              total: i.get(TOTAL),
              trackNumber: i.get("трек"),
              saleKey: i.get("saleKey"),
              createdAt: i.get("date") + " " + i.get("time"),
              status: i.get(STATUS)));
        });
    });

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserOrders();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    "Мои заказы",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            ThemaMode.isDarkMode ? Colors.white : Colors.black),
                  ),
                  leading: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          width: 50,
                          height: 50,
                          child: Icon(
                            CupertinoIcons.back,
                            size: 28.0,
                            color: mainColor,
                          ))),
                )
              ];
            },
            body: _loading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                    ),
                  )
                : orderListTile.isEmpty
                    ? _emptyList()
                    : ListView(children: orderListTile)));
  }

  _emptyList() {
    return Center(
      child: Container(
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          /*decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Colors.grey[600]),
                  top: BorderSide(width: 2.0, color: Colors.grey[600]),
                  left: BorderSide(width: 2.0, color: Colors.grey[600]),
                  right: BorderSide(width: 2.0, color: Colors.grey[600]),
                ),
              ),*/
          //  child: Container(
          alignment: Alignment.center,
          child: Column(children: [
            Container(
              child: Image(
                image: AssetImage("lib/assets/boxx.png"),
                height: MediaQuery.of(context).size.height / 7,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "Здесь пустовато...",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.grey[600],
                  ),
                )),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  "Заказов пока никаких нет. Лучше закажите чего-нибудь!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ))
          ])),
    );
  }
}
