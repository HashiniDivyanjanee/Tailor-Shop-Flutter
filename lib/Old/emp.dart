import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tailer_shop/Old/nav.dart';

class emp extends StatefulWidget {
  const emp({Key? key}) : super(key: key);

  @override
  _empState createState() => _empState();
}

class _empState extends State<emp> {
  List<dynamic> employeeData = [];
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

//Start Load Employee
   Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1/Tailer/employee.php'));

    if (response.statusCode == 200) {
      setState(() {
        employeeData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
//End Load Employee

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
        title: Text('Employee'),
        actions: [
          Expanded(
            child: EmpSearchBar(onSearch: (value) {
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
                  color: const Color.fromARGB(255, 255, 255,
                      255), // Change this color to the desired border color
                  width: 5.0, // Change this value to the desired border width
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmployeeForm()),
                    );
                  },
                  child: const Text(
                    'ADD NEW EMPLOYEE',
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
    return ListView.builder(
      itemCount: employeeData.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeForm()),
              );
            },
            child: Text('Add Employee'),
          );
        } else {
          final employee = employeeData[index - 1];
          return ListTile(
            title: Text('${employee['no']} ${employee['full_name']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address: ${employee['address']}'),
                Text('Phone: ${employee['phone']}'),
                Text('NIC: ${employee['nic']}'),
                Text('Gender: ${employee['gender']}'),
                Text('DOB: ${employee['dob']}'),
                Text('Position: ${employee['position']}'),
                Text('Start Date: ${employee['startdate']}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // editEmployee(context, employee);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteEmployeeFromDatabase(employee);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void deleteEmployee(int index) {
    setState(() {
      employeeData.removeAt(index);
    });
  }

  void editEmployee(BuildContext context, Map<String, dynamic> employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeEditForm(employee: employee),
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
              padding: const EdgeInsets.only(top: 10),
              
              child: DataTable(
                  columnSpacing: 270,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Color.fromRGBO(3, 191, 203, 1),
                ),
                columns: [
                  DataColumn(
                      label: Text('EID',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Name',
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
                      label: Text('NIC',
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
                      label: Text('DOB',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Position',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Start Date',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  DataColumn(
                      label: Text('Actions',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                ],
                rows: employeeData
                    .where((employee) =>
                        employee['full_name']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()) ||
                        employee['phone']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()) ||
                        employee['nic']
                            .toLowerCase()
                            .contains(searchTerm.toLowerCase()))
                    .map(
                      (employee) => DataRow(
                        cells: [
                          DataCell(Text('${employee['no']}')),
                          DataCell(Text('${employee['full_name']}')),
                          DataCell(Text('${employee['address']}')),
                          DataCell(Text('${employee['phone']}')),
                          DataCell(Text('${employee['nic']}')),
                          DataCell(Text('${employee['gender']}')),
                          DataCell(Text('${employee['dob']}')),
                          DataCell(Text('${employee['position']}')),
                          DataCell(Text('${employee['startdate']}')),
                          DataCell(
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    editEmployee(context, employee);
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
                                    deleteEmployeeFromDatabase(employee);
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

  void deleteEmployeeFromDatabase(Map<String, dynamic> employee) async {
    try {
      String uri = "http://127.0.0.1/Tailer/emoDelete.php";
      var res = await http.post(Uri.parse(uri), body: {
        "action": "delete",
        "no": employee['no'].toString(),
      });
      var response = jsonDecode(res.body);
      if (response["success"] == true) {
        setState(() {
          employeeData.removeWhere((e) => e['no'] == employee['no']);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Employee deleted successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete employee'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}

class EmployeeForm extends StatefulWidget {
  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  TextEditingController _efullName = TextEditingController();
  TextEditingController _eaddress = TextEditingController();
  TextEditingController _ephone = TextEditingController();
  TextEditingController _enic = TextEditingController();

  TextEditingController _edob = TextEditingController();
  TextEditingController _eposition = TextEditingController();
  TextEditingController _estartDate = TextEditingController();
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
    if (_efullName.text.isNotEmpty &&
        _eaddress.text.isNotEmpty &&
        _ephone.text.isNotEmpty &&
        _enic.text.isNotEmpty &&
        _edob.text.isNotEmpty &&
        _eposition.text.isNotEmpty &&
        _estartDate.text.isNotEmpty) {
      try {
        String uri = "http://127.0.0.1/Tailer/employeeReg.php";
        String gender = _selectedGender == 0 ? "Male" : "Female";
        var res = await http.post(Uri.parse(uri), body: {
          "full_name": _efullName.text,
          "address": _eaddress.text,
          "phone": _ephone.text,
          "nic": _enic.text,
          "gender": gender,
          "dob": _edob.text,
          "position": _eposition.text,
          "startdate": _estartDate.text,
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

          _efullName.clear();
          _eaddress.clear();
          _ephone.clear();
          _enic.clear();
          _edob.clear();
          _eposition.clear();
          _estartDate.clear();

          setState(() {
            // String gender = _selectedGender == 0 ? "Male" : "Female";
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Some Issues'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print(e);
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
        title: Text('Employee Registration'),
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
                controller: _efullName,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _eaddress,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ephone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _enic,
                decoration: InputDecoration(labelText: 'NIC'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _edob,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, _edob),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _eposition,
                decoration: InputDecoration(labelText: 'Position'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _estartDate,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, _estartDate),
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

class EmpSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const EmpSearchBar({required this.onSearch});

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

class EmployeeEditForm extends StatefulWidget {
  final Map<String, dynamic> employee;

  EmployeeEditForm({required this.employee});

  @override
  _EmployeeEditFormState createState() => _EmployeeEditFormState();
}

class _EmployeeEditFormState extends State<EmployeeEditForm> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _eaddress = TextEditingController();
  TextEditingController _ephone = TextEditingController();
  TextEditingController _enic = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.employee['full_name'];
    _eaddress.text = widget.employee['address'];
    _ephone.text = widget.employee['phone'];
    _enic.text = widget.employee['nic'];
  }

  Future<void> updateEmployeeData() async {
    try {
      String uri = "http://127.0.0.1/Tailer/empUpdate.php";
      var response = await http.post(
        Uri.parse(uri),
        body: {
          "action": "update",
          "no": widget.employee['no'].toString(),
          "full_name": _fullNameController.text,
          "address": _eaddress.text,
          "phone": _ephone.text,
          "nic": _enic.text,
        },
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        // Update local state
        setState(() {
          widget.employee['full_name'] = _fullNameController.text;
          widget.employee['address'] = _eaddress.text;
          widget.employee['phone'] = _ephone.text;
          widget.employee['nic'] = _enic.text;
        });

        // Handle successful update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Employee data updated successfully!'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
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
                controller: _eaddress,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ephone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _enic,
                decoration: InputDecoration(labelText: 'NIC'),
              ),
              SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  updateEmployeeData();
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
                        updateEmployeeData();
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

Future<void> _selectDate(
    BuildContext context, TextEditingController controller) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );

  if (picked != null && picked != DateTime.now()) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Date selected: ${picked.toString().split(' ')[0]}'),
        ),
      );

      controller.text = picked.toString().split(' ')[0];
    } catch (e) {
      print('Error updating date: $e');
    }
  }
}
