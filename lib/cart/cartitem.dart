import 'package:flutter/material.dart';
import 'package:graffitineeds/cart/counterCard.dart';

import 'package:graffitineeds/main.dart';
import 'package:graffitineeds/models/itemModel.dart';
import 'package:graffitineeds/product/count.dart';

// ignore: must_be_immutable
class CartItem extends StatefulWidget with ChangeNotifier {
  String id;
  String name;
  String image;
  String productId;
  String imageUrl;
  int price;
  int quantity;
  int summary;

  CartItem(
      {Key key,
      this.id,
      this.name,
      this.image,
      this.imageUrl,
      this.price,
      this.productId,
      this.quantity,
      this.summary});

  CartItemState createState() => new CartItemState();
}

class CartItemState extends State<CartItem> with ChangeNotifier {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyListeners();
  }

  @override
  void dispose() {
    notifyListeners();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return /* Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        notifyListeners();
        print("ff");
        // cartItems.remove(cartItems[0]);
        // dispose();
      },
      child:*/
        Container(
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
                  padding: EdgeInsets.only(top: 50),
                  alignment: Alignment.bottomRight,
                  // margin: EdgeInsets.only(top: 10, right: 20),
                  child: CounterCart(
                    count: widget.quantity,
                    price: 0,
                    kolvo: 1,
                    quantity: 90,
                  )),
              IconButton(
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width - 170, top: 33),
                  alignment: Alignment.bottomRight,
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: () async {})
            ],
          ),
        ],
      ),
    );
  }
}

List<CartItem> cartItems = [
  CartItem(
    id: "1",
    imageUrl: 'lib/assets/m1.jpg',
    price: 370,
    quantity: 1,
    name: "LP-367 BALTIMORE 400 ML",
  ),
  CartItem(
    id: "2",
    imageUrl: 'lib/assets/m2.jpg',
    price: 370,
    quantity: 1,
    name: "LP-367 BALTIMORE 400 ML",
  ),
  CartItem(
    id: "3",
    imageUrl: 'lib/assets/m3.jpg',
    price: 370,
    quantity: 5,
    name: "LP-367 BALTIMORE 400 ML",
  ),
];
