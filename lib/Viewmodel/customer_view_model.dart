import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tailer_shop/Model/customer_model.dart';


class CustomerViewModel extends ChangeNotifier {
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Customer> get customers => _filteredCustomers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCustomer() async {
    _isLoading = true;
    notifyListeners();
    try {
      var url = 'http://127.0.0.1/Tailer/customer.php';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonCustomers = jsonDecode(response.body) as List;
        _customers =
            jsonCustomers.map((json) => Customer.fromJson(json)).toList();
        _filteredCustomers = _customers;
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load data: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch Customers: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCustomer(String query) {
    if (query.isEmpty) {
      _filteredCustomers = _customers;
    } else {
      _filteredCustomers = _customers.where((customer) {
        try {
          // Attempt to convert cost price to string

          // Check if product name or cost price contains the query
          return customer.cid.toLowerCase().contains(query.toLowerCase()) ||
              customer.fullName.toLowerCase().contains(query.toLowerCase()) ||
              customer.address.toLowerCase().contains(query.toLowerCase()) ||
              customer.phone.toLowerCase().contains(query.toLowerCase());
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