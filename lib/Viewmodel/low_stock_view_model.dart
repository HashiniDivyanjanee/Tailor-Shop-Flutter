import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tailer_shop/Model/current_stock.dart';
import 'dart:convert';

class LowProductViewModel extends ChangeNotifier {
    List<Product> _products = [];
    List<Product> _filteredProducts = [];
    bool _isLoading = true;
    String? _errorMessage;

    List<Product> get products => _filteredProducts;
    bool get isLoading => _isLoading;
    String? get errorMessage => _errorMessage;

    Future<void> fetchProducts() async {
        _isLoading = true;
        notifyListeners();
        try {
            var url = 'http://127.0.0.1/Tailer/low_stock.php';
            var response = await http.get(Uri.parse(url));
            if (response.statusCode == 200) {
                var jsonProducts = jsonDecode(response.body) as List;
                _products = jsonProducts.map((json) => Product.fromJson(json)).toList();
                _filteredProducts = _products;
                _isLoading = false;
                notifyListeners();
            } else {
                _errorMessage = 'Failed to load data: ${response.statusCode}';
                _isLoading = false;
                notifyListeners();
            }
        } catch (e) {
            _errorMessage = 'Failed to fetch products: $e';
            _isLoading = false;
            notifyListeners();
        }
    }

void searchProduct(String query) {
  if (query.isEmpty) {
    _filteredProducts = _products;
  } else {
    _filteredProducts = _products.where((product) {
      try {
        // Attempt to convert cost price to string
        String costPriceAsString = product.costPrice.toString();
         String quantity = product.qty.toString();
        String discount = product.discount.toString();
        String sale_price = product.salePrice.toString();

        return product.product.toLowerCase().contains(query.toLowerCase()) ||
            costPriceAsString.contains(query.toLowerCase())||
            product.category.toLowerCase().contains(query.toLowerCase())||
            product.range.toLowerCase().contains(query.toLowerCase())||
            product.color.toLowerCase().contains(query.toLowerCase())||
            quantity.contains(query.toLowerCase())||
            discount.contains(query.toLowerCase())||
            sale_price.contains(query.toLowerCase());
            
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
