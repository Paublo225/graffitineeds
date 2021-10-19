import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/cart/cartitem.dart';
import 'package:graffitineeds/cart/cartpage.dart';
import 'package:graffitineeds/homepage/tabbar.dart';
import 'package:graffitineeds/models/items.dart';
import 'package:graffitineeds/models/mainpageCover.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../main.dart';
import 'package:sliver_tools/sliver_tools.dart';

class MainPage extends StatefulWidget {
  MainPage();
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    var topCir = MediaQuery.of(context).size.height / 120;
    var rightCir = MediaQuery.of(context).size.height / 46;
    var radius = 6.0;
    //print(radius);
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

    List<MainPageCover> mainPageCover = [
      MainPageCover(
          imageUrl: "lib/assets/loop.png",
          title: "краска loop",
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (builder) =>
                        ItemZ(name: "Краска loop", category: "Краска")));
          }),
      MainPageCover(
        imageUrl: "lib/assets/montana.png",
        title: "краска montana",
      ),
      MainPageCover(
          imageUrl: "lib/assets/markers.png",
          title: "восковые Маркеры",
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (builder) =>
                        ItemZ(name: "восковые Маркеры", category: "Маркеры")));
          }),
      MainPageCover(
        imageUrl: "lib/assets/stickers.png",
        title: "стикеры",
      ),
    ];
    var fontCir = MediaQuery.of(context).size.height / 80;
    String _searchString = "";
    bool _folded = true;

    return new Scaffold(
        resizeToAvoidBottomInset: false,
        // key: _scaffoldKey,
        backgroundColor: Colors.white,
        /* appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                padding: EdgeInsets.only(right: 150),
                child: Image.asset(
                  'lib/assets/gn_logo.png',
                  //width: 250,
                  height: 151,
                  width: 151,
                  // fit: BoxFit.cover,
                )),
          ]),
        ),*/
        body: new CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 50,
              backgroundColor: Colors.white,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.only(right: 150),
                        child: Image.asset(
                          'lib/assets/gn_logo.png',
                          //width: 250,
                          height: 121,
                          width: 121,
                          // fit: BoxFit.cover,
                        )),
                  ]),
            ),
            SliverAppBar(
                foregroundColor: mainColor,
                backgroundColor: Colors.white,
                collapsedHeight: 60,
                pinned: true,
                elevation: 0.0,
                flexibleSpace:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      margin: EdgeInsets.only(top: 30),
                      width: MediaQuery.of(context).size.width - 50,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0.8,
                            blurRadius: 0.1,
                            offset: Offset(0, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                left: 10,
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey,
                              )),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(left: 15),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              cursorColor: mainColor,
                              decoration: InputDecoration(
                                  hoverColor: Colors.black38,
                                  hintText: 'Поиск',
                                  hintStyle: TextStyle(
                                    height: 1.3,
                                    fontSize: 16,
                                    color: Colors.black38,
                                  ),
                                  border: InputBorder.none),
                              onChanged: (val) {
                                setState(() {
                                  _searchString = val.toLowerCase();
                                  _folded = !_folded;
                                });
                              },
                            ),
                          ))
                        ],
                      )),
                ])),
            _folded
                ? SliverList(
                    delegate: SliverChildListDelegate([
                    Container(
                        height: 150,
                        margin: EdgeInsets.only(top: 10, bottom: 15),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true,
                          ),
                          items: mainPageCover,
                        )),
                  ]))
                : new SizedBox(),
            _folded
                ? MultiSliver(pushPinnedChildren: true, children: [
                    _titlePinned("Новинки"),
                    SliverPadding(
                      padding: EdgeInsets.only(bottom: 50),
                      sliver: SliverGrid.count(
                        crossAxisCount: 2,
                        children: products2,
                      ),
                    )
                  ])
                : new SizedBox(
                    height: 10,
                    width: 1,
                  ),
            _titlePinned("Горячее"),
            /*SliverList(
                delegate: SliverChildListDelegate(
              products,
            )),*/
            SliverPadding(
              padding: EdgeInsets.only(bottom: 50),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                children: products,
              ),
            )
          ],
        ));
  }

  _titlePinned(String title) {
    return SliverPinnedHeader(
        child: Container(
      margin: EdgeInsets.only(bottom: 10, left: 20),
      height: 40,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));
  }

  _searchField() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(bottom: 60),
          height: MediaQuery.of(context).size.width + 50,
          width: MediaQuery.of(context).size.width * 0.9,
          alignment: Alignment.topCenter,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                // padding: EdgeInsets.only(top: 10, bottom: 50),
                child: Icon(
              Icons.search_rounded,
              size: 80,
              color: Colors.grey[400],
            )),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Введите интересующий Вас товар",
                  style: TextStyle(
                    fontFamily: 'Avenir next',
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                )),
          ])),
    );
  }

  PageController _pageController;
  _sliderui(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 270.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: GestureDetector(
        /*onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieScreen(movie: movies[index]),
          ),
        ),*/
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 4.0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Hero(
                    tag: "movies[index].imageUrl",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image: AssetImage("lib/assers/caps.png"),
                        height: 220.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 30.0,
              bottom: 40.0,
              child: Container(
                width: 250.0,
                child: Text(
                  "movies[index].title.toUpperCase()",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
