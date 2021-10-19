import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/models/items.dart';
import 'package:graffitineeds/models/mainpageCover.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextStyle topMenuStyle = new TextStyle(
      //  fontFamily: 'Avenir next',
      fontFamily: 'Astakhov First One Stripe',
      fontSize: 26,
      color: Colors.black,
      fontWeight: FontWeight.w600);
  final TextStyle buttonInfoStyle = new TextStyle(
      fontFamily: 'Astakhov First One Stripe',
      fontSize: 14,
      fontWeight: FontWeight.w600);
  final Color coverColor = Colors.black26;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size.height / 24;
    var topCir = MediaQuery.of(context).size.height / 120;
    var rightCir = MediaQuery.of(context).size.height / 46;
    var radius = MediaQuery.of(context).size.height / 110;

    List<MainPageCover> mainPageCover = [
      MainPageCover(
        imageUrl:
            "/Users/pavel/Desktop/Projects/graffitineeds/lib/assets/loop.png",
        title: "краска loop",
      ),
      MainPageCover(
        imageUrl:
            "/Users/pavel/Desktop/Projects/graffitineeds/lib/assets/montana.png",
        title: "краска montana",
      ),
      MainPageCover(
          imageUrl:
              "/Users/pavel/Desktop/Projects/graffitineeds/lib/assets/markers.png",
          title: "восковые Маркеры",
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (builder) =>
                        ItemZ(name: "восковые Маркеры", category: "Маркеры")));
          }),
      MainPageCover(
        imageUrl:
            "/Users/pavel/Desktop/Projects/graffitineeds/lib/assets/stickers.png",
        title: "стикеры",
      ),
    ];
    //print(radius);
    var fontCir = MediaQuery.of(context).size.height / 80;
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Text(
              "Каталог",
              style: topMenuStyle,
            ),
            GestureDetector(
                child: Stack(children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 30,
                color: Colors.black,
              ),
              new Positioned(
                  top: topCir,
                  right: rightCir,
                  child: new Center(
                      child:
                          /*StreamBuilder(
                            stream: _firebaseServices.usersRef
                                .doc(_firebaseServices.getUserId())
                                .collection("cart")
                                .snapshots(),
                            builder: (context, snapshot) {
                              // list = snapshot.data.docs.length;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {*/
                          CircleAvatar(
                              radius: radius,
                              backgroundColor: Colors.red,
                              child: new Text(
                                0.toString(),
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: fontCir,
                                    fontWeight: FontWeight.w500),
                              )))),
            ]))
          ],
        ),
      ),
      body: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: mainPageCover),
    );
  }
}
