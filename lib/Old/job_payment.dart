import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:tailer_shop/Old/job_card.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'dart:io';

import 'package:tailer_shop/Old/job_card_table.dart';

class job_payment extends StatefulWidget {
  final Map<String, dynamic> jobCardData;

  job_payment({required this.jobCardData});

  @override
  State<job_payment> createState() => _job_paymentState();
}

class _job_paymentState extends State<job_payment> {
  List<Map<String, dynamic>> jobItems = [];
  TextEditingController payment_amount = TextEditingController();
  double originalAmount = 0.0;
  double changeAmount = 0.0;
  int? maxOrderID;
  String _selectedMethod = 'Cash';

  @override
  void initState() {
    super.initState();
    fetchJobItemData(int.parse(widget.jobCardData['job_no']));
    originalAmount = double.parse(widget.jobCardData['amount']);
    fetchData();
  }

  void handlePaymentConfirm() async {
    // Assuming your PHP server is hosted at http://your-php-server.com/update_status.php
    final Uri uri =
        Uri.parse('http://127.0.0.1/Tailer/update_status_jobcard.php');

    // Make a POST request to update the status
    final http.Response response = await http.post(
      uri,
      body: {
        'job_no': widget.jobCardData['job_no'].toString(),
      },
    );

    // Handle the response (you may want to add error handling here)
    if (response.statusCode == 200) {
      // Successfully updated status, you can handle the response as needed
      print('Status updated successfully');
    } else {
      // Handle error
      print('Error updating status');
    }
  }

  void sendDataToServer(List<Map<String, dynamic>> jobItems) async {
    final url = 'http://127.0.0.1/Tailer/jobItem.php';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "jobItems": jobItems,
        "order_id": maxOrderID.toString(),
      }),
    );

    if (response.statusCode == 200) {
      print("Data sent successfully");
    } else {
      print("Failed to send data. Error: ${response.reasonPhrase}");
    }
  }

  Future<void> insert_payment() async {
    try {
      String uri = "http://127.0.0.1/Tailer/payment.php";
      String currentDateTime = getCurrentDateTime();
      var res = await http.post(Uri.parse(uri), body: {
        'customer_name': widget.jobCardData['customerName'] ?? '',
        'customer_phone': widget.jobCardData['customerPhone'] ?? '',
        'payment_method': _selectedMethod,
        'payment_amount': payment_amount.text,
        'payment_date': currentDateTime,
        'outstanding_amount': changeAmount.toString(),
        'invoice_no': maxOrderID.toString(),
      });
      print("Response Status Code: ${res.statusCode}");
      print("Response Body: ${res.body}");

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          print("Record Inserted");
        } else {
          print("Some Issue: ${response['message']}");
        }
      } else {
        print("HTTP Request Failed with status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    return now.toLocal().toString();
  }

  Future<void> insert_order() async {
    String currentDateTime = getCurrentDateTime();

    try {
      String uri = "http://127.0.0.1/Tailer/place_order.php";
      var res = await http.post(Uri.parse(uri), body: {
        'customerName': widget.jobCardData['customerName'] ?? '',
        'customerPhone': widget.jobCardData['customerPhone'] ?? '',
        'order_date': currentDateTime,
        'status': 'Complete',
        'total_price': widget.jobCardData['total_price'] ?? '',
        'discount': widget.jobCardData['discount'] ?? '',
        'advance': widget.jobCardData['advance'] ?? '',
        'payment': payment_amount.text,
        'amount': widget.jobCardData['amount']?.toString() ?? '0.0',
        'paymentStatus': _selectedMethod,
      });
      print("Response Status Code: ${res.statusCode}");
      print("Response Body: ${res.body}");

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          print("Record Inserted");
        } else {
          print("Some Issue: ${response['message']}");
        }
      } else {
        print("HTTP Request Failed with status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchData() async {
    var url = 'http://127.0.0.1/Tailer/order_ID.php';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          // Parse the response body and add 1
          setState(() {
            maxOrderID = int.parse(response.body) + 1;
          });
        } else {
          print('Response body is empty.');
        }
      } else {
        // Handle errors
        print('Failed to fetch data. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchJobItemData(int job_id) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/Tailer/show_job_item.php'),
        body: {'job_id': job_id.toString()},
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
        print('Value causing the error: ${widget.jobCardData['someProperty']}');
      }
    } catch (e) {
      // Handle other errors
      print('Error during data fetching: $e');
    }
  }

  void _printPayment() async {
    final pdfBytes = await _generatePdf();
    Printing.sharePdf(bytes: pdfBytes);
  }

