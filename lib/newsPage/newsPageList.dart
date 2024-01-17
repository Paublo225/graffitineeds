import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/models/vkNewsModel.dart';
import 'package:graffitineeds/newsPage/newsListItem.dart';

import 'package:graffitineeds/services/vk_services.dart';

// ignore: must_be_immutable
class NewsListPage extends StatefulWidget {
  NewsListPage();
  _NewsListPageState createState() => new _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<NewsListItem> newsItemList = [];
  bool loading = false;
  _getNews() async {
    if (mounted)
      setState(() {
        loading = true;
      });
    await VkService.getPosts().then((value) {
      value!.items!.forEach((element) {
        newsItemList.add(NewsListItem(newsItem: element));
      });
    });
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "НОВОСТИ",
          style: TextStyle(fontFamily: "Circe", fontWeight: FontWeight.w700),
        ),
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
                color: Colors.transparent,
                width: 50,
                height: 50,
                child: Icon(
                  Icons.arrow_back,
                  size: 28.0,
                  color: ThemaMode.isDarkMode ? mainColor : Colors.black,
                ))),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
              ),
            )
          : ListView(children: newsItemList),
    );
  }
}
