import 'package:flutter/material.dart';
import 'package:tailer_shop/View/Current%20Stock/footer.dart';
import 'package:tailer_shop/View/Current%20Stock/header.dart';
import 'package:tailer_shop/View/Current%20Stock/show_table.dart';
import 'package:provider/provider.dart';
import 'package:tailer_shop/Viewmodel/current_stock_view_model.dart.dart';

class CurrentStock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductViewModel>(
      create: (context) => ProductViewModel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: CurrentStockHeader()),
      
          Flexible(
            flex: 10,
            child: Stock(),
          ),
          Flexible(
            child: CurrentStockFooter(),
          ),
        ],
      ),
    );
  }
}
