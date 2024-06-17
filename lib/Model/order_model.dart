class Order {
  final String orderID;
  final String customerName;
  final String customerPhone;
  final String orderDate;
  final String status;
  final double totalPrice;
  final double discount;
  final double advance;
  final double total;
  final double paymentAmount;
  final String paymentStatus;

  Order({
    required this.orderID,
    required this.customerName,
    required this.customerPhone,
    required this.orderDate,
    required this.status,
    required this.totalPrice,
    required this.discount,
    required this.advance,
    required this.total,
    required this.paymentAmount,
    required this.paymentStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderID: json['orderID'],
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      orderDate: json['orderDate'] ?? '',
        status: json['status'] ?? '',
      totalPrice: json['totalPrice'] ?? '',
      discount: json['discount'] ?? '',
      advance: json['advance'] ?? '',
        total: json['total'] ?? '',
      paymentAmount: json['paymentAmount'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
   
    );
  }
}
