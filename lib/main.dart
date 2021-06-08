import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:practice/Module/member.dart';
import 'Page/Home/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(MemberAdapter());
  await Hive.openBox<Member>("favoriteBox");
  runApp(PracticeApp());
}

class PracticeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Practice",
      theme: new ThemeData(primaryColor: Colors.blueAccent),
      home: new Practice(),
    );
  }


}



