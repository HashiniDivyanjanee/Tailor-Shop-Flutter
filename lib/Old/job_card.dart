import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:tailer_shop/Old/customer.dart';
import 'package:tailer_shop/Old/emp.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

import 'package:tailer_shop/Old/job_card_table.dart';

// ***Start of Add Product Section***
class Product {
  String product;
  String price;
  String quantity;
  String discount;

  Product({
    required this.product,
    required this.price,
    required this.quantity,
    required this.discount,
  });

  double calculateTotal() {
    double total = (double.parse(price) * double.parse(quantity)) -
        (double.parse(discount));
    return total;
  }

  double amount() {
    double amount = ((double.parse(price) * double.parse(quantity)) -
        double.parse(discount));
    return amount;
  }

  double net_tot() {
    double net_tot = (double.parse(price) * double.parse(quantity));
    return net_tot;
  }
}
// ***End of Add Product Section***

class job_card extends StatefulWidget {
  const job_card({
    Key? key,
    required String bust,
    required String waist,
    required String hips,
    required String sleeve_length,
    required String bust_poin_to_bust_poin,
    required String bust_poin_to_waist,
    required String back_waist_length,
    required String front_waist_length,
    required String shoulder_width,
    required String neck_circumference,
    required String length,
    required String armhole_depth,
    required String shoulder_to_bust_point,
    required String shoulder_to_waist,
    required String other,
    required String selectedItems,
  }) : super(key: key);

  @override
  State<job_card> createState() => _job_cardState();
}

class _job_cardState extends State<job_card> {
  String _selectedType = 'Women';
  String _selectedItems = 'Frock';
  String _selectedMethod = 'Default';
  String _selectedStatus = 'Pending';
  String selectedEmployee = '';
  String searchTerm = "";
  String defaultPrice = '0';
  String defaultQty = '1';
  String defaultDiscount = '0';
  String defaultAdvance = '0';
  int? maxOrderID = 1;
  double? amount;

  List<String> dataList = [];
  List<int> selectedRows = [];
  List<Product> productList = [];
  List<dynamic> orderData = [];
  List<String> employeeNames = [];
  List<Map<String, String>> sizesList = [];
  List<Map<String, dynamic>> ordersAndMeasurements = [];

  TextEditingController textEditingController = TextEditingController();
  TextEditingController textPhoneNumberController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _TotalController = TextEditingController();
  TextEditingController _PriceController = TextEditingController(text: '0');
  TextEditingController _qtyController = TextEditingController(text: '1');
  TextEditingController _discountController = TextEditingController(text: '0');
  TextEditingController _AdvanceController = TextEditingController(text: '0');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();

  Map<String, List<String>> _itemsMap = {
    'Women': [
      'Frock',
      'Blouses',
      'T-shirts',
      'Tank tops',
      'Sweaters',
      'Tunics',
      'Jeans ',
      'Leggings',
      'Skirts',
      'Shorts',
      'Trousers'
    ],
    'Men': [
      'T-shirts',
      'Shirts',
      'Polo Shirts',
      'Jeans',
      'Chinos',
      'Shorts',
      'Sweaters',
      'Jackets and Coats',
      'Activewear',
      'Sleepwear'
    ],
    'Kids': [
      'T-shirts',
      'Shirts',
      'Frock',
      'Polo Shirts',
      'Jeans',
      'Tops',
      'Shorts',
      'Sweaters',
      'Jackets and Coats',
      'Underwear',
      'Sleepwear'
    ]
  };

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataOrders();
    fetchEmployeeNames();
  }

// *** Start of Add Product Calculate part ***
  double calculateTotalPrice() {
    double total = 0.0;
    for (Product product in productList) {
      total += product.calculateTotal();
    }
    return total - double.parse(_AdvanceController.text);
  }

  double total_discount() {
    double total_discount = 0.0;
    for (Product product in productList) {
      total_discount += double.parse(product.discount);
    }
    return total_discount;
  }

  double net_total() {
    double net_total = 0.0;
    for (Product product in productList) {
      net_total += product.net_tot();
    }
    return net_total;
  }
// *** End of Add Product Calculate part ***

// *** Start of add item in job card bill ***
  void _addItem() {
    setState(() {
      Product product = Product(
        product: _selectedItems,
        price: _PriceController.text,
        quantity: _qtyController.text,
        discount: _discountController.text,
      );
      productList.add(product);
      _PriceController.text = defaultPrice;
      _qtyController.text = defaultQty;
      _discountController.text = defaultDiscount;
    });
  }
// *** End of add item in job card bill ***

// *** Start of delete row in job card bill ***
  void deleteSelectedRows() {
    setState(() {
      selectedRows.sort((a, b) => b.compareTo(a));

      for (int index in selectedRows) {
        if (index >= 0 && index < productList.length) {
          productList.removeAt(index);
        }
      }
      selectedRows.clear();
    });
  }
// *** End of delete row in job card bill ***

  void deleteRows() {
    setState(() {
      productList.clear();
    });
  }

// *** Start of Update job card dtails in databse ***
  void updateData(int job_no, Map<String, dynamic> updatedData) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/Tailer/update_job_card.php'),
      body: {
        'job_no': job_no.toString(),
        'customerName': updatedData['customerName'],
        'customerPhone': updatedData['customerPhone'],
        'orderDate': updatedData['orderDate'],
        'dueDate': updatedData['dueDate'],
        'status': updatedData['status'],
        'total_price': updatedData['total_price'],
        'discount': updatedData['discount'],
        'advance': updatedData['advance'],
        'amount': updatedData['amount'],
        'paymentStatus': updatedData['paymentStatus'],
        'empName': updatedData['empName'],
        'job_status': updatedData['job_status'],
      },
    );

    if (response.statusCode == 200) {
      print('Record updated successfully');
    } else {
      print('Error updating record: ${response.body}');
    }
  }
// *** Strt of Update job card dtails in databse ***

