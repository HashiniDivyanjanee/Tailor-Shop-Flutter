import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailer_shop/Const/constant.dart';
import 'package:tailer_shop/Viewmodel/customer_view_model.dart';

class CustomerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CustomerViewModel(),
      child: CustomersPage(),
    );
  }
}

class CustomersPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerViewModel>(context, listen: false).fetchCustomer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CustomerViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(child: Text('Error: ${viewModel.errorMessage}'));
          } else if (viewModel.customers.isEmpty) {
            return Center(child: Text('No Cusomers found'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 380,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 2),
                  child: TextField(
                    onChanged: (value) =>
                        Provider.of<CustomerViewModel>(context, listen: false)
                            .searchCustomer(value),
                    decoration: InputDecoration(
                      labelText: "Search",
                      labelStyle: TextStyle(color: cardBackgroundColor),
                      prefixIcon:
                          Icon(Icons.search, color: cardBackgroundColor),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: cardBackgroundColor, width: 3.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: cardBackgroundColor, width: 2.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: DataTable(
                      columnSpacing: 290,
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromRGBO(201, 202, 202, 1),
                      ),
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Customer')),
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Gender')),
                     
                      ],
                      rows: viewModel.customers.map((customer) {
                        return DataRow(cells: [
                            DataCell(Text(customer.cid)),
                        DataCell(Text(customer.fullName)),
                        DataCell(Text(customer.address)),
                        DataCell(Text(customer.phone)),
                        DataCell(Text(customer.gender ?? 'Not specified')),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
