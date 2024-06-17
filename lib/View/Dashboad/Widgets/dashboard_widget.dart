import 'package:flutter/material.dart';
import 'package:tailer_shop/View/Dashboad/Widgets/card_widget.dart';
import 'package:tailer_shop/View/Dashboad/Widgets/header_widget.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(
          height: 18,
        ),
        HeaderWidget(),
        SizedBox(
          height: 18,
        ),
        CardWidget(),
         SizedBox(
          height: 18,
        ),
      
      ],
    );
  }
}
