import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graffitineeds/cart/counterCard.dart';

import 'package:graffitineeds/main.dart';
import 'package:graffitineeds/models/itemModel.dart';
import 'package:graffitineeds/product/count.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// ignore: must_be_immutable
class SearchCard extends StatefulWidget with ChangeNotifier {
  String id;
  String name;
  String image;
  String productId;
  String imageUrl;
  int price;
  int quantity;
  int summary;

  SearchCard(
      {Key key,
      this.id,
      this.name,
      this.image,
      this.imageUrl,
      this.price,
      this.productId,
      this.quantity,
      this.summary});

  SearchCardState createState() => new SearchCardState();
}

class SearchCardState extends State<SearchCard> with ChangeNotifier {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  void _doSomething() async {
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        icon: null,
        message: "+1 ${widget.name} добавлен в корзину",
      ),
      displayDuration: Duration(milliseconds: 100),
    );
    _btnController.success();

    print("clickedz");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      height: 95,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            offset: Offset(1.0, 3.0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              height: 95,
              width: 90,
              image: AssetImage(widget.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
            width: 10,
          ),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: widget.name + "\n",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        )),
                    TextSpan(
                        text: "${widget.price} руб \n\n",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
              Container(
                // width: 00,
                padding: EdgeInsets.only(left: 180, top: 35),
                alignment: Alignment.topRight,
                // margin: EdgeInsets.only(top: 10, right: 20),
                child: IconButton(
                    onPressed: () async {
                      print("clicked");
                      // _btnController.stop();
                    },
                    icon: RoundedLoadingButton(
                      animateOnTap: false,
                      borderRadius: 4,
                      loaderSize: 20,
                      height: 30,
                      width: 30,
                      color: Colors.white,
                      successColor: Color(4278249078),
                      child: Icon(
                        CupertinoIcons.add,
                        size: 16,
                        color: Colors.grey,
                      ),
                      controller: _btnController,
                      onPressed: _doSomething,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<SearchCard> searchItems = [
  SearchCard(
    id: "1",
    imageUrl: 'lib/assets/m1.jpg',
    price: 370,
    quantity: 1,
    name: "LP-367 BALTIMORE 400 ML",
  ),
  SearchCard(
    id: "2",
    imageUrl: 'lib/assets/m2.jpg',
    price: 370,
    quantity: 1,
    name: "LP-367 BALTIMORE 400 ML",
  ),
  SearchCard(
    id: "3",
    imageUrl: 'lib/assets/m3.jpg',
    price: 370,
    quantity: 5,
    name: "LP-367 BALTIMORE 400 ML",
  ),
];
