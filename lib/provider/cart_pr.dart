import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graffitineeds/models/cartItemModel.dart';
import 'package:graffitineeds/models/product.dart';
import 'package:graffitineeds/services/apitest.dart';
import 'package:graffitineeds/services/user_service.dart';

class CartProvider with ChangeNotifier {
  late FirebaseAuth _auth;
  late UserInfo _user;
  Status _status = Status.Uninitialized;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserServices _userServicse = UserServices();
  //OrderServices _orderServices = OrderServices();
  //UserModel _userModel;
  bool isLoading = false;

//  getter
  // UserModel get userModel => _userModel;
  Status get status => _status;
  UserInfo get user => _user;

  // public variables
  // List<OrderModel> orders = [];

  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  Future<int> getLengthCartProvider() async {
    int cartLength = await _userServicse.getCartFullLength();

    // notifyListeners();
    return cartLength;
  }

  Future<List<int>> calculateTotalAmount(
      Future<List<CartItemModel>> list) async {
    double? res = 0;
    int? quantity = 0;
    List<CartItemModel> superList = await list;
    List<int> cartInfo = [];
    superList.forEach((element) {
      res = res! + element.price! * element.quantity!;
      quantity = quantity! + element.quantity!;
    });
    cartInfo.add(res!.toInt());
    cartInfo.add(quantity!.toInt());
    return cartInfo;
  }

  Future<int> getBalance(String nomNumber) async {
    int balanceProduct = 0;
    ProductApi? productApi;

    productApi = await ApiTest.getProducts(nomNumber, 0, 5);
    balanceProduct =
        double.parse(productApi.nomenclatures!.last.balance!).toInt();

    return balanceProduct;
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
