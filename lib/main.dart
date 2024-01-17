import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graffitineeds/auth/initialization.dart';
import 'package:graffitineeds/bottom_nav_bar/lib/tab_view.dart';
import 'package:graffitineeds/cart/cartpage.dart';
import 'package:graffitineeds/category/categoryPage.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/helpers/gn_icons.dart';
import 'package:graffitineeds/helpers/styles.dart';

import 'package:graffitineeds/homepage/homePage.dart';
import 'package:graffitineeds/provider/cart_pr.dart';
import 'package:graffitineeds/provider/user_pr.dart';
import 'package:graffitineeds/services/api_settings.dart';
import 'package:graffitineeds/services/api_yookassa.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  imageCache.clear();
  box = await Hive.openBox('currentTheme');
  await Firebase.initializeApp();
  await FirebaseFirestore.instance.terminate();
  await FirebaseFirestore.instance.clearPersistence();
  await FirebaseFirestore.instance
      .collection(TEX_RABOTI)
      .doc("tokens")
      .get()
      .then((value) {
    ApiKey.sbisToken = value.get("sbisToken");
    ApiYookassa.token = value.get("yookassa");
  });

  /*BlocOverrides.runZoned(
    () {
      runApp(MyApp());
    },
    blocObserver: SimpleBlocObserver(),
  );*/
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: UserProvider.initialize()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp();
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    curMode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return ConnectionNotifier(
        disconnectedContent: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Поиск сети',
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 10,
              width: 10,
              child: isIOS
                  ? CupertinoTheme(
                      data: CupertinoTheme.of(context)
                          .copyWith(brightness: Brightness.dark),
                      child: const CupertinoActivityIndicator(),
                    )
                  : const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.0,
                    ),
            ),
          ],
        ),
        connectedContent: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Соединение установлено',
            ),
            const SizedBox(width: 10),
            SizedBox(
                height: 10,
                width: 10,
                child: const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                )),
          ],
        ),

        /// Wrap [MaterialApp] with [ConnectionNotifier], and that is it!
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale('ru', 'RU'),
          darkTheme: ThemeData(
            useMaterial3: true,
            textTheme: TextTheme(),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Color.fromRGBO(37, 39, 48, 1)),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Color.fromARGB(255, 8, 7, 7),
            // iconTheme: IconThemeData(color: Colors.white),
            colorScheme:
                ColorScheme.dark(background: Color.fromRGBO(20, 20, 20, 1)),

            cupertinoOverrideTheme: CupertinoThemeData(
              primaryColor: mainColor,
            ),
            // inputDecorationTheme: InputDecorationTheme(primaryColor: mainColor),
            fontFamily: "Circe",

            appBarTheme: Theme.of(context)
                .appBarTheme
                .copyWith(systemOverlayStyle: SystemUiOverlayStyle.light),
          ),
          themeMode: curMode.currentTheme(),
          theme: ThemeData(
            useMaterial3: true,
            textTheme: TextTheme(),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,

            cupertinoOverrideTheme: CupertinoThemeData(primaryColor: mainColor),
            // inputDecorationTheme: InputDecorationTheme(primaryColor: mainColor),
            fontFamily: "Circe",
            appBarTheme: Theme.of(context)
                .appBarTheme
                .copyWith(systemOverlayStyle: SystemUiOverlayStyle.dark),
          ),
          home: DefaultTabBar(),
        ));
  }
}

class DefaultTabBar extends StatefulWidget {
  int? indexTab;
  int? mainIndex;
  bool? cartFlag;
  DefaultTabBar({Key? key, this.indexTab, this.mainIndex, this.cartFlag})
      : super(key: key);
  @override
  DefaultTabBarState createState() => new DefaultTabBarState();
}

