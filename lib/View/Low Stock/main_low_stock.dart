import 'package:flutter/material.dart';
import 'package:tailer_shop/View/Low%20Stock/all_part_show.dart';
import 'package:tailer_shop/View/Navigation%20Bar/navigation_bar.dart';

class MainLowStock extends StatelessWidget {
  const MainLowStock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          Expanded(flex: 2,child: Navigation_Bar(),),
          Expanded(flex: 10, child: LowStock()),
        ],
      )),
    );
  }
}
