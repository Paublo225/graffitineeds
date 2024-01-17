import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/boxberry/api_boxberry.dart';
import 'package:graffitineeds/boxberry/pvzModel.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/models/colorsModel.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BoxBerryPvzListPage extends StatefulWidget {
  String CityCode;
  BuildContext? buildContext;
  BoxBerryPvzListPage(this.CityCode, this.buildContext);
  _BoxBerryPvzListPageState createState() => new _BoxBerryPvzListPageState();
}

class _BoxBerryPvzListPageState extends State<BoxBerryPvzListPage> {
  List<Pvz> listPvz = [];
  List<Pvz> searchList = [];
  Pvz? selectedPvz;

  bool loading = false;
  getPvz() async {
    if (mounted)
      setState(() {
        loading = true;
      });
    if (mounted)
      await ApiBoxberry.getPVZ(widget.CityCode)
          .then((value) => listPvz = value);

    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    getPvz();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            ThemaMode.isDarkMode ? darkScaffoldColor : Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          leading: SizedBox(),
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
          backgroundColor: Colors.transparent,
          title: Text(
            "Пункт доставки",
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
                          ? listPvz.length
                          : searchList.length,
                      itemBuilder: (context, index) {
                        return _searchString == ""
                            ? ListTile(
                                onTap: () {
                                  selectedPvz = listPvz[index];

                                  Navigator.pop(
                                      widget.buildContext!, (selectedPvz));
                                },
                                title: Text(
                                  listPvz[index].Address!,
                                  style: TextStyle(
                                      color: ThemaMode.isDarkMode
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              )
                            : ListTile(
                                onTap: () {
                                  selectedPvz = searchList[index];

                                  Navigator.pop(
                                      widget.buildContext!, (selectedPvz));
                                },
                                title: Text(
                                  searchList[index].Address!,
                                  style: TextStyle(
                                      color: ThemaMode.isDarkMode
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              );
                      }))
        ]));
  }

  late TextEditingController _textController;

  _searchBar(String searchString) {
    double widthSize = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(children: [
      Container(
        margin: EdgeInsets.only(top: 10, left: 15, right: 10, bottom: 5),
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
            searchList = [];
            if (mounted)
              setState(() {
                _searchString = val.toLowerCase();
                searchList = listPvz
                    .where((t) =>
                        t.Name!
                            .toLowerCase()
                            .contains(searchString.toLowerCase()) ||
                        t.Address!
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
}
