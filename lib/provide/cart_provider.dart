// provide/cart_provider.dart
import 'package:flutter/material.dart';

class CartItem {
  final String id;           // ID duy nhất của item trong giỏ (ví dụ: "productID_timestamp")
  final String productId;    // ID sản phẩm từ hệ thống backend
  final String name;
  final double price;
  int quantity;
  final String? imageUrl;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.imageUrl,
  }) : id = '${productId}_${DateTime.now().microsecondsSinceEpoch}'; // Sử dụng microseconds để tăng tính duy nhất

  double get total => price * quantity;
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.total);

  void addItem(String productId, String name, double price, String? imageUrl, {int quantity = 1}) {
    // Sửa đổi quan trọng: Kiểm tra sự tồn tại dựa trên cả productId VÀ name
    final existingIndex = _items.indexWhere((item) => item.productId == productId && item.name == name);

    if (existingIndex >= 0) {
      // Nếu sản phẩm đã tồn tại (productId và name giống nhau), chỉ tăng số lượng
      _items[existingIndex].quantity += quantity;
      debugPrint('Đã tăng số lượng cho sản phẩm: $name (ID: $productId)');
    } else {
      // Nếu sản phẩm chưa có trong giỏ, thêm mới
      _items.add(CartItem(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity,
      ));
      debugPrint('Đã thêm sản phẩm mới vào giỏ: $name (ID: $productId)');
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void increaseQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        // Nếu số lượng về 0, xóa sản phẩm khỏi giỏ
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }
}