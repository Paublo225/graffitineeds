import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/helpers/styles.dart';

import 'package:skeleton_loader/skeleton_loader.dart';

class BrandItem extends StatefulWidget {
  int? id;
  String? index;
  String? imageUrl;
  String? title;
  String? description;
  String? country;
  VoidCallback? onTap;
  BrandItem(
      {this.id,
      this.index,
      this.imageUrl,
      this.title,
      this.description,
      this.country,
      this.onTap});

  Map toMap() => {
        "parentId": id,
        "картинка": imageUrl,
        "название": title,
      };

  _BrandItemState createState() => new _BrandItemState();
}

class _BrandItemState extends State<BrandItem> {
  final Color coverColor = Color.fromRGBO(217, 217, 217, 1);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    curMode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: widget.onTap,
        child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            // height: 90,
            // width: double.infinity,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                /*  child: ColorFiltered(
                    colorFilter: ThemaMode.isDarkMode
                        ? ColorFilter.matrix(
                            [
                              0.2126, 0.7152, 0.0722, 0, 250, ////
                              0.2126, 0.7152, 0.0722, 0, 250,

                              ///
                              0.2126, 0.7152, 0.0722, 0, 250,

                              ///
                              -1, -1, 0, 1, 0, ////
                            ],
                          )
                        : ColorFilter.matrix([
                            1, 0, 0, 0, 0, ////
                            0, 1, 0, 0, 0,

                            ///
                            0, 0, 1, 0, 0,

                            ///
                            0, 0, 0, 1, 0,

                            ///
                          ]),*/
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl!,
                  fit: BoxFit.fill,
                  placeholder: (context, str) {
                    return SkeletonLoader(
                        items: 1,
                        period: Duration(seconds: 2),
                        highlightColor: mainColor,
                        direction: SkeletonDirection.ltr,
                        builder: Container(
                          height: 90,
                          // width: double.infinity,
                          decoration: BoxDecoration(
                            color: coverColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ));
                  },
                ))),
      ),
      Center(
          child: Text(
        widget.title.toString().toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.w700),
      ))
    ]);
  }
}
