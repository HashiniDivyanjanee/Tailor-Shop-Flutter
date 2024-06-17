import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:tailer_shop/Old/job_card.dart';
import 'package:tailer_shop/Old/nav.dart';

import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class ProductSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(3, 191, 203, 1),
                Color.fromRGBO(3, 191, 203, 1),
              ],
            ),
          ),
        ),
        title: Text('Order'),
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
      body: ProductSearch(),
    );
  }
}

class ProductSearch extends StatefulWidget {
  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  List<dynamic> _searchResults = [];
  List<dynamic> _selectedProducts = [];
  List<dynamic> _searchCusResults = [];
  List<dynamic> _selectedCustomers = [];
  List<TextEditingController> _controllers = [];
  TextEditingController _searchController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  String selectedCid = '';
  String selectedFullName = '';
  String selectedPhone = '';
  int? maxOrderID = 1;
  double total = 0;
  double outstanding = 0;
  double totalDiscount = 0;
  double balance = 0;
  String _selectedMethod = 'Cash';

  void _initControllers() {
    _controllers = List.generate(
        _searchResults.length, (index) => TextEditingController());
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
    fetchData();
  }

  void _removeSelectedProduct(int index) {
    setState(() {
      _selectedProducts.removeAt(index);
    });
  }

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    return now.toLocal().toString();
  }

  Future<void> insert_payment() async {
    try {
      String uri = "http://127.0.0.1/Tailer/payment.php";
      String currentDateTime = getCurrentDateTime();
      var res = await http.post(Uri.parse(uri), body: {
        'payment_method': _selectedMethod,
        'payment_amount': paymentController.text,
        'payment_date': currentDateTime,
        'outstanding_amount': outstanding.toString(),
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

  Future<bool> insertRecord() async {
    String currentDateTime = getCurrentDateTime();

    if (paymentController.text.trim().isNotEmpty) {
      try {
        String uri = "http://127.0.0.1/Tailer/place_order.php";
        var res = await http.post(Uri.parse(uri), body: {
          'customerName': selectedFullName,
          'customerPhone': selectedPhone,
          'order_date': currentDateTime,
          'total_price': total.toString(),
          'discount': totalDiscount.toString(),
          'amount': balance.toString(),
        });
        print("Response Status Code: ${res.statusCode}");
        print("Response Body: ${res.body}");

        if (res.statusCode == 200) {
          var response = jsonDecode(res.body);
          if (response["success"] == true) {
            return true;
          } else {
            return false;
          }
        } else {
          print("HTTP Request Failed with status code: ${res.statusCode}");
        }
      } catch (e) {
        print("Error: $e");
        return false;
      }
    } else {
      return false;
    }
    return false;
  }

  Future<void> saveProducts(List<dynamic> products) async {
    var url = Uri.parse('http://127.0.0.1/Tailer/place_Item_save.php');
    for (var product in products) {
      product['order_id'] = maxOrderID;
    }

    var response =
        await http.post(url, body: json.encode({'products': products}));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> fetchData() async {
    var url = 'http://127.0.0.1/Tailer/order_ID.php';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          setState(() {
            maxOrderID = int.parse(response.body) + 1;
          });

          await saveProducts(_selectedProducts);
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

  Future<void> searchProducts(String searchTerm) async {
    if (searchTerm.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final response = await http.get(Uri.parse(
        'http://127.0.0.1/Tailer/product_show.php?search=$searchTerm'));

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = json.decode(response.body);
        _initControllers();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> searchcustomers(String searchTerm) async {
    if (searchTerm.isEmpty) {
      setState(() {
        _searchCusResults = [];
      });
      return;
    }

    final response = await http.get(Uri.parse(
        'http://127.0.0.1/Tailer/customer_serach.php?search=$searchTerm'));

    if (response.statusCode == 200) {
      setState(() {
        _searchCusResults = json.decode(response.body);
        _initControllers();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _addToSelectedProducts(int index, String quantity) {
    final product = _searchResults[index];
    final existingIndex =
        _selectedProducts.indexWhere((p) => p['pid'] == product['pid']);
    if (existingIndex >= 0) {
      _selectedProducts[existingIndex]['quantity'] = quantity;
    } else {
      final newProduct = Map.of(product);
      newProduct['quantity'] = quantity;
      _selectedProducts.add(newProduct);
    }
    setState(() {});
  }

  void Outstanding() {
    outstanding = 0;
    double? paymentAmount = double.tryParse(paymentController.text);

    if (paymentAmount == null) {
      print("Error: Invalid input");
      return;
    }

    outstanding = balance - paymentAmount;
  }

  void calculateTotals() {
    total = 0;
    totalDiscount = 0;
    balance = 0;

    for (var product in _selectedProducts) {
      double salePrice = double.parse(product['sale_price'].toString());
      double quantity = double.parse(product['quantity'].toString());
      double discount = double.parse(product['discount'].toString());

      total += salePrice * quantity;
      totalDiscount += discount * quantity;
    }
    balance = total - totalDiscount;
  }

  void _printSizeList() async {
    final pdfBytes = await _generatePdf();
    Printing.sharePdf(bytes: pdfBytes);
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();
    final imageFile =
        File('assets/roy1.png'); // Replace with the actual file path
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
                                        'Customer: ${selectedFullName}'),
                                    pw.SizedBox(height: 5),
                                    pw.Text(
                                        'Phone Number: ${selectedPhone}'),
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
                              pw.Center(child: pw.Text('Product ID')),
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
                           
                            ],
                          ),
                          // Table rows
                           ...List<pw.TableRow>.generate(
            _selectedProducts.length, // Make sure this is the correct data source
            (index) => pw.TableRow(
              children: [
                pw.Center(
                    child: pw.Text(_selectedProducts[index]['pid'].toString())),
                pw.Center(
                    child: pw.Text(_selectedProducts[index]['product'] ?? 'No Name')),
                pw.Center(
                    child: pw.Text(_selectedProducts[index]['sale_price'].toString())),
                         pw.Center(
                    child: pw.Text(_selectedProducts[index]['quantity'].toString())),
                pw.Center(
                    child: pw.Text(_selectedProducts[index]['discount'].toString())),
           
              ],
                            ),
                          )
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
                                '${total}',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                '${totalDiscount}',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              pw.Text(
                                '${balance}',
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

  @override
  Widget build(BuildContext context) {
    Outstanding();
    calculateTotals();
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, bottom: 8),
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 10,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => searchProducts(value),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Search Product',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, bottom: 8),
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 10,
                    ),
                    child: TextField(
                      controller: phoneNumberController,
                      onChanged: (value) => searchcustomers(value),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Search Customer',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _searchResults.isEmpty
                      ? const Center(
                          child: Text(
                            '',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : GestureDetector(
                          onDoubleTap: () {},
                          child: DataTable(
                            columnSpacing: 110,
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) => const Color.fromRGBO(3, 191, 203, 1),
                            ),
                            columns: const [
                              DataColumn(label: Text('Product ID')),
                              DataColumn(label: Text('Product Name')),
                              DataColumn(label: Text('Cost Price')),
                              DataColumn(label: Text('Sale Price')),
                              DataColumn(label: Text('Discount')),
                              DataColumn(label: Text('Available Quantity')),
                              DataColumn(label: Text('Color')),
                              DataColumn(label: Text('Category')),
                              DataColumn(label: Text('Range')),
                              DataColumn(label: Text('Quantity')),
                              DataColumn(
                                  label: Text('Add',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                            ],
                            rows: List<DataRow>.generate(
                              _searchResults.length,
                              (index) => DataRow(
                                cells: [
                                  DataCell(Text(
                                      _searchResults[index]['pid'].toString())),
                                  DataCell(Text(_searchResults[index]
                                          ['product'] ??
                                      'No Name')),
                                  DataCell(Text(_searchResults[index]
                                          ['cost_price']
                                      .toString())),
                                  DataCell(
                                    TextField(
                                      controller: TextEditingController(
                                          text: _searchResults[index]
                                                  ['sale_price']
                                              .toString()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        _searchResults[index]['sale_price'] =
                                            value;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Sale Price',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    TextField(
                                      controller: TextEditingController(
                                          text: _searchResults[index]
                                                  ['discount']
                                              .toString()),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        _searchResults[index]['discount'] =
                                            value;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Discount',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(
                                      _searchResults[index]['qty'].toString())),
                                  DataCell(Text(_searchResults[index]
                                          ['color'] ??
                                      'No Name')),
                                  DataCell(Text(_searchResults[index]
                                          ['category'] ??
                                      'No Name')),
                                  DataCell(Text(_searchResults[index]
                                          ['range'] ??
                                      'No Name')),
                                  DataCell(
                                    TextField(
                                      controller: _controllers[index],
                                      decoration: const InputDecoration(),
                                      onSubmitted: (value) {
                                        _addToSelectedProducts(index, value);
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: 60,
                                      height: 35,
                                      child: InkWell(
                                        onTap: () {
                                          int qty = int.tryParse(
                                                  _searchResults[index]['qty']
                                                      .toString()) ??
                                              0;
                                          int quantity = int.tryParse(
                                                  _controllers[index].text) ??
                                              0;

                                          if (quantity > 0 && qty >= quantity) {
                                            _addToSelectedProducts(
                                                index, quantity.toString());
                                            _searchResults.clear();
                                            _searchController.clear();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Quentity not available'),
                                                duration: Duration(seconds: 3),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: const Icon(
                                            Icons.add_box_sharp,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _searchCusResults.isEmpty
                      ? const Center(
                          child: Text(
                            '',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : GestureDetector(
                          onDoubleTap: () {},
                          child: DataTable(
                            columnSpacing: 110,
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) => const Color.fromRGBO(3, 191, 203, 1),
                            ),
                            columns: const [
                              DataColumn(label: Text('Customer ID')),
                              DataColumn(label: Text('Full Name')),
                              DataColumn(label: Text('Address')),
                              DataColumn(label: Text('Phone Number')),
                              DataColumn(label: Text('Gender')),
                              DataColumn(
                                  label: Text('Add',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                            ],
                            rows: List<DataRow>.generate(
                              _searchCusResults.length,
                              (index) => DataRow(
                                cells: [
                                  DataCell(Text(_searchCusResults[index]['cid']
                                      .toString())),
                                  DataCell(Text(_searchCusResults[index]
                                          ['full_name'] ??
                                      'No Name')),
                                  DataCell(Text(_searchCusResults[index]
                                          ['address']
                                      .toString())),
                                  DataCell(Text(_searchCusResults[index]
                                          ['phone']
                                      .toString())),
                                  DataCell(Text(_searchCusResults[index]
                                          ['gender']
                                      .toString())),
                                  DataCell(
                                    Container(
                                      width: 60,
                                      height: 35,
                                      child: InkWell(
                                        onTap: () {
                                          selectedCid = _searchCusResults[index]
                                                  ['cid']
                                              .toString();
                                          selectedPhone =
                                              _searchCusResults[index]['phone']
                                                  .toString();
                                          selectedFullName =
                                              _searchCusResults[index]
                                                      ['full_name'] ??
                                                  'No Name';
                                          _searchCusResults.clear();
                                          phoneNumberController.clear();
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: const Icon(
                                            Icons.add_box_sharp,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "INVOICE",
            style: TextStyle(fontSize: 25),
          ),
          Text(
            'Invoice ID: $maxOrderID',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('Customer ID: $selectedCid'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text(selectedFullName),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text(selectedPhone),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 290,
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => const Color.fromRGBO(195, 197, 197, 1),
                    ),
                    columns: const [
                      DataColumn(label: Text('Product ID')),
                      DataColumn(label: Text('Product Name')),
                      DataColumn(label: Text('Sale Price')),
                      DataColumn(label: Text('Discount')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: List<DataRow>.generate(
                      _selectedProducts.length,
                      (index) => DataRow(
                        cells: [
                          DataCell(
                              Text(_selectedProducts[index]['pid'].toString())),
                          DataCell(Text(_selectedProducts[index]['product'] ??
                              'No Name')),
                          DataCell(Text(_selectedProducts[index]['sale_price']
                              .toString())),
                          DataCell(Text(
                              _selectedProducts[index]['discount'].toString())),
                          DataCell(Text(
                              _selectedProducts[index]['quantity'].toString())),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                _removeSelectedProduct(index);
                              },
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sub Total",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Total Discount",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Total Balance",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$total'),
                  SizedBox(height: 15),
                  Text('$totalDiscount'),
                  SizedBox(height: 15),
                  Text('$balance'),
                ],
              )
            ]),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 170,
                  padding: EdgeInsets.symmetric(
                      horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(8), 
                    border: Border.all(color: Colors.grey), 
                  ),
                  child: TextField(
                    controller: paymentController,
                    decoration: InputDecoration(
                      hintText: 'Payment Amount',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: 180,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonFormField<String>(
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
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
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
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 110,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(3, 191, 203, 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          _selectedProducts.forEach((product) async {
                            try {
                              final response = await http.put(
                                Uri.parse(
                                    'http://127.0.0.1/Tailer/order_qty_reduce.php'),
                                body: {
                                  'pid': '${product['pid']}',
                                  'quantity': '${product['quantity']}',
                                },
                              );

                              if (response.statusCode == 200) {
                                print("Quantity updated successfully");
                              } else {
                                print('Handle error cases here');
                              }
                            } catch (e) {
                              print("Handle exceptions here");
                            }
                          });
                          insertRecord();
                          saveProducts(_selectedProducts);
                          insert_payment();
                        },
                        child: const Text(
                          'PLACE ORDER',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 100,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(117, 117, 117, 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {   _printSizeList();},
                        child: const Text(
                          'PRINT',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 100,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(171, 122, 122, 122),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'CLOSE',
                          style: TextStyle(
                            fontSize: 13,
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
