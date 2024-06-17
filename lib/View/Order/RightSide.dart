import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailer_shop/View/Order/footer.dart';
import 'package:tailer_shop/View/Order/header.dart';
import 'package:tailer_shop/View/Order/show_table.dart';
import 'package:tailer_shop/Viewmodel/customer_view_model.dart';

class RightOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CustomerViewModel>(
      create: (context) => CustomerViewModel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: OrderHeader()),
      
          Flexible(
            flex: 10,
            child: OrderView(),
          ),
          Flexible(
            child: OrderFooter(),
          ),
        ],
      ),
    );
  }
}
