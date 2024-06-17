import 'package:flutter/material.dart';
import 'package:tailer_shop/Model/menu_model.dart';
import 'package:tailer_shop/View/dashboad.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.dashboard, title: 'Dashboad'),
    MenuModel(icon: Icons.production_quantity_limits, title: 'Product'),
    MenuModel(icon: Icons.person, title: 'Customer'),
    MenuModel(icon: Icons.person_3_outlined, title: 'Supplier'),
    MenuModel(icon: Icons.delivery_dining, title: 'Orders'),
    MenuModel(icon: Icons.view_comfortable_outlined, title: 'Job Card'),
    MenuModel(icon: Icons.report, title: 'Report'),
    MenuModel(icon: Icons.notification_add, title: 'Notification'),
    MenuModel(icon: Icons.logout, title: 'Sign Out'),
  ];
}
