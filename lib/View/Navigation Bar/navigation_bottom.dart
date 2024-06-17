import 'package:flutter/material.dart';
import 'package:tailer_shop/Const/constant.dart';
import 'package:tailer_shop/View/Current%20Stock/main_current_stock.dart';
import 'package:tailer_shop/View/Customer/main_customer_page.dart';
import 'package:tailer_shop/View/Login/login.dart';
import 'package:tailer_shop/View/Low%20Stock/main_low_stock.dart';
import 'package:tailer_shop/View/Supplier/main_supplier_page.dart';
import 'package:tailer_shop/View/order_table.dart';
import 'package:tailer_shop/Old/customer.dart';
import 'package:tailer_shop/View/dashboad.dart';
import 'package:tailer_shop/Old/finish_job.dart';
import 'package:tailer_shop/Old/home.dart';
import 'package:tailer_shop/Old/job_card.dart';
import 'package:tailer_shop/Old/job_card_table.dart';
import 'package:tailer_shop/Old/order_table.dart';
import 'package:tailer_shop/Old/pending_job.dart';
import 'package:tailer_shop/Old/place_order.dart';
import 'package:tailer_shop/Old/product.dart';
import 'package:tailer_shop/report/daily_cash_report.dart';
import 'package:tailer_shop/Old/supplier.dart';

class NavigationBottom extends StatelessWidget {
  const NavigationBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color.fromRGBO(5, 5, 5, 1),
                  cardBackgroundColor
                ]),
              ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
              leading: Icon(
                Icons.dashboard,color: Colors.white,
              ),
              title: Text('Dashboard', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home())); 
              },   hoverColor: Color.fromARGB(255, 105, 22, 22)),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "PRODUCT",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700, color: Colors.white
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add,color: Colors.white,),
              title: Text('New Product', style: TextStyle(color: Colors.white),),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => product()))
                  }, hoverColor: Color.fromARGB(255, 105, 22, 22)),
          ListTile(
              leading: Icon(Icons.production_quantity_limits_outlined,color: Colors.white,),
              title: Text('Products', style: TextStyle(color: Colors.white),),
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add,color: Colors.white,),
              title: Text('New Customer', style: TextStyle(color: Colors.white),),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => customer()))
                  }),
          ListTile(
              leading: Icon(Icons.person,color: Colors.white,),
              title: Text('Customers', style: TextStyle(color: Colors.white),),
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          ListTile(
              leading: Icon(Icons.account_circle,color: Colors.white,),
              title: Text('New Supplier', style: TextStyle(color: Colors.white),),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => supplier()))
                  }),
                   ListTile(
              leading: Icon(Icons.display_settings,color: Colors.white,),
              title: Text('Supplier', style: TextStyle(color: Colors.white),),
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add,color: Colors.white,),
              title: Text('New Order', style: TextStyle(color: Colors.white),),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => place_order()))
                  }),
          ListTile(
              leading: Icon(Icons.delivery_dining,color: Colors.white,),
              title: Text('Orders', style: TextStyle(color: Colors.white),),
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add,color: Colors.white,),
              title: Text('New Job card', style: TextStyle(color: Colors.white),),
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
              leading: Icon(Icons.add_card,color: Colors.white,),
              title: Text('Job cards', style: TextStyle(color: Colors.white),),
              onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => job_card_table()))
                  }),
          ListTile(
              leading: Icon(Icons.pending,color: Colors.white,),
              title: Text('Pending Job', style: TextStyle(color: Colors.white),),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Pending_job()))
                  }),
          ListTile(
              leading: Icon(Icons.confirmation_num_rounded,color: Colors.white,),
              title: Text('Finish Job', style: TextStyle(color: Colors.white),),
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          ListTile(
              leading: Icon(Icons.add,color: Colors.white,),
              title: Text('Current Stock', style: TextStyle(color: Colors.white),),
              onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainCurrentStock()))
                  }, hoverColor: Color.fromARGB(255, 105, 22, 22)),
          ListTile(
              leading: Icon(Icons.person,color: Colors.white,),
              title: Text('Low Stock Products', style: TextStyle(color: Colors.white),),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainLowStock()))
                  }),
          ListTile(
              leading: Icon(Icons.person,color: Colors.white,),
              title: Text('Stock Adjustment', style: TextStyle(color: Colors.white),),
              onTap: () => {}),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              "REPORTS",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          ListTile(
              leading: Icon(Icons.summarize,color: Colors.white,),
              title: Text('Daily Cash Report', style: TextStyle(color: Colors.white),),
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          ListTile(
              leading: Icon(Icons.notifications,color: Colors.white,),
              title: Text('Notification', style: TextStyle(color: Colors.white),),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Dashboad()))
                  }),
          ListTile(
              leading: Icon(Icons.logout_rounded,color: Colors.white,),
              title: Text('Sign out', style: TextStyle(color: Colors.white),),
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()))
                  }),
        ],
      ),
    );
  }
}
