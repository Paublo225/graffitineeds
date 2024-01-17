import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/auth/authentication.dart';
import 'package:graffitineeds/boxberry/api_boxberry.dart';

import 'package:graffitineeds/boxberry/citiesModel.dart';
import 'package:graffitineeds/boxberry/pvzModel.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';

import 'package:graffitineeds/models/colorsModel.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graffitineeds/purchase/boxberryListPvz.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BoxBerryCitiesListPage extends StatefulWidget {
  String? addressName;
  BuildContext? buildContext;

  BoxBerryCitiesListPage({this.addressName, this.buildContext});
  _BoxBerryCitiesListPageState createState() =>
      new _BoxBerryCitiesListPageState();
}

class _BoxBerryCitiesListPageState extends State<BoxBerryCitiesListPage>
    with AutomaticKeepAliveClientMixin {
  List<Pvz> listPvz = [];
  List<PvzWidget> listWidgetPvz = [];
  List<City> listCities = [];
  List<City> searchListCities = [];

  bool loading = false;
  getCities() async {
    if (mounted)
      setState(() {
        loading = true;
      });
    if (mounted)
      await ApiBoxberry.getCities().then((value) => listCities = value);

    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    getCities();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor:
            ThemaMode.isDarkMode ? darkScaffoldColor : Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          leading: SizedBox(),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      color: Colors.transparent,
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.arrow_downward_rounded,
                        size: 28.0,
                        color: mainColor,
                      )))),
          title: Text(
            "Город доставки",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: ThemaMode.isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        body: Column(children: [
          _searchBar(_searchString),
          loading
              ? Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
                  ))
              : Flexible(
                  child: ListView.builder(
                      itemCount: _searchString == ""
                          ? listCities.length
                          : searchListCities.length,
                      itemBuilder: (context, index) {
                        return _searchString == ""
                            ? ListTile(
                                splashColor: Colors.transparent,
                                enableFeedback: false,
                                onTap: () {
                                  showCupertinoModalBottomSheet(
                                      context: widget.buildContext!,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => BoxBerryPvzListPage(
                                          listCities[index].Code,
                                          widget.buildContext)).then((value) {
                                    if (value != null) {
                                      Navigator.pop(context, value);
                                    }
                                  });
                                },
                                title: Text(
                                  listCities[index].Prefix! +
                                      ". " +
                                      listCities[index].UniqName!,
                                  style: TextStyle(
                                      color: ThemaMode.isDarkMode
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              )
                            : ListTile(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  showCupertinoModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => BoxBerryPvzListPage(
                                          searchListCities[index].Code,
                                          widget.buildContext)).then((value) {
                                    if (value != null) {
                                      Navigator.pop(context, value);
                                    }
                                  });
                                  ;
                                },
                                title: Text(
                                  searchListCities[index].Prefix! +
                                      ". " +
                                      searchListCities[index].UniqName!,
                                  style: TextStyle(
                                      color: ThemaMode.isDarkMode
                                          ? Colors.white
                                          : Colors.black),
                                ));
                      }))
        ]));
  }

  late TextEditingController _textController;
  void _warningTop() async {
    // await _addToCart();
    showTopSnackBar(
      context,
      CustomSnackBar.error(
        icon: Icon(null),
        message: "Зарегистрируйтесь или войдите в профиль",
      ),
      displayDuration: Duration(milliseconds: 500),
      onTap: () {
        showCupertinoModalPopup(
            context: context, builder: (builder) => AuthPage());
      },
    );
  }

  List<ColorsModel> searchList = [];
  _searchBar(String searchString) {
    double widthSize = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(children: [
      Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 10),
        width: widthSize,
        height: 40,
        child: CupertinoSearchTextField(
          controller: _textController,

          //  prefixInsets: EdgeInsets.only(left: 8, right: 3),

          placeholder: "Поиск",
          //   placeholderStyle: TextStyle(color: Colors.black),
          style:
              TextStyle(color: Colors.black, fontFamily: "Circe", fontSize: 14),
          decoration: BoxDecoration(
            color: Color(0xFFE4E4E4),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          onChanged: (val) {
            searchListCities = [];
            if (mounted)
              setState(() {
                _searchString = val.toLowerCase();
                searchListCities = listCities
                    .where((t) =>
                        t.Name!
                            .toLowerCase()
                            .contains(searchString.toLowerCase()) ||
                        t.UniqName!
                            .toLowerCase()
                            .contains(searchString.toLowerCase()))
                    .toList();
              });
          },

          onSuffixTap: () {
            if (mounted)
              setState(() {
                _searchString = "";
              });

            _textController.clear();
          },
        ),
      )
    ]));
  }

  bottomBarCheck(ColorsModel item) {
    if (item.checked) print(item.checked);
  }

  @override
  bool get wantKeepAlive => true;
}
