import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Expenses extends StatefulWidget {
  final Function(double) updateTotalExpenses;

  const Expenses({Key? key, required this.updateTotalExpenses})
      : super(key: key);

  // ... rest of the code
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<dynamic> expensesData = [];
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1/Tailer/expenses_table.php'));

    if (response.statusCode == 200) {
      setState(() {
        expensesData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  String _selectedType = 'Rent';
  String _selectedPaymentMethod = 'Cash';
  TextEditingController _dateController = TextEditingController();
  TextEditingController _PaymentdateController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _invoiceController = TextEditingController();

  void submitExpense() async {
    String url = 'http://127.0.0.1/Tailer/expenses.php';
    Map<String, dynamic> data = {
      'exCategory': _selectedType,
      'paymentMethod': _selectedPaymentMethod,
      'invoiceNo': _invoiceController.text,
      'amount': _amountController.text,
      'description': _descriptionController.text,
      'exDate': _dateController.text,
      'paymentDate': _PaymentdateController.text,
    };

    try {
      final response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Record Inserted successfully!'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );

        _invoiceController.clear();
        _amountController.clear();
        _descriptionController.clear();
        _dateController.clear();
        _PaymentdateController.clear();
        await fetchData();

        double updatedTotalExpenses = calculateTotalExpenses();
        widget.updateTotalExpenses(updatedTotalExpenses);
        Navigator.pop(context, updatedTotalExpenses);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Some Issues'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Some Issues'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<dynamic>> fetchExpenses() async {
    String url = 'http://127.0.0.1/Tailer/expenses_table.php';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load expenses');
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
        title: Text('Expenses'),
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
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600,
          ),
          padding: const EdgeInsets.all(16.0),
          child: ListView(shrinkWrap: true, children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              items: ['Rent', 'Income']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              decoration: InputDecoration(labelText: 'Type'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              items: ['Cash', 'Credit Card', 'Bank Transfer']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              decoration: InputDecoration(labelText: 'Payment Method'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _invoiceController,
              decoration: InputDecoration(labelText: 'Invoice Number'),
            ),
            Container(
              height: 40,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(colors: [
                  Color.fromRGBO(3, 191, 203, 1),
                  Color.fromRGBO(3, 191, 203, 1),
                ]),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    // insertrecord();
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
          ]),
        ),
      ),
    );
  }

  Widget buildDesktopView() {
    double totalExpenses = calculateTotalExpenses();

    List<dynamic> sortedExpensesData = List.from(expensesData);
    sortedExpensesData
        .sort((a, b) => (b['exID'] ?? 0).compareTo(a['exID'] ?? 0));

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
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
                              submitExpense();
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
                              // submitExpense();
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
                              // submitExpense();
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
                padding: const EdgeInsets.only(right: 50, left: 50, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                        items: [
                          'Rent',
                          'Electricity Bill',
                          'Water Bill',
                          'Salaries',
                          'Materials and Supplies',
                          'Equipment and Machinery',
                          'Insurance',
                          'Marketing and Advertising',
                          'Transportation',
                          'Maintenance and Repairs',
                          'Taxes',
                          'Software and Technology',
                          'Other',
                        ]
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          labelText: 'Type',
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
                    SizedBox(width: 70),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                        items: ['Cash', 'Credit Card', 'Bank Transfer']
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          labelText: 'Payment Method',
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
                    SizedBox(width: 70),
                    Expanded(
                      child: TextFormField(
                        controller: _invoiceController,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Invoice No',
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
                    SizedBox(width: 70),
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount',
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
              SizedBox(height: 16),
              // Second Row
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _descriptionController,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Description',
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
                      width: 70,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (selectedDate != null &&
                              selectedDate != _dateController.text) {
                            setState(() {
                              _dateController.text = selectedDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0];
                            });
                          }
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Expenses Date',
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
                    SizedBox(width: 70),
                    Expanded(
                      child: TextFormField(
                        controller: _PaymentdateController,
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (selectedDate != null &&
                              selectedDate != _PaymentdateController.text) {
                            setState(() {
                              _PaymentdateController.text = selectedDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0];
                            });
                          }
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Payment Date',
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
              SizedBox(
                height: 50,
              ),

              Text(
                'Total Expenses: \Rs.${totalExpenses.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 56),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => const Color.fromRGBO(3, 191, 203, 1),
                    ),
                    columns: [
                      DataColumn(
                          label: Text('Expense ID',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      DataColumn(
                          label: Text('Type',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      DataColumn(
                          label: Text('Description',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      DataColumn(
                          label: Text('Invoice No',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      DataColumn(
                          label: Text('Expenses Date',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      DataColumn(
                          label: Text('Amount',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      DataColumn(
                          label: Text('Payment Method',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                      DataColumn(
                          label: Text('Payment Date',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                    ],
                    rows: sortedExpensesData
                        .where((expenses) =>
                            expenses['exCategory']
                                .toLowerCase()
                                .contains(searchTerm.toLowerCase()) ||
                            expenses['invoiceNo']
                                .toLowerCase()
                                .contains(searchTerm.toLowerCase()))
                        .map(
                          (expenses) => DataRow(
                            cells: [
                              DataCell(
                                  Text(expenses['exID']?.toString() ?? '')),
                              DataCell(Text(expenses['exCategory'] ?? '')),
                              DataCell(Text(expenses['description'] ?? '')),
                              DataCell(Text(expenses['invoiceNo'] ?? '')),
                              DataCell(Text(expenses['exDate'] ?? '')),
                              DataCell(
                                  Text(expenses['amount']?.toString() ?? '')),
                              DataCell(Text(expenses['paymentMethod'] ?? '')),
                              DataCell(Text(expenses['paymentDate'] ?? '')),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to calculate total expenses
  double calculateTotalExpenses() {
    DateTime currentDate = DateTime.now();
    DateTime thirtyDaysAgo = currentDate.subtract(Duration(days: 30));

    // Filter expenses within the last 30 days
    List<dynamic> filteredExpenses = expensesData.where((expenses) {
      DateTime expenseDate = DateTime.parse(expenses['paymentDate']);
      return expenseDate.isAfter(thirtyDaysAgo) &&
          expenseDate.isBefore(currentDate);
    }).toList();

    // Calculate the sum of amounts
    double totalExpenses = filteredExpenses
        .map((expenses) => double.parse(expenses['amount']))
        .fold(0, (previousValue, amount) => previousValue + amount);

    return totalExpenses;
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
