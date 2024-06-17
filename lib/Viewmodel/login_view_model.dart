import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tailer_shop/Old/home.dart';
import 'package:tailer_shop/model/login_user.dart';

class LoginViewModel extends ChangeNotifier {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    String phone = phoneController.text;
    String password = passwordController.text;

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Enter all Details '),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      String uri = "http://127.0.0.1/Tailer/login.php";
      var response = await http.post(Uri.parse(uri), body: {
        "phone": phone,
        "password": password,
      });

      var data = json.decode(response.body);
      if (data == "success") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign In Successfully!'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong Phone Number or Password'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
