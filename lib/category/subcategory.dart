import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graffitineeds/helpers/firebase_cache.dart';
import 'package:graffitineeds/helpers/styles.dart';

import 'package:graffitineeds/models/mainpageCover.dart';
import 'package:graffitineeds/models/subcategoryModel.dart';

import 'package:skeleton_loader/skeleton_loader.dart';

import 'package:sliver_tools/sliver_tools.dart';

class SubCategoryPage extends StatefulWidget {
  String title;
  String? description;
  String? country;
  SubCategoryPage({required this.title, this.description, this.country});
  @override
  _SubCategoryPageState createState() => new _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String mainCategory1 = "";
  String mainImageCategory1 = "";
  final Color coverColor = Color.fromRGBO(217, 217, 217, 1);
  String mainCategory2 = "";
  String mainImageCategory2 = "";
  String descriptionText = "";

  List<SubCategoryModel> subCategoryList = [];
  bool _loading = false;

  _getCategories() async {
    if (mounted)
      setState(() {
        _loading = true;
      });
    await FirebaseFirestore.instance
        .collection("категории")
        .doc("бренды")
        .collection("бренды")
        .doc(widget.title.toLowerCase())
        .collection("подкатегории")
        .getCacheFirst()
        .then((value) {
      value.docs.forEach((f) {
        if (mounted)
          setState(() {
            subCategoryList.add(SubCategoryModel(
              id: f.get("id"),
              imageUrl: f.get("картинка"),
              name: f.get("название"),
              brand: widget.title.toLowerCase(),
              category: f.id,
              productView: f.get("productView"),
              searchString: f.get("searchString")!,
            ));
          });
      });
    });
    if (mounted)
      setState(() {
        _loading = false;
      });
  }

  @override
  void initState() {
    // _getDescription();

    super.initState();
    if (mounted) _getCategories();
  }

  List<MainPageCover> categoryList = [];
  Widget mainPageCategory(String image, String title, {VoidCallback? onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Stack(children: [
                CachedNetworkImage(
                  imageUrl: image,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.fill,
                  placeholder: (context, str) {
                    return SkeletonLoader(
                        // items: 1,
                        period: Duration(seconds: 2),
                        highlightColor: coverColor,
                        direction: SkeletonDirection.ltr,
                        builder: Container(
                          height: 120,
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
                ),
              ]),
              Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Center(
                    child: Text(
                      title.toUpperCase(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ))
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    print(subCategoryList.length);
    super.build(context);

    return new Scaffold(
        resizeToAvoidBottomInset: false,
        // key: _scaffoldKey,

        appBar: AppBar(
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  color: Colors.transparent,
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.arrow_back,
                    size: 28.0,
                    color: mainColor,
                  ))),
          title: Text(
            widget.title.toUpperCase(),
            style: TextStyle(fontFamily: "Circe", fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: !_loading
            ? SafeArea(
                child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        for (int i = 0; i < subCategoryList.length; i++)
                          subCategoryList[i],
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Text(
                            "ОПИСАНИЕ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                          child: Text(
                            widget.description!,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 20, top: 5, right: 20),
                          child: Text(
                            "Страна производитель: " + widget.country!,
                          ),
                        ),
                      ],
                    )))
            : Center(
                child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
              )));
  }

  Widget _titlePinned(String title) {
    return SliverPinnedHeader(
        child: Container(
      // margin: EdgeInsets.only(top: 10, left: 15, right: 15)
      width: double.infinity,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ))
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

  @override
  bool get wantKeepAlive => true;
}
