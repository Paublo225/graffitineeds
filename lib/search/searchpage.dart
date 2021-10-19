import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/main.dart';
import 'package:graffitineeds/models/itemModel.dart';
import 'package:graffitineeds/search/searchCard.dart';

class SearchResultPage extends StatefulWidget {
  String search;
  SearchResultPage({Key key, this.search}) : super(key: key);
  @override
  _SearchResultPageState createState() => new _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  String _searchString = "";
  PageController _pageController;

  void initState() {
    // loadData();
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 4);
    print("called Search");
  }

  List<SearchCard> searcard = [
    SearchCard(),
    SearchCard(),
    SearchCard(),
    SearchCard(),
    SearchCard(),
    SearchCard(),
    SearchCard(),
    SearchCard(),
    SearchCard(),
    SearchCard(),
    SearchCard(),
  ];

  bool _folded = true;
  TabController _tabController;

  final TextStyle topMenuStyle = new TextStyle(
      //  fontFamily: 'Avenir next',
      fontSize: 26,
      color: Colors.black,
      fontWeight: FontWeight.w600);
  final TextStyle buttonInfoStyle = new TextStyle(
      fontFamily: 'Avenir next', fontSize: 14, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  //  margin: EdgeInsets.only(top: 1),
                  width: MediaQuery.of(context).size.width - 50,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(17),
                        topRight: Radius.circular(17),
                        bottomLeft: Radius.circular(17),
                        bottomRight: Radius.circular(17)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.8,
                        blurRadius: 0.1,
                        offset: Offset(3, 6), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 4),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              cursorColor: mainColor,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.black54,
                                  ),
                                  hoverColor: Colors.white,
                                  hintText: 'Поиск',
                                  hintStyle: TextStyle(
                                    height: 1.3,
                                    fontSize: 16,
                                    color: Colors.black26,
                                  ),
                                  border: InputBorder.none),
                              onChanged: (val) {
                                setState(() {
                                  _searchString = val.toLowerCase();
                                });
                              },
                            )),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        body: Container(
            child: Stack(children: [
          if (_searchString.isEmpty)
            _searchField()
          else
            ListView(children: searchItems)
        ])));
  }

  // Loading State

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
}
