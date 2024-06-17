import 'package:flutter/material.dart';
import 'package:tailer_shop/Const/constant.dart';

class NavHeader extends StatelessWidget {
  const NavHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAccountsDrawerHeader(
              accountName: Text('Hashini Divyanjanee'),
              accountEmail: Text('0769070920'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(child: Image.asset('assets/person.png')),
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color.fromRGBO(31, 30, 30, 1),
                   Color.fromRGBO(31, 30, 30, 1),
                ]),
              ),
            ),
      ],
    );
  }
}
