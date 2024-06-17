class Supplier {
  final String supplierID;
  final String supplierName;
  final String phone;
  final String address;
  Supplier({
    required this.supplierID,
    required this.supplierName,
    required this.phone,
    required this.address,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      supplierID: json['supplierID'] ?? '',
      supplierName: json['supplierName'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
