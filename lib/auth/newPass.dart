import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/main.dart';
import 'package:graffitineeds/services/authentification.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class NewPassPage extends StatefulWidget {
  NewPassPage({Key? key}) : super(key: key);
  @override
  _NewPassPageState createState() => new _NewPassPageState();
}

class _NewPassPageState extends State<NewPassPage> {
  TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _email;
  void _displayWarningMotionToast(String text) {
    MotionToast.warning(
      title: Text(
        'Внимание',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(text),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.bottom,
      dismissable: true,
      toastDuration: Duration(seconds: 5),
    ).show(context);
  }

  void _displaySuccessfulMoationToast(String text) {
    MotionToast.success(
      title: Text("Успешно"),
      description: Text(text),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.bottom,
      dismissable: true,
    ).show(context);
  }

  void _displayErrorMotionToast(String text) {
    MotionToast.error(
      title: Text(
        'Ошибка',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(text),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.bottom,
      width: 300,
      dismissable: true,
    ).show(context);
  }

  Future _resetPassword() async {
    _email = _emailController.text;

    if (_email!.isEmpty)
      return;
    else {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email!);
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final email = Container(
        // padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: borderColor),
            bottom: BorderSide(color: borderColor),
            left: BorderSide(color: borderColor),
            right: BorderSide(color: borderColor),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: TextFormField(
          cursorColor: mainColor,
          style: TextStyle(fontFamily: mainFontFamily),
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          autocorrect: false,
          controller: _emailController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
            hintText: 'Почта',
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: mainColor)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ));

    final passResetBtn = GestureDetector(
      onTap: () async {
        _resetPassword().then(
            (value) => _displaySuccessfulMoationToast(
                "Перейдите на почту, чтобы сбросить пароль"),
            onError: (Object e, StackTrace stackTrace) {
          print(e.toString());
          _displayErrorMotionToast("Пользователя с такой почтой еще пока нет");
        });
      },
      child: Container(
          width: double.infinity,
          height: 40,
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
          child: Center(
              child: Text('СБРОСИТЬ ПАРОЛЬ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: mainFontFamily,
                      fontWeight: FontWeight.bold)))),
    );

    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  color: Colors.transparent,
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.close,
                    size: 28.0,
                    color: mainColor,
                  ))),
        ),
        body: Center(
            child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView(children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Введите почту",
                    style: TextStyle(
                        fontFamily: mainFontFamily,
                        color: Colors.grey[900],
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                email,
                SizedBox(
                  height: 10,
                ),
                passResetBtn
              ]))
            ],
          ),
        )));
  }
}
