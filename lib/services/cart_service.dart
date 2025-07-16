import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

class CartService {
  final ValueNotifier<List<CartItem>> items = ValueNotifier([]);
  final ValueNotifier<int> itemCount = ValueNotifier(0);

  void addItem(String id, String name, double price, String? imageUrl, {int quantity = 1}) {
    final existingIndex = items.value.indexWhere((item) => item.id == id);
    
    if (existingIndex >= 0) {
      items.value[existingIndex].quantity += quantity;
    } else {
      items.value = [...items.value, CartItem(
        id: id,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity,
      )];
    }
    
    _updateCount();
  }

  void removeItem(String id) {
    items.value = items.value.where((item) => item.id != id).toList();
    _updateCount();
  }

  void clearCart() {
    items.value = [];
    _updateCount();
  }

  void _updateCount() {
    itemCount.value = items.value.fold(0, (sum, item) => sum + item.quantity);
    items.notifyListeners();
  }

  double get totalAmount {
    return items.value.fold(0, (sum, item) => sum + item.total);
  }
}