import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graffitineeds/auth/initialization.dart';
import 'package:graffitineeds/helpers/pageRoute.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/main.dart';
import 'package:graffitineeds/models/product.dart';

import 'package:graffitineeds/order/orderlist.dart';
import 'package:graffitineeds/services/api_UserAgreement.dart';
import 'package:graffitineeds/services/api_orderSbis.dart';
import 'package:graffitineeds/services/api_yookassa.dart';
import 'package:graffitineeds/services/apitest.dart';
import 'package:graffitineeds/services/vk_services.dart';
import 'package:graffitineeds/user/contactPage.dart';

import 'package:graffitineeds/user/setting.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  UserPage();
  @override
  _UserPageState createState() => new _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  String contactInformation = "";
  String contactEmail = "";

  String? userUid;

  openUserAgreement() async {
    String? url;
    await SbisUserDocs.getLink().then((value) => url = value);
    if (await canLaunchUrl(Uri.parse(url!))) {
      await launchUrl(Uri.parse(url!));
    } else {
      throw 'Could not launch $url';
    }
  }

  /*IgetApplicationVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
  }*/

  @override
  void initState() {
    super.initState();
    userUid = user!.uid.toUpperCase().substring(0, 3);
    // getApplicationVersion();
  }

  @override
  Widget build(BuildContext context) {
    double heightB = MediaQuery.of(context).size.width / 7;
    double widthB = MediaQuery.of(context).size.width;
    double fontSize = MediaQuery.of(context).size.width / 26;

    return Scaffold(
        floatingActionButton: NeumorphicButton(
            margin: EdgeInsets.only(top: 10),
            onPressed: () {
              curMode.switchTheme();
              if (mounted) setState(() {});
            },
            style: NeumorphicStyle(
              depth: 4,
              shadowLightColor: Colors.transparent,
              color: ThemaMode.isDarkMode ? darkBackColor : Colors.white54,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            child: NeumorphicIcon(
              Icons.brightness_4,
              style: NeumorphicStyle(
                color: !ThemaMode.isDarkMode ? Colors.black : Colors.white,
                depth: 10,
              ),
            )),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(
                user!.email!,
                style: TextStyle(
                    //  fontFamily: 'Avenir next',
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              )),
            ],
          ),
        ),
        body: Stack(children: <Widget>[
          Container(
            //color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                              onTap: () => Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return OrderHistory();
                                  })),
                              child: Container(
                                  width: widthB,
                                  height: 43,
                                  margin: EdgeInsets.only(top: 15),
                                  decoration: BoxDecoration(
                                    color: ThemaMode.isDarkMode
                                        ? darkBackColor
                                        : Colors.white,
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
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('История заказов',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ))
                                  ])))),
                          new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (builder) =>
                                                SettingsPage()))
                                    .then((value) => setState(() {
                                          print("switched");
                                        }));
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 35),
                                  width: widthB,
                                  height: 43,
                                  decoration: BoxDecoration(
                                    color: ThemaMode.isDarkMode
                                        ? darkBackColor
                                        : Colors.white,
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
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Настройки',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ))
                                  ])))),
                          new GestureDetector(
                              onTap: () async {
                                showCupertinoModalBottomSheet(
                                    context: context,
                                    builder: (builder) {
                                      return ContactPage();
                                    });
                              },
                              child: Container(
                                  width: widthB,
                                  height: 43,
                                  margin: EdgeInsets.only(top: 35),
                                  decoration: BoxDecoration(
                                    color: ThemaMode.isDarkMode
                                        ? darkBackColor
                                        : Colors.white,
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
                                      CupertinoIcons.phone,
                                      size: 26,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Контакты',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ))
                                  ])))),
                          new GestureDetector(
                              onTap: () async {
                                openUserAgreement();
                              },
                              child: Container(
                                  width: widthB,
                                  height: 43,
                                  margin: EdgeInsets.only(top: 35),
                                  decoration: BoxDecoration(
                                    color: ThemaMode.isDarkMode
                                        ? darkBackColor
                                        : Colors.white,
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
                                      CupertinoIcons.person_3,
                                      size: 26,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Пользовательское соглашение',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ))
                                  ])))),
                          new GestureDetector(
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();

                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  // Navigator.of(context).pop();
                                });
                              },
                              child: Container(
                                  width: widthB,
                                  height: 43,
                                  margin: EdgeInsets.only(top: 35),
                                  decoration: BoxDecoration(
                                    color: ThemaMode.isDarkMode
                                        ? darkBackColor
                                        : Colors.white,
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
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Выход',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ))
                                  ]))),

                          /////////API TEST BUTTON///////////////////
                          new GestureDetector(
                              onTap: () async {
                                BuildContext contexta = context;
                                // await VkService.getPosts();
                                await ApiTest.getDifferentProducts();
                                await ApiTest.getBalance([925]);
                                /*showCupertinoModalPopup(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return _popUp("rr", contexta);
                                    });*/
                                // await ApiTest.getBalance([1007]);
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 35),
                                  width: widthB,
                                  height: 43,
                                  decoration: BoxDecoration(
                                    color: Colors.pinkAccent,
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
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('api test',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ))
                                  ])))),
                          /*Center(
                            child: Image.asset(
                              'lib/assets/gn_loading.png',
                              height: 150,
                              width: 150,
                            ),
                          )*/
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

  _popUp(String id, BuildContext cocontex) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 35,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child:
                Text("Заказ №${id} оформлен!", style: TextStyle(fontSize: 20)),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                child: Text(
                  'ОК',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await Navigator.pushAndRemoveUntil(
                      cocontex,
                      NoAnimationMaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                      (route) => false);
                }),
            /*   SizedBox(
              width: 10,
            ),
            RaisedButton(
                color: Colors.white,
                child: Text(
                  'Узнать статус',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return DefaultTabBar();
                      });
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => OrderHistory(),
                      fullscreenDialog: true));
                }),*/
          ])
        ])));
  }
}
