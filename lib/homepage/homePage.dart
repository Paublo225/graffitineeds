import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graffitineeds/brands/brandPages.dart';
import 'package:graffitineeds/category/subcategory.dart';
import 'package:graffitineeds/brands/brandsModel.dart';
import 'package:graffitineeds/helpers/firebase_cache.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/models/mainPageCategory.dart';
import 'package:graffitineeds/models/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:graffitineeds/newsPage/newsMain.dart';
import 'package:graffitineeds/services/apitest.dart';
import 'package:http/http.dart';

class MainPage extends StatefulWidget {
  MainPage();
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TextEditingController _textController;

  String mainCategory1 = "";
  String mainImageCategory1 = "";
  NewsMain? newsMain;

  List<BrandItem> brandsList = [];
  List<Nomenclature>? productsList = [];

  ProductApi? productApi;

  _getProducts() async {
    productApi = await ApiTest.getRepoTest();
    setState(() {
      productsList = productApi?.nomenclatures;
    });
    print("Всего в номенклатуре: ${productApi?.nomenclatures!.length}");
    return productsList;
  }

  _getBrands() async {
    await FirebaseFirestore.instance
        .collection("категории")
        .doc("бренды")
        .collection("бренды")
        .getCacheFirst()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          brandsList.add(BrandItem(
            imageUrl: element.get("картинка"),
            title: element.get("название"),
            index: element.get("index"),
            description: element.get("описание"),
            country: element.get("страна"),
            onTap: () {
              print(element.get("название"));
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (builder) => SubCategoryPage(
                            description: element.get("описание"),
                            country: element.get("страна"),
                            title: element.get("название"),
                          )));
            },
          ));
        });
        brandsList.sort(((a, b) => a.index!.compareTo(b.index!)));
      });
    });
  }

  // List<MainPageCategoryModel> main2PageCategoryList = [];

  getNews() async {
    Map<String, dynamic> newsMap = {};
    await FirebaseFirestore.instance
        .collection("новости")
        .doc("новости")
        .getCacheFirst()
        .then(
      (v) {
        setState(() {
          newsMap = {
            "изображение": v.get("изображение"),
            "имя": v.get("имя"),
          };
          newsMain = NewsMain(
              newsMain: newsMap = {
            "изображение": v.get("изображение"),
            "имя": v.get("имя"),
          });
        });
      },
    );
    return newsMap;
  }

  List<MainPageCategoryModel> mainPageCategoryList = [];
  bool loadMainCategory = false;
  _getCategories() async {
    setState(() {
      loadMainCategory = true;
    });
    await FirebaseFirestore.instance
        .collection("категории")
        .doc("главная")
        .collection("главная2")
        .getCacheFirst()
        .then((value) {
      value.docs.forEach((item) {
        if (item.get("published") == true) {
          mainPageCategoryList.add(MainPageCategoryModel(
            id: item.get("id"),
            imageUrl: item.get("изображение"),
            name: item.get("имя"),
            nomList: item.get("nomList"),
            modifiers: item.get('modifiers'),
            hierarchicalParent: item.get(HIERARCHICALPARENT),
            searchFlag: item.get(SEARCHFLAG),
            searchList: item.get(SEARCHLIST),
          ));
        }
      });
    });

    /* main2PageCategoryList.clear();
    await FirebaseFirestore.instance
        .collection("категории")
        .doc("главная")
        .collection("главная")
        .getCacheFirst()
        .then((value) {
      value.docs.forEach((item) {
        if (item.get("published") == true)
          main2PageCategoryList.add(MainPageCategoryModel(
            id: item.get("id"),
            imageUrl: item.get("изображение"),
            name: item.get("имя"),
            nomList: item.get("nomList"),
            hierarchicalParent: item.get(HIERARCHICALPARENT),
            searchFlag: item.get(SEARCHFLAG),
            searchList: item.get(SEARCHLIST),
          ));
      });
    });*/
    setState(() {
      loadMainCategory = false;
    });
  }

  @override
  void initState() {
    _getCategories();
    getNews();
    _getBrands();

    super.initState();
    _getProducts();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _folded = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    String _searchString = "";

    return new SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            // key: _scaffoldKey,
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              toolbarHeight: 0,
              backgroundColor: Colors.transparent,
            ),
            //  backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(children: [
                Container(
                    child: CarouselSlider(
                  items: mainPageCategoryList,
                  options: CarouselOptions(
                    autoPlayInterval: Duration(seconds: 8),
                    autoPlay: true,
                    aspectRatio: 2.0,
                  ),
                )),
                _titlePinned("Бренды"),
                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 5.0,
                    ),
                    itemCount: brandsList.length < 6 ? brandsList.length : 6,
                    itemBuilder: (context, i) {
                      return brandsList[i];
                    }),
                Container(margin: EdgeInsets.only(bottom: 30), child: newsMain),
                /* _newsTitlePinned("НОВОСТИ"),
                    GridView.builder(
                        padding:
                            EdgeInsets.only(bottom: 10, left: 15, right: 15),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1.5,
                          mainAxisSpacing: 1.0,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: newsList.length < 3 ? brandsList.length : 3,
                        itemBuilder: (context, i) {
                          return newsList[i];
                        })*/
              ]),
            )
            /* : ListView(children: [
                SearchResultPage(
                  search: _searchString,
                )
              ])*/
            ));
  }

  Widget _titlePinned(String title) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 40,
      width: double.infinity,
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(title.toUpperCase(),
                style: TextStyle(
                    fontFamily: "Circe",
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
          ),
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (builder) => BrandListPage(
                            brandsList: brandsList,
                          ))),
              child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text("ПОКАЗАТЬ ЕЩЕ",
                          style: TextStyle(
                            fontFamily: "Circe",
                            fontSize: 15,
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.arrow_right_alt)
                  ]))),
        ],
      ),
    );
  }

/*  Widget _newsTitlePinned(String title) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 40,
      width: double.infinity,
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(title.toUpperCase(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Circe",
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
          ),
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (builder) => NewsListPage(
                            newsList: newsList,
                          ))),
              child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text("ПОКАЗАТЬ ЕЩЕ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Circe",
                            fontSize: 15,
                          )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.arrow_right_alt)
                  ]))),
        ],
      ),
    );
  }
*/
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
