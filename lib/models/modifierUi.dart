import 'package:flutter/material.dart';
import 'package:graffitineeds/helpers/firebase_names.dart';
import 'package:graffitineeds/helpers/paint_icons.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/models/product.dart';

import 'package:graffitineeds/services/api_services.dart';

// ignore: must_be_immutable
class ModifierUi extends StatefulWidget {
  Modifiers modifier;
  ModifierUi({Key? key, required this.modifier});
  _ModifierUiState createState() => new _ModifierUiState();
}

class _ModifierUiState extends State<ModifierUi> {
  int? baseCount = 0, price = 0;
  /*getInfo(Modifiers mod ,int balance, int price) async{
      mod.cost
  }
*/

  @override
  void initState() {
    super.initState();
    baseCount = widget.modifier.baseCount!;
    price = widget.modifier.cost!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16),
        height: 15,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ThemaMode.isDarkMode ? darkBackColor : Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1.0, 3.0),
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Row(children: <Widget>[
          Stack(children: [
            Container(
              height: 115,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    fit: BoxFit.contain,
                    height: 115,
                    width: 90,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Image.asset(
                        "lib/assets/gn_loading.png",
                        height: 115,
                        width: 90,
                        fit: BoxFit.contain,
                      );
                    },
                    errorBuilder: (contex, object, tyy) => Image.asset(
                          "lib/assets/gn_loading.png",
                          height: 115,
                          width: 90,
                          fit: BoxFit.contain,
                        ),
                    image: NetworkImage(
                        APILINKIMAGE + widget.modifier.images![0],
                        headers: ApiServices.headers))),
          ]),
          SizedBox(
            height: 10,
            width: 5,
          ),
          Flexible(
            child: Stack(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 5),
                    child: Text(widget.modifier.name!,
                        style: TextStyle(
                            fontSize: 14,
                            color: ThemaMode.isDarkMode
                                ? Colors.white
                                : Colors.black)),
                  ),
                  //FutureBuilder(builder: (builder, snap) {}),

                  Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(price.toString() + " руб",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: ThemaMode.isDarkMode
                                  ? Colors.white
                                  : Colors.black))),
                ]),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Кол-во: " + baseCount.toString(),
                          style: TextStyle(
                              color: ThemaMode.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        )
                      ]),
                )
              ],
            ),
          ),
        ]));
  }
}
