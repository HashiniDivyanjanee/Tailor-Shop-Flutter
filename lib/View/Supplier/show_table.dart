import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailer_shop/Const/constant.dart';
import 'package:tailer_shop/Viewmodel/supplier_view_model.dart';

class SupplierView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SupplierViewModel(),
      child: SupplierPage(),
    );
  }
}

class SupplierPage extends StatefulWidget {
  @override
  _SupplierPageState createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SupplierViewModel>(context, listen: false).fetchSupplier();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SupplierViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(child: Text('Error: ${viewModel.errorMessage}'));
          } else if (viewModel.suppliers.isEmpty) {
            return Center(child: Text('No Supplier found'));
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
                        Provider.of<SupplierViewModel>(context, listen: false)
                            .searchSupplier(value),
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
                      columnSpacing: 390,
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromRGBO(201, 202, 202, 1),
                      ),
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Supplier')),
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('Phone')),
                      ],
                      rows: viewModel.suppliers.map((supplier) {
                        return DataRow(cells: [
                          DataCell(Text(supplier.supplierID)),
                          DataCell(Text(supplier.supplierName)),
                          DataCell(Text(supplier.address)),
                          DataCell(Text(supplier.phone)),
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