//Start job Card Print
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();
    final imageFile = File('assets/roy1.png');
    final image = pw.MemoryImage(imageFile.readAsBytesSync());
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5.copyWith(
          width: PdfPageFormat.a4.height,
          height: PdfPageFormat.a4.width,
        ),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Expanded(
                child: pw.Container(
                  padding: pw.EdgeInsets.only(right: 30.0),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Column(
                        children: [
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Column(children: [
                                  pw.Image(image),
                                ]),
                                pw.SizedBox(width: 20),
                                pw.Column(children: [
                                  pw.Text(
                                    'Roy Textile & Tailors (Pvt) Ltd.',
                                    style: pw.TextStyle(
                                        fontSize: 18,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                ]),
                              ]),
                          pw.Divider(
                            thickness: 0.5,
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    pw.Text(
                                      'Address:',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                    pw.SizedBox(
                                      height: 13,
                                    ),
                                    pw.Text(
                                      'Tel:',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    pw.Text(
                                      'Web:',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    pw.Text(
                                      'Email:',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ]),
                              pw.SizedBox(
                                width: 10,
                              ),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'No.674, Negombo Road,',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                    pw.Text(
                                      'Mattumagala, Ragama.',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                    pw.Text(
                                      '011 295 21 63',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    pw.Text(
                                      'www.roylk.com',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    pw.Text(
                                      'roy@roylk.com',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                          pw.Divider(
                            thickness: 0.5,
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'INVOICE',
                            style: pw.TextStyle(
                                fontSize: 13, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 15),
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('Invoice No: $maxOrderID'),
                                    pw.SizedBox(height: 5),
                                    pw.Text(
                                        'Customer: ${widget.jobCardData['customerName']}'),
                                    pw.SizedBox(height: 5),
                                    pw.Text(
                                        'Phone Number: ${widget.jobCardData['customerPhone']}'),
                                  ],
                                ),
                                pw.SizedBox(width: 180),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                        'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
                                    pw.SizedBox(height: 5),
                                    pw.Text(
                                        'Time: ${DateFormat.jm().format(DateTime.now())}'),
                                    pw.SizedBox(height: 5),
                                  ],
                                )
                              ]),
                          pw.SizedBox(height: 25),
                          pw.Text(
                            'ITEM DETAILS',
                            style: pw.TextStyle(
                                fontSize: 13, fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 20),
                      pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.black),
                        children: [
                          // Table header
                          pw.TableRow(
                            children: [
                              pw.Center(child: pw.Text('')),
                              pw.Center(
                                  child: pw.Text(
                                'Product',
                              )),
                              pw.Center(
                                  child: pw.Text(
                                'Unit Price',
                              )),
                              pw.Center(
                                  child: pw.Text(
                                'Quantity',
                              )),
                              pw.Center(
                                  child: pw.Text(
                                'Discount',
                              )),
                              pw.Center(
                                  child: pw.Text(
                                'Amount',
                              )),
                            ],
                          ),

                          for (final entry in jobItems.asMap().entries)
                            pw.TableRow(
                              children: [
                                pw.Center(child: pw.Text('')),
                                pw.Center(
                                    child: pw.Text(
                                        entry.value['item_name'] ?? 'Unknown')),
                                pw.Center(
                                    child: pw.Text(
                                  double.parse(
                                          entry.value['unit_price'].toString())
                                      .toStringAsFixed(2),
                                )),
                                pw.Center(
                                    child: pw.Text(
                                        entry.value['unit'].toString())),
                                pw.Center(
                                    child: pw.Text(
                                  double.parse(
                                          entry.value['discount'].toString())
                                      .toStringAsFixed(2),
                                )),
                                pw.Center(
                                    child: pw.Text(
                                  double.parse(
                                          entry.value['total_price'].toString())
                                      .toStringAsFixed(2),
                                )),
                              ],
                            ),
                        ],
                      ),
                      pw.SizedBox(height: 20),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Sub Total',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                'Total Discount',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                'Advance Payment',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                'Total',
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                           
                              pw.Text(
                                'Payment Amount',
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ],
                          ),
                          pw.SizedBox(width: 20),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                double.parse(
                                        '${widget.jobCardData['total_price']}')
                                    .toStringAsFixed(2),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                double.parse(
                                        '${widget.jobCardData['discount']}')
                                    .toStringAsFixed(2),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                double.parse('${widget.jobCardData['advance']}')
                                    .toStringAsFixed(2),
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                double.parse('${widget.jobCardData['amount']}')
                                    .toStringAsFixed(2),
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                           
                              pw.Text(
                                double.parse(payment_amount.text)
                                    .toStringAsFixed(2),
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Thank You!',
                              style: pw.TextStyle(
                                  fontSize: 15, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Please Inform any changes within 1 day.',
                              style: pw.TextStyle(fontSize: 10),
                            ),
                            pw.Text(
                              'Please bring this receipt when you come to collect your items.',
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        )
                      ])
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
//End job Card Print

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAYMENT'),
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
                "PAYMENT",
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
                          'INVOICE NO: $maxOrderID',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${widget.jobCardData['customerName'].toUpperCase()}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${widget.jobCardData['customerPhone']}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
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
                    columns:  [
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
                    "Advance Payment:",
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
                    '${widget.jobCardData['total_price']}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${widget.jobCardData['discount']}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${widget.jobCardData['advance']}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${widget.jobCardData['amount']}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              )
            ]),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 220, 229, 238),
                        borderRadius: BorderRadius.circular(0)),
                    child: Center(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: DropdownButton<String>(
                              hint: Text("Select Advance Payment"),
                              value: _selectedMethod,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMethod = newValue!;
                                });
                              },
                              items: [
                                'Cash',
                                'Credit Card',
                                'Debit Card',
                                'Check',
                                'Bank Transfer',
                              ].map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ))),
                  ),
                  Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 220, 229, 238),
                        borderRadius: BorderRadius.circular(0)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Payment Amount",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    )),
                  ),
                  Center(
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 220, 229, 238),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Center(
                        child: TextField(
                          controller: payment_amount,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              double enteredValue =
                                  double.tryParse(value) ?? 0.0;
                              changeAmount = originalAmount - enteredValue;
                            });
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Column(
                children: [
                  if (changeAmount < 0)
                    Container(
                      width: 250,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 220, 229, 238),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Change Amount \n ${changeAmount.abs()}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 250,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 220, 229, 238),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Outstanding Amount \n $changeAmount',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 155,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(3, 191, 203, 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          sendDataToServer(jobItems);
                          insert_payment();
                          handlePaymentConfirm();
                          insert_order();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => job_card_table(
                                
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Conform Payment',
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
                      color: Color.fromRGBO(3, 191, 203, 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          _printPayment();
                        },
                        child: const Text(
                          'Print',
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
          )
        ],
      ),
    );
  }
}
