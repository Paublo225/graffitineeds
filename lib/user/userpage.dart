import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/login/loginpage.dart';
import 'package:graffitineeds/models/items.dart';
import 'package:graffitineeds/models/mainpageCover.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../main.dart';

class UserPage extends StatefulWidget {
  UserPage();
  @override
  _UserPageState createState() => new _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    double heightB = MediaQuery.of(context).size.width / 7;
    double widthB = MediaQuery.of(context).size.width;
    double fontSize = MediaQuery.of(context).size.width / 26;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "user@mail.ru",
                style: TextStyle(
                    //  fontFamily: 'Avenir next',
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                  onTap: () {},
                  /* Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {})),*/
                  child: Column(children: [
                    Icon(
                      Icons.contact_support,
                      size: 25,
                      color: Colors.black,
                    ),
                    Text(
                      "Поддержка",
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    )
                  ]))
            ],
          ),
        ),
        body: Stack(children: <Widget>[
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new GestureDetector(
                              onTap: () {},
                              child: Container(
                                  width: widthB,
                                  height: 43,
                                  margin: EdgeInsets.only(top: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(13),
                                        topRight: Radius.circular(13),
                                        bottomLeft: Radius.circular(13),
                                        bottomRight: Radius.circular(13)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                      child: Row(children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 26,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('История заказов',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ))
                                  ])))),
                          new GestureDetector(
                              onTap: () {},
                              child: Container(
                                  margin: EdgeInsets.only(top: 35),
                                  width: widthB,
                                  height: 43,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(13),
                                        topRight: Radius.circular(13),
                                        bottomLeft: Radius.circular(13),
                                        bottomRight: Radius.circular(13)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  // padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                      child: Row(children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      CupertinoIcons.settings_solid,
                                      size: 26,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Настройки',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ))
                                  ])))),
                          new GestureDetector(
                              onTap: () {},
                              child: Container(
                                  width: widthB,
                                  height: 43,
                                  margin: EdgeInsets.only(top: 35),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(13),
                                        topRight: Radius.circular(13),
                                        bottomLeft: Radius.circular(13),
                                        bottomRight: Radius.circular(13)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                      child: Row(children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      CupertinoIcons.question_circle_fill,
                                      size: 26,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Вопросы/Ответы',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ))
                                  ])))),
                          new GestureDetector(
                              onTap: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Loginpage();
                                    });
                              },
                              child: Container(
                                  width: widthB,
                                  height: 43,
                                  margin: EdgeInsets.only(top: 35),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(13),
                                        topRight: Radius.circular(13),
                                        bottomLeft: Radius.circular(13),
                                        bottomRight: Radius.circular(13)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.exit_to_app_rounded,
                                      size: 26,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Выход',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ))
                                  ]))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // _footer(),
        ]));
  }
}
