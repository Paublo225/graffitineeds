import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/services/api_UserAgreement.dart';
import 'package:graffitineeds/services/api_userSbis.dart';
import 'package:graffitineeds/services/authentification.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailControllerZ = TextEditingController();
  TextEditingController _nameControllerZ = TextEditingController();
  TextEditingController _lastNameControllerZ = TextEditingController();
  TextEditingController _firstPassControllerZ = TextEditingController();
  TextEditingController _secondPassControllerZ = TextEditingController();
  TextEditingController _phoneNumberControllerZ = TextEditingController();
  final AuthService _authService = AuthService();

  User? user = FirebaseAuth.instance.currentUser;
  final String collectionPath = "тех_работы";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String initialCountry = 'RU';
  PhoneNumber number = PhoneNumber(isoCode: 'RU');
  String mainPhoneNumber = "";
  Future<bool> checkIfVerifificetionIsNeeded() async {
    bool isVerNeeded = false;
    isVerNeeded = await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(collectionPath)
        .get()
        .then((value) => value.data()!["верификация"]);
    debugPrint(isVerNeeded.toString());
    return isVerNeeded;
  }

  Future sendVerification(String externalId, int userId) async {
    user = await _authService.registerWithEmailAndPassword(
        _emailControllerZ.text.trim(), _firstPassControllerZ.text.trim());
    user!.updateDisplayName(_nameControllerZ.text);

    print(user!.email);

    if (!await checkIfVerifificetionIsNeeded()) {
      debugPrint(' Успешная Регистрация ');
    } else {
      if (user != null && !user!.emailVerified) {
        await user!.sendEmailVerification();

        final CollectionReference _usersRef =
            FirebaseFirestore.instance.collection("пользователи");
        await _usersRef.doc(user!.uid).set({
          "id": userId,
          "Name": _nameControllerZ.text,
          "Surname": _lastNameControllerZ.text,
          "ExternalId": externalId,
          "Телефон": mainPhoneNumber,
          "Электронная почта": _emailControllerZ.text,
        });

        _authService.logOut();
        print(' Верификация ');

        // _displayWarningMotionToast("Подтвердите свою почту");
      }
    }
  }

  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<bool> fetchUsersEmails() async {
    List<String> emailList = [];
    await _fAuth
        .fetchSignInMethodsForEmail(_emailControllerZ.text)
        .then((value) => setState(() {
              emailList = value;
            }));
    if (emailList.isEmpty)
      return true;
    else
      return false;
  }

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
      //  toastDuration: Duration(seconds: 5),
      dismissable: true,
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

  bool validationNumber = false;
  int? sbisUserId;
  Future _sbisUserCredentials(String uuid) async {
    var input_params = {
      "UUID": uuid,
      "Name": _nameControllerZ.text,
      "Surname": _lastNameControllerZ.text,
      "Электронная почта": _emailControllerZ.text,
      'Мобильный телофон': mainPhoneNumber
    };
    await SbisUser.login().then((value) {
      SbisUser.create_customer(value["result"], input_params).then((value2) {
        setState(() {
          sbisUserId = value2["result"];
        });
      });
    }).whenComplete(() => sbisUserId);
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
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

  _registerNewUser() async {
    bool? _phoneCheck;
    await FirebaseFirestore.instance
        .collection("пользователи")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty)
        for (var element in value.docs) {
          if (element.get("Телефон") == mainPhoneNumber) {
            setState(() {
              _phoneCheck = true;
            });
            break;
          } else {
            setState(() {
              _phoneCheck = false;
            });
          }
        }
      ;
      return _phoneCheck;
    });
    print(_phoneCheck.toString() + " lll");
    if (!_phoneCheck!) {
      if (await fetchUsersEmails()) {
        if (!validationNumber)
          _displayErrorMotionToast("Телефон набран неправильно");
        else if (_firstPassControllerZ.text.length < 6) {
          _displayErrorMotionToast(
              "Пароль должен содержать не менее 6 символов");

          _firstPassControllerZ.clear();
          _secondPassControllerZ.clear();
        } else {
          if (_firstPassControllerZ.text != _secondPassControllerZ.text) {
            _displayErrorMotionToast("Пароли не совпадают");

            _firstPassControllerZ.clear();
            _secondPassControllerZ.clear();
          } else {
            String externalId = Uuid().v1();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                    ),
                  );
                });

            //  await _sbisUserCredentials(externalId);

            var input_params = {
              "UUID": externalId,
              "Name": _nameControllerZ.text,
              "Surname": _lastNameControllerZ.text,
              "Электронная почта": _emailControllerZ.text,
              'Мобильный телофон': mainPhoneNumber
            };

            await SbisUser.login().then((value) {
              SbisUser.create_customer(value["result"], input_params)
                  .then((value2) async {
                await sendVerification(externalId, value2["result"])
                    .whenComplete(() async {
                  await Timer(Duration(seconds: 2), () {
                    Navigator.of(context, rootNavigator: true).pop();

                    Navigator.pop(context);
                    // Navigator.of(context, rootNavigator: true).pop();
                    //_displaySuccessfulMoationToast("Регистрация прошла успешно!");
                    _displayWarningMotionToast("Подтвердите свою почту");
                  });
                });
              });
            }).whenComplete(() => print("sukses"));
          }
        }
      } else {
        _displayErrorMotionToast("Пользователь уже зарегистрирован");
      }
    } else {
      _displayErrorMotionToast(
          "Пользователь с таким номером уже зарегистрирован");
    }
  }

  bool checkedBox = false;
  Widget checkBox() {
    return Padding(
        padding: EdgeInsets.only(top: 30, right: 5),
        child: Row(
          children: [
            Checkbox(
              value: checkedBox,
              onChanged: (value) {
                setState(() {
                  checkedBox = value!;
                });
              },
              splashRadius: 0,
              activeColor: mainColor,
            ),
            Expanded(
                child: GestureDetector(
                    onTap: () async {
                      String? url;
                      await SbisUserDocs.getLink().then((value) => url = value);
                      if (await canLaunchUrl(Uri.parse(url!))) {
                        await launchUrl(Uri.parse(url!));
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: RichText(
                        text: TextSpan(
                      spellOut: true,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Отправляя данную форму вы соглашаетесь с ",
                        ),
                        TextSpan(
                          text: "Политикой конфиденциальности",
                          style: TextStyle(
                              color: mainColor,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    )))),
          ],
        ));
  }

  Widget inputBox(String title, Icon icon,
      TextEditingController texEditingController, TextInputType textInputType,
      {bool? secure}) {
    return Container(
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
          onChanged: (value) => setState(() {}),
          cursorColor: mainColor,
          obscureText: secure != null ? secure : false,
          keyboardType: textInputType,
          autofocus: false,
          autocorrect: false,
          controller: texEditingController,
          inputFormatters: [
            if (textInputType == TextInputType.phone)
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
          ],
          decoration: InputDecoration(
            prefixIcon: icon,
            hintText: title,
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: mainColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ));
  }

  Widget titleAbove(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      // margin: EdgeInsets.only(bottom: ),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.grey[900], fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = Form(
      key: formKey,
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InternationalPhoneNumberInput(
              cursorColor: mainColor,
              inputDecoration: InputDecoration(
                //  prefixIcon: icon,
                //  hintText: title,

                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 3.0, 10.0),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: mainColor)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
              ),
              onInputChanged: (PhoneNumber number) {
                mainPhoneNumber = number.phoneNumber!;
                print(mainPhoneNumber);
              },
              onInputValidated: (bool value) {
                validationNumber = value;
              },
              selectorConfig:
                  SelectorConfig(showFlags: false, trailingSpace: false
                      //selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
              ignoreBlank: false,
              countries: ['RU'],
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                if (!validationNumber) {
                  return 'Пожалуйста, введите номер';
                } else
                  return null;
              },
              selectorTextStyle: TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: _phoneNumberControllerZ,
              formatInput: true,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
          ],
        ),
      ),
    );
    Widget registerButton = GestureDetector(
      onTap: () async {
        if (_emailControllerZ.text != "" &&
            _nameControllerZ.text != "" &&
            _lastNameControllerZ.text != "" &&
            _firstPassControllerZ.text != "" &&
            _phoneNumberControllerZ.text != "" &&
            _secondPassControllerZ.text != "" &&
            checkedBox == true) _registerNewUser();
      },
      child: Container(
          width: double.infinity,
          height: 40,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: _emailControllerZ.text != "" &&
                    _nameControllerZ.text != "" &&
                    _lastNameControllerZ.text != "" &&
                    _firstPassControllerZ.text != "" &&
                    _phoneNumberControllerZ.text != "" &&
                    _secondPassControllerZ.text != "" &&
                    checkedBox == true
                ? mainColor
                : Colors.white,
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
              child: Text('ЗАРЕГИСТРИРОВАТЬСЯ',
                  style: TextStyle(
                    color: _emailControllerZ.text != "" &&
                            _nameControllerZ.text != "" &&
                            _firstPassControllerZ.text != "" &&
                            _phoneNumberControllerZ.text != "" &&
                            _secondPassControllerZ.text != "" &&
                            checkedBox == true
                        ? Colors.white
                        : Colors.black54,
                    fontFamily: "Circe",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )))),
    );

    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                    color: Colors.transparent,
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.arrow_back,
                      size: 28.0,
                      color: Colors.black,
                    )))),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: Text(
                            "Регистрация",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 26),
                          )),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                        ),
                        child: Column(
                          children: [
                            titleAbove("Как вас зовут?"),
                            Flexible(
                                flex: 0,
                                child: Row(children: [
                                  Flexible(
                                      child: inputBox(
                                          "Имя",
                                          Icon(
                                            CupertinoIcons.person,
                                            size: 28.0,
                                            color: Colors.black45,
                                          ),
                                          _nameControllerZ,
                                          TextInputType.name)),
                                  Flexible(
                                      child: inputBox(
                                          "Фамилия",
                                          Icon(
                                            CupertinoIcons.person,
                                            size: 28.0,
                                            color: Colors.black45,
                                          ),
                                          _lastNameControllerZ,
                                          TextInputType.name)),
                                ])),
                            SizedBox(
                              height: 15,
                            ),
                            titleAbove("Ваша почта"),
                            inputBox(
                                "Почта",
                                Icon(
                                  CupertinoIcons.mail,
                                  size: 28.0,
                                  color: Colors.black45,
                                ),
                                _emailControllerZ,
                                TextInputType.emailAddress),
                            titleAbove("Номер телефона"),
                            phoneNumber,
                            SizedBox(
                              height: 15,
                            ),
                            titleAbove("Введите пароль"),
                            inputBox(
                                "Пароль",
                                Icon(
                                  Icons.lock_outline,
                                  size: 28.0,
                                  color: Colors.black45,
                                ),
                                _firstPassControllerZ,
                                TextInputType.visiblePassword,
                                secure: true),
                            SizedBox(
                              height: 15,
                            ),
                            inputBox(
                                "Повторите пароль",
                                Icon(
                                  Icons.lock,
                                  size: 28.0,
                                  color: Colors.black45,
                                ),
                                _secondPassControllerZ,
                                TextInputType.visiblePassword,
                                secure: true),
                            SizedBox(
                              height: 20,
                            ),
                            registerButton,
                            checkBox()
                          ],
                        ),
                      ),
                    ])))));
  }
}
