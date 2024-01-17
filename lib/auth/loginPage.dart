import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:graffitineeds/auth/authentication.dart';

import 'package:graffitineeds/auth/newPass.dart';
import 'package:graffitineeds/auth/registerPage.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/services/api_UserAgreement.dart';
import 'package:graffitineeds/services/authentification.dart';
import 'package:graffitineeds/user/contactPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final FirebaseAuth _fSAuth = FirebaseAuth.instance;
  final TextStyle authTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: "Circe",
      color: Colors.white);
  final TextStyle authButtonTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      //fontWeight: FontWeight.w600,
      fontFamily: "Circe");

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Color borderColor = Colors.grey[200]!;
  late String _email;
  late String _password;
  bool showLogin = true;
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
      description: Text(text),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.bottom,
      width: 300,
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

  _signInButtonAction() async {
    _email = _emailController.text;
    _password = _passwordController.text;
    AlertDialog alert = AlertDialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        content: Center(
            child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink[100]!),
        )));
    User? user = await _authService.signInWithEmailAndPassword(
        _email.trim(), _password.trim());
    if (_email.isEmpty || _password.isEmpty) return;

    if (user == null)
      _displayErrorMotionToast("Проверьте вашу почту или пароль");
    else if (!user.emailVerified) {
      await user
          .sendEmailVerification()
          .onError((error, stackTrace) => print(error));
      _displayWarningMotionToast("Для входа подтвердите вашу почту.");
    } else {
      _displaySuccessfulMoationToast("Вход выполнен");
      user = await _authService.signInWithEmailAndPassword(
          _email.trim(), _password.trim());
      //   _emailController.clear();
      //   _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: Image.asset(
        'lib/assets/GN_white.png',
        height: 150,
      ),
    );

    final email = Container(
        //padding: EdgeInsets.only(top: ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: borderColor),
            bottom: BorderSide(color: borderColor),
            left: BorderSide(color: borderColor),
            right: BorderSide(color: borderColor),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          autocorrect: false,
          cursorColor: mainColor,
          controller: _emailController,
          style: authButtonTextStyle,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person_outlined,
              color: Colors.grey,
            ),
            hintText: 'Почта',
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: mainColor)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ));

    final password = Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: borderColor),
            bottom: BorderSide(color: borderColor),
            left: BorderSide(color: borderColor),
            right: BorderSide(color: borderColor),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: TextFormField(
          style: authButtonTextStyle,
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
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: mainColor)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ));

    /*showAlertDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          content: Center(
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink[100]!),
          )));

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
          });
          return alert;
        },
      );
    }*/
    Widget signInMethods(String providerName, String image) {
      return GestureDetector(
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black)),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: Center(
              child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset("lib/assets/" + image),
              SizedBox(
                width: 12,
              ),
              Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    providerName,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: "Circe",
                        fontWeight: FontWeight.bold),
                  ))
            ],
          )),
        ),
      );
    }

    final userAgreement = new GestureDetector(
        onTap: () async {
          openUserAgreement();
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 43,
            margin: EdgeInsets.only(top: 35),
            decoration: BoxDecoration(
              color: ThemaMode.isDarkMode ? darkBackColor : Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                  bottomLeft: Radius.circular(13),
                  bottomRight: Radius.circular(13)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
                child: Row(children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                CupertinoIcons.person_3,
                size: 26,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Пользовательское соглашение',
                  style: TextStyle(
                    fontSize: 14,
                  ))
            ]))));

    final contactPage = new GestureDetector(
        onTap: () async {
          showCupertinoModalBottomSheet(
              context: context,
              builder: (builder) {
                return ContactPage();
              });
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 43,
            margin: EdgeInsets.only(top: 35),
            decoration: BoxDecoration(
              color: ThemaMode.isDarkMode ? darkBackColor : Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                  bottomLeft: Radius.circular(13),
                  bottomRight: Radius.circular(13)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
                child: Row(children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                CupertinoIcons.phone,
                size: 26,
              ),
              SizedBox(
                width: 10,
              ),
              Text('Контакты',
                  style: TextStyle(
                    fontSize: 14,
                  ))
            ]))));
    final loginButton = GestureDetector(
        onTap: () {
          showCupertinoModalPopup(
              context: context, builder: (builder) => AuthPage());
          //  _signInButtonAction();
        },
        child: Container(
          width: double.infinity,
          height: 40,

          // margin: EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
          //height: double.infinity,
          // width: double.infinity,
          decoration: BoxDecoration(
            color: ThemaMode.isDarkMode ? darkBackColor : Colors.black,
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
          //  padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(child: Text('ВОЙТИ', style: authTextStyle)),
        ));
    final secondbtn = GestureDetector(
        onTap: () {
          showCupertinoModalPopup(
              context: context, builder: (builder) => RegisterPage());
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
            //   padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
                child: Text('ЗAРЕГИСТРИРОВАТЬСЯ', style: authTextStyle))));

    final forgotLabel = TextButton(
      child: Text(
        'Забыли пароль?',
        style: TextStyle(color: Colors.black54, fontSize: 14),
      ),
      onPressed: () {
        showCupertinoModalBottomSheet(
            context: context, builder: (builder) => NewPassPage());
      },
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: ThemaMode.isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark, // play with this
        child: new Scaffold(
            resizeToAvoidBottomInset: false,
            // key: _scaffoldKey,

            body: SafeArea(
                child: SingleChildScrollView(
                    child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 130,
                  left: 24.0,
                  top: 40,
                  right: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    logo,
                    Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 15),
                        child: Center(
                          child: Text(
                            "Войдите или создайте аккаунт, чтобы сделать заказ:)",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                    loginButton,
                    secondbtn,
                    contactPage,
                    userAgreement
                    /*  Center(
                    child: Text(
                  "ИЛИ ВОЙДИ С ПОМОЩЬЮ...",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Circe",
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                )),
                Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          signInMethods("GOOGLE", "google.png"),
                          SizedBox(width: 10),
                          signInMethods("APPLE", "apple.png")
                        ]))*/
                  ],
                ),
              ),
            )))));
  }

  openUserAgreement() async {
    String? url;
    await SbisUserDocs.getLink().then((value) => url = value);
    if (await canLaunchUrl(Uri.parse(url!))) {
      await launchUrl(Uri.parse(url!));
    } else {
      throw 'Could not launch $url';
    }
  }
}
