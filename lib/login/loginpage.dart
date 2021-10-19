import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:graffitineeds/main.dart';
import 'package:requests/requests.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => new _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email;
  String _password;
  bool showLogin = true;
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 88.0,
        child: Image.asset('lib/assets/gn_logo.png'),
      ),
    );
    final image = Image.asset(
      'lib/assets/gn_logo.png',
      //width: 250,
      height: 200,
    );
    final imo = Image.network(
        "https://api.sbis.ru/retail/point/list?/img?params=eyJPYmplY3RUeXBlIjogInBvaW50IiwgIk9iamVjdElkIjogMTQwLCAiUGhvdG9VUkwiOiAiaHR0cDovL3N0b3JhZ2Uuc2Jpcy5ydS9hcGkvdjEvcmV0YWlsX2ZpbGVzLzJiZmQ1ZWEzLThkODgtNGE5MC05ZDkxLTQ0ODA1NDZlODIzMT9obWFjPTBlMDI1YzU2ZmVkOWE0YmY4ZDI2N2VmZWM3OTAwMWJmYzY5NDU0MTUmbW9kZT13cml0ZSIsICJQaG90b0lkIjogbnVsbCwgIlNpemUiOiBudWxsLCAiQWRkaXRpb25hbFBhcmFtcyI6IG51bGx9");

    final email = Container(
        //padding: EdgeInsets.only(top: ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.8,
              blurRadius: 0.1,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          autocorrect: false,
          cursorColor: mainColor,
          controller: _emailController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person_outlined,
              color: Colors.grey,
            ),
            hintText: 'Почта',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.0),
                borderSide: BorderSide(color: Colors.transparent)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.0),
                borderSide: BorderSide(color: Colors.red)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ));

    final password = Container(
        padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.8,
              blurRadius: 0.1,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: TextFormField(
          cursorColor: mainColor,
          obscureText: true,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          autocorrect: false,
          controller: _passwordController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.grey,
            ),
            hintText: 'Пароль',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.0),
                borderSide: BorderSide(color: Colors.transparent)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.0),
                borderSide: BorderSide(color: Colors.red)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ));

    final firstbtn = GestureDetector(
        onTap: () {
          print("object");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DefaultTabBar()));
        },
        child: Container(
          //width: 50,
          //height: 70,

          // margin: EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
          //height: double.infinity,
          // width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.8,
                blurRadius: 0.1,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
              child: Text('Войти',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold))),
        ));
    final secondbtn = GestureDetector(
        onTap: () {
          _auth();
          _request();
          print("request");
        },
        child: Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0.8,
                  blurRadius: 0.1,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
                child: Text('Зарегистрироваться',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)))));

    final forgotLabel = FlatButton(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        'Забыли пароль?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Theme(
        data: ThemeData(
          // elevatedButtonTheme: ElevatedButtonThemeData(style: ),
          bottomAppBarColor: Colors.lightBlue,
          backgroundColor: Colors.lightBlue,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: ListView(
              //  shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                image,
                SizedBox(height: 15.0),
                email,
                SizedBox(height: 15.0),
                password,
                SizedBox(height: 54.0),
                firstbtn,
                secondbtn,
                forgotLabel
              ],
            ),
          ),
        ));
  }

  _request() async {
    var parameters = {
      'pointId': '157',
      'priceListId': '107',
      'withBalance': 'true',
      'page': '20',
      'pageSize': '10'
    };
    var url = 'https://api.sbis.ru/retail/nomenclature/list?';
    var headers = {
      "X-SBISAccessToken":
          "uxPSTLFSYINMofPyApK6pJaA8USknERsTMWLdrsaD16xBj3gfANaqxUb67flWHKmBPmSLZnEuPfa0taDuTSdw05GDcDmqUGkfiRsvwKToKvdnONheJS6jH"
    };

    var response =
        await Requests.get(url, queryParameters: parameters, headers: headers);
    print(response.statusCode);
    print(response.success);
    // print(response.contentType);
    print(response.content());
    print(response.json());
  }

  _auth() async {
    var json = {
      "app_client_id": "5890423132023623",
      "app_secret": "JHDGKJU5LMXRPLXZP6S6C5MV",
      "secret_key":
          "uxPSTLFSYINMofPyApK6pJaA8USknERsTMWLdrsaD16xBj3gfANaqxUb67flWHKmBPmSLZnEuPfa0taDuTSdw05GDcDmqUGkfiRsvwKToKvdnONheJS6jH"
    };
    var url = 'https://online.sbis.ru/oauth/service/';
    var response = await Requests.post(url, json: json);
    print(response.json());
  }
}

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => new _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => new _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class PassRecovery extends StatefulWidget {
  @override
  _PassRecoveryState createState() => new _PassRecoveryState();
}

class _PassRecoveryState extends State<PassRecovery> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
