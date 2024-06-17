import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:tailer_shop/size_update.dart';
import 'dart:io';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tailer_shop/Old/job_card_display.dart';
import 'package:tailer_shop/Old/size_update.dart';

class size_list extends StatefulWidget {
  final Map<String, dynamic> jobCardData;

  size_list({required this.jobCardData});

  @override
  State<size_list> createState() => _size_listState();
}

class _size_listState extends State<size_list> {
  List<Map<String, dynamic>> size_list = [];

  @override
  void initState() {
    super.initState();
    fetchJobItemData(int.parse(widget.jobCardData['job_no']));
  }

  Future<void> fetchJobItemData(int job_id) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/Tailer/show_size.php'),
        body: {'job_id': job_id.toString()},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse != null && jsonResponse is List) {
          setState(() {
            size_list = List<Map<String, dynamic>>.from(jsonResponse);
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

  void _printSizeList() async {
    final pdfBytes = await _generatePdf();
    Printing.sharePdf(bytes: pdfBytes);
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
          build: (pw.Context context) {
          return pw.Column(children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'SIZE LIST',
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text('Job No: ${widget.jobCardData['job_no']}'),
              ],
            ),
            pw.SizedBox(height: 25),
            pw.Row(
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Item",
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Bust",
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Hips",
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Waist",
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Sleeve Length",
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Bust Point to Bust Point",
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Bust Point to Waist",
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Front Waist Length",
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Back Waist Length",
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Shoulder Width",
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Neck Circumference",
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Length",
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Armhole Depth",
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Shoulder to Bust Point",
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Shoulder to Waist",
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      "Other",
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                  ],
                ),
                pw.SizedBox(
                  width: 150,
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${size_list.map((size) => size['item']).join('        ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['bust']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['hips']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['waist']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['sleeve_length']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['bust_poin_to_bust_poin']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['bust_poin_to_waist']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['front_waist_length']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['back_waist_length']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['shoulder_width']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['neck_circumference']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['length']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['armhole_depth']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['shoulder_to_bust_point']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['shoulder_to_waist']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Text(
                      '${size_list.map((size) => size['other']).join('             ')}',
                      style: pw.TextStyle(
                          fontSize: 12),
                    ),
                  ],
                )
              ],
            )
          ]);
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Color.fromARGB(255, 224, 224, 224),
        contentPadding: EdgeInsets.symmetric(horizontal: 100),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Center(
            child: Text(
              'SIZE LIST',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        content: SingleChildScrollView(
            child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('JOB NO: ${widget.jobCardData['job_no']}'),
                  Text('${widget.jobCardData['customerName']}'.toUpperCase()),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                      "Dress Code",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Item",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Bust",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Hips",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Waist",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Sleeve Length",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Bust Point to Bust Point",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Bust Point to Waist",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Front Waist Length",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Back Waist Length",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Shoulder Width",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Neck Circumference",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Length",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Armhole Depth",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Shoulder to Bust Point",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Shoulder to Waist",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Other",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  width: 150,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                      '${size_list.map((size) => size['mid']).join('        ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['item']).join('        ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['bust']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['hips']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['waist']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['sleeve_length']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['bust_poin_to_bust_poin']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['bust_poin_to_waist']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['front_waist_length']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['back_waist_length']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['shoulder_width']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['neck_circumference']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['length']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['armhole_depth']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['shoulder_to_bust_point']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['shoulder_to_waist']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${size_list.map((size) => size['other']).join('             ')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 150,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(117, 117, 117, 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(25),
                    child: GestureDetector(
                        child: Center(
                          child: Text(
                            'Print',
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          _printSizeList();
                        }),
                  ),
                ),
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
                            'Update',
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.white),
                          ),
                        ),
                        onTap: ()async {
                          
                  showSizePopup(context);
                 
                        }),
                  ),
                ),
              ],
            ),
          )
        ])));
  }
}

void showSizePopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return size_update(
        
      );
    },
  );
}