import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:tailer_shop/Old/job_payment.dart';
import 'dart:convert';
import 'package:tailer_shop/Old/size_list.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'dart:io';

class job_card_display extends StatefulWidget {
  final Map<String, dynamic> jobCardData;
  job_card_display({required this.jobCardData});

  @override
  State<job_card_display> createState() => _job_card_displayState();
}

class _job_card_displayState extends State<job_card_display> {
  List<Map<String, dynamic>> jobItems = [];

// Start Job Item Display
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
          print('Invalid JSON response: $jsonResponse');
        }
      } else {
        print('Value causing the error: ${widget.jobCardData['someProperty']}');
      }
    } catch (e) {
      print('Error during data fetching: $e');
    }
  }
// End Job Item Display


 @override
  void initState() {
    super.initState();
    fetchJobItemData(int.parse(widget.jobCardData['job_no']));
  }


  void _printSizeList() async {
    final pdfBytes = await _generatePdf();
    Printing.sharePdf(bytes: pdfBytes);
  }


//Start job Card Print
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();
    final imageFile =
        File('assets/roy1.png'); 
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
                            'JOB CARD',
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
                                    pw.Text(
                                        'Job Card No: ${widget.jobCardData['job_no']}'),
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
                                        'Order Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
                                    pw.SizedBox(height: 5),
                                    pw.Text(
                                        'Time: ${DateFormat.jm().format(DateTime.now())}'),
                                    pw.SizedBox(height: 5),
                                    pw.Text(
                                        'Deliver Date: ${widget.jobCardData['dueDate']}'),
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
                                    child: pw.Text(entry.value['unit']
                                        .toString())),
                                pw.Center(
                                    child: pw.Text(
                                  double.parse(
                                          entry.value['discount'].toString())
                                      .toStringAsFixed(
                                          2), 
                                )),
                                pw.Center(
                                    child: pw.Text(
                                  double.parse(
                                          entry.value['total_price'].toString())
                                      .toStringAsFixed(
                                          2), 
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
                                'Sub Total:',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                'Total Discount:',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                'Advance Payment:',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                'Total Balance:',
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
                              'Please Infom any changes within 1 day.',
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
        title: Text('Job Card'),
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
                "JOB CARD DETAILS",
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
                          'JOB NO: ${widget.jobCardData['job_no']}',
                          style: TextStyle(
                            fontSize: 15,
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
                          '0${widget.jobCardData['customerPhone']}',
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
                        Text(
                          'TAILOR:  ${widget.jobCardData['empName'].toUpperCase()}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                    
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'DELIVERY DATE:   ${widget.jobCardData['dueDate']}',
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
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Total Discount:",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Advance Payment:",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Total Balance:",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    double.parse('${widget.jobCardData['total_price']}')
                        .toStringAsFixed(2),
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 15),
                  Text(
                    double.parse('${widget.jobCardData['discount']}')
                        .toStringAsFixed(2),
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 15),
                  Text(
                    double.parse('${widget.jobCardData['advance']}')
                        .toStringAsFixed(2),
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 15),
                  Text(
                    double.parse('${widget.jobCardData['amount']}')
                        .toStringAsFixed(2),
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 25),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  job_payment(jobCardData: widget.jobCardData),
                            ),
                          );
                        },
                        child: const Text(
                          'Complete Payment',
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
                          _printSizeList();
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
                          showSizePopup(context,
                              jobCardData: widget.jobCardData);
                        },
                        child: const Text(
                          'Size List',
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

void showSizePopup(BuildContext context,
    {required Map<String, dynamic> jobCardData}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return size_list(jobCardData: jobCardData);
    },
  );
}
