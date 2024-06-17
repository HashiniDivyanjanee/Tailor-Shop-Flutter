import 'package:flutter/material.dart';

class Sewing extends StatefulWidget {
  Sewing({Key? key}) : super(key: key);

  @override
  _SewingState createState() => _SewingState();
}

class _SewingState extends State<Sewing> {
  String? selectedApparel;
  List<String> apparelItems = ['Women', 'Men', 'Children\'s'];
  String? DressSize;
  List<String> DressSizeItems = ['Mini', 'Midi', 'Maxi'];
  bool showDresses = false;
  bool jeans = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sewing'),
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
    // Implement your mobile view here
    return Column(
      children: [
        // Employee Data section
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Employee Data'),
              SizedBox(height: 8),
              Text('Label:'),
              SizedBox(width: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter value',
                ),
              ),
              SizedBox(height: 8),
              Text('Label:'),
              SizedBox(width: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter value',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'City',
                ),
              ),
            ],
          ),
        ),

        // Customer Data section
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer Data'),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'City',
                ),
              ),
            ],
          ),
        ),

        // Product Details section
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product Details'),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Product Name',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Quantity',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDesktopView() {
    // Implement your desktop view here
    return Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40)),
                      color: Color.fromARGB(255, 203, 228, 245),
                    ),
                    padding: EdgeInsets.only(left: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: Column(
                        children: [
                          Text(
                            'Customer Details',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                  ),
                                ),
                              ),
                              SizedBox(width: 18),
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Address',
                                  ),
                                ),
                              ),
                              SizedBox(width: 18),
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Gender',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)),
                      color: Color.fromARGB(255, 183, 190, 194),
                    ),
                    padding: EdgeInsets.only(left: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Employee Details',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                  ),
                                ),
                              ),
                              SizedBox(width: 18),
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Address',
                                  ),
                                ),
                              ),
                              SizedBox(width: 18),
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Position',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            // Product Details section
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(),
                      color: Color.fromARGB(255, 70, 94, 110),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        children: [
                          Text(
                            'Product Details',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Flexible(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Select Apparel',
                                  ),
                                  value: selectedApparel,
                                  onChanged: (String? newValue) {
                                    // Update the selected value
                                    setState(() {
                                      selectedApparel = newValue;
                                    });
                                  },
                                  items: apparelItems.map((String item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: selectedApparel == 'Women',
                                child: Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          bottomRight: Radius.circular(40)),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    padding: EdgeInsets.only(left: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(50),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      jeans = false;
                                                      showDresses = true;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 90,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 255, 255, 255),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Image.asset(
                                                        'assets/dresses.png'),
                                                  ),
                                                ),
                                                SizedBox(width: 18),
                                                Container(
                                                  height: 90,
                                                  width: 90,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Image.asset(
                                                      'assets/crop-top.png'),
                                                ),
                                                SizedBox(width: 18),
                                                Container(
                                                  height: 90,
                                                  width: 90,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Image.asset(
                                                      'assets/skirt.png'),
                                                ),
                                              ]),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    jeans = true;
                                                    showDresses = false;
                                                  });
                                                },
                                                child: Container(
                                                  height: 90,
                                                  width: 90,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Image.asset(
                                                      'assets/trousers.png'),
                                                ),
                                              ),
                                              SizedBox(width: 18),
                                              Container(
                                                height: 90,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Image.asset(
                                                    'assets/jumpsuit.png'),
                                              ),
                                              SizedBox(width: 18),
                                              Container(
                                                height: 90,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Image.asset(
                                                    'assets/short.png'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: selectedApparel ==
                                    'Men', // Show dropdown to select Women for Men's apparel
                                child: Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          bottomRight: Radius.circular(40)),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    padding: EdgeInsets.only(left: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(50),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Select Women',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: selectedApparel ==
                                    'Children\'s', // Show dropdown to select Women for Men's apparel
                                child: Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          bottomRight: Radius.circular(40)),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    padding: EdgeInsets.only(left: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(50),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Welcome Childrens',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
                Visibility(
                  visible: showDresses,
                  child: Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(),
                        color: Color.fromARGB(255, 194, 243, 235),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Dress Sizes',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Bust',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 48),
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Waist',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Hips',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 48),
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Length',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Shoulder Width',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 48),
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Arm Length',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Neck Circumference',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 48),
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Back Width',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      'Dress Size',
                                    ),
                                    value: DressSize,
                                    onChanged: (String? newValue) {
                                      // Update the selected value
                                      DressSize = newValue;
                                    },
                                    items: DressSizeItems.map((String item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(width: 48),
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Additional measurements',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Additional measurements',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
                Visibility(
                  visible: jeans,
                  child: Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(),
                        color: Color.fromARGB(255, 194, 243, 235),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'jeans Sizes',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 18),
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Address',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 18),
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Position',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
