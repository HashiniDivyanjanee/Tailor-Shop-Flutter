import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailer_shop/Old/home.dart';
import 'package:tailer_shop/View/Register/register.dart';
import 'package:tailer_shop/viewmodel/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 200.0),
        child: Column(
          children: [
            Container(
              height: 450,
              width: 900,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Row(
                children: [
                  Container(
                      height: 450,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(3, 191, 203, 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hello Friend!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              "Enter your Personal Details \n and Start Journey with Us",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()));
                            },
                            child: Container(
                              width: 100,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.white, // Border color
                                  width: 3, // Border width
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    8.0), // Adjust padding as needed
                                child: Center(
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                    height: 450,
                    width: 550,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "SIGN IN",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            child: TextFormField(
                              controller: viewModel.phoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.grey,
                                ),
                                labelText: 'Phone Number',
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            child: TextFormField(
                              controller: viewModel.passwordController,
                              obscureText: true,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                labelText: 'Password',
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen()));
                              },
                              child: Text(
                                "Fogot your Password?",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Center(
                            child: SizedBox(
                              width: 100,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(3, 191, 203, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                    viewModel.login(context);
                                    },
                                    child: const Text(
                                      'SIGN IN',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
