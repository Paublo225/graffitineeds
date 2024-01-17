import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graffitineeds/auth/newPass.dart';
import 'package:graffitineeds/auth/registerPage.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/services/authentification.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);
  @override
  _AuthPageState createState() => new _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  final FirebaseAuth _fSAuth = FirebaseAuth.instance;
  final TextStyle authTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: "Circe");
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
      user = await _authService.signInWithEmailAndPassword(
          _email.trim(), _password.trim());
      //   _emailController.clear();

      Navigator.of(context).pop();

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

    final loginButton = GestureDetector(
        onTap: () {
          _signInButtonAction();
        },
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black,
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
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(child: Text('ВОЙТИ', style: authTextStyle)),
        ));
    final secondbtn = GestureDetector(
        onTap: () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (builder) => RegisterPage()));
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
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
                child: Text('ЗAРЕГИСТРИРОВАТЬСЯ', style: authTextStyle))));

    final forgotLabel = TextButton(
      child: Text(
        'Забыли пароль?',
        style: TextStyle(color: Colors.black54, fontSize: 14),
      ),
      onPressed: () {
        showModalBottomSheet(
            context: context, builder: (builder) => NewPassPage());
      },
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark, // play with this
        child: new Scaffold(
            resizeToAvoidBottomInset: false,
            // key: _scaffoldKey,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniStartTop,
            floatingActionButton: NeumorphicButton(
                margin: EdgeInsets.only(top: 10),
                onPressed: () => Navigator.of(context).pop(),
                style: NeumorphicStyle(
                  depth: 4,
                  color: Colors.white54,
                  shape: NeumorphicShape.concave,
                  boxShape: NeumorphicBoxShape.circle(),
                ),
                child: NeumorphicIcon(
                  Icons.close,
                  style: NeumorphicStyle(
                    color: Colors.black,
                    depth: 10,
                  ),
                )),
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 130,
                  left: 24.0,
                  right: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    logo,
                    SizedBox(height: 5.0),
                    email,
                    SizedBox(height: 15.0),
                    password,
                    SizedBox(height: 34.0),
                    loginButton,
                    secondbtn,
                    forgotLabel,

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
            )));
  }
}
