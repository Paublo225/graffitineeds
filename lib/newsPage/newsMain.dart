import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/category/mainPageCategory.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/newsPage/newsPageList.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

// ignore: must_be_immutable
class NewsMain extends StatefulWidget {
  Map<dynamic, dynamic>? newsMain;

  NewsMain({required this.newsMain});
  _NewsMainState createState() => new _NewsMainState();
}

class _NewsMainState extends State<NewsMain> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final Color coverColor = Color.fromRGBO(217, 217, 217, 1);
    return GestureDetector(
        onTap: () => Navigator.push(
            context, CupertinoPageRoute(builder: (context) => NewsListPage())),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(20),
          child: Stack(alignment: AlignmentDirectional.center, children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: widget.newsMain!["изображение"],
                  errorWidget: (c, s, e) {
                    return Text("");
                  },
                  width: double.infinity,
                  fit: BoxFit.fill,
                  placeholder: (context, str) {
                    // fallback to placeholder
                    return SkeletonLoader(
                        items: 1,
                        period: Duration(seconds: 2),
                        highlightColor: mainColor,
                        direction: SkeletonDirection.ltr,
                        builder: Container(
                          height: height < 680 ? 175 : 185,
                          decoration: BoxDecoration(
                            color: coverColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                        ));
                  },
                )),
            Center(
              child: Text(
                widget.newsMain!["имя"],
                style: TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 2.5,
                        offset: Offset.fromDirection(2.0),
                      ),
                      Shadow(
                        blurRadius: 2.5,
                        offset: Offset.fromDirection(2.0),
                      ),
                    ],
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ]),
        ));
  }
}
