import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/category/mainPageCategory.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/newsPage/newsPageList.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

// ignore: must_be_immutable
class MainPageCategoryModel extends StatefulWidget {
  String? id;
  List<dynamic>? nomList;
  int? hierarchicalParent;
  String? name;
  bool? modifiers;
  String? imageUrl;
  List<dynamic>? searchList;
  bool? searchFlag;

  MainPageCategoryModel(
      {Key? key,
      this.id,
      this.name,
      this.imageUrl,
      this.modifiers,
      this.searchList,
      this.nomList,
      this.hierarchicalParent,
      this.searchFlag});
  _MainPageCategoryModelState createState() =>
      new _MainPageCategoryModelState();
}

class _MainPageCategoryModelState extends State<MainPageCategoryModel> {
  final Color coverColor = Color.fromRGBO(217, 217, 217, 1);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => widget.hierarchicalParent! == 999999
                    ? NewsListPage()
                    : MainPageCategoryProducts(
                        name: widget.name!,
                        hierarchicalParent: widget.hierarchicalParent,
                        nomList: widget.nomList!,
                        id: widget.id,
                        modifiers: widget.modifiers ?? false,
                        searchFlag: widget.searchFlag,
                        searchList: widget.searchList,
                      ))),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Stack(alignment: AlignmentDirectional.center, children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl!,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  placeholder: (context, sr) {
                    return SkeletonLoader(
                        // items: 1,
                        period: Duration(seconds: 2),
                        highlightColor: mainColor,
                        direction: SkeletonDirection.ltr,
                        builder: Container(
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
                widget.name!,
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
