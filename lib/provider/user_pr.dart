import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graffitineeds/models/cartItemModel.dart';
import 'package:graffitineeds/models/product.dart';
import 'package:graffitineeds/services/apitest.dart';
import 'package:graffitineeds/services/user_service.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
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

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        _firestore.collection('users').doc(result.user!.uid).set({
          'name': name.text,
          'email': email.text,
          'uid': result.user!.uid,
          "likedFood": [],
          "likedRestaurants": []
        });
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

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

  void clearController() {
    name.text = "";
    password.text = "";
    email.text = "";
  }

  Future<void> reloadUserModel() async {
    notifyListeners();
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  _onStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      // _user = firebaseUser.;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  /* getOrders() async {
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }*/

  /*Future<bool> removeFromCart(String cartItem) async {
    print("THE PRODUC IS: ${cartItem.toString()}");

    try {
      _userServicse.removeFromCart(cartItem: cartItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }*/
}
