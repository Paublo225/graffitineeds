import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserServices {
  final String CART = "корзина";
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("пользователи");

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String getUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

  Future<int> getCartTotalSum() async {
    int totalSumma = 0;
    await usersRef.doc(getUserId()).collection("корзина").get().then((value) {
      value.docs.toList().forEach((a) {
        totalSumma += a.data()["цена"] * a.data()["количество"] as int;
      });
    });
    print(totalSumma);
    return totalSumma;
  }

  Future<int> getCartFullLength() async {
    return await usersRef
        .doc(getUserId())
        .collection(CART)
        .get()
        .then((value) => value.size);
  }
}
