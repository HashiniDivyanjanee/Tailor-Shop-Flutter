import 'package:flutter/material.dart';
import 'package:tailer_shop/View/Navigation%20Bar/nav_head.dart';
import 'package:tailer_shop/View/Navigation%20Bar/navigation_bottom.dart';

class Navigation_Bar extends StatelessWidget {
  const Navigation_Bar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(flex:2, child: NavHeader()),
      Expanded(flex:10,child: NavigationBottom()),
    ]);
  }
}
