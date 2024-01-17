/*import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graffitineeds/auth/authentication.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/main.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pinput.dart';

class PhoneRegistration extends StatefulWidget {
  PhoneRegistration();
  @override
  _PhoneRegistrationState createState() => new _PhoneRegistrationState();
}

class _PhoneRegistrationState extends State<PhoneRegistration> {
  String textData =
      "Зарегистрируйтесь, чтобы пользоваться приложением\nНа ваш номер придет код с подтверждением";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool validationNumber = false;
  String phoneNumber = "";
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'RU';
  PhoneNumber number = PhoneNumber(isoCode: 'RU');
  Future<bool?> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: '+17209162278',
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          UserCredential result = await _auth.signInWithCredential(credential);

          User? user = result.user;

          if (user != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CodePage(
                          phone: '+17209162278',
                        )));
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CodePage(
                        phone: '+17209162278',
                      )));
          /*   showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        final code = "123456";
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: code);

                        UserCredential result =
                            await _auth.signInWithCredential(credential);

                        User? user = result.user;

                        if (user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthPage()));
                        } else {
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              });*/
        },
        codeAutoRetrievalTimeout: (ff) {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
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
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: SizedBox(),
      ),
      body: Column(children: [
        Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 150),
            child: Text(
              textData,
              textAlign: TextAlign.center,
              //  style: authStyle,
            )),
        Container(
          margin: EdgeInsets.only(bottom: 50, top: 30, left: 30, right: 30),
          child: InternationalPhoneNumberInput(
            inputDecoration: InputDecoration(
              //  prefixIcon: icon,
              //  hintText: title,
              contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: mainColor)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
            ),
            onInputChanged: (PhoneNumber number) {
              phoneNumber = number.phoneNumber!;
              print(phoneNumber);
            },
            onInputValidated: (bool value) {
              validationNumber = value;
              print(validationNumber);
            },
            selectorConfig: SelectorConfig(
                //selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                leadingPadding: 20),
            ignoreBlank: false,
            maxLength: 15,
            countries: ['RU', 'KZ', 'AM', 'UA', 'BY'],
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (!validationNumber) {
                return 'Пожалуйста, введите номер';
              } else
                return null;
            },
            selectorTextStyle: TextStyle(color: Colors.black),
            initialValue: number,
            textFieldController: controller,
            formatInput: true,
            keyboardType: TextInputType.phone,
            inputBorder: OutlineInputBorder(),
            onSaved: (PhoneNumber number) {
              print('On Saved: $number');
            },
          ),
        ),
        GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CodePage(phone: phoneNumber)));
            },
            child: Container(
              margin: EdgeInsets.only(left: 44, right: 44),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Center(
                  child: Text(
                "Получить код",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: mainFontFamily,
                    fontWeight: FontWeight.w500),
              )),
            ))
      ]),
    );
  }
}

class CodePage extends StatefulWidget {
  String phone;
  CodePage({required this.phone});
  @override
  _CodePageState createState() => new _CodePageState();
}

class _CodePageState extends State<CodePage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String? _verificationCode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    String textData =
        "Мы отправили СМС с 4-х значным кодом на ваш номер:\n${widget.phone}";
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: SizedBox(),
      ),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
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
      body: Column(children: [
        Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 150),
            child: Text(
              textData,
              textAlign: TextAlign.center,
              //    style: authStyle,
            )),
        Container(
            margin: EdgeInsets.fromLTRB(55, 55, 55, 30), child: inputCode()),
        GestureDetector(
            onTap: () async {},
            child: Container(
              margin: EdgeInsets.only(
                left: 44,
                right: 44,
              ),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Center(
                  child: Text(
                "Ввести код",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              )),
            ))
      ]),
    );
  }

  String code = "";
  Widget inputCode() {
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    final forgotLabel = TextButton(
      child: Text(
        'Не пришла смс?\nОтправить еще раз',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54, fontSize: 14),
      ),
      onPressed: () {
        /*showModalBottomSheet(
            context: context, builder: (builder) => NewPassPage());*/
      },
    );
    final defaultPinTheme = PinTheme(
      width: 186,
      height: 66,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: mainColor),
      ),
    );
    return Form(
      key: formKey,
      child: Column(
        children: [
          Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            child: Pinput(
              onSubmitted: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode!, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DefaultTabBar()),
                          (route) => false);
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              controller: pinController,
              focusNode: focusNode,
              androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              validator: (value) {
                return value == '2222' ? null : 'Код введен неправильно';
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: mainColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: mainColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: mainColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextButton(
                style: ButtonStyle(
                    shadowColor:
                        MaterialStateProperty.all<Color>(Colors.white30),
                    surfaceTintColor:
                        MaterialStateProperty.all<Color>(Colors.white30)),
                onPressed: () => formKey.currentState!.validate(),
                child: forgotLabel,
              )),
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DefaultTabBar()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }
}
*/