import 'package:flutter/material.dart';
import 'package:tailer_shop/Const/constant.dart';
import 'package:tailer_shop/View/Login/login.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor:  backgroundColor,
        brightness: Brightness.light,
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
