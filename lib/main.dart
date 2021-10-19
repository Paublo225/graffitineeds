import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graffitineeds/cart/cartpage.dart';
import 'package:graffitineeds/homepage/homepage.dart';
import 'package:graffitineeds/homepage/mainPage.dart';
import 'package:graffitineeds/login/loginpage.dart';
import 'package:graffitineeds/search/searchpage.dart';

import 'package:graffitineeds/user/userpage.dart';

Color mainColor = Color(0xffFFA5A5);
void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DefaultTabBar(),
    );
  }
}

class DefaultTabBar extends StatefulWidget {
  // int indexTab;
  //DefaultTabBar({Key key, this.indexTab}) : super(key: key);
  @override
  DefaultTabBarState createState() => new DefaultTabBarState();
}

class DefaultTabBarState extends State<DefaultTabBar>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _tabIndex = 0;
  CupertinoTabController _tabController;
  void initState() {
    super.initState();
    _tabController = new CupertinoTabController(initialIndex: 0);

    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
      print('my index is' + _tabController.index.toString());
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size.height / 24;
    var topCir = MediaQuery.of(context).size.height / 120;
    var leftCir = MediaQuery.of(context).size.height / 46;
    var radius = MediaQuery.of(context).size.height / 110;
    print(radius);
    var fontCir = MediaQuery.of(context).size.height / 90;
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        activeColor: mainColor,

        // indicatorWeight: 40,
        //indicatorPadding: EdgeInsets.only(top: 40, left: 50),
        items: <BottomNavigationBarItem>[
          /*  Tab(
                      iconMargin: EdgeInsets.only(top: 5.0),
                      icon: Icon(GNeeds.spray_paint, size: 35),
                      text: ""),*/
          BottomNavigationBarItem(
            // iconMargin: EdgeInsets.only(top: 5.0),
            icon: Icon(Icons.home_outlined, size: 35),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_outlined,
              size: 35,
              //   color: Colors.black,
            ),
          ),
          /* Tab(
                      iconMargin: EdgeInsets.only(top: 5.0),
                      icon: Icon(CupertinoIcons.cart_fill, size: 35),
                      text: ""),*/
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person, size: 35),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: MainPage(),
              );
            });
            break;
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Cart(),
              );
            });
            break;
          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: UserPage(),
              );
            });
            break;
          default:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomePage(),
              );
            });
            break;
        }
      },
    );
  }
}

class GNeeds {
  GNeeds._();

  static const _kFontFam = 'GNeeds';
  static const String _kFontPkg = null;

  static const IconData spray_paint =
      IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