class DefaultTabBarState extends State<DefaultTabBar>
    with SingleTickerProviderStateMixin {
  int cartLength = 0;
  int currentIndex = 0;

  void initState() {
    super.initState();
    curMode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double media = MediaQuery.of(context).size.width > 420 ? 35 : 25;
    final userpr = Provider.of<UserProvider>(context);
    double radius = MediaQuery.of(context).size.height > 750 ? 8 : 7;
    double fontCir = MediaQuery.of(context).size.height > 750 ? 10 : 9;
    User? user = FirebaseAuth.instance.currentUser;
    return TabBottomView(
      enableFeedback: true,
      onTap: changeIndex,
      currentIndex: currentIndex,

      //  backgroundColor: Colors.white,
      elevation: 24,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: media, // Default iconSize is 24,

      bottomNavigationBarType: BottomNavigationBarType.fixed,

      items: [
        TabItem(
          label: '',
          page: MainPage(),
          icon: Icon(
            GNIcons.capicon,
          ),
        ),
        TabItem(
          label: '',
          page: CategoryPage(),
          icon: Icon(
            GNIcons.searchicon,
          ),
        ),
        TabItem(
            label: '',
            page: Cart(),
            icon: Stack(alignment: AlignmentDirectional.center, children: [
              Icon(
                GNIcons.shoppericon,
              ),
              user != null
                  ? FutureBuilder<int>(
                      future: userpr.getLengthCartProvider(),
                      initialData: cartLength,
                      builder: (builder, AsyncSnapshot<int> snap) {
                        if (snap.hasData) {
                          cartLength = snap.data!;
                          return snap.data != 0 && snap.data != null
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(left: 20, bottom: 15),
                                  child: new CircleAvatar(
                                      radius: currentIndex == 2
                                          ? radius - 1
                                          : radius,
                                      backgroundColor: Colors.red,
                                      child: Center(
                                          child: new Text(
                                        snap.hasData
                                            ? snap.data!.toString()
                                            : cartLength.toString(),
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: fontCir,
                                            fontWeight: FontWeight.w500),
                                      ))))
                              : SizedBox();
                        } else {
                          return SizedBox();
                        }
                      })
                  : SizedBox(),
            ])),
        TabItem(
            label: '',
            page: LandingPage(),
            icon: Icon(
              GNIcons.usericon,
            ))
      ],
    );
    /* tabBar: CupertinoTabBar(
        activeColor: mainColor,
        backgroundColor: Colors.white,
        inactiveColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: GestureDetector(
                //  onDoubleTap: () => Navigator.pop(context),
                child: Icon(GNIcons.capicon, size: media)),
          ),
          BottomNavigationBarItem(
            // label: "Категории",
            // iconMargin: EdgeInsets.only(top: 5.0),
            icon: Icon(GNIcons.searchicon, size: media),
          ),
          BottomNavigationBarItem(
              //label: "Корзина",
              icon: Container(
                  height: 40,
                  width: 40,
                  child:
                      Stack(alignment: AlignmentDirectional.center, children: [
                    Icon(
                      GNIcons.shoppericon,
                      size: media,
                      //   color: Colors.black,
                    ),
                    user != null
                        ? FutureBuilder<int>(
                            future: userpr.getLengthCartProvider(),
                            initialData: cartLength,
                            builder: (builder, AsyncSnapshot<int> snap) {
                              if (snap.hasData) {
                                cartLength = snap.data!;
                                return snap.data != 0 && snap.data != null
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, bottom: 15),
                                        child: new CircleAvatar(
                                            radius: radius,
                                            backgroundColor: Colors.red,
                                            child: Center(
                                                child: new Text(
                                              snap.hasData
                                                  ? snap.data!.toString()
                                                  : cartLength.toString(),
                                              textAlign: TextAlign.center,
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fontCir,
                                                  fontWeight: FontWeight.w500),
                                            ))))
                                    : SizedBox();
                              } else {
                                return SizedBox();
                              }
                            })
                        : SizedBox(),
                  ]))),
          BottomNavigationBarItem(
            // label: "Профиль",
            icon: Icon(GNIcons.usericon, size: media),
          ),
        ],
      ),*/
    /* tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: MainPage(),
              );
            });

          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: CategoryPage(),
              );
            });

          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Cart(),
              );
            });

          case 3:
            return CupertinoTabView(builder: (context) {
              return new LandingPage();
            });

          default:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: MainPage(),
              );
            });
        }
      },*/
  }

  void changeIndex(int itemIndex) {
    setState(() {});
    if (itemIndex == currentIndex) {
      TabConsts.navigatorKeys[currentIndex].currentState?.popUntil(
        (route) => route.isFirst,
      );
    } else {
      currentIndex = itemIndex;
      if (TabConsts.pageList.length <= 2) {
        if (TabConsts.pageList.contains(currentIndex)) {
          TabConsts.pageList.remove(currentIndex);
          TabConsts.pageList.add(currentIndex);
        } else {
          TabConsts.pageList.add(currentIndex);
        }
      } else {
        TabConsts.pageList.removeAt(1);
        TabConsts.pageList.add(currentIndex);
      }
    }
  }
}
