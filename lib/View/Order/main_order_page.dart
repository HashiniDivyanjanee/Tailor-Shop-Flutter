import 'package:flutter/material.dart';
import 'package:tailer_shop/View/Customer/RightSide.dart';
import 'package:tailer_shop/View/Navigation%20Bar/navigation_bar.dart';

class MainOrderPage extends StatelessWidget {
  const MainOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          Expanded(flex: 2, child: Navigation_Bar()),
          Expanded(flex: 10, child: RightCustomer()),
        ],
      )),
    );
  }
}
