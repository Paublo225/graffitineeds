import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/order/orderpage.dart';
import 'package:graffitineeds/services/api_orderSbis.dart';
import 'package:graffitineeds/services/order_services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OrderListTile extends StatefulWidget {
  String orderId;
  String createdAt;
  int total;
  String? saleKey;
  String? status;
  String? trackNumber;
  OrderListTile(
      {required this.orderId,
      required this.total,
      this.saleKey,
      this.trackNumber,
      required this.createdAt,
      this.status});
  @override
  _OrderListTileState createState() => new _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile> {
  bool _loading = false;
  String status = "";
  _getStatus() async {
    if (mounted)
      setState(() {
        _loading = true;
      });
    await SbisOrder.getOrderState(widget.saleKey!).then((saleCode) {
      statusCodes.forEach((key, value) {
        if (saleCode == key) {
          if (mounted)
            setState(() {
              status = value;
            });
        }
      });
    }).then((value) async {
      if (status != widget.status) {
        await OrderServices()
            .orderRef
            .doc(widget.orderId)
            .update({"статус": status});
      }
    });
    if (mounted)
      setState(() {
        _loading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    _getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //   color: Colors.white,
        // height: 120,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 10),
        child: GestureDetector(
            onTap: () => showCupertinoModalBottomSheet(
                  //   expand: true,
                  //  topControl: SizedBox(),
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => OrderScreen(
                    orderID: widget.orderId,
                    status: widget.status ?? "",
                    total: widget.total,
                    createdAt: widget.createdAt,
                    trackNumber: widget.trackNumber,
                  ),
                ),
            child: ListTile(
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.createdAt),
                    Text(
                      "Заказ №${widget.orderId}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 1),
                      child: Text(
                        "ИТОГ: ${widget.total}",
                      ),
                    ),
                    _loading
                        ? Text("Статус: ${widget.status}")
                        : Text("Статус: ${status}")
                    /*Text(
                                    mapl.toString().substring(
                                        1, mapl.toString().lastIndexOf(']')),
                                    style: TextStyle(fontSize: 14),
                                  ),*/
                  ]),
              /*trailing: Container(
                                          margin: EdgeInsets.only(
                                            right: 10,
                                          ),
                                          child: RaisedButton(
                                            onPressed: () async {
                                              /*
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          MyAppZ()));*/
                                              print("send");
                                            },
                                            child: Text("Оплатить"),
                                          ))*/
            )));
  }

  Map statusCodes = {
    5: "Черновик",
    10: "В обработке",
    11: "Новый заказ на доставку",
    21: "Принят",
    40: "Отмена заказа",
    42: "Отмена заказа",
    45: "Не пришел",
    50: "Продажа открыта",
    70: "В работе",
    80: "Заказ обработан",
    81: "Сборка",
    90: "На доставке",
    91: "Готов к выдаче",
    100: "Доставлен",
    150: "Заблокирован",
    180: "Отгружен",
    200: "Закрыт",
    220: "Отменена",
    250: "Удален"
  };
}
