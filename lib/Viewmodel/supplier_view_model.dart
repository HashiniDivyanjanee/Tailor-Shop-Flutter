import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tailer_shop/Model/supplier_model.dart';


class SupplierViewModel extends ChangeNotifier {
  List<Supplier> _suppliers = [];
  List<Supplier> _filteredSupplier = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Supplier> get suppliers => _filteredSupplier;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSupplier() async {
    _isLoading = true;
    notifyListeners();
    try {
      var url = 'http://127.0.0.1/Tailer/supplierDisplay.php';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonSuppliers = jsonDecode(response.body) as List;
        _suppliers =
            jsonSuppliers.map((json) => Supplier.fromJson(json)).toList();
        _filteredSupplier = _suppliers;
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load data: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch Suppliers: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchSupplier(String query) {
    if (query.isEmpty) {
      _filteredSupplier = _suppliers;
    } else {
      _filteredSupplier = _suppliers.where((supplier) {
        try {
          // Attempt to convert cost price to string

          // Check if product name or cost price contains the query
          return supplier.supplierID.toLowerCase().contains(query.toLowerCase()) ||
              supplier.supplierName.toLowerCase().contains(query.toLowerCase()) ||
              supplier.address.toLowerCase().contains(query.toLowerCase()) ||
              supplier.phone.toLowerCase().contains(query.toLowerCase());
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