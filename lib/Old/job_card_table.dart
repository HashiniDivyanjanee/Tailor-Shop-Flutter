import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tailer_shop/Old/job_card.dart';
import 'package:tailer_shop/Old/job_card_display.dart';
import 'package:tailer_shop/Old/job_card_update.dart';

class job_card_table extends StatefulWidget {
  const job_card_table({super.key});

  @override
  State<job_card_table> createState() => _job_card_tableState();
}

class _job_card_tableState extends State<job_card_table> {
  String searchTerm = "";
  List<dynamic> orderData = [];

  @override
  void initState() {
    super.initState();
    fetchDataOrders();
  }


 void refreshContent() {  
    setState(() {
     
    });
  }


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
          Expanded(
            child: Container(
              child: orderSearchBar(onSearch: (value) {
                setState(() {
                  searchTerm = value;
                });
              }),
            ),
          ),
          SizedBox(
            width: 150,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Color.fromARGB(3, 191, 203, 1),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255,
                      255), 
                  width: 5.0, 
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => job_card(
                          bust: '0',
                          waist: '0',
                          hips: '0',
                          sleeve_length: '0',
                          bust_poin_to_bust_poin: '0',
                          bust_poin_to_waist: '0',
                          back_waist_length: '0',
                          front_waist_length: '0',
                          shoulder_width: '0',
                          neck_circumference: '0',
                          length: '0',
                          armhole_depth: '0',
                          shoulder_to_bust_point: '0',
                          shoulder_to_waist: '0',
                          other: '0',
                          selectedItems: '0',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'ADD NEW JOB CARD',
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
          IconButton(
            icon:
                Icon(Icons.refresh, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              refreshContent();
            },
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
    return const Center(
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
                columnSpacing: 48,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => const Color.fromRGBO(3, 191, 203, 1),
                ),
                columns: const [
                  DataColumn(
                      label: Text('Job ID',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Customer\nName',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Phone\nNumber',
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
                      label: Text('Delivery\nDate',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Delivery',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Price',
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
                      label: Text('Advance\nPayment',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Advance Payment\nMethod',
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
                      label: Text('Status',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Employee\nName',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('View',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Edit',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                ],
                rows: orderData
                    .where((job_card) =>
                        job_card['job_no']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()) ||
                        job_card['customerPhone']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()) ||
                        job_card['orderDate']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()) ||
                        job_card['dueDate']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()) ||
                        job_card['status']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()) ||
                        job_card['empName']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()) ||
                        job_card['paymentStatus']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()) ||
                        job_card['job_status']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()) ||
                        job_card['customerName']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()))
                    .map(
                      (job_card) => DataRow(
                        cells: [
                          DataCell(Text('${job_card['job_no']}')),
                          DataCell(Text('${job_card['customerName']}')),
                          DataCell(Text('${job_card['customerPhone']}')),
                          DataCell(Text('${job_card['orderDate']}')),
                          DataCell(Text('${job_card['dueDate']}')),
                          DataCell(
                            Container(
                              width: 80,
                              height: 30,
                              color: _getColorForStatus(job_card['status']),
                              child: Text(
                                '${job_card['status']}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          DataCell(Text('${job_card['total_price']}')),
                          DataCell(Text('${job_card['discount']}')),
                          DataCell(Text('${job_card['advance']}')),
                          DataCell(Text('${job_card['paymentStatus']}')),
                          DataCell(Text('${job_card['amount']}')),
                          DataCell(
                            Container(
                              width: 80,
                              height: 30,
                              color: _getColorForStatus(job_card['job_status']),
                              child: Text(
                                '${job_card['job_status']}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          DataCell(Text('${job_card['empName']}')),
                          DataCell(
                            Container(
                              width: 60,
                              height: 35,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => job_card_display(
                                        jobCardData: job_card,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.visibility,
                                    color: const Color.fromARGB(255, 0, 0, 0),
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
                                  // Assuming 'order' is defined in the same scope or widget
                                  showJobPopup(context, job_card);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.edit,
                                    color: const Color.fromARGB(255, 0, 0, 0),
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

void showJobPopup(BuildContext context, Map<String, dynamic> job_card) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return jobPopup(jobCardData: job_card);
    },
  );
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
