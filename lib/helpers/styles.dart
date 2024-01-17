library config.globals;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graffitineeds/helpers/themeMode.dart';
import 'package:hive/hive.dart';

const Color mainColor = const Color(0xffFF6A39);
const Color darkBackColor = const Color.fromRGBO(37, 39, 48, 1);
const Color darkScaffoldColor = const Color.fromRGBO(20, 20, 20, 1);
String mainFontFamily = "Circe";
const String APILINKIMAGE = 'https://api.sbis.ru/retail';
const String gnLogo =
    "https://firebasestorage.googleapis.com/v0/b/graffitineeds-c48c1.appspot.com/o/gn_loading.png?alt=media&token=d51fb1b6-d9df-4be4-87c3-8ae411436140";
Color borderColor = Colors.grey[200]!;
var brightness = SchedulerBinding.instance.window.platformBrightness;

Box? box;
ThemaMode curMode = ThemaMode();
