import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailer_shop/View/Supplier/footer.dart';
import 'package:tailer_shop/View/Supplier/header.dart';
import 'package:tailer_shop/View/Supplier/show_table.dart';
import 'package:tailer_shop/Viewmodel/supplier_view_model.dart';

class RightSupplier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SupplierViewModel>(
      create: (context) => SupplierViewModel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: SupplierHeader()),
      
          Flexible(
            flex: 10,
            child: SupplierView(),
          ),
          Flexible(
            child: SupplierFooter(),
          ),
        ],
      ),
    );
  }
}
