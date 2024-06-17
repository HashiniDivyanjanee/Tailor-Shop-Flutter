import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tailer_shop/View/Login/login.dart';
import 'package:tailer_shop/model/user.dart';

class RegisterViewModel extends ChangeNotifier {
  User user = User();

  void setName(String value) {
    user.name = value;
    notifyListeners();
  }

  void setPhone(String value) {
    user.phone = value;
    notifyListeners();
  }

  void setPassword(String value) {
    user.password = value;
    notifyListeners();
  }

  Future<void> insertRecord(BuildContext context) async {
    if (user.name != "" || user.phone != "" || user.password != "") {
      try {
        String uri = "http://127.0.0.1/Tailer/reg.php";
        var res = await http.post(Uri.parse(uri), body: {
          "name": user.name,
          "phone": user.phone,
          "password": user.password,
        });
        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration is Successful!'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration is Failed!'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print(e);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Enter all Details'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