// *** Start of Fetch Job ID ***
  Future<void> fetchData() async {
    var url = 'http://127.0.0.1/Tailer/job_ID.php';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          setState(() {
            maxOrderID = int.parse(response.body) + 1;
          });
        } else {
          print('Response body is empty.');
        }
      } else {
        print('Failed to fetch data. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
// *** End of Fetch Job ID ***

// *** Start of saving Size Details in Database ***
  void addSize(Map<String, String> sizeData) {
    sizesList.add(sizeData);
    setState(() {});
  }

  Future<bool> size_list() async {
    try {
      String uri = "http://127.0.0.1/Tailer/measurement.php";

      for (var sizeData in sizesList) {
        var res = await http.post(Uri.parse(uri), body: {
          'bust': sizeData['bust'] ?? '',
          'hips': sizeData['hips'] ?? '',
          'waist': sizeData['waist'] ?? '',
          'sleeve_length': sizeData['sleeve_length'] ?? '',
          'bust_poin_to_bust_poin': sizeData['bust_poin_to_bust_poin'] ?? '',
          'bust_poin_to_waist': sizeData['bust_poin_to_waist'] ?? '',
          'front_waist_length': sizeData['front_waist_length'] ?? '',
          'back_waist_length': sizeData['back_waist_length'] ?? '',
          'shoulder_width': sizeData['shoulder_width'] ?? '',
          'neck_circumference': sizeData['neck_circumference'] ?? '',
          'length': sizeData['length'] ?? '',
          'armhole_depth': sizeData['armhole_depth'] ?? '',
          'shoulder_to_bust_point': sizeData['shoulder_to_bust_point'] ?? '',
          'shoulder_to_waist': sizeData['shoulder_to_waist'] ?? '',
          'other': sizeData['other'] ?? '',
          'customer': customerNameController.text,
          'job_id': maxOrderID.toString(),
          'item': sizeData['selectedItems'] ?? '',
        });

        print("Response Body: ${res.body}");

        if (res.statusCode == 200) {
          var response = jsonDecode(res.body);

          print("Server Response: $response");

          if (response["success"] == "true") {
            print("Record Inserted");
            return true;
          } else {
            print("Some Issue: ${response['message']}");
            return false;
          }
        } else {
          print("HTTP Request Failed with status code: ${res.statusCode}");
          return false;
        }
      }
      return false;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
// *** End of saving Size Details in Database ***

// *** Start of saving Job Card Details in Database ***
  Future<bool> insertrecord() async {
    String currentDateTime = getCurrentDateTime();

    if (customerNameController.text.trim().isNotEmpty ||
        phoneNumberController.text.trim().isNotEmpty ||
        _TotalController.text.trim().isNotEmpty) {
      try {
        String uri = "http://127.0.0.1/Tailer/job_card.php";
        var res = await http.post(Uri.parse(uri), body: {
          'customerName': customerNameController.text,
          'customerPhone': phoneNumberController.text,
          'orderDate': currentDateTime,
          'dueDate': _dateController.text,
          'status': _selectedStatus,
          'total_price': net_total().toString(),
          'discount': total_discount().toString(),
          'advance': _AdvanceController.text,
          'amount': calculateTotalPrice().toString(),
          'paymentStatus': _selectedMethod,
          'empName': selectedEmployee
        });
        print("Response Status Code: ${res.statusCode}");
        print("Response Body: ${res.body}");

        if (res.statusCode == 200) {
          var response = jsonDecode(res.body);
          if (response["success"] == "true") {
            return true;
          } else {
            return false;
          }
        } else {
          print("HTTP Request Failed with status code: ${res.statusCode}");
        }
      } catch (e) {
        print("Error: $e");
      }
    } else {}
    return false;
  }
// *** End of saving Job Card Details in Database ***

// *** Start of current date and time part ***
  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    return now.toLocal().toString();
  }
// *** End of current date and time part ***

// *** Start of saving item in database ***
  Future<bool> _saveProducts() async {
    final url = 'http://127.0.0.1/Tailer/item_job_card.php';

    try {
      List<Map<String, String>> productsData = productList
          .map((product) => {
                'product': product.product,
                'price': product.price,
                'quantity': product.quantity,
                'discount': product.discount,
                'total_price': amount.toString(),
                'job_id': maxOrderID.toString(),
              })
          .toList();
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productsData),
      );

      if (response.statusCode == 200) {
        print('Products saved successfully');
        return true;
      } else {
        print('Error saving products. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
// *** End of saving item in database ***

// *** Start of Fetch Employee ***
  Future<void> fetchEmployeeNames() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1/Tailer/Employee_name.php'));

    if (response.statusCode == 200) {
      setState(() {
        employeeNames = List<String>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load employee names');
    }
  }
// *** End of Fetch Employee ***

// *** Start of Fetch Customer when enter Phone number ***
  Future<void> fetchCustomerData(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/Tailer/Customers_Name.php'),
      body: {'phone': phoneNumber},
    );

    if (response.statusCode == 200) {
      setState(() {
        customerNameController.text = response.body;
      });
    } else {
      print('Failed to fetch customer data');
    }
  }
// *** End of Fetch Customer when enter Phone number ***

// *** Start of Fetch Job card table ***
  Future<void> fetchDataOrders() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1/Tailer/job_card_display.php'));

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      setState(() {
        orderData = json.decode(response.body);
        print(orderData);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
// *** End of Fetch Job card table ***

// *** Start of Print Job Card ***
  void _printSizeList() async {
    final pdfBytes = await _generatePdf();
    Printing.sharePdf(bytes: pdfBytes);
  }


Future<pw.ImageProvider> _loadImage() async {
  final byteData = await rootBundle.load('assets/roy1.png');
  return pw.MemoryImage(byteData.buffer.asUint8List());
}

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();
   final image = await _loadImage();

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
                                    pw.Text('Job Card No: $maxOrderID'),
                                    pw.SizedBox(height: 5),
                                    pw.Text(
                                        'Customer: ${customerNameController.text}'),
                                    pw.SizedBox(height: 5),
                                    pw.Text(
                                        'Phone Number: ${phoneNumberController.text}'),
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
                                        'Deliver Date: ${_dateController.text}'),
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
                          // Table rows
                          for (final entry in productList.asMap().entries)
                            pw.TableRow(
                              children: [
                                pw.Center(child: pw.Text('')),
                                pw.Center(child: pw.Text(entry.value.product)),
                                pw.Center(
                                    child: pw.Text(
                                  double.parse(entry.value.price)
                                      .toStringAsFixed(2),
                                )),
                                pw.Center(child: pw.Text(entry.value.quantity)),
                                pw.Center(
                                    child: pw.Text(
                                  double.parse(entry.value.discount)
                                      .toStringAsFixed(2),
                                )),
                                pw.Center(
                                    child: pw.Text(entry.value
                                        .amount()
                                        .toStringAsFixed(2))),
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
                                '${net_total().toStringAsFixed(2)}',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                '${total_discount().toStringAsFixed(2)}',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                '${double.parse(_AdvanceController.text).toStringAsFixed(2)}',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                '${calculateTotalPrice().toStringAsFixed(2)}',
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
  // *** End of Print Job Card ***

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
        title: Text('JOB CARD'),
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

// *** Start of Mobile View ***
  Widget buildMobileView() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
      ),
    );
  }
// *** End of the Mobile View ***



showAlertDialog(BuildContext context) {  
  // Create button  
  Widget okButton = MenuItemButton(  
    child: Text("OK"),  
    onPressed: () {  
      Navigator.of(context).pop();  
    },  
  );  
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text("Simple Alert"),  
    content: Text("This is an alert message."),  
    actions: [  
      okButton,  
    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  

// *** Start of Desktop View ***
  Widget buildDesktopView() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 1700,
                  child: Padding(
                    padding: const EdgeInsets.only(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.only(
                                right: 30.0, top: 65, left: 30, bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CUSTMER DETAILS',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 25),
                                TextField(
                                  controller: phoneNumberController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Phone Number',
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
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    String phoneNumber =
                                        phoneNumberController.text;
                                    fetchCustomerData(phoneNumber);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color.fromRGBO(3, 191, 203, 1),
                                    ),
                                  ),
                                  child: Text(
                                    'Find',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: customerNameController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: 'Customer Name',
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
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => customer()));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color.fromRGBO(117, 117, 117, 1),
                                    ),
                                  ),
                                  child: Text(
                                    'New Customer',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 35),
                                Text(
                                  'EMPLOYEE DETAILS',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 25),
                                DropdownButtonFormField(
                                  value: employeeNames.isNotEmpty
                                      ? (selectedEmployee.isNotEmpty
                                          ? selectedEmployee
                                          : employeeNames.first)
                                      : null, // Set value to null if the list is empty
                                  items: employeeNames
                                      .map((employee) => DropdownMenuItem(
                                            child: Text(employee),
                                            value: employee,
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedEmployee = value.toString();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Employee Name',
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
                                SizedBox(height: 25),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => emp()));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color.fromRGBO(117, 117, 117, 1),
                                    ),
                                  ),
                                  child: Text(
                                    'New Employee',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.only(
                                right: 30.0, top: 65, left: 30, bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ORDER DETAILS',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 30),
                                DropdownButtonFormField<String>(
                                  value: _selectedType,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedType = newValue!;
                                      // Update items when category changes
                                      _selectedItems = _itemsMap[_selectedType]!
                                          .first; // Set to the first item in the list
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Category',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 16,
                                    ),
                                  ),
                                  items: _itemsMap.keys
                                      .map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                ),
                                SizedBox(height: 15),
                                DropdownButtonFormField<String>(
                                  value: _selectedItems,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedItems = newValue!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Item',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 16,
                                    ),
                                  ),
                                  items: _itemsMap[_selectedType]!
                                      .map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            bust_Controller.clear();
                                            waist_Controller.clear();
                                            hips_Controller.clear();
                                            sleeve_length_Controller.clear();
                                            bust_poin_to_bust_poin_Controller
                                                .clear();
                                            bust_poin_to_waist_Controller
                                                .clear();
                                            back_waist_length_Controller
                                                .clear();
                                            front_waist_length_Controller
                                                .clear();
                                            shoulder_width_Controller.clear();
                                            neck_circumference_Controller
                                                .clear();
                                            length_Controller.clear();
                                            armhole_depth_Controller.clear();
                                            shoulder_to_bust_point_Controller
                                                .clear();
                                            shoulder_to_waist_Controller
                                                .clear();
                                            other_Controller.clear();

                                            // Handle the button press action here
                                            // Check the selected item and navigate accordingly
                                            // if (_selectedItems == 'Frock' ||
                                            //     _selectedItems == 'T-shirts' ||
                                            //     _selectedItems == 'Blouses' ||
                                            //     _selectedItems == 'Tank tops' ||
                                            //     _selectedItems == 'Sweaters' ||
                                            //     _selectedItems == 'Tunics') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WelcomeFrockPage(
                                                  customerNameController:
                                                      customerNameController,
                                                  selectedItems: _selectedItems,
                                                  addSizeCallback: addSize,
                                                ),
                                              ),
                                            );
                                            // } else if (_selectedItems ==
                                            //         'Jeans' ||
                                            //     _selectedItems == 'Leggings' ||
                                            //     _selectedItems == 'Skirts' ||
                                            //     _selectedItems == 'Shorts' ||
                                            //     _selectedItems == 'Trousers') {
                                            //   Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             WelcomeBlousesPage(
                                            //                 customerNameController),
                                            //       ));
                                            // }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Color.fromRGBO(3, 191, 203, 1),
                                            ),
                                          ),
                                          child: Text(
                                            'Add Size',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: _PriceController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Price',
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
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: _qtyController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Quantity',
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
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: _discountController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Discount',
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
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _addItem();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Color.fromRGBO(3, 191, 203, 1),
                                            ),
                                          ),
                                          child: Text(
                                            'Add',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            deleteSelectedRows();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Color.fromRGBO(117, 117, 117, 1),
                                            ),
                                          ),
                                          child: Text(
                                            'Remove',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.only(
                                right: 30.0, top: 60, left: 30, bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'OTHER DETAILS',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  onTap: () async {
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (selectedDate != null) {
                                      setState(() {
                                        _dateController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(selectedDate);
                                      });
                                    }
                                  },
                                  controller: _dateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Delivery Date',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  controller: _AdvanceController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Advance Payment',
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
                                SizedBox(height: 15),
                                DropdownButtonFormField<String>(
                                  value: _selectedMethod,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedMethod = newValue!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Payment Method',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 16,
                                    ),
                                  ),
                                  items: [
                                    'Default',
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
                                ),
                                SizedBox(height: 20),
                                DropdownButtonFormField<String>(
                                  value: _selectedStatus,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedStatus = newValue!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Status ',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 16,
                                    ),
                                  ),
                                  items: [
                                    'Pending',
                                    'Complete',
                                    'Failed',
                                    'On Hold',
                                  ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                ),
                                SizedBox(height: 170),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.only(
                                right: 30.0, top: 60, bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'JOB CARD',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text('Job Card No: $maxOrderID'),
                                    Text(
                                        'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
                                    Text(
                                        'Time: ${DateFormat.jm().format(DateTime.now())}'),
                                    SizedBox(height: 20),
                                    Text(
                                        'Customer: ${customerNameController.text}'),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'ITEM DETAILS',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                DataTable(
                                  columnSpacing: 10,
                                  columns: [
                                    DataColumn(label: Text('')),
                                    DataColumn(label: Text('Product')),
                                    DataColumn(label: Text('Unit\nPrice')),
                                    DataColumn(label: Text('Quantity')),
                                    DataColumn(label: Text('Discount')),
                                    DataColumn(label: Text('Amount')),
                                  ],
                                  rows:
                                      productList.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    Product product = entry.value;

                                    return DataRow(
                                      selected: selectedRows.contains(index),
                                      onSelectChanged: (isSelected) {
                                        setState(() {
                                          if (isSelected != null &&
                                              isSelected) {
                                            selectedRows.add(index);
                                          } else {
                                            selectedRows.remove(index);
                                          }
                                        });
                                      },
                                      cells: [
                                        DataCell(Text(''), onTap: () {}),
                                        DataCell(Text(product.product)),
                                        DataCell(Text(product.price)),
                                        DataCell(Text(product.quantity)),
                                        DataCell(Text(product.discount)),
                                        DataCell(Text(product
                                            .amount()
                                            .toStringAsFixed(2))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            'Sub Total:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            'Total Discount:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            'Advance Payment:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            'Total Balance:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            '${net_total().toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            '${total_discount().toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            '${double.parse(_AdvanceController.text).toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            '${calculateTotalPrice().toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 110, right: 20, top: 50, bottom: 20),
              child: Row(
                children: [
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
                            setState(() {});
                            bool jobItemInsert = await _saveProducts();
                            bool jobInsert = await insertrecord();
                            bool sizeList = await size_list();

                            if (jobItemInsert && sizeList || jobInsert) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Your Order is Completely Successful'),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              showAlertDialog(context);
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Your Order is failed. Please try again'),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              _printSizeList();
                            }
                          },
                          child: const Text(
                            'Save',
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => job_card_table()));
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
                        color: Color.fromARGB(171, 122, 122, 122),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            phoneNumberController.clear();
                            customerNameController.clear();
                            _PriceController.text = defaultPrice;
                            _qtyController.text = defaultQty;
                            _discountController.text = defaultDiscount;
                            _AdvanceController.text = defaultAdvance;
                            phoneNumberController.clear();
                            deleteRows();
                          },
                          child: const Text(
                            'Clear',
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
            ),
          ],
        ),
      ),
    );
  }
