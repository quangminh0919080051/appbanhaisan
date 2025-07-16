// lib/models/product.dart
class Product {
  int? productId;
  String? productName;
  String? description;
  double? price;
  int? stock;
  String? imageUrl;
  String? createdAt;

  Product({
    this.productId,
    this.productName,
    this.description,
    this.price,
    this.stock,
    this.imageUrl,
    this.createdAt,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    description = json['description'];

    price = json['price'] != null ? double.tryParse(json['price'].toString()) : null;
    stock = json['stock'] != null ? int.tryParse(json['stock'].toString()) : null;
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    
    // Khi cập nhật (PUT), productId PHẢI ĐƯỢC GỬI (nếu có giá trị)
    // Khi tạo mới (POST), API của bạn có thể yêu cầu 0 nếu không tự tạo ID
    if (productId != null) { 
      data['productId'] = productId;
    } else {
      // Nếu API của bạn yêu cầu productId: 0 khi tạo mới
      data['productId'] = 0; 
    }

    // Đảm bảo tất cả các khóa là camelCase
    data['productName'] = productName; 
    data['description'] = description;
    data['price'] = price;
    data['stock'] = stock;
    data['imageUrl'] = imageUrl;
    // createdAt thường do backend tự động tạo/cập nhật, không nên gửi từ client
    // data['createdAt'] = createdAt; 
    return data;
  }
}