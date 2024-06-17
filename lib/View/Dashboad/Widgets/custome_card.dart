import 'package:flutter/material.dart';
import 'package:tailer_shop/Const/constant.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const CustomCard({super.key, this.color, this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: color ?? cardBackgroundColor,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}
