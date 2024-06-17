import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailer_shop/Const/constant.dart';
import 'package:tailer_shop/Viewmodel/current_stock_view_model.dart.dart';

class Stock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductViewModel(),
      child: ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductViewModel>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(child: Text('Error: ${viewModel.errorMessage}'));
          } else if (viewModel.products.isEmpty) {
            return Center(child: Text('No products found'));
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
                        Provider.of<ProductViewModel>(context, listen: false)
                            .searchProduct(value),
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
                      columnSpacing: 155,
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Color.fromRGBO(201, 202, 202, 1),
                      ),
                      columns: const [
                        DataColumn(label: Text('Product')),
                        DataColumn(label: Text('Cost Price')),
                        DataColumn(label: Text('Sale Price')),
                        DataColumn(label: Text('Discount')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Color')),
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Range')),
                      ],
                      rows: viewModel.products.map((product) {
                        return DataRow(cells: [
                          DataCell(Text(product.product)),
                          DataCell(Text(product.costPrice.toStringAsFixed(2))),
                          DataCell(Text(product.salePrice.toStringAsFixed(2))),
                          DataCell(Text(product.discount.toStringAsFixed(2))),
                          DataCell(Text(product.qty.toString())),
                          DataCell(Text(product.color)),
                          DataCell(Text(product.category)),
                          DataCell(Text(product.range)),
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
