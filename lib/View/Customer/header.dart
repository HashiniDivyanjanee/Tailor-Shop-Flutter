import 'package:flutter/material.dart';
import 'package:tailer_shop/Const/constant.dart';

class CustomerHeader extends StatelessWidget {
  const CustomerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Text(
              "CUSTOMERS",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(color: cardBackgroundColor,thickness: 3,),
          ),
        ],
      ),
    );
  }
}
