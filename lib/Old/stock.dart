import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tailer_shop/Old/home.dart';
import 'dart:convert';

class stock extends StatefulWidget {
  const stock({super.key});

  @override
  State<stock> createState() => _stockState();
}

class _stockState extends State<stock> {
  List<String> matchingSuppliers = [];
  String _selectedType = 'Fabrics';
  String _selectedItems = 'Cotton';
  TextEditingController qty = TextEditingController();
  TextEditingController unit_price = TextEditingController();
  TextEditingController total_price = TextEditingController();
  TextEditingController supplierName = TextEditingController();
  // String selectedSupplier = '';
  // List<String> supplierNames = [];

  List<dynamic> supplierData = [];

  @override
  void initState() {
    super.initState();
  }

  // Future<void> fetchSupplierName() async {
  //   final response = await http
  //       .get(Uri.parse('http://192.168.8.130/Tailer/supplierName.php'));

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       supplierNames = List<String>.from(json.decode(response.body));
  //     });
  //   } else {
  //     throw Exception('Failed to load Supplier` names');
  //   }
  // }

  Future<void> insertmaterial() async {
    if (qty.text != "" ||
        unit_price.text != "" ||
        total_price.text != "" ||
        supplierName.text != "") {
      try {
        String uri = "http://192.168.8.130/Tailer/material.php";
        var res = await http.post(Uri.parse(uri), body: {
          "category": _selectedType,
          "name": _selectedItems,
          "qty": qty.text,
          "unit_price": unit_price.text,
          "total_price": total_price.text,
          "supplier": supplierName.text,
        });
        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          print("Success");
        } else {
          print("Some Issue");
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("Please fill all fields");
    }
  }

  Map<String, List<String>> _itemsMap = {
    'Fabrics': [
      'Cotton',
      'Wool',
      'Silk',
      'Linen',
      'Polyester',
      'Denim',
      'Velvet',
      'Satin',
      'Lace',
      'Chiffon'
    ],
    'Notions': [
      'Buttons',
      'Zippers',
      'Hooks and eyes',
      'Snaps',
      'Velcro',
      'Elastic',
      'Ribbons',
      'Bias tape',
      'Piping'
    ],
    'Measuring and Cutting Tools': [
      'Tape',
      'Measure',
      'Scissors',
      'Shears',
      'Rotary cutter',
      'Cutting mat',
      'Rulers'
    ],
    'Sewing Machines and Accessories': [
      'Sewing machines',
      'Needles',
      'Bobbins',
      'Presser feet',
    ],
    'Marking Tools': ['Chalk', 'Fabric Markers', 'Pins and needles'],
    'Iron and Ironing Board': ['Steam iron', 'Ironing board'],
    'Miscellaneous': ['Dress forms', 'Thimbles', 'Seam ripper', 'Sewing gauge']
  };

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
        title: Text('Stock'),
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

  Widget buildMobileView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Mobile Payment View',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget buildDesktopView() {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, top: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  insertmaterial();
                                },
                                child: const Text(
                                  'Submit',
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
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 100,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  qty.clear();
                                  unit_price.clear();
                                  total_price.clear();
                                },
                                child: const Text(
                                  'Clear all',
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
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 100,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                  );
                                },
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 50, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: supplierName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Supplier Name',
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
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
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
                            items: _itemsMap.keys.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Second Row
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 50, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: unit_price,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Unit Price',
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
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: qty,
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
                        ),
                        SizedBox(width: 50),
                        Expanded(
                          child: TextFormField(
                            controller: total_price,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Total Price',
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
