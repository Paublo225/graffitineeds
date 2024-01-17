import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CountWidget extends StatefulWidget {
  final Function(int)? onSelected;
  final Function(int)? onSelected1;
  final Function(int)? onSelected2;

  int? quantity;
  int? count;
  int? price;
  int? kolvo;
  int? minkolvo;

  CountWidget({
    this.onSelected,
    this.count,
    this.price,
    this.kolvo,
    this.onSelected1,
    this.onSelected2,
    this.quantity,
    this.minkolvo,
  });

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget>
    with AutomaticKeepAliveClientMixin<CountWidget> {
  late int st;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    st = widget.count!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int _selected = widget.count!;
    int? _price = widget.price;
    int start = st;
    return Row(
      children: <Widget>[
        /////MINUS///////
        SizedBox(
            width: 20,
            height: MediaQuery.of(context).size.height / 20,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(4.0),
                  ),
                  primary: Colors.white,
                  //   disabledBackgroundColor: Colors.white,
                ),
                onPressed: () {
                  if (widget.count! >= start) {
                    setState(() {
                      _selected -= start;

                      widget.count = _selected;
                      widget.kolvo = _selected;
                      // widget.price = _price;
                      print("EYO $_price");
                      // print(_selected);
                      //  print(widget.kolvo);
                      //  print(start);
                      // summa = widget.price / _selected;
                    });
                    widget.onSelected1!(_selected);
                  }
                },
                child: Text("-",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey)))),
        SizedBox(
          width: 15,
        ),
        Center(
            child: Text(widget.count.toString(),
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 40,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey))),
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
        SizedBox(
            width: MediaQuery.of(context).size.height / 20,
            height: MediaQuery.of(context).size.height / 20,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(4.0),
                  ),
                  primary: Colors.white,
                  // disabledBackgroundColor: Colors.white,
                ),
                onPressed: () {
                  if (widget.quantity! - start >= _selected) {
                    setState(() {
                      // if(_selected <= widget.optKolvo[2])

                      _selected = _selected + start;
                      print("EYO $_price");
                      widget.count = _selected;
                      widget.kolvo = _selected;
                      // summa = _price * kolvo;
                      // print(_selected);
                      widget.onSelected!(widget.count!);
                    });
                  }
                },
                child: Text("+",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey)))),
        SizedBox(
          width: 20,
        ),

        _sumCount(_selected, _price!)
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

  Widget _createIncrementDicrementButton(IconData icon, Function? onPressed) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: BoxConstraints(minWidth: 32.0, minHeight: 32.0),
      onPressed: onPressed!.call(),
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