// *** Start of Desktop View ***
}

TextEditingController bust_Controller = TextEditingController();
TextEditingController hips_Controller = TextEditingController();
TextEditingController waist_Controller = TextEditingController();
TextEditingController sleeve_length_Controller = TextEditingController();
TextEditingController bust_poin_to_bust_poin_Controller =
    TextEditingController();
TextEditingController bust_poin_to_waist_Controller = TextEditingController();
TextEditingController front_waist_length_Controller = TextEditingController();
TextEditingController back_waist_length_Controller = TextEditingController();
TextEditingController shoulder_width_Controller = TextEditingController();
TextEditingController neck_circumference_Controller = TextEditingController();
TextEditingController length_Controller = TextEditingController();
TextEditingController armhole_depth_Controller = TextEditingController();
TextEditingController shoulder_to_bust_point_Controller =
    TextEditingController();
TextEditingController shoulder_to_waist_Controller = TextEditingController();
TextEditingController seat_Controller = TextEditingController();
TextEditingController thigh_circumference_Controller = TextEditingController();
TextEditingController knee_circumference_Controller = TextEditingController();
TextEditingController calf__circumference_Controller = TextEditingController();
TextEditingController inseam_length_Controller = TextEditingController();
TextEditingController outseam_length_Controller = TextEditingController();
TextEditingController front_rise_Controller = TextEditingController();
TextEditingController back_rise_Controller = TextEditingController();
TextEditingController hip_depth_Controller = TextEditingController();
TextEditingController crotch_depth_Controller = TextEditingController();
TextEditingController other_Controller = TextEditingController();
TextEditingController customer_Controller = TextEditingController();
TextEditingController customerNameController = TextEditingController();
int? maxOrderID;

