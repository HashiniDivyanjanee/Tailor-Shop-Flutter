import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tailer_shop/Old/job_card.dart';

class size_update extends StatefulWidget {
  @override
  _size_updateState createState() => _size_updateState();
}

class _size_updateState extends State<size_update> {
  TextEditingController bust_Controller = TextEditingController();
  TextEditingController hipsController = TextEditingController();
  TextEditingController waistController = TextEditingController();
  TextEditingController sleeve_lengthController = TextEditingController();
  TextEditingController bust_poin_to_bust_poinController =
      TextEditingController();
  TextEditingController bust_poin_to_waistController = TextEditingController();
  TextEditingController front_waist_lengthController = TextEditingController();

  TextEditingController findController = TextEditingController();

  String selectedEmployee = '';

  List<String> employeeNames = [];

  @override
  void initState() {
    super.initState();
  }

// Function to fetch dress size data from the API
  Future<Map<String, dynamic>> fetchDressSizeData(int mid) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1/Tailer/size_find.php?mid=$mid'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load dress size data');
    }
  }

  void handleFindButtonTap(int mid) async {
    try {
      final dressSizeData = await fetchDressSizeData(mid);

      setState(() {
        bust_Controller.text = dressSizeData['bust'];
        hipsController.text = dressSizeData['hips'];
        waistController.text = dressSizeData['waist'];
        sleeve_lengthController.text = dressSizeData['sleeve_length'];
        bust_poin_to_bust_poinController.text =
            dressSizeData['bust_poin_to_bust_poin'];
        bust_poin_to_waistController.text = dressSizeData['bust_poin_to_waist'];
        front_waist_lengthController.text = dressSizeData['front_waist_length'];
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateSizeList(int mid) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/Tailer/size_update.php'),
      body: {
        'mid': mid.toString(), 
        'bust': bust_Controller.text,
        'hips': hipsController.text,
        'waist': waistController.text,
        'sleeve_length': sleeve_lengthController.text,
        'bust_poin_to_bust_poin': bust_poin_to_bust_poinController.text,
        'bust_poin_to_waist': bust_poin_to_waistController.text,
        'front_waist_length': front_waist_lengthController.text,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Size List Updated successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    } else {
   ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Update Size List'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 224, 224, 224),
      contentPadding: EdgeInsets.symmetric(horizontal: 150),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Center(
          child: Text(
            'UPDATE SIZE LIST DETAILS',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Enter Dress Code',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: TextFormField(
                    controller: findController,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: '',
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
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
                          String midString = findController.text;
                          int? mid = int.tryParse(midString);

                          if (mid != null) {
                            handleFindButtonTap(mid);
                          } else {
                            print('Invalid input for mid');
                          }
                        },
                        child: const Text(
                          'Find',
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
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'SIZE LIST',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: bust_Controller,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Bust',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: hipsController,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Hips',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: waistController,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Waist',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: sleeve_lengthController,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Sleeve Length',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: bust_poin_to_bust_poinController,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Bust Poin to Bust Poin',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: bust_poin_to_waistController,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Bust Poin to Waist',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: front_waist_lengthController,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Front Waist Length',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
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
                    String midString = findController.text;
                    int? mid = int.tryParse(midString);

                    if (mid != null) {
                      updateSizeList(mid);
                    } else {
                      print('Invalid input for mid');
                    }
                  },
                  child: const Text(
                    'Update',
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
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 100,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Color.fromARGB(171, 54, 54, 54),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
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
        ]),
      ],
    );
  }
}
