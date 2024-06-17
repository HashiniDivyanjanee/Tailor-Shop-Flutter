import 'package:flutter/material.dart';
import 'package:tailer_shop/Const/constant.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: cardBackgroundColor,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            contentPadding: EdgeInsets.symmetric(vertical: 5),
            hintText: 'Search',
            prefixIcon: Icon(Icons.search,
                color: const Color.fromARGB(255, 27, 27, 27), size: 21)),
      ),
    );
  }
}
