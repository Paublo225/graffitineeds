import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:graffitineeds/models/mainpageCover.dart';

import '../main.dart';

class FilterView extends StatefulWidget {
  FilterView();
  @override
  _FilterViewState createState() => new _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            "Палитра цветов",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black54,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, top: 10, bottom: 5),
              alignment: Alignment.bottomLeft,
              child: Text(
                "Цвет: LP-365 Las Vegas",
                style: TextStyle(fontSize: 14),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                )),
            Expanded(
                child: GridView.count(
              crossAxisCount: 6,
              children: colors,
            ))
          ],
        ));
  }
}

class ColorsStuff extends StatefulWidget {
  late Color color;
  late String name;
  ColorsStuff({required this.color});
  _ColorsStuffState createState() => new _ColorsStuffState();
}

class _ColorsStuffState extends State<ColorsStuff> {
  bool _state = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _state = !_state;
          });

          print(widget.color.toString());
        },
        child: Container(
          height: 45,
          width: 45,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: _state ? Colors.blue : Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(11))),
          child: Center(
            child: Container(
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
              ),
            ),
          ),
        ));
  }
}

List<ColorsStuff> colors = [
  ColorsStuff(
    color: Color(int.parse("0xff1A8D89")),
  ),
  ColorsStuff(
    color: Color(0xff1A8D89),
  ),
  ColorsStuff(
    color: Color(0xff31FF46),
  ),
  ColorsStuff(
    color: Color(0xff3161FF),
  ),
  ColorsStuff(
    color: Color(0xffF831FF),
  ),
  ColorsStuff(
    color: Color(0xffFFA5A5),
  ),
  ColorsStuff(
    color: Color(0xffFF3138),
  ),
  ColorsStuff(
    color: Color(0xffDEFF31),
  ),
  ColorsStuff(
    color: Color(0xffE4FF97),
  ),
  ColorsStuff(
    color: Color(0xff83FF31),
  ),
  ColorsStuff(
    color: Color(0xffFF8A31),
  ),
  ColorsStuff(
    color: Color(0xff34FFAD),
  ),
  ColorsStuff(
    color: Color(0xff31FFAD),
  ),
  ColorsStuff(
    color: Color(0xffFFA5A5),
  ),
  ColorsStuff(
    color: Color(0xff9CFFFC),
  ),
  ColorsStuff(
    color: Color(0xff1A8D89),
  ),
  ColorsStuff(
    color: Color(0xff31FF46),
  ),
  ColorsStuff(
    color: Color(0xff3161FF),
  ),
  ColorsStuff(
    color: Color(0xffF831FF),
  ),
  ColorsStuff(
    color: Color(0xffDFEFE9),
  ),
  ColorsStuff(
    color: Color(0xffFF3138),
  ),
  ColorsStuff(
    color: Color(0xffDEFF31),
  ),
  ColorsStuff(
    color: Color(0xffE4FF97),
  ),
  ColorsStuff(
    color: Color(0xff83FF31),
  ),
  ColorsStuff(
    color: Color(0xffFF8A31),
  ),
  ColorsStuff(
    color: Color(0xff34FFAD),
  ),
  ColorsStuff(
    color: Color(0xff31FFAD),
  ),
  ColorsStuff(
    color: Color(0xffDFEFE9),
  ),
  ColorsStuff(
    color: Color(0xff9CFFFC),
  ),
  ColorsStuff(
    color: Color(0xff1A8D89),
  ),
  ColorsStuff(
    color: Color(0xff31FF46),
  ),
  ColorsStuff(
    color: Color(0xff3161FF),
  ),
  ColorsStuff(
    color: Color(0xffF831FF),
  ),
  ColorsStuff(
    color: Color(0xffFFA5A5),
  ),
  ColorsStuff(
    color: Color(0xffFF3138),
  ),
  ColorsStuff(
    color: Color(0xffDEFF31),
  ),
  ColorsStuff(
    color: Color(0xffE4FF97),
  ),
  ColorsStuff(
    color: Color(0xff83FF31),
  ),
  ColorsStuff(
    color: Color(0xffFF8A31),
  ),
  ColorsStuff(
    color: Color(0xff34FFAD),
  ),
  ColorsStuff(
    color: Color(0xff31FFAD),
  ),
  ColorsStuff(
    color: Color(0xffDFEFE9),
  ),
];
