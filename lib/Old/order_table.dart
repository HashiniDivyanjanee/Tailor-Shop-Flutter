import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tailer_shop/Old/order_display.dart';
import 'package:tailer_shop/Old/place_order.dart';

class order_table extends StatefulWidget {
  const order_table({super.key});

  @override
  State<order_table> createState() => _order_tableState();
}

class _order_tableState extends State<order_table> {
  String searchTerm = "";
  List<dynamic> orderData = [];

  @override
  void initState() {
    super.initState();
    fetchDataOrders();
  }

  Future<void> fetchDataOrders() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1/Tailer/order.php'));

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
        title: Text('ORDERS'),
        actions: [
          Expanded(
            child: orderSearchBar(onSearch: (value) {
              setState(() {
                searchTerm = value;
              });
            }),
          ),
          SizedBox(
            width: 150,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Color.fromARGB(3, 191, 203, 1),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255), // Change this color to the desired border color
                  width: 5.0, // Change this value to the desired border width
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => place_order()),
                            );
                  },
                  child: const Text(
                    'NEW ORDER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
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

  Widget buildDesktopView() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Scrollbar(
              controller: ScrollController(),
              trackVisibility: true,
              child: DataTable(
                columnSpacing: 115,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Color.fromRGBO(3, 191, 203, 1),
                ),
                columns: [
                
                              DataColumn(
                                  label: Text('Order ID',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Customer Name',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Phone Number',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Order Date',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Order Status',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                              DataColumn(
                                  label: Text('Sub Total',
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
                              
                            
                              DataColumn(
                                  label: Text('',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                                           DataColumn(
                                  label: Text('',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))),
                            ],
                            rows: orderData
                                .where((order) =>
                                    order['orderID']
                                        .toLowerCase()
                                        .contains(searchTerm.toLowerCase()) ||
                                    order['customerPhone']
                                        .toLowerCase()
                                        .contains(searchTerm.toLowerCase()) ||
                                    order['status']
                                        .toLowerCase()
                                        .contains(searchTerm.toLowerCase()) ||
                                    order['order_date']
                                        .toLowerCase()
                                        .contains(searchTerm.toLowerCase()) ||
                                  
                                    order['customerName']
                                        .toLowerCase()
                                        .contains(searchTerm.toLowerCase()))
                                .map(
                                  (order) => DataRow(
                                    cells: [
                                      DataCell(Text('${order['orderID']}')),
                                      DataCell(
                                          Text('${order['customerName']}')),
                                      DataCell(
                                          Text('${order['customerPhone']}')),
                                      DataCell(Text('${order['order_date']}')),
                                      DataCell(
                                        Container(
                                          width: 80,
                                          height: 30,
                                          color: _getColorForStatus(
                                              order['status']),
                                          child: Text(
                                            '${order['status']}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      DataCell(Text('${order['total_price']}')),
                                      DataCell(Text('${order['discount']}')),
                                 
                                      DataCell(Text('${order['amount']}')),
                                    
                                  
                                      DataCell(
                                        Container(
                                          width: 60,
                                          height: 35,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      order_display(
                                                          orderData: order),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.visibility,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          width: 60,
                                          height: 35,
                                          child: InkWell(
                                            onTap: () {
                                          
                                              showOrderPopup(context, order);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.edit,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'Pending':
        return Color.fromARGB(255, 201, 138, 4);
      case 'Complete':
        return Color.fromARGB(255, 3, 119, 30);
      case 'Failed':
        return const Color.fromARGB(255, 248, 17, 1);
      case 'Processing':
        return Color.fromARGB(255, 1, 67, 248);
      case 'On Hold':
        return Color.fromARGB(255, 4, 76, 134);
      default:
        return Colors.white;
    }
  }
}

class orderSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const orderSearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, left: 1300, right: 30, bottom: 10),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: TextField(
          style: TextStyle(
            backgroundColor: Color.fromARGB(255, 139, 172, 214),
          ),
          onChanged: onSearch,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Color.fromRGBO(3, 191, 203, 1),
            ),
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
