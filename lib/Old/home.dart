import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tailer_shop/View/Login/login.dart';
import 'package:tailer_shop/Old/customer.dart';
import 'package:tailer_shop/Old/emp.dart';
import 'package:tailer_shop/Old/Expenses.dart';
import 'package:tailer_shop/Old/finish_job.dart';
import 'package:tailer_shop/Old/job_card_table.dart';
import 'package:tailer_shop/Old/nav.dart';
import 'package:tailer_shop/Old/order_table.dart';
import 'package:tailer_shop/Old/pending_job.dart';
import 'package:tailer_shop/Old/sewing.dart';
import 'package:tailer_shop/Old/supplier.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pie_chart/pie_chart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int customerCount = 0;
  int employeeCount = 0;
  int jobCardCount = 0;
  int orderCount = 0;
  int pendingJobCount = 0;
  int finishJobCount = 0;
  List<dynamic> orderData = [];
  String searchTerm = "";
  double totalExpenses = 0.0;

  Map<String, double> dataMap = {
    'Pending Job': 5,
    'Complete Job': 3,
    'Delivered Job': 2,
    'Return Job': 2,
  };

  List<Color> colorList = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    fetchDataCounts();
  }

//Start Count
  Future<void> fetchDataCounts() async {
    final response =
        await http.get(Uri.parse("http://127.0.0.1/Tailer/count.php"));

    if (response.statusCode == 200) {
      final counts = response.body.split("&");
      setState(() {
        customerCount = int.parse(counts[0].split("=")[1]);
        employeeCount = int.parse(counts[1].split("=")[1]);
        jobCardCount = int.parse(counts[2].split("=")[1]);
        pendingJobCount = int.parse(counts[3].split("=")[1]);
        finishJobCount = int.parse(counts[4].split("=")[1]);
        orderCount = int.parse(counts[5].split("=")[1]);
      });
    } else {}
  }
