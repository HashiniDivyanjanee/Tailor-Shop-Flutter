import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailer_shop/Const/constant.dart';
import 'package:tailer_shop/Viewmodel/order_view_model.dart';

class OrderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderViewModel(),
      child: OrdersPage(),
    );
  }
}

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderViewModel>(context, listen: false).fetchOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OrderViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(child: Text('Error: ${viewModel.errorMessage}'));
          } else if (viewModel.orders.isEmpty) {
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
                        Provider.of<OrderViewModel>(context, listen: false)
                            .searchOrder(value),
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
                      columnSpacing: 180,
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromRGBO(201, 202, 202, 1),
                      ),
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Customer')),
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('Phone')),                      
                      ],
                      rows: viewModel.orders.map((order) {
                        return DataRow(cells: [
                          DataCell(Text(order.orderID)),
                          DataCell(Text(order.customerName)),
                          DataCell(Text(order.customerPhone)),
                          DataCell(Text(order.status)),                        
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
