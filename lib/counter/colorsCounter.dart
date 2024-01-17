import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ColorsProduct extends StatefulWidget {
  final Function(int)? onSelected;
  final Function(int)? onSelected1;
  final Function(int)? onSelected2;
  int? quantity;
  int? count;
  int? price;
  int? kolvo;
  int? minkolvo;
  String? color;

  ColorsProduct(
      {this.onSelected,
      this.count,
      this.price,
      this.kolvo,
      this.onSelected1,
      this.onSelected2,
      this.quantity,
      this.minkolvo,
      this.color});

  @override
  _ColorsProductState createState() => _ColorsProductState();
}

class _ColorsProductState extends State<ColorsProduct>
    with AutomaticKeepAliveClientMixin<ColorsProduct> {
  late int st;
  @override
  void initState() {
    super.initState();
    st = widget.count!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int _selected = widget.count!;

    return Row(
      children: <Widget>[
        /////MINUS///////
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(40, 25),
              minimumSize: Size(5, 5),
              padding: EdgeInsets.all(1),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(4.0),
              ),
              primary: Colors.white,
              // disabledBackgroundColor: Colors.white,
            ),
            onPressed: () {
              if (widget.count! >= 1) {
                setState(() {
                  _selected -= 1;

                  widget.count = _selected;
                  widget.kolvo = _selected;

                  //  print(widget.kolvo);
                  //  print(start);
                  // summa = widget.price / _selected;
                });
                widget.onSelected1!(_selected);
              }
            },
            child: Text("—",
                // textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.black))),
        SizedBox(
          width: 15,
        ),
        Center(
            child: Text(widget.count.toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: widget.color == null
                        ? Colors.black
                        : Color(int.parse(widget.color!)).computeLuminance() >
                                0.5
                            ? Colors.black
                            : Colors.white))),
        /*SizedBox(
                    width: MediaQuery.of(context).size.height / 10,
                    height: MediaQuery.of(context).size.height / 20,
                    child: OutlineButton(
                        disabledBorderColor: Colors.black,
                        onPressed: null,
                        child: Text("${widget.count}",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 40,
                                color: Colors.black)))),*/
        SizedBox(
          width: 15,
        ),

        /////PLUS//////
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(45, 25),
              padding: EdgeInsets.all(1),
              minimumSize: Size(5, 5),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(4.0),
              ),
              primary: Colors.white,
              // disabledBackgroundColor: Colors.white,
            ),
            onPressed: () {
              if (widget.quantity! > widget.count!) {
                setState(() {
                  // if(_selected <= widget.optKolvo[2])

                  _selected += 1;

                  widget.count = _selected;
                  widget.kolvo = _selected;
                  // summa = _price * kolvo;
                  // print(_selected);
                });
                widget.onSelected1!(_selected);
              }
            },
            child:
                Text("+", style: TextStyle(fontSize: 20, color: Colors.black))),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _sumCount(int _selected, int _price) {
    _price = widget.price!;

    List k = [];

    for (int i = 0; i < k.length; i++) {
      if (_selected >= k[i]) {
        print("Kol ${k[i]}");
        setState(() {
          widget.onSelected2!(_price);
        });
      }
    }
    /* if (_selected >= k.first) {
        print("Kol ${k.first}");
        setState(() {
          _price = v.first;
          widget.onSelected2(_price);
        });
        print(_price);
      }
    k.forEach((k1) {
      v.forEach((v1) {
        if (_selected >= k1) {
          print("Kol $k1");
          setState(() {
            _price = v1;
            widget.onSelected2(_price);
          });
          // _price = value;
          print(_price);
        }

////////////////////////////////////////////////////

        /* if (_selected < k[1]) {
          setState(() {
            _price = widget.price;
            widget.onSelected2(_price);
          });
          print("start");
          print(_price);
        }*/
      });
    });
*/
    return Padding(
        padding: EdgeInsets.only(top: 1),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          /* Text(
            "$_price₽/шт.",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 45,
                color: Colors.black,
                fontWeight: FontWeight.w200),
          ),*/
          SizedBox(
            width: 10,
          ),
          Text(
            "${_price * _selected}₽",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),
        ]));
  }
  /*else
        return Padding(
          padding: EdgeInsets.only(top: 1),
          child: Text(
            "${widget.price * _selected}₽",
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        );*/

  Widget _createIncrementDicrementButton(IconData icon, Function onPressed) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: BoxConstraints(minWidth: 32.0, minHeight: 32.0),
      onPressed: onPressed.call(),
      elevation: 2.0,
      fillColor: Colors.black12,
      child: Icon(
        icon,
        color: Colors.black,
        size: 12.0,
      ),
      shape: CircleBorder(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
