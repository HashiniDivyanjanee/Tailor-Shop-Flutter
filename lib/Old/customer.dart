import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class customer extends StatefulWidget {
  const customer({Key? key}) : super(key: key);

  @override
  _cusState createState() => _cusState();
}

class _cusState extends State<customer> {
  List<dynamic> customerData = [];
  String searchTerm = "";

//Start Load Customer
  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1/Tailer/customer.php'));

    if (response.statusCode == 200) {
      print(
          'Response body: ${response.body}'); // Add this line to check the response body
      setState(() {
        customerData = json.decode(response.body);
        print(customerData);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
//End Load Customer


  @override
  void initState() {
    super.initState();
    fetchData();
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
      
        actions: [
           Padding(
             padding: const EdgeInsets.only(left: 50.0),
             child: Text('CUSTOMER',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
           ),
         Expanded(
            child: customerSearchBar(onSearch: (value) {
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
                  color: const Color.fromARGB(255, 255, 255, 255), 
                  width: 5.0, 
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerForm()),
                  );
                  },
                  child: const Text(
                    'ADD NEW CUSTOMER',
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
          // Add mobile-specific content here
        ],
      ),
    );
  }

  void deleteCustomer(int index) {
    // Perform the deletion logic here
    setState(() {
      customerData.removeAt(index);
    });
  }

  void editCustomer(BuildContext context, Map<String, dynamic> customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerEditForm(customer: customer),
      ),
    );
  }

  Widget buildDesktopView() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: DataTable(
                   columnSpacing: 270,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Color.fromRGBO(3, 191, 203, 1),
                ),
                columns: [
                  DataColumn(
                      label: Text('CID',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Full Name',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Address',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Phone',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Gender',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Actions',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.white))), 
                ],
                rows: customerData
                    .where((customer) =>
                        customer['full_name']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()) ||
                        customer['phone']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()))
                    .map(
                      (customer) => DataRow(
                        cells: [
                          DataCell(Text('${customer['cid']}')),
                          DataCell(Text('${customer['full_name']}')),
                          DataCell(Text('${customer['address']}')),
                          DataCell(Text('${customer['phone']}')),
                          DataCell(Text('${customer['gender']}')),
                          DataCell(
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    editCustomer(context, customer);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 38, 186, 238),
                                    ),
                                  ),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    deleteCustomerFromDatabase(context, customer,
                                        () {
                                      setState(() {
                                        customerData.removeWhere(
                                            (e) => e['cid'] == customer['cid']);
                                      });
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color.fromARGB(255, 148, 27, 18),
                                    ),
                                  ),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
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
}

void deleteCustomerFromDatabase(BuildContext context,
    Map<String, dynamic> customer, Function() updateState) async {
  try {
    String uri = "http://127.0.0.1/Tailer/customerDelete.php";
    var res = await http.post(Uri.parse(uri), body: {
      "action": "delete",
      "cid": customer['cid'].toString(),
    });
    var response = jsonDecode(res.body);
    if (response["success"] == true) {
      updateState();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer deleted successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete Customer'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    print(e);
  }
}

class CustomerForm extends StatefulWidget {
  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  TextEditingController _cfullName = TextEditingController();
  TextEditingController _caddress = TextEditingController();
  TextEditingController _cphone = TextEditingController();
  int _selectedGender = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> insertrecord() async {
    if (_cfullName.text.isNotEmpty &&
        _caddress.text.isNotEmpty &&
        _cphone.text.isNotEmpty) {
      try {
        String uri = "http://127.0.0.1/Tailer/customerAdd.php";
        String gender = _selectedGender == 0 ? "Male" : "Female";
        var res = await http.post(Uri.parse(uri), body: {
          "full_name": _cfullName.text,
          "address": _caddress.text,
          "phone": _cphone.text,
          "gender": gender,
        });
        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Record Inserted successfully!'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );

          _cfullName.clear();
          _caddress.clear();
          _cphone.clear();

          setState(() {
          
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Some Issues. Please check again'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('This number is already registered'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Fill all Fields'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Registration'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600,
          ),
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _cfullName,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _caddress,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _cphone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              SizedBox(height: 16),
              Text("Gender"),
              Row(
                children: [
                  Radio(
                    value: 0,
                    groupValue: _selectedGender,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio(
                    value: 1,
                    groupValue: _selectedGender,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  insertrecord();
                },
                child: Container(
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(colors: [
                      Color.fromRGBO(152, 238, 204, 1),
                      Color.fromRGBO(121, 224, 238, 1),
                    ]),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        insertrecord();
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 20,
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
      ),
    );
  }
}

class customerSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const customerSearchBar({required this.onSearch});

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

class CustomerEditForm extends StatefulWidget {
  final Map<String, dynamic> customer;

  CustomerEditForm({required this.customer});

  @override
  _CustomerEditFormState createState() => _CustomerEditFormState();
}

class _CustomerEditFormState extends State<CustomerEditForm> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _caddress = TextEditingController();
  TextEditingController _cphone = TextEditingController();
  int _selectedGender = 0;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.customer['full_name'];
    _caddress.text = widget.customer['address'];
    _cphone.text = widget.customer['phone'];
    _selectedGender = widget.customer['gender'] == 'Male' ? 0 : 1;
  }

  Future<void> updateCustomerData() async {
    try {
      String uri = "http://127.0.0.1/Tailer/customerUpdate.php";

      var response = await http.post(
        Uri.parse(uri),
        body: {
          "action": "update",
          "cid": widget.customer['cid'].toString(),
          "full_name": _fullNameController.text,
          "address": _caddress.text,
          "phone": _cphone.text,
          "gender": _selectedGender == 0 ? "Male" : "Female",
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData["success"] == true) {
         
        } else {
          print(
              'Failed to update Customer data: ${responseData["message"]}');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Customer data updated successfully!'),
            ),
          );
        }
      } else {
        print(
            'Failed to update Customer data. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update Customer data'),
          ),
        );
      }
    } catch (e) {
      print('Error updating Customer data: $e'); 
    }
  }

  Future<void> updateCustomer() async {
    await updateCustomerData();
  
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600,
          ),
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _caddress,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _cphone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              SizedBox(height: 16),
              Text("Gender"),
              Row(
                children: [
                  Radio(
                    value: 0,
                    groupValue: _selectedGender,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio(
                    value: 1,
                    groupValue: _selectedGender,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  updateCustomer();
                },
                child: Container(
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(colors: [
                      Color.fromRGBO(152, 238, 204, 1),
                      Color.fromRGBO(121, 224, 238, 1),
                    ]),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        updateCustomer();
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 20,
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
      ),
    );
  }
}