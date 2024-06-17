// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tailer_shop/Model/customer_model.dart';
// import 'package:tailer_shop/Viewmodel/customer_view_model.dart';
// import 'package:tailer_shop/customer.dart';

// class CustomerTable extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => CustomerViewModel(),
//       child: CustomersTable(),
//     );
//   }
// }

// class CustomersTable extends StatefulWidget {

  
//   @override
//   _CustomerTableState createState() => _CustomerTableState();
// }

// class _CustomerTableState extends State<CustomersTable> {
//   @override
//   void initState() {
//     super.initState();
// Provider.of<CustomerViewModel>(context, listen: false).fetchCustomers();
    
//   }
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<CustomerViewModel>(context);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.fromRGBO(3, 191, 203, 1),
//                 Color.fromRGBO(3, 191, 203, 1),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(left: 50.0),
//             child: Text(
//               'CUSTOMER',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//           ),
//           //  Expanded(
//           //     child: customerSearchBar(onSearch: (value) {
//           //       setState(() {
//           //         searchTerm = value;
//           //       });
//           //     }),
//           //   ),
//           SizedBox(
//             width: 150,
//             child: Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(3, 191, 203, 1),
//                 borderRadius: BorderRadius.circular(10.0),
//                 border: Border.all(
//                   color: const Color.fromARGB(255, 255, 255, 255),
//                   width: 5.0,
//                 ),
//               ),
//               child: Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => CustomerForm()),
//                     );
//                   },
//                   child: const Text(
//                     'ADD NEW CUSTOMER',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 255, 255, 255),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: viewModel.customers.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : LayoutBuilder(
//               builder: (context, constraints) {
//                 if (constraints.maxWidth < 600) {
//                   return buildMobileView(viewModel.customers);
//                 } else {
//                   return buildDesktopView(viewModel.customers);
//                 }
//               },
//             ),
//     );
//   }

//   Widget buildMobileView(List<Customer> customers) {
//     return ListView.builder(
//       itemCount: customers.length,
//       itemBuilder: (context, index) {
//         final customer = customers[index];
//         return ListTile(
//           title: Text(customer.fullName),
//           subtitle: Text(customer.address),
//           trailing: Text(customer.phone),
//         );
//       },
//     );
//   }

//   Widget buildDesktopView(List<Customer> customers) {
    
//     return SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Center(
//               child: Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: DataTable(
//                     columnSpacing: 250,
//                     headingRowColor: MaterialStateColor.resolveWith(
//                       (states) => Color.fromRGBO(3, 191, 203, 1),
//                     ),
//                     columns: [
//                       DataColumn(
//                           label: Text('CID',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white))),
//                       DataColumn(
//                           label: Text('Full Name',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white))),
//                       DataColumn(
//                           label: Text('Address',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white))),
//                       DataColumn(
//                           label: Text('Phone',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white))),
//                       DataColumn(
//                           label: Text('Gender',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white))),
//                                    DataColumn(
//                           label: Text('Action',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white))),
//                     ],
//                     rows: customers.map((customer) {
//                       return DataRow(cells: [
//                         DataCell(Text(customer.cid)),
//                         DataCell(Text(customer.fullName)),
//                         DataCell(Text(customer.address)),
//                         DataCell(Text(customer.phone)),
//                         DataCell(Text(customer.gender ?? 'Not specified')),
//                           DataCell(
//                             Row(
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     // editCustomer(context, customer);
//                                   },
//                                   style: ButtonStyle(
//                                     backgroundColor:
//                                         MaterialStateProperty.all<Color>(
//                                       Color.fromARGB(255, 38, 186, 238),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     'Edit',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                                 SizedBox(width: 8),
//                                 ElevatedButton(
//                                   onPressed: () {
                                   
//                                   },
//                                   style: ButtonStyle(
//                                     backgroundColor:
//                                         MaterialStateProperty.all<Color>(
//                                       Color.fromARGB(255, 148, 27, 18),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     'Delete',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ]);
//                     }).toList(),
//                   )))
//         ]));
//   }
// }
