import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/services/user_service.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController _pass1Contr = TextEditingController();
  TextEditingController _pass2Contr = TextEditingController();

  String _name = "";
  String _lastName = "";
  String? _email = "";
  String _phoneNumber = "";

  bool _onChangedLine = false;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  bool exist = false;
  String currentUser = FirebaseAuth.instance.currentUser!.uid;
  void checkExist() async {
    await FirebaseFirestore.instance
        .collection("пользователи")
        .doc(currentUser)
        .get()
        .then((doc) {
      if (doc.data()!["Name"] != null) {
        if (mounted)
          setState(() {
            exist = true;
          });
      } else if (mounted)
        setState(() {
          exist = false;
        });
    });
  }

  Widget inputBox(String title, TextEditingController texEditingController,
      TextInputType textInputType,
      {bool? secure}) {
    return Container(
        decoration: BoxDecoration(
          color: ThemaMode.isDarkMode ? darkBackColor : Colors.white,
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
          onChanged: (value) {
            if (mounted) setState(() {});
          },
          cursorColor: mainColor,
          keyboardType: textInputType,
          autofocus: false,
          autocorrect: false,
          controller: texEditingController,
          decoration: InputDecoration(
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

  _getName() async {
    await FirebaseFirestore.instance
        .collection("пользователи")
        .doc(currentUser)
        .get()
        .then((value) {
      if (mounted)
        setState(() {
          _name = user!.displayName!;
          _lastName = value["Surname"];
        });
    });
  }

  String? _mobilePhone;
  bool? _phoneLoading;
  _getNumberPhone() async {
    if (mounted)
      setState(() {
        _phoneLoading = true;
      });
    await FirebaseFirestore.instance
        .collection("пользователи")
        .doc(currentUser)
        .get()
        .then((value) {
      if (mounted)
        setState(() {
          _mobilePhone = value["Телефон"];
        });
    }).whenComplete(() => _phoneLoading = false);
  }

  @override
  void initState() {
    super.initState();

    ///  checkExist();
    _getName();
    _getNumberPhone();
    //  _getName();

    _email = user!.email;
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController _userDeletion = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    double heightB = MediaQuery.of(context).size.width / 7;
    double widthB = MediaQuery.of(context).size.width / 1.1;

    BuildContext buildContext;
    titleText(String title) {
      return Padding(
        padding: EdgeInsets.only(
          left: 5.0,
          top: 10,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }

    final email = Container(
        //padding: EdgeInsets.only(top: ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
              bottom: BorderSide(
            color: !ThemaMode.isDarkMode ? Color(0xFF000000) : Colors.white,
          )),
        ),
        child: TextFormField(
          //keyboardType: TextInputType.emailAddress,
          readOnly: true,
          autofocus: false,
          onChanged: (value) {
            if (mounted)
              setState(() {
                _onChangedLine = true;
              });
          },
          autocorrect: false,
          cursorColor: mainColor,
          controller: _emailController,
          decoration: InputDecoration(
            hintText: _email,
            contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 10.0),
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

    final phoneNumber = Container(
        //padding: EdgeInsets.only(top: ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
              bottom: BorderSide(
            color: !ThemaMode.isDarkMode ? Color(0xFF000000) : Colors.white,
          )),
        ),
        child: TextFormField(
          //keyboardType: TextInputType.emailAddress,
          readOnly: true,
          autofocus: false,
          onChanged: (value) {
            if (mounted)
              setState(() {
                _onChangedLine = true;
              });
          },
          autocorrect: false,
          cursorColor: mainColor,
          controller: _phoneController,
          decoration: InputDecoration(
            hintText: _phoneLoading! ? "Загрузка..." : _mobilePhone,
            contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 10.0),
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
    final name = Container(
        //padding: EdgeInsets.only(top: ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(bottom: BorderSide()),
        ),
        child: TextFormField(
          //keyboardType: TextInputType.emailAddress,
          autofocus: false,
          autocorrect: false,
          cursorColor: mainColor,
          controller: _nameController,
          onChanged: (value) {
            if (mounted)
              setState(() {
                _onChangedLine = true;
              });
          },
          decoration: InputDecoration(
            hintText: user!.displayName,
            hintStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 10.0),
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

    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              "Настройки",
              style: TextStyle(
                  color: ThemaMode.isDarkMode ? Colors.white : Colors.black),
            ),
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    width: 50,
                    height: 50,
                    child: Icon(
                      CupertinoIcons.back,
                      size: 28.0,
                      color: mainColor,
                    ))),
          )
        ];
      },
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          //shrinkWrap: true,
          //height: MediaQuery.of(context).size.height / 2,
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 12.0,
            right: 24.0,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 5.0),

                titleText("Имя Фамилия"),
                Flexible(
                    flex: 0,
                    child: Row(children: [
                      Flexible(
                          child: inputBox(
                              _name, _nameController, TextInputType.name)),
                      Flexible(
                          child: inputBox(_lastName, _lastNameController,
                              TextInputType.name)),
                    ])),
                Center(
                    child: Container(
                  // alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 20),
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _lastNameController.text != "" ||
                                _nameController.text != ""
                            ? mainColor
                            : ThemaMode.isDarkMode
                                ? darkBackColor
                                : Colors.white),
                    onPressed: () {
                      if (_nameController.text != "" ||
                          _nameController.text != null ||
                          _lastNameController.text != "" ||
                          _lastNameController.text != null) _nameChange();
                    },
                    child: Text(
                      "Изменить",
                      style: TextStyle(
                          color: _lastNameController.text != "" ||
                                  _nameController.text != ""
                              ? Colors.white
                              : ThemaMode.isDarkMode
                                  ? Colors.white
                                  : Colors.black54),
                    ),
                  ),
                )),
                SizedBox(height: 8.0),
                titleText("Почта"),
                email,
                titleText("Телефон"),
                phoneNumber,
                SizedBox(height: 15.0),
                /////CHANGE PASSWORD//////
                Container(
                  // alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 5, bottom: 10),
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          ThemaMode.isDarkMode ? darkBackColor : Colors.white,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Scaffold(
                                body: Column(
                              children: [
                                Row(children: [
                                  GestureDetector(
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
                                  Center(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Text(
                                          "Сменить пароль",
                                          style: TextStyle(
                                              color: !ThemaMode.isDarkMode
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        )),
                                  )
                                ]),
                                SizedBox(
                                  height: 5,
                                ),
                                new Container(
                                    width: widthB,
                                    height: heightB,
                                    padding: EdgeInsets.only(
                                      left: 15.0,
                                    ),
                                    child: TextField(
                                      obscureText: true,
                                      controller: _pass1Contr,
                                      cursorColor: mainColor,
                                      decoration: InputDecoration(
                                        floatingLabelStyle:
                                            TextStyle(color: mainColor),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: mainColor)),
                                        labelText: "Новый пароль",
                                      ),
                                    )),
                                new Container(
                                    width: widthB,
                                    height: heightB,
                                    padding: EdgeInsets.only(
                                      left: 15.0,
                                    ),
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 15),
                                    child: TextField(
                                      controller: _pass2Contr,
                                      obscureText: true,
                                      cursorColor: mainColor,
                                      decoration: InputDecoration(
                                        floatingLabelStyle:
                                            TextStyle(color: mainColor),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: mainColor)),
                                        focusColor: mainColor,
                                        labelText: "Повторите пароль",
                                      ),
                                    )),
                                Center(
                                    child: Container(
                                  // alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 20),
                                  width: 120,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white),
                                    onPressed: () {
                                      //   _passChange();
                                    },
                                    child: Text(
                                      "Изменить",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ))
                              ],
                            ));
                          });
                    },
                    child: Text(
                      "Сменить пароль",
                      style: TextStyle(
                        color:
                            !ThemaMode.isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),

                ///////DELETE USER/////
                Container(
                  // alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 5, bottom: 10),
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          ThemaMode.isDarkMode ? darkBackColor : Colors.white,
                    ),
                    onPressed: () {
                      String _password = "";
                      showDialog<bool>(
                        context: context,
                        builder: (contextz) {
                          // String _deleteText = "";
                          buildContext = contextz;
                          return CupertinoAlertDialog(
                            title: Text(
                                'Вы уверены?\nОтменить действие будет невозможно'),
                            content: Card(
                              color: Colors.transparent,
                              elevation: 0.0,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Введите пароль для подтверждения",
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                      height: 35,
                                      width: double.infinity,
                                      child: CupertinoTextField(
                                        obscureText: true,
                                        style: TextStyle(fontSize: 12),
                                        onChanged: ((value) {
                                          _password = value;
                                        }),
                                        placeholder: "Пароль",
                                        controller: _userDeletion,
                                      )),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                //isDefaultAction: true,
                                onPressed: (() async {
                                  _userDeletion.clear();
                                  await _deleteUser(_password);

                                  Navigator.of(buildContext,
                                          rootNavigator: true)
                                      .pop();

                                  Navigator.pop(context);
                                }),
                                child: Text("Принять"),
                              ),
                              CupertinoDialogAction(
                                onPressed: () {
                                  _password = "";
                                  _userDeletion.clear();
                                  Navigator.of(buildContext,
                                          rootNavigator: true)
                                      .pop();
                                },
                                child: Text("Отмена"),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Удалить пользователя",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ])),
    ));
  }

  _nameChange() async {
    _name = _nameController.text;
    _lastName = _lastNameController.text;

    if (_name.isEmpty && _lastName.isEmpty)
      return;
    else {
      await UserServices()
          .usersRef
          .doc(UserServices().getUserId())
          .update({"Name": _name, "Surname": _lastName});
      user!.updateDisplayName(_name).onError((error, stackTrace) =>
          _displayErrorMotionToast(
              "По какой-то причине не удалось изменить имя"));
      _displaySuccessfulMoationToast("Имя успешно изменено");
    }
  }

  Future _deleteUser(String pass) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var user = await _auth.currentUser;

    await user
        ?.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: user.email!,
        password: pass,
      ),
    )
        .whenComplete(() async {
      await user.delete();
      await UserServices()
          .usersRef
          .doc(user.uid)
          .collection("корзина")
          .get()
          .then((value) {
        for (DocumentSnapshot ds in value.docs) {
          ds.reference.delete();
        }
      });

      await FirebaseFirestore.instance
          .collection("пользователи")
          .doc(user.uid)
          .delete();
    }).catchError((error, stackTrace) {
      _displayErrorMotionToast("Неверный пароль, повторите еще раз");
      return Future<UserCredential>.error(Exception(error));
    });
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

  /*_passChange() async {
    _pass1 = _pass1Contr.text;
    _pass2 = _pass2Contr.text;

    if (_pass1.isEmpty || _pass1.isEmpty) return;
    if (_pass1 != _pass2) {
      Fluttertoast.showToast(
          msg: "Пароль не совпадает",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    if (_pass1 == _pass2) {
      if (_pass2.length >= 6) {
        user!.updatePassword(_pass2).then((_) {
          print("Successfully changed password");
        }).catchError((error) {
          print("Password can't be changed" + error.toString());
          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
        });

        Fluttertoast.showToast(
            msg: "Пароль успешно изменен",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else
        Fluttertoast.showToast(
            msg: "Пароль должен содержать не менее 6 символов",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
    }
  }

  _nameChange() async {
    _name = _nameController.text;
    // _pass2 = _pass2Contr.text;

    if (_name.isEmpty)
      return;
    else {
      await FirebaseFirestore.instance
          .collection("пользователи")
          .doc(currentUser)
          .update({"имя": _name});
      user!.updateDisplayName(_name);
      Fluttertoast.showToast(
          msg: "Имя успешно изменено",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _emailChange() async {
    _email = _emailController.text;
    // _pass2 = _pass2Contr.text;

    if (_email!.isEmpty)
      return;
    else {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      firebaseUser!.updateEmail(_email!).then((_) {
        print("Successfully changed email");
        Fluttertoast.showToast(
            msg: "На почту придет уведомление",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }).catchError((error) {
        print("Email can't be changed" + error.toString());
        Fluttertoast.showToast(
            msg: "Произошла ошибка.\nПопробуйте еще раз",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            // webPosition: "center",
            fontSize: 16.0);
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    }
  }*/
}
