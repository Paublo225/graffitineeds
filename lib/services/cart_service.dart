import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graffitineeds/models/cartItemModel.dart';
import 'package:graffitineeds/services/user_service.dart';

class CartServices {
  final String CART = "корзина";
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("пользователи");

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String getUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

  /* Future<List<CartItemModel>> getCart() async {
    List<CartItemModel> cartList = [];
    cartList.clear();

    try {
      await usersRef.doc(getUserId()).collection("корзина").get().then((value) {
        value.docs.forEach((doc) async {
          cartList.add(CartItemModel(
            id: doc.id,
            nomNumber: doc.get("nomNumber"),
            categoryId: doc.get("categoryId"),
            name: doc.get("наименование"),
            quantity: doc.get("количество"),
            price: doc.get("цена"),
            weight: doc.get('вес'),
            //  balance: await userpr.getBalance(doc.get("nomNumber")),
            hexColor: doc.get("hex"),
            imageUrl: doc.get("imageUrl"),
            categoryName: doc.get("categoryName"),
            searchString: doc.get("наименование"),
            brandName: doc.get("brandName"),
            description: doc.get("описание"),
            modifiers: doc.get("modifiers"),
            modifiersList: doc.data()["modifiersList"] ?? null,
            onBalance: (value) {},
            onDelete: () async {
              await UserServices()
                  .usersRef
                  .doc(UserServices().getUserId())
                  .collection("корзина")
                  .doc(doc.get("id"))
                  .delete();
              // cartList.clear();
              //cartItemList = getCart();
              cartList.removeWhere((element) => element.id == doc.get("id"));
              MainCartList.removeWhere(
                  (element) => element.id == doc.get("id"));
            },
            onMinus: (z) async {
              await UserServices()
                  .usersRef
                  .doc(UserServices().getUserId())
                  .collection("корзина")
                  .doc(doc.get("id"))
                  .update({'количество': z});
              userpr.calculateTotalAmount(cartItemList!);
   
            },
            onPlus: (z) async {
              await UserServices()
                  .usersRef
                  .doc(UserServices().getUserId())
                  .collection("корзина")
                  .doc(doc.get("id"))
                  .update({'количество': z});
              userpr.calculateTotalAmount(cartItemList!);
              userpr.changeLoading();
            },
          ));
        });
      });
    } catch (e) {
      userFound = false;
    }
    return cartList;
  }*/

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
