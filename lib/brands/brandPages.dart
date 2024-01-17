import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/brands/brandsModel.dart';
import 'package:graffitineeds/helpers/styles.dart';

// ignore: must_be_immutable
class BrandListPage extends StatefulWidget with ChangeNotifier {
  List<BrandItem> brandsList;
  BrandListPage({Key? key, required this.brandsList});

  BrandListPageState createState() => new BrandListPageState();
}

class BrandListPageState extends State<BrandListPage> {
  TextEditingController _textController = TextEditingController();
  List<BrandItem> brandSearchList = [];
  List<BrandItem> brandList = [];
  String _searchString = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.brandsList.sort(((a, b) => a.title!.compareTo(b.title!)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          flexibleSpace: SafeArea(
              child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 10, left: 55, right: 15),
              width: double.infinity,
              height: 40,
              child: CupertinoSearchTextField(
                controller: _textController,
                itemColor: Colors.black45,

                //  prefixInsets: EdgeInsets.only(left: 8, right: 3),
                placeholder: "Бренды",
                //   placeholderStyle: TextStyle(color: Colors.black),
                style: TextStyle(
                    color: Colors.black, fontFamily: "Circe", fontSize: 14),
                decoration: BoxDecoration(
                  color: Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                onChanged: (val) {
                  brandSearchList = [];
                  if (mounted)
                    setState(() {
                      _searchString = val.toLowerCase();
                    });

                  if (mounted)
                    setState(() {
                      brandSearchList = widget.brandsList
                          .where((t) => t.title!
                              .toLowerCase()
                              .contains(val.toLowerCase()))
                          .toList();
                    });
                },

                onSuffixTap: () {
                  brandSearchList.clear();
                  setState(() {
                    _searchString = "";
                  });
                  _textController.clear();
                },
              ),
            )
          ])),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.arrow_back,
                    size: 28.0,
                    color: mainColor,
                  ))),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.only(top: 20),
            child: Column(children: [
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5.0,
                  ),
                  itemCount: _searchString == ""
                      ? widget.brandsList.length
                      : brandSearchList.length,
                  itemBuilder: (context, i) {
                    return _searchString == ""
                        ? widget.brandsList[i]
                        : brandSearchList[i];
                  }),
            ])));
  }
}