//End Count

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile view
            return _buildMobileView();
          } else {
            // Desktop view
            return _buildDesktopView();
          }
        },
      ),
    );
  }

  Widget _buildMobileView() {
    return Scaffold(
        drawer: navbar(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(38, 186, 238, 1),
                  Color.fromRGBO(159, 232, 250, 1)
                ],
              ),
            ),
          ),
        ),
        body: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(38, 186, 238, 1),
                Color.fromRGBO(121, 224, 238, 1),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 10.0, left: 22),
              child: Text(
                'Welcome\nHashini!',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 130.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 22),
                      child: Text(
                        "Category",
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 38.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Sewing()));
                              },
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Image.asset('assets/sewing.png'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => emp()));
                              },
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Image.asset('assets/emp.png'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => emp()));
                              },
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Image.asset('assets/order.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => supplier()));
                          },
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Image.asset('assets/supplier.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => customer()));
                          },
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Image.asset('assets/customer.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Expenses(
                                  updateTotalExpenses: (double totalExpenses) {
                                    setState(() {
                                      this.totalExpenses = totalExpenses;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Image.asset('assets/expe.png'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => emp()));
                          },
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Image.asset('assets/cash.png'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }

  Widget _buildDesktopView() {
    return Scaffold(
        drawer: navbar(),
        appBar: AppBar(
          title: Text(
            "Roy Texttile & Tailors (Pvt) Ltd",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          actions: [
            Text(
              DateFormat.jm().format(DateTime.now()),
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
          backgroundColor: Colors.blue,
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
        ),
        body: Center(
          child: Stack(children: [
          
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
          child:SingleChildScrollView(
                scrollDirection: Axis.vertical,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => order_table()),
                                );
                              },
                              child: Container(
                                height: 150,
                                width: 350,
                                color: Color.fromARGB(255, 3, 70, 47),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Orders",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 20),
                                          ),
                                          Text(
                                            "$orderCount",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 78),
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        'assets/orders.png',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => customer()),
                                );
                              },
                              child: Container(
                                height: 150,
                                width: 350,
                                color: Color.fromARGB(255, 141, 24, 15),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Customers",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 20),
                                          ),
                                          Text(
                                            "$customerCount",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 78),
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        'assets/customers.png',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Pending_job()),
                                );
                              },
                              child: Container(
                                height: 150,
                                width: 350,
                                color: Color.fromARGB(255, 6, 179, 223),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pendding Job",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 20),
                                          ),
                                          Text(
                                            "$pendingJobCount",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 78),
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        'assets/pending_job.png',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Finish_Job()),
                                );
                              },
                              child: Container(
                                height: 150,
                                width: 350,
                                color: Color.fromARGB(255, 235, 57, 205),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Finish Job",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 20),
                                          ),
                                          Text(
                                            "$finishJobCount",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 78),
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        'assets/job_card.png',
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => emp()),
                              );
                            },
                            child: Container(
                              height: 150,
                              width: 350,
                              color: Color.fromARGB(255, 228, 165, 49),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Employees",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        Text(
                                          "$employeeCount",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 78),
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      'assets/employee.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => job_card_table(),
                                ),
                              );
                            },
                            child: Container(
                              height: 150,
                              width: 350,
                              color: Color.fromARGB(255, 9, 47, 172),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Job Card",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        Text(
                                          "$jobCardCount",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 78),
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      'assets/job.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Expenses(
                                    updateTotalExpenses: (double totalExpenses) {
                                      setState(() {
                                        this.totalExpenses = totalExpenses;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 150,
                              width: 350,
                              color: Color.fromARGB(255, 2, 94, 14),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Expenses",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        // Text(
                                        //   "$totalExpenses",
                                        //   style: TextStyle(
                                        //       color: Colors.white, fontSize: 58),
                                        // ),
                                      ],
                                    ),
                                    Image.asset(
                                      'assets/expe.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => supplier()),
                              );
                            },
                            child: Container(
                              height: 150,
                              width: 350,
                              color: Color.fromARGB(255, 175, 89, 8),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Supplier",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        Text(
                                          "$employeeCount",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 78),
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      'assets/suppliers.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 70,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                PieChart(
                                  dataMap: dataMap,
                                  animationDuration: Duration(milliseconds: 800),
                                  chartLegendSpacing: 32,
                                  chartRadius:
                                      MediaQuery.of(context).size.width / 5,
                                  colorList: colorList,
                                  initialAngleInDegree: 0,
                                  chartType: ChartType.disc,
                                  ringStrokeWidth: 32,
                                  centerText: "ORDERS",
                                  legendOptions: LegendOptions(
                                    showLegendsInRow: false,
                                    legendPosition: LegendPosition.right,
                                    showLegends: true,
                                    legendShape:
                                        BoxShape.circle, // Fixed the typo here
                                    legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  chartValuesOptions: ChartValuesOptions(
                                    showChartValueBackground: true,
                                    showChartValues: true,
                                    showChartValuesInPercentage: false,
                                    showChartValuesOutside: false,
                                    decimalPlaces: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                PieChart(
                                  dataMap: dataMap,
                                  animationDuration: Duration(milliseconds: 800),
                                  chartLegendSpacing: 32,
                                  chartRadius:
                                      MediaQuery.of(context).size.width / 5,
                                  colorList: colorList,
                                  initialAngleInDegree: 0,
                                  chartType:
                                      ChartType.ring, // Set the chartType to ring
                                  ringStrokeWidth: 32,
                                  centerText: "CUSTOMERS",
                                  legendOptions: LegendOptions(
                                    showLegendsInRow: false,
                                    legendPosition: LegendPosition.right,
                                    showLegends: true,
                                    legendShape: BoxShape.circle,
                                    legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  chartValuesOptions: ChartValuesOptions(
                                    showChartValueBackground: true,
                                    showChartValues: true,
                                    showChartValuesInPercentage: false,
                                    showChartValuesOutside: false,
                                    decimalPlaces: 1,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                PieChart(
                                  dataMap: dataMap,
                                  animationDuration: Duration(milliseconds: 800),
                                  chartLegendSpacing: 32,
                                  chartRadius:
                                      MediaQuery.of(context).size.width / 5,
                                  colorList: colorList,
                                  initialAngleInDegree: 0,
                                  chartType: ChartType.disc,
                                  ringStrokeWidth: 32,
                                  centerText: "JOB",
                                  legendOptions: LegendOptions(
                                    showLegendsInRow: false,
                                    legendPosition: LegendPosition.right,
                                    showLegends: true,
                                    legendShape:
                                        BoxShape.circle, // Fixed the typo here
                                    legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  chartValuesOptions: ChartValuesOptions(
                                    showChartValueBackground: true,
                                    showChartValues: true,
                                    showChartValuesInPercentage: false,
                                    showChartValuesOutside: false,
                                    decimalPlaces: 1,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ]))),
            ),
          ]),
        ));
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
