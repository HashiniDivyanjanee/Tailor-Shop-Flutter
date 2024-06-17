import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class jobPopup extends StatefulWidget {
  final Map<String, dynamic> jobCardData;
  jobPopup({required this.jobCardData});
  @override
  _jobPopupState createState() => _jobPopupState();
}

class _jobPopupState extends State<jobPopup> {
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController advanceController = TextEditingController();
  TextEditingController paymentStatusController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  String selectedEmployee = '';
  String _selectedMethod = 'Default';
  String _selectedStatus = 'Pending';
  String _selectedItemStatus = 'Processing';
  List<String> employeeNames = [];

  @override
  void initState() {
    super.initState();
    fetchEmployeeNames();
    customerPhoneController.text = '${widget.jobCardData['customerPhone']}';
    customerNameController.text = '${widget.jobCardData['customerName']}';
    _selectedMethod = '${widget.jobCardData['paymentStatus']}';
    _selectedStatus = '${widget.jobCardData['status']}';
    advanceController.text = '${widget.jobCardData['advance']}';
    _dateController.text = '${widget.jobCardData['dueDate']}';
    selectedEmployee = '${widget.jobCardData['empName']}';
    _selectedItemStatus = '${widget.jobCardData['job_status']}';
  }

  Future<void> updateJobCard() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/Tailer/update_job_card.php'),
      body: {
        'job_no': '${widget.jobCardData['job_no']}',
        'customerName': customerNameController.text,
        'customerPhone': customerPhoneController.text,
        'dueDate': _dateController.text,
        'advance': advanceController.text,
        'paymentStatus': _selectedMethod,
        'status': _selectedStatus,
        'job_status': _selectedItemStatus,
        'empName': selectedEmployee,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job card Updated Successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Update Job Card'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 224, 224, 224),
      contentPadding: EdgeInsets.symmetric(horizontal: 100),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Center(
          child: Text(
            'UPDATE JOB CARD DETAILS',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'JOB ID: ${widget.jobCardData['job_no']}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              controller: customerNameController,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Customer Name',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: customerPhoneController,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Customer Phone Number',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  setState(() {
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(selectedDate);
                  });
                }
              },
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Delivery Date',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
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
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: advanceController,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Advance Payment',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
                fillColor: const Color.fromARGB(255, 255, 255, 255),
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
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Delivery ',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
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
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              value: _selectedItemStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItemStatus = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Job Status ',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
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
                'Processing',
                'Complete',
              ].map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              value: employeeNames.isNotEmpty
                  ? (selectedEmployee.isNotEmpty
                      ? selectedEmployee
                      : employeeNames.first)
                  : null, 
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
                labelText: 'Tailor Name',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    updateJobCard();
                  },
                  child: const Text(
                    'Update',
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
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
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
        ]),
      ],
    );
  }
}
