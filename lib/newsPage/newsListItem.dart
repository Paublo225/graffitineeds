import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/models/vkNewsModel.dart';
import 'package:graffitineeds/newsPage/newsPageList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:octo_image/octo_image.dart';

class NewsListItem extends StatefulWidget {
  VkItem newsItem;
  NewsListItem({required this.newsItem});
  _NewsListItemState createState() => new _NewsListItemState();
}

class _NewsListItemState extends State<NewsListItem> {
  VkItem? vkNewModel;
  int carouselindex = 0;
  final CarouselController carouselController = new CarouselController();
  @override
  void initState() {
    super.initState();
    vkNewModel = widget.newsItem;
    transformDate();
  }

  List<OctoImage> imagesList() {
    List<OctoImage> imagess = [];

    for (var element in vkNewModel!.attachments) {
      if (element["type"] == "photo")
        imagess.add(OctoImage(
            width: double.infinity,
            fit: BoxFit.fill,
            placeholderBuilder: (BuildContext context) {
              return Image.asset(
                "lib/assets/gn_loading.png",
                fit: BoxFit.contain,
              );
            },
            errorBuilder: (contex, object, tyy) => Image.asset(
                  "lib/assets/gn_loading.png",
                  fit: BoxFit.contain,
                ),
            image: NetworkImage(element["photo"]["sizes"][3]["url"])));
    }
    return imagess;
  }

  String transformDate() {
    DateTime? date;
    String transormedDate = "";
    date = DateTime.fromMillisecondsSinceEpoch(widget.newsItem.date * 1000);
    if (date.day < 10) {
      transormedDate += "0" + date.day.toString() + "/";
    } else {
      transormedDate += date.day.toString() + "/";
    }
    if (date.month < 10) {
      transormedDate += "0" + date.month.toString() + "/";
    } else {
      transormedDate += date.month.toString() + "/";
    }
    transormedDate += date.year.toString();
    return transormedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
          carouselController: carouselController,
          items: imagesList(),
          options: CarouselOptions(
              autoPlay: false,
              enlargeFactor: 1,
              aspectRatio: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  carouselindex = index;
                });
              },
              viewportFraction: 1,
              padEnds: false,
              enableInfiniteScroll: false,
              autoPlayInterval: Duration(seconds: 10))),
      Container(
          color: ThemaMode.isDarkMode ? darkBackColor : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imagesList().asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(carouselindex == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          )),

      /* Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            constraints: BoxConstraints(minHeight: 200),
            margin: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                  width: double.infinity,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Image.asset(
                      "lib/assets/gn_loading.png",
                      fit: BoxFit.contain,
                    );
                  },
                  errorBuilder: (contex, object, tyy) => Image.asset(
                        "lib/assets/gn_loading.png",
                        fit: BoxFit.contain,
                      ),
                  image: NetworkImage(
                    widget.newsItem.attachments[0]["photo"]["sizes"][3]["url"],
                  )),
            )),*/

      Container(
          constraints: BoxConstraints(
            minWidth: double.infinity,
          ),
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 20),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: ThemaMode.isDarkMode ? darkBackColor : Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                offset: Offset(1.0, 3.0),
                blurRadius: 3.0,
              ),
            ],
          ),
          child: Text(transformDate() + "\n\n" + vkNewModel!.text)),
    ]);
  }
}
