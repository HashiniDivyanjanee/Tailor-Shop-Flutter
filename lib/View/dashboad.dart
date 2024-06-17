import 'package:flutter/material.dart';
import 'package:tailer_shop/View/Dashboad/Widgets/dashboard_widget.dart';
import 'package:tailer_shop/View/Dashboad/Widgets/side_menu_widget.dart';

class Dashboad extends StatefulWidget {
  const Dashboad({super.key});

  @override
  State<Dashboad> createState() => _DashboadState();
}

class _DashboadState extends State<Dashboad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              child: SideMenuWidget(),
            ),
          ),
          Expanded(
            flex: 7,
            child: DashboardWidget(),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.green,
            ),
          )
        ],
      )),
    );
  }
}
