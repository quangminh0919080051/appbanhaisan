import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provide/cart_provider.dart';
import '../services/order_service.dart'; // Import OrderService để tạo đơn hàng
import '../models/order.dart'; // Import model Order

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng của bạn'),
        backgroundColor: const Color(0xFFFF385C),
        foregroundColor: Colors.white, // Màu chữ trên AppBar
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => const Divider(height: 16),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _buildCartItem(item, cart, context);
                    },
                  ),
                ),
                _buildCheckoutSection(cart, context),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Giỏ hàng của bạn đang trống',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF385C),
            ),
            child: const Text('Tiếp tục mua sắm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, CartProvider cart, BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => cart.removeItem(item.id),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  image: item.imageUrl != null && item.imageUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(item.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: item.imageUrl == null || item.imageUrl!.isEmpty
                    ? const Icon(Icons.image, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.price.toStringAsFixed(0)} VNĐ',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tổng: ${item.total.toStringAsFixed(0)} VNĐ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => cart.decreaseQuantity(item.id),
                  ),
                  Text(
                    item.quantity.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => cart.increaseQuantity(item.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(CartProvider cart, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${cart.totalAmount.toStringAsFixed(0)} VNĐ',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF385C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.payment),
              label: const Text('Thanh toán ngay', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF385C),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => _showCheckoutForm(context, cart), // Gọi biểu mẫu thanh toán
            ),
          ),
        ],
      ),
    );
  }

  // --- PHƯƠNG THỨC MỚI: HIỂN THỊ BIỂU MẪU THANH TOÁN ---
  void _showCheckoutForm(BuildContext context, CartProvider cart) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _phoneController = TextEditingController();
    final _addressController = TextEditingController();

    // Lấy ngày hiện tại
    final orderDate = DateTime.now().toLocal(); // Lấy đối tượng DateTime

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Xác nhận thông tin đặt hàng', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Họ tên người nhận',
                      hintText: 'Nhập họ tên',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ tên người nhận';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      hintText: 'Nhập số điện thoại',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }
                      if (value.length < 9 || value.length > 11 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Số điện thoại không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Địa chỉ nhận hàng',
                      hintText: 'Nhập địa chỉ chi tiết',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập địa chỉ nhận hàng';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ngày đặt hàng:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(orderDate.toLocal().toString().split(' ')[0]), // Hiển thị ngày YYYY-MM-DD
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng tiền:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${cart.totalAmount.toStringAsFixed(0)} VNĐ', style: const TextStyle(color: Color(0xFFFF385C), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF385C),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Tạo một đối tượng Order từ dữ liệu form
                  final newOrder = Order(
                    customerName: _nameController.text.trim(),
                    customerPhone: _phoneController.text.trim(),
                    customerAddress: _addressController.text.trim(),
                    orderDate: orderDate, // Sử dụng đối tượng DateTime
                    totalAmount: cart.totalAmount,
                    status: "Pending", // Trạng thái mặc định khi tạo đơn hàng
                  );

                  // Gọi API tạo đơn hàng
                  final result = await OrderService.createOrder(newOrder);

                  if (result['success']) {
                    Navigator.pop(dialogContext); // Đóng dialog
                    ScaffoldMessenger.of(context).showSnackBar( // Dùng context gốc
                      const SnackBar(
                        content: Text('Đặt hàng thành công!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    cart.clearCart(); // Xóa giỏ hàng sau khi đặt thành công
                    // Có thể chuyển hướng đến trang lịch sử đơn hàng
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar( // Dùng context gốc
                      SnackBar(
                        content: Text(result['message'] ?? 'Đặt hàng thất bại.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Xác nhận thanh toán', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}