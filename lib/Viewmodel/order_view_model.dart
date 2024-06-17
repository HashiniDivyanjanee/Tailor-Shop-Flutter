import 'package:flutter/material.dart';
import 'package:tailer_shop/model/order_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class OrderViewModel extends ChangeNotifier {
//   String _searchTerm = "";
//   List<Order> _orders = [];

//   String get searchTerm => _searchTerm;
//   List<Order> get orders => _orders;

//   Future<void> fetchDataOrders() async {
//     final response =
//         await http.get(Uri.parse('http://127.0.0.1/Tailer/order.php'));

//     if (response.statusCode == 200) {
//       final List<dynamic> responseData = json.decode(response.body);
//       _orders = responseData.map((data) => Order(
//         orderId: data['orderID'],
//         customerName: data['customerName'],
//         customerPhone: data['customerPhone'],
//         orderDate: data['order_date'],
//         status: data['status'],
//         totalPrice: data['total_price'],
//         discount: data['discount'],
//         advance: data['advance'],
//         total: data['total'],
//         paymentAmount: data['payment'],
//         paymentStatus: data['paymentStatus'],
//       )).toList();
//       notifyListeners();
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   void setSearchTerm(String term) {
//     _searchTerm = term;
//     notifyListeners();
//   }
// }


class OrderViewModel extends ChangeNotifier {
  List<Order> _orders = [];
  List<Order> _filteredOrders = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Order> get orders => _filteredOrders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrder() async {
    _isLoading = true;
    notifyListeners();
    try {
      var url = 'http://127.0.0.1/Tailer/customer.php';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonOrders = jsonDecode(response.body) as List;
        _orders =
            jsonOrders.map((json) => Order.fromJson(json)).toList();
        _filteredOrders = _orders;
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load data: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch Orders: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchOrder(String query) {
    if (query.isEmpty) {
      _filteredOrders = _orders;
    } else {
      _filteredOrders = _orders.where((order) {
        try {
          // Attempt to convert cost price to string

          // Check if product name or cost price contains the query
          return order.orderID.toLowerCase().contains(query.toLowerCase()) ||
              order.customerName.toLowerCase().contains(query.toLowerCase()) ||
              order.customerPhone.toLowerCase().contains(query.toLowerCase()) ||
              order.status.toLowerCase().contains(query.toLowerCase());
        } catch (e) {
          // Handle any error that occurs during conversion
          print('Error converting cost price: $e');
          return false; // Exclude the product from filtered list
        }
      }).toList();
    }
    notifyListeners();
  }
}