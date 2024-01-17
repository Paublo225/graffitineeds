import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graffitineeds/helpers/notifications.dart';
import 'package:graffitineeds/helpers/styles.dart';

import 'package:graffitineeds/order/orderUIcard.dart';

import 'package:graffitineeds/services/order_services.dart';

import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class OrderScreen extends StatefulWidget {
  String? orderID;
  int? indexs;
  String? createdAt;
  int? total;
  String? status;
  String? title;
  String? trackNumber;
  OrderScreen(
      {this.orderID,
      this.title,
      this.indexs,
      this.createdAt,
      this.status,
      this.trackNumber,
      this.total});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int count = 0;
  String? track;
  OrderServices _firebaseServices = OrderServices();
  bool loading = false;
  List<OrderUiCard> productList = [];

  Future<void> _openUrl(String trackNumber) async {
    if (await canLaunchUrl(
        Uri.parse("https://boxberry.ru/tracking-page?id=$trackNumber"))) {
      await launchUrl(
        Uri.parse("https://boxberry.ru/tracking-page?id=$trackNumber"),
      );
    } else {
      NotificationsToast().displayErrorMotionToast(
          "По какой-то причине не удалось открыть почту", context);
    }
  }

  fetchAllOrder(String id) async {
    dynamic orderInfo;
    String? status = "ll";
    String? saleKey;

    if (mounted)
      setState(() {
        loading = true;
      });

    await _firebaseServices.orderRef.doc(widget.orderID).get().then((value) {
      orderInfo = value.get("заказ");
      saleKey = value.get("saleKey");
      track = value.get("трек");
      //  print(saleKey);
      status = value.get("статус") ?? "kk";
      for (int i = 0; i < orderInfo.length; i++)
        productList.add(OrderUiCard(
          name: orderInfo[i]["имя"],
          //weight: orderInfo[i]!["вес"]! ?? 350,
          quantity: orderInfo[i]["количество"],
          imageUrl: orderInfo[i]["imageUrl"],
          price: orderInfo[i]["цена"],
          id: orderInfo[i]["id"],

          hexColor: orderInfo[i]["hex"]! ?? null,
          brandName: orderInfo[i]["brandName"],
          categoryName: orderInfo[i]["категория"],
          nomNumber: orderInfo[i]["nomNumber"],
          categoryId: orderInfo[i]["hierarchicalParent"],
        ));
    }).whenComplete(() {
      if (mounted)
        setState(() {
          loading = false;
        });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllOrder(widget.orderID!);
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
        key: key,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Заказ",
          ),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  color: Colors.transparent,
                  width: 50,
                  height: 50,
                  child: Icon(
                    CupertinoIcons.back,
                    size: 28.0,
                    color: mainColor,
                  ))),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                    height: 50,
                    child: ListTile(
                      title: Text("Номер заказа"),
                      subtitle: SelectableText(widget.orderID!),
                    ),
                  )),
                  if (track != "")
                    Flexible(
                        fit: FlexFit.tight,
                        child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              await _openUrl(widget.trackNumber!);
                            },
                            child: Container(
                                height: 50,
                                padding: EdgeInsets.only(bottom: 30),
                                child: ListTile(
                                    title: Text("Трек номер"),
                                    subtitle: Row(children: [
                                      Text(
                                        widget.trackNumber!,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ])))))
                ]),
            Container(
              height: 50,
              // padding: EdgeInsets.only(bottom: 30),
              child: ListTile(
                title: Text("Время"),
                subtitle: Text("${widget.createdAt}"),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.only(bottom: 30),
              child: ListTile(
                title: Text("Итог"),
                subtitle: Text(widget.total.toString()),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: productList.length,
                    itemBuilder: (context, index) => productList[index])
          ],
        )));
  }
}
