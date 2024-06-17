import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:tailer_shop/Old/customer.dart';
import 'package:tailer_shop/Old/home.dart';
import 'package:tailer_shop/Old/product.dart';

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
  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'price': price,
      'quantity': quantity,
      'discount': discount,
    };
  }

  double calculateTotal() {
    double total =
        (double.parse(price) * double.parse(quantity)) - double.parse(discount);
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

class place_order extends StatefulWidget {
  const place_order({Key? key}) : super(key: key);
  @override
  State<place_order> createState() => _place_orderState();
}

class _place_orderState extends State<place_order> {
  double calculateTotalPrice() {
    double total = 0.0;
    for (Product product in productList) {
      total += product.calculateTotal();
    }
    return total;
  }

  double last_total() {
    double total = 0.0;
    for (Product product in productList) {
      total += product.calculateTotal();
    }
    return total - double.parse(_PaymentController.text);
  }

  double total_amount() {
    double total_amount = 0.0;
    for (Product product in productList) {
      total_amount += product.amount();
    }
    return total_amount;
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

  String _selectedMethod = 'Cash';
  String searchTerm = "";
  List<Product> productList = [];
  List<int> selectedRows = [];
  List<dynamic> orderData = [];
  List<String> employeeNames = [];

  TextEditingController textEditingController = TextEditingController();
  TextEditingController textPhoneNumberController = TextEditingController();
  TextEditingController _TotalController = TextEditingController(text: '0');
  TextEditingController _PriceController = TextEditingController(text: '0');
  TextEditingController _qtyController = TextEditingController(text: '1');
  TextEditingController _discountController = TextEditingController(text: '0');
  TextEditingController _PaymentController = TextEditingController(text: '0');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController _AdvanceController = TextEditingController(text: '0');
  TextEditingController ProductController = TextEditingController();
  TextEditingController available_qty = TextEditingController();

  List<String> dataList = [];
  int? maxOrderID = 1;
  double? amount;
  String defaultPrice = '0';
  String defaultQty = '1';
  String defaultDiscount = '0';
  String defaultAdvance = '0';
  String? productName;
  String? quantity;

  void _addItem() {
    setState(() {
      Product product = Product(
        product: ProductController.text,
        price: _PriceController.text,
        quantity: _qtyController.text,
        discount: _discountController.text,
      );

      productList.add(product);
      _PriceController.text = defaultPrice;
      _qtyController.text = defaultQty;
      _discountController.text = defaultDiscount;
      available_qty.clear();
      ProductController.clear();
    });
  }

  List<Map<String, dynamic>> ordersAndMeasurements = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> updateProductQuantity(
      String? productName, String? quantity) async {
    if (productName == null || quantity == null) {
      print("Product name or quantity is null");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/Tailer/quantity.php'),
        body: {
          'productName': productName,
          'quantity': quantity,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update product quantity');
      }
    } catch (e) {
      print('Exception: $e');
    }
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

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    return now.toLocal().toString();
  }

  Future<bool> insertrecord() async {
    String currentDateTime = getCurrentDateTime();

    if (_discountController.text.trim().isNotEmpty ||
        _PaymentController.text.trim().isNotEmpty ||
        customerNameController.text.trim().isNotEmpty ||
        phoneNumberController.text.trim().isNotEmpty ||
        _TotalController.text.trim().isNotEmpty) {
      try {
        String uri = "http://127.0.0.1/Tailer/place_order.php";
        var res = await http.post(Uri.parse(uri), body: {
          'customerName': customerNameController.text,
          'customerPhone': phoneNumberController.text,
          'order_date': currentDateTime,
          'total_price': net_total().toString(),
          'discount': total_discount().toString(),
      
        
          'amount': calculateTotalPrice().toString(),
         
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
        return false;
      }
    } else {
      return false;
    }

    return false;
  }

  Future<bool> _saveProducts() async {
    final url = 'http://127.0.0.1/Tailer/item_order.php';

    try {
      List<Map<String, String>> productsData = productList
          .map((product) => {
                'product': product.product,
                'price': product.price,
                'quantity': product.quantity,
                'discount': product.discount,
                'total_price': amount.toString(),
                'order_id': maxOrderID.toString(),
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

  Future<void> fetchProductData(String product) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/Tailer/fetch_product.php'),
      body: {'product': product},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _PriceController.text = data['sale_price'] ?? '';
        _discountController.text = data['discount'] ?? '';
        available_qty.text = data['qty'] ?? '';
      });
    } else {
      print('Failed to fetch product data');
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return buildMobileView();
          } else {
            return buildDesktopView();
          }
        },
      ),
    );
  }

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
          ],
        ),
      ),
    );
  }

  Widget buildDesktopView() {
    return Container(
      padding: const EdgeInsets.only(top: 40.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 1700,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 80),
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
                                right: 30.0, top: 65, left: 30, bottom: 155),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CUSTOMER DETAILS',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: phoneNumberController,
                                  style: const TextStyle(
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
                                    contentPadding: const EdgeInsets.symmetric(
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
                                SizedBox(height: 35),
                                TextField(
                                  controller: customerNameController,
                                  style: const TextStyle(
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                  ),
                                ),
                                SizedBox(height: 16),
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
                                  child: const Text(
                                    'New Customer',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 28),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.only(
                                right: 30.0, top: 65, left: 30, bottom: 60),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ORDER DETAILS',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: ProductController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Product Name',
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

                                // DropdownButtonFormField<String>(
                                //   value: _selectedType,
                                //   onChanged: (String? newValue) {
                                //     setState(() {
                                //       _selectedType = newValue!;
                                //       _selectedItems =
                                //           _itemsMap[_selectedType]!.first;
                                //     });
                                //   },
                                //   decoration: InputDecoration(
                                //     labelText: 'Category',
                                //     filled: true,
                                //     fillColor: Colors.grey[200],
                                //     border: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10.0),
                                //       borderSide: BorderSide.none,
                                //     ),
                                //     contentPadding: EdgeInsets.symmetric(
                                //       vertical: 14,
                                //       horizontal: 16,
                                //     ),
                                //   ),
                                //   items: _itemsMap.keys
                                //       .map<DropdownMenuItem<String>>(
                                //     (String value) {
                                //       return DropdownMenuItem<String>(
                                //         value: value,
                                //         child: Text(value),
                                //       );
                                //     },
                                //   ).toList(),
                                // ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        String product = ProductController.text;
                                        fetchProductData(product);
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
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    product()));
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(117, 117, 117, 1),
                                        ),
                                      ),
                                      child: Text(
                                        'Add new Product',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 15),
                                TextField(
                                  controller: available_qty,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: 'Available Quantity',
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
                                            int qty = int.tryParse(
                                                    _qtyController.text) ??
                                                0;

                                            int availableQty = int.tryParse(
                                                    available_qty.text) ??
                                                0;
                                            if (availableQty >= qty) {
                                              _addItem();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Quentity not available'),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
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
                                right: 30.0, top: 60, left: 30, bottom: 230),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PAYMENT DETAILS',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _PaymentController,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Payment',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                  ),
                                ),
                                const SizedBox(height: 15),
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
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: _AdvanceController,
                                  style: const TextStyle(
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
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
                                        DataCell(const Text(''), onTap: () {}),
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
                                            'Sub Total',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            'Total Discount',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            'Advance Payment',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            'Total Balance',
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
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            'Rs. ${net_total().toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            'Rs. ${total_discount().toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            'Rs. ${_AdvanceController.text}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Text(
                                            'Rs. ${calculateTotalPrice().toStringAsFixed(2)}',
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
              padding: const EdgeInsets.only(left: 80, top: 50),
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
                            insertrecord();
                            for (var entry in productList.asMap().entries) {
                              int index = entry.key;
                              Product product = entry.value;
                              String productName = product.product;
                              String quantity = product.quantity;
                              await updateProductQuantity(
                                  productName, quantity);
                            }
                            bool saveProductsSuccess = await _saveProducts();

                            if (saveProductsSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Your Order is Completely Successful'),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Your Order failed. Please try again'),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'SAVE',
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
                        color: Color.fromRGBO(117, 117, 117, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'CLEAR',
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          },
                          child: const Text(
                            'CLOSE',
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

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'Pending':
        return Color.fromARGB(255, 201, 138, 4);
      case 'Complete':
        return Color.fromARGB(255, 3, 119, 30);
      case 'On Hold':
        return Color.fromARGB(255, 4, 76, 134);
      default:
        return Colors.white;
    }
  }

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
}

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

void showOrderPopup(BuildContext context, Map<String, dynamic> order) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return OrderPopup();
    },
  );
}

class OrderPopup extends StatefulWidget {
  @override
  _OrderPopupState createState() => _OrderPopupState();
}

class _OrderPopupState extends State<OrderPopup> {
  TextEditingController orderIDController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController orderDateController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController totalPriceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController advanceController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController paymentStatusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Order'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: orderIDController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextFormField(
              controller: customerNameController,
              decoration: InputDecoration(labelText: 'Customer Phone Number'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            updateOrder();
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  // Function to update the order in the database
  void updateOrder() {
    // Implement your PHP request to update the MySQL database here
    // You can use packages like http or dio for HTTP requests
    // Example using http package:
    /*
    http.post('http://your-api-endpoint/update_order.php', body: {
      'orderID': orderIDController.text,
      'customerName': customerNameController.text,
      // ... Repeat for other fields
    });
    */
  }
}
