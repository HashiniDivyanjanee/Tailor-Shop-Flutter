import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tailer_shop/View/Customer/footer.dart';
import 'package:tailer_shop/View/Customer/header.dart';
import 'package:tailer_shop/View/Customer/show_table.dart';
import 'package:tailer_shop/Viewmodel/customer_view_model.dart';

class RightCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CustomerViewModel>(
      create: (context) => CustomerViewModel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: CustomerHeader()),
      
          Flexible(
            flex: 10,
            child: CustomerView(),
          ),
          Flexible(
            child: CustomerFooter(),
          ),
        ],
      ),
    );
  }
}
