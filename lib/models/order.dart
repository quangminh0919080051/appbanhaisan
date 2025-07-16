// lib/models/order.dart
class Order {
  final int? orderId; // orderId có thể null khi tạo mới
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final DateTime orderDate;
  final double totalAmount;
  final String status;
  // Bạn có thể thêm UserId ở đây nếu bạn muốn lưu nó trong Flutter model
  // final String? userId; 

  Order({
    this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    // this.userId,
  });

  // Factory constructor để tạo Order từ JSON Map (khi nhận từ API)
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] as int?,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      customerAddress: json['customerAddress'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(), // num to double
      status: json['status'] as String,
      // userId: json['userId'] as String?,
    );
  }

  // Chuyển đổi Order object thành JSON Map (khi gửi lên API)
  Map<String, dynamic> toJson() {
    return {
      // orderId thường do backend tự sinh khi tạo mới, không gửi lên
      // 'orderId': orderId, // Chỉ gửi nếu bạn đang cập nhật và API yêu cầu
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'orderDate': orderDate.toIso8601String(), // Định dạng ISO 8601
      'totalAmount': totalAmount,
      'status': status,
      // 'userId': userId,
    };
  }
}