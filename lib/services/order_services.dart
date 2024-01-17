import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/models/orderListModel.dart';
import 'package:graffitineeds/models/userOrdersModel.dart';

class OrderServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference orderRef =
      FirebaseFirestore.instance.collection(ORDERS);

  void createOrder(
      String userId,
      String id,
      String status,
      List<OrderListModel> cartItems,
      String payMeth,
      int totalPrice,
      String saleKey,
      String payid,
      String trackNumber) async {
    List<Map> convertedCart = [];
    var uid = id;
    DateTime dateTime = DateTime.now().toUtc().add(const Duration(hours: 3));
    var _minute;
    var _data;
    var _month;
    var _hour;
////Date
    if (DateTime.now().day < 10)
      _data = "0${DateTime.now().day}";
    else
      _data = DateTime.now().day.toString();

    ///Minute
    if (DateTime.now().minute < 10)
      _minute = "0${DateTime.now().minute}";
    else
      _minute = DateTime.now().minute.toString();

    ///Hour
    if (DateTime.now().hour < 10)
      _hour = "0${DateTime.now().hour}";
    else
      _hour = DateTime.now().hour.toString();
/////Month
    if (DateTime.now().month < 10)
      _month = "0${DateTime.now().month}";
    else
      _month = DateTime.now().month.toString();

    for (OrderListModel item in cartItems) {
      convertedCart.add(item.toMap());
    }

    await _firestore.collection(ORDERS).doc(uid).set({
      USERID: userId,
      ORDERID: uid,
      ORDER: convertedCart,
      TOTAL: totalPrice,
      "payid": payid,
      "saleKey": saleKey.toString(),
      "time": "$_hour:$_minute",
      CREATEDAT: dateTime,
      "date": "$_data/$_month/${DateTime.now().year.toString()}",
      STATUS: status,
      PAYMENT: payMeth,
      "трек": trackNumber,
    });
  }

  Future<List<UserOrderModel>> getUserOrders({String? userId}) async =>
      _firestore
          .collection(ORDERS)
          .where(USERID, isEqualTo: userId)
          .get()
          .then((result) {
        List<UserOrderModel> orders = [];
        for (DocumentSnapshot order in result.docs) {
          orders.add(UserOrderModel.fromSnapshot(order));
        }
        return orders;
      });
}
