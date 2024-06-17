import 'package:flutter/material.dart';
import 'package:tailer_shop/View/Navigation%20Bar/navigation_bar.dart';
import 'package:tailer_shop/View/Supplier/RightSide.dart';

class MainSupplierPage extends StatelessWidget {
  const MainSupplierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          Expanded(flex: 2, child: Navigation_Bar()),
          Expanded(flex: 10, child: RightSupplier()),
        ],
      )),
    );
  }
}
