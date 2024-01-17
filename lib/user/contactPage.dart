import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:graffitineeds/helpers/notifications.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:graffitineeds/helpers/styles.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:graffitineeds/main.dart';
import 'package:graffitineeds/services/user_service.dart';
import 'package:http/http.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:requests/requests.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class ContactPage extends StatefulWidget {
  ContactPage();
  @override
  _ContactPageState createState() => new _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  String contactInformation = "";
  String contactEmail = "";
  String contactAddress = "";
  String contactPhone = "";

  Future<void>? _launched;
  Future<void> _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      NotificationsToast().displayErrorMotionToast(
          "По какой-то причине не удалось открыть почту", context);
    }
  }

  Future<void> _openMaps() async {
    if (await canLaunchUrl(Uri.parse("https://yandex.com/maps/-/CCU7r4r1cB"))) {
      await launchUrl(Uri.parse("https://yandex.com/maps/-/CCU7r4r1cB"),
          mode: LaunchMode.externalApplication);
    } else {
      NotificationsToast().displayErrorMotionToast(
          "По какой-то причине не удалось перейти по ссылке", context);
    }
  }

  _getContactInfo() async {
    await FirebaseFirestore.instance
        .collection("контакты")
        .doc("контакты")
        .get()
        .then((value) {
      setState(() {
        contactPhone = value.data()!["номер"];
        contactEmail = value.data()!["почта"];
        contactAddress = value.data()!["адрес"];
        contactInformation = value.data()!["график"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getContactInfo();
  }

  openVk() async {
    const url = 'https://vk.com/graffitineeds';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthB = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  color: Colors.transparent,
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.arrow_back,
                    size: 28.0,
                    color: mainColor,
                  ))),
          title: Text(
            "Контакты",
            style: TextStyle(fontFamily: "Circe", fontWeight: FontWeight.w700),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
          padding: EdgeInsets.only(
            top: 30,
            left: 24.0,
            right: 24.0,
          ),
          child: Column(
            children: [
              Text(
                "Адрес: $contactAddress\nГрафик работы: $contactInformation\nТелефон: $contactPhone\nПочта: $contactEmail\n",
                textAlign: TextAlign.center,
              ),
              new GestureDetector(
                  onTap: () async {
                    setState(() {
                      String uidv1 =
                          Uuid().v1().toString().toUpperCase().substring(0, 8);
                      _launched = _openUrl(
                          'mailto:$contactEmail?subject=${Uri.encodeFull("Обращение №$uidv1")}&body=${Uri.encodeFull("Здравствуйте! ")}');
                    });
                  },
                  child: Container(
                      width: widthB,
                      height: 43,
                      margin: EdgeInsets.only(top: 35),
                      decoration: BoxDecoration(
                        color:
                            ThemaMode.isDarkMode ? darkBackColor : Colors.white,
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
                          CupertinoIcons.question_circle_fill,
                          size: 26,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Написать в поддержку',
                            style: TextStyle(
                              fontSize: 14,
                            ))
                      ])))),
              GestureDetector(
                child: Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Image.asset("lib/assets/yandexmaps.png")),
                onTap: () => _openMaps(),
              ),
              GestureDetector(
                child: Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(top: 30),
                    child: Image.asset(
                      "lib/assets/socials/vk.png",
                    )),
                onTap: () => openVk(),
              ),
            ],
          ),
        ))));
  }
}
