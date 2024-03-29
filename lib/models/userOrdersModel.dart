import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrderModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";

  String? _id;
  String? _description;
  String? _userId;
  String? _status;
  int? _createdAt;
  int? _total;

//  getters
  String get id => _id!;

  String get description => _description!;

  String get userId => _userId!;

  String get status => _status!;

  int get total => _total!;

  int get createdAt => _createdAt!;

  // public variable
  List? cart;

  UserOrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.get(ID);
    _description = snapshot.get(DESCRIPTION);
    _total = snapshot.get(TOTAL);
    _status = snapshot.get(STATUS);
    _userId = snapshot.get(USER_ID);
    _createdAt = snapshot.get(CREATED_AT);
    cart = snapshot.get(CART);
  }
}
