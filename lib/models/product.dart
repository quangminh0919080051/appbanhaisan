class Product {
  int? productId;
  String? productName;
  String? description;
  double? price; // Sửa int? thành double?
  double? stock; // Nếu stock cũng có thể là double, sửa luôn
  String? imageUrl;
  String? createdAt;

  Product(
      {this.productId,
      this.productName,
      this.description,
      this.price,
      this.stock,
      this.imageUrl,
      this.createdAt});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    description = json['description'];
    
    price = json['price'] != null ? double.tryParse(json['price'].toString()) : null;
    stock = json['stock'] != null ? double.tryParse(json['stock'].toString()) : null;
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['description'] = this.description;
    data['price'] = this.price;
    data['stock'] = this.stock;
    data['imageUrl'] = this.imageUrl;
    data['createdAt'] = this.createdAt;
    return data;
  }
}