class Product {
  final int pid;
  final String product;
  final double costPrice;
  final double salePrice;
  final double discount;
  final int qty;
  final String color;
  final String category;
  final String range;

  Product(
      {required this.pid,
      required this.product,
      required this.costPrice,
      required this.salePrice,
      required this.discount,
      required this.qty,
      required this.color,
      required this.category,
      required this.range});

 factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    pid: json['pid'] != null ? int.tryParse(json['pid'].toString()) ?? 0 : 0,
    product: json['product'],
    costPrice: double.parse(json['cost_price']),
    salePrice: double.parse(json['sale_price']),
    discount: double.parse(json['discount']),
    qty: json['qty'] != null ? int.tryParse(json['qty'].toString()) ?? 0 : 0,
    color: json['color'],
    category: json['category'],
    range: json['range'],
  );
}

}
