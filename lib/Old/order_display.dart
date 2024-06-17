import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class order_display extends StatefulWidget {
  final Map<String, dynamic> orderData;

  // Constructor to receive data
  order_display({required this.orderData});

  @override
  State<order_display> createState() => _order_displayState();
}

class _order_displayState extends State<order_display> {
  List<Map<String, dynamic>> jobItems = [];

  @override
  void initState() {
    super.initState();
    fetchJobItemData(int.parse(widget.orderData['orderID']));
  }

  Future<void> fetchJobItemData(int orderID) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/Tailer/show_order_item.php'),
        body: {'orderID': orderID.toString()},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse != null && jsonResponse is List) {
          setState(() {
            jobItems = List<Map<String, dynamic>>.from(jsonResponse);
          });
        } else {
          // Handle the case where the JSON response is not a List
          print('Invalid JSON response: $jsonResponse');
        }
      } else {
        // Handle HTTP error
        print('Value causing the error: ${widget.orderData['someProperty']}');
      }
    } catch (e) {
      // Handle other errors
      print('Error during data fetching: $e');
    }
  }

  void _updatePaymentAmount(BuildContext context, double enteredAmount) async {
    final url =
        'http://127.0.0.1/Tailer/onCredit.php';

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'orderID': widget.orderData['orderID'],
          'enteredAmount': enteredAmount.toString(),
        },
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment Completely'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
        } else {}
      } else {
        print("HTTP Request Failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
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

  Widget buildMobileView() {
    return Scaffold(body: Container());
  }

  Widget buildDesktopView() {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "INVOICE",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 150),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoice No: ${widget.orderData['orderID']}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${widget.orderData['customerName']}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '0${widget.orderData['customerPhone']}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${widget.orderData['order_date']}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 40, left: 40),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color.fromRGBO(3, 191, 203, 1),
                    ),
                    columns: [
                      DataColumn(
                          label: Text('Item Name',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      DataColumn(
                          label: Text('Unit Price',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      DataColumn(
                          label: Text('Quantity',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      DataColumn(
                          label: Text('Discount',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      DataColumn(
                          label: Text('Total',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                    ],
                    rows: jobItems.map<DataRow>((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text('${item['item_name']}')),
                          DataCell(Text('${item['unit_price']}')),
                          DataCell(Text('${item['unit']}')),
                          DataCell(Text('${item['discount']}')),
                          DataCell(Text('${item['total_price']}')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Total Discount:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Total Balance:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.orderData['total_price']}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${widget.orderData['discount']}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${widget.orderData['amount']}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
               
                ],
              )
            ]),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     if (double.parse(widget.orderData['amount']) >
          //         double.parse(widget.orderData['payment']))
          //       ElevatedButton(
          //         onPressed: () {
          //           _showInputDialog(context);
          //         },
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Color.fromARGB(255, 230, 44, 31),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           minimumSize: Size(250, 80),
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.all(10),
          //           child: Text(
          //             'Payment Uncompleted \n ${double.parse(widget.orderData['amount']) - double.parse(widget.orderData['payment'])}',
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.w500,
          //               color: Colors.white,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //       )
          //     else
          //       Container(
          //         width: 250,
          //         height: 80,
          //         decoration: BoxDecoration(
          //           color: Color.fromARGB(255, 55, 134, 10),
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.all(25.0),
          //           child: Text(
          //             'Payment Completed',
          //             style: TextStyle(
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.w500,
          //                 color: Colors.white),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 150,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(3, 191, 203, 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(25),
                    child: GestureDetector(
                      child: Center(
                        child: Text(
                          'Print',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showInputDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Amount'),
          content: TextField(
            controller: amountController,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                double enteredAmount =
                    double.tryParse(amountController.text) ?? 0.0;
               _updatePaymentAmount(context, enteredAmount);

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
