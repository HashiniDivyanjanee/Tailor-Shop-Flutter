import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class supplier extends StatefulWidget {
  supplier({Key? key}) : super(key: key);

  @override
  State<supplier> createState() => _supplierState();
}
class _supplierState extends State<supplier> {
  @override
  void initState() {
    super.initState();

    fetchDataSupplier();
  }

  List<dynamic> supplierData = [];
  TextEditingController supplierName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  Future<void> insertrecord() async {
    if (supplierName.text != "" || phone.text != "" || address.text != "") {
      try {
        String uri = "http://127.0.0.1/Tailer/supplier.php";
        var res = await http.post(Uri.parse(uri), body: {
          "supplierName": supplierName.text,
          "phone": phone.text,
          "address": address.text,
        });
        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          print("Record Inserted");
        } else {
          print("Some Issue");
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("Please fill all fileds");
    }
  }

  Future<void> fetchDataSupplier() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1/Tailer/supplierDisplay.php'));

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      setState(() {
        supplierData = json.decode(response.body);
        print(supplierData);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(3, 191, 203, 1),
                Color.fromRGBO(3, 191, 203, 1),
              ],
            ),
          ),
        ),
        title: Text('Supplier'),
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile view
            return buildMobileView();
          } else {
            // Desktop view
            return buildDesktopView();
          }
        },
      ),
    );
  }

  Widget buildDesktopView() {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, top: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  insertrecord();
                                },
                                child: const Text(
                                  'Add',
                                  style: TextStyle(
                                    fontSize: 18,
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
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  // submitExpense();
                                },
                                child: const Text(
                                  'Clear all',
                                  style: TextStyle(
                                    fontSize: 18,
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
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  // submitExpense();
                                },
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 50, left: 50, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: supplierName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Supplier Name',
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
                        SizedBox(width: 50),
                        Expanded(
                          child: TextFormField(
                            controller: phone,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
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
                        SizedBox(width: 50),
                        Expanded(
                          child: TextFormField(
                            controller: address,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Address',
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Container(
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Color.fromRGBO(3, 191, 203, 1),
                          ),
                          columns: [
                            DataColumn(
                              label: Text('Supplier ID',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            DataColumn(
                              label: Text('Supplier Name',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            DataColumn(
                              label: Text('Phone Number',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            DataColumn(
                              label: Text('Supplier Address',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ],
                          rows: supplierData
                              .map(
                                (supplier) => DataRow(
                                  cells: [
                                    DataCell(Text('${supplier['supplierID']}')),
                                    DataCell(
                                        Text('${supplier['supplierName']}')),
                                    DataCell(Text('${supplier['phone']}')),
                                    DataCell(Text('${supplier['address']}')),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget buildMobileView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Mobile Supplier View',
            style: TextStyle(fontSize: 20),
          ),
          // Add mobile-specific content here
        ],
      ),
    );
  }
}
