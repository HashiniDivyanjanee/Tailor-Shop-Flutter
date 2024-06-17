import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailer_shop/View/Low%20Stock/footer.dart';
import 'package:tailer_shop/View/Low%20Stock/header.dart';
import 'package:tailer_shop/View/Low%20Stock/show_table.dart';
import 'package:tailer_shop/Viewmodel/low_stock_view_model.dart';

class LowStock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LowProductViewModel>(
      create: (context) => LowProductViewModel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: LowStockHeader()),
      
          Flexible(
            flex: 10,
            child: LowStockPage(),
          ),
          Flexible(
            child: LowStockFooter(),
          ),
        ],
      ),
    );
  }
}
