class Customer {
  final String cid;
  final String fullName;
  final String address;
  final String phone;
  final String? gender; 
  Customer({
    required this.cid,
    required this.fullName,
    required this.address,
    required this.phone,
     this.gender,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
     cid: json['cid'] ?? '', 
    fullName: json['full_name'] ?? '', 
    address: json['address'] ?? '', 
    phone: json['phone'] ?? '', 
    gender: json['gender'], 
    );
  }
}