Future<String> fetchMaxOrderID() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1/Tailer/order_ID.php'));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load data');
  }
}

class WelcomeFrockPage extends StatelessWidget {
  final TextEditingController customerNameController;
  final String selectedItems;
  final Function(Map<String, String>) addSizeCallback;
  WelcomeFrockPage({
    required this.customerNameController,
    required this.selectedItems,
    required this.addSizeCallback,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frock Size'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 800,
          ),
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(customerNameController.text)],
              ),
              SizedBox(height: 40),
              Text(selectedItems),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: bust_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Bust',
                        filled: true,
                        fillColor: Colors.grey[200],
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
                    width: 30,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: waist_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Waist',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: hips_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Hips',
                        filled: true,
                        fillColor: Colors.grey[200],
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
                    width: 30,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: sleeve_length_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Sleeve Length',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: bust_poin_to_bust_poin_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Bust Point to Bust Point',
                        filled: true,
                        fillColor: Colors.grey[200],
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
                    width: 30,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: bust_poin_to_waist_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Bust Point to Waist',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: back_waist_length_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Back Waist Length',
                        filled: true,
                        fillColor: Colors.grey[200],
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
                    width: 30,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: front_waist_length_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Front Waist Length',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: shoulder_width_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Shoulder Width',
                        filled: true,
                        fillColor: Colors.grey[200],
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
                    width: 30,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: neck_circumference_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Neck Circumference',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: length_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Length',
                        filled: true,
                        fillColor: Colors.grey[200],
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
                    width: 30,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: armhole_depth_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Armhole Depth',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: shoulder_to_bust_point_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Shoulder to Bust Point',
                        filled: true,
                        fillColor: Colors.grey[200],
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
                    width: 30,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: shoulder_to_waist_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Shoulder to Waist',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: other_Controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Other',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 100,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 10, 62, 110),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            addSizeCallback({
                              'bust': bust_Controller.text,
                              'waist': waist_Controller.text,
                              'hips': hips_Controller.text,
                              'sleeve_length': sleeve_length_Controller.text,
                              'bust_poin_to_bust_poin':
                                  bust_poin_to_bust_poin_Controller.text,
                              'bust_poin_to_waist':
                                  bust_poin_to_waist_Controller.text,
                              'back_waist_length':
                                  back_waist_length_Controller.text,
                              'front_waist_length':
                                  front_waist_length_Controller.text,
                              'shoulder_width': shoulder_width_Controller.text,
                              'neck_circumference':
                                  neck_circumference_Controller.text,
                              'length': length_Controller.text,
                              'armhole_depth': armhole_depth_Controller.text,
                              'shoulder_to_bust_point': length_Controller.text,
                              'shoulder_to_waist':
                                  armhole_depth_Controller.text,
                              'other': other_Controller.text,
                              'selectedItems': selectedItems,
                            });

                            Navigator.pop(context); // Go back to job_card page
                          },
                          child: const Text(
                            'OK',
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class WelcomeBlousesPage extends StatelessWidget {
//   final TextEditingController customerNameController;

//   WelcomeBlousesPage(this.customerNameController);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Size'),
//       ),
//       body: Center(
//         child: Container(
//           constraints: BoxConstraints(
//             maxWidth: 800,
//           ),
//           padding: const EdgeInsets.only(top: 80),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [Text(customerNameController.text)],
//               ),
//               FutureBuilder(
//                 future: fetchMaxOrderID(),
//                 builder: (context, AsyncSnapshot<String?> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (snapshot.hasData) {
//                     // Parse the retrieved value as an integer and add 1
//                     int maxOrderID = int.parse(snapshot.data!) + 1;

//                     // Insert order item using the obtained maxOrderID
//                     insertsize(customerNameController.text, maxOrderID);
//                     // Display the modified maximum order ID using Text widget
//                     return Center(child: Text('Invoice Number: $maxOrderID'));
//                   } else {
//                     // If there is no data, you can choose to display nothing or a placeholder
//                     return Center(child: Text('No data available'));
//                   }
//                 },
//               ),
//               SizedBox(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: seat_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Seat',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 30,
//                   ),
//                   Expanded(
//                     child: TextFormField(
//                       controller: waist_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Waist',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: hips_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Hips',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 30,
//                   ),
//                   Expanded(
//                     child: TextFormField(
//                       controller: thigh_circumference_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Thigh Circumference',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: knee_circumference_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Knee Circumference',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 30,
//                   ),
//                   Expanded(
//                     child: TextFormField(
//                       controller: calf__circumference_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Calf Circumference',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: inseam_length_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Inseam Length',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 30,
//                   ),
//                   Expanded(
//                     child: TextFormField(
//                       controller: outseam_length_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Outseam Length',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: front_rise_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Front Rise',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 30,
//                   ),
//                   Expanded(
//                     child: TextFormField(
//                       controller: back_rise_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Back Rise',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: hip_depth_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Hip Depth',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 30,
//                   ),
//                   Expanded(
//                     child: TextFormField(
//                       controller: crotch_depth_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Crotch Depth',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: other_Controller,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         labelText: 'Other',
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(
//                     width: 100,
//                     child: Container(
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Center(
//                         child: GestureDetector(
//                           onTap: () {
//                             insertsize(
//                                 customerNameController.text, maxOrderID!);
//                           },
//                           child: const Text(
//                             'Save',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 50,
//                   ),
//                   SizedBox(
//                     width: 100,
//                     child: Container(
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 10, 62, 110),
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Center(
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => job_card(
//                                   bust: bust_Controller.text,
//                                   waist: waist_Controller.text,
//                                   hips: hips_Controller.text,
//                                   thigh_circunference:
//                                       thigh_circumference_Controller.text,
//                                   knee_circunference:
//                                       knee_circumference_Controller.text,
//                                   calf_circunference:
//                                       calf__circumference_Controller.text,
//                                   inseam_length: inseam_length_Controller.text,
//                                   outseam_length:
//                                       outseam_length_Controller.text,
//                                   front_rise: front_rise_Controller.text,
//                                   back_rise: back_rise_Controller.text,
//                                   hip_depth: hip_depth_Controller.text,
//                                   crotch_depth: crotch_depth_Controller.text,
//                                   other: other_Controller.text,
//                                   sleeve_length: sleeve_length_Controller.text,
//                                   bust_poin_to_bust_poin:
//                                       bust_poin_to_bust_poin_Controller.text,
//                                   bust_poin_to_waist:
//                                       bust_poin_to_waist_Controller.text,
//                                   back_waist_length:
//                                       back_waist_length_Controller.text,
//                                   front_waist_length:
//                                       front_waist_length_Controller.text,
//                                   shoulder_width:
//                                       shoulder_width_Controller.text,
//                                   neck_circumference:
//                                       neck_circumference_Controller.text,
//                                   length: length_Controller.text,
//                                   armhole_depth: armhole_depth_Controller.text,
//                                   shoulder_to_bust_point:
//                                       length_Controller.text,
//                                   shoulder_to_waist:
//                                       armhole_depth_Controller.text,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             'OK',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class orderSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const orderSearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 1300, right: 30),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 194, 218, 238),
        ),
        child: TextField(
          style: TextStyle(
            backgroundColor: Color.fromARGB(255, 139, 172, 214),
          ),
          onChanged: onSearch,
          decoration: InputDecoration(
            labelText: 'Search',
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            filled: true,
          ),
        ),
      ),
    );
  }
}
