import 'package:flutter/material.dart';
import 'package:tailer_shop/View/Current%20Stock/main_current_stock.dart';
import 'package:tailer_shop/View/Customer/main_customer_page.dart';
import 'package:tailer_shop/View/Low%20Stock/main_low_stock.dart';
import 'package:tailer_shop/View/Supplier/main_supplier_page.dart';
import 'package:tailer_shop/View/order_table.dart';
import 'package:tailer_shop/Old/customer.dart';
import 'package:tailer_shop/View/dashboad.dart';
import 'package:tailer_shop/Old/finish_job.dart';
import 'package:tailer_shop/Old/home.dart';
import 'package:tailer_shop/Old/job_card.dart';
import 'package:tailer_shop/Old/job_card_table.dart';
import 'package:tailer_shop/View/Login/login.dart';
import 'package:tailer_shop/Old/order_table.dart';
import 'package:tailer_shop/Old/pending_job.dart';
import 'package:tailer_shop/Old/place_order.dart';
import 'package:tailer_shop/Old/product.dart';
import 'package:tailer_shop/report/daily_cash_report.dart';
import 'package:tailer_shop/Old/supplier.dart';

class navbar extends StatelessWidget {
  const navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Hashini Divyanjanee'),
            accountEmail: Text('0769070920'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('assets/person.png')),
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color.fromRGBO(3, 191, 203, 1),
                Color.fromRGBO(3, 191, 203, 1),
              ]),
            ),
          ),
          ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              }),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "PRODUCT",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add),
              title: Text('New Product'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => product()))
                  }),
          ListTile(
              leading: Icon(Icons.production_quantity_limits_outlined),
              title: Text('Products'),
              onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductSearchScreen()))
                  }),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "CUSTOMER",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add),
              title: Text('New Customer'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => customer()))
                  }),
          ListTile(
              leading: Icon(Icons.person),
              title: Text('Customers'),
              onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainCustomerPage()))
                  }),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "SUPPLIER",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('New Supplier'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => supplier()))
                  }),
                   ListTile(
              leading: Icon(Icons.display_settings),
              title: Text('Supplier'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainSupplierPage()))
                  }),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "ORDER",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add),
              title: Text('New Order'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => place_order()))
                  }),
          ListTile(
              leading: Icon(Icons.delivery_dining),
              title: Text('Orders'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => order_table()))
                  }),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "JOB CARD",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add),
              title: Text('New Job card'),
              onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => job_card(
                                  bust: '0',
                                  waist: '0',
                                  hips: '0',
                                  sleeve_length: '0',
                                  bust_poin_to_bust_poin: '0',
                                  bust_poin_to_waist: '0',
                                  back_waist_length: '0',
                                  front_waist_length: '0',
                                  shoulder_width: '0',
                                  neck_circumference: '0',
                                  length: '0',
                                  armhole_depth: '0',
                                  shoulder_to_bust_point: '0',
                                  shoulder_to_waist: '0',
                                  other: '0',
                                  selectedItems: '0',
                                )))
                  }),
          ListTile(
              leading: Icon(Icons.add_card),
              title: Text('Job cards'),
              onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => job_card_table()))
                  }),
          ListTile(
              leading: Icon(Icons.pending),
              title: Text('Pending Job'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Pending_job()))
                  }),
          ListTile(
              leading: Icon(Icons.confirmation_num_rounded),
              title: Text('Finish Job'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Finish_Job()))
                  }),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "STOCK",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add),
              title: Text('Current Stock'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainCurrentStock()))
                  }),
          ListTile(
              leading: Icon(Icons.person),
              title: Text('Low Stock Products'),
              onTap: () => {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainLowStock()))
                  }),
          ListTile(
              leading: Icon(Icons.person),
              title: Text('Stock Adjustment'),
              onTap: () => {
                    
                  }),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "REPORTS",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
              leading: Icon(Icons.summarize),
              title: Text('Daily Cash Report'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => cash_report()))
                  }),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "OTHER",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Dashboad()))
                  }),
          ListTile(
              leading: Icon(Icons.logout_rounded),
              title: Text('Sign out'),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()))
                  }),
        ],
      ),
    );
  }
}
