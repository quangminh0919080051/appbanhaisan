// lib/services/order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Để lấy JWT token
import '../models/order.dart'; // Import model Order

class OrderService {
  // THAY ĐỔI URL NÀY ĐỂ KHỚP VỚI API SQL SERVER CỦA BẠN (API .NET)
  static const String _orderBaseUrl = 'http://10.0.2.2:5106/api/orders'; 

  // Helper để lấy token
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Helper để lấy headers với token
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Bearer $token', // Gửi token nếu có
    };
  }

  // --- PHƯƠNG THỨC CREATE ORDER (POST) ---
  static Future<Map<String, dynamic>> createOrder(Order order) async {
    final headers = await _getAuthHeaders();
    if (!headers.containsKey('Authorization')) {
      return {'success': false, 'message': 'Bạn chưa đăng nhập.'};
    }

    try {
      final response = await http.post(
        Uri.parse(_orderBaseUrl),
        headers: headers,
        body: jsonEncode(order.toJson()), // Gửi Order object đã chuyển thành JSON
      );

      if (response.statusCode == 201) { // 201 Created
        return {'success': true, 'message': 'Đơn hàng đã được tạo thành công!', 'data': jsonDecode(response.body)};
      } else {
        print('Error creating order: Status ${response.statusCode}, Body: ${response.body}');
        final errorBody = jsonDecode(response.body);
        return {'success': false, 'message': errorBody['message'] ?? 'Lỗi tạo đơn hàng: ${response.statusCode}.'};
      }
    } catch (e) {
      print('Network error creating order: $e');
      return {'success': false, 'message': 'Lỗi kết nối khi tạo đơn hàng: $e'};
    }
  }

  // --- PHƯƠNG THỨC GET ALL ORDERS (GET) ---
  static Future<Map<String, dynamic>> getOrders() async {
    final headers = await _getAuthHeaders();
    if (!headers.containsKey('Authorization')) {
      return {'success': false, 'message': 'Bạn chưa đăng nhập.'};
    }

    try {
      final response = await http.get(
        Uri.parse(_orderBaseUrl), // Endpoint lấy tất cả đơn hàng
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> orderJsonList = jsonDecode(response.body);
        List<Order> orders = orderJsonList.map((json) => Order.fromJson(json)).toList();
        return {'success': true, 'orders': orders};
      } else {
        print('Error fetching orders: Status ${response.statusCode}, Body: ${response.body}');
        final errorBody = jsonDecode(response.body);
        return {'success': false, 'message': errorBody['message'] ?? 'Không thể lấy danh sách đơn hàng: ${response.statusCode}.'};
      }
    } catch (e) {
      print('Network error fetching orders: $e');
      return {'success': false, 'message': 'Lỗi kết nối khi lấy đơn hàng: $e'};
    }
  }

  // --- PHƯƠNG THỨC GET ORDER BY ID (GET) ---
  static Future<Map<String, dynamic>> getOrderById(int orderId) async {
    final headers = await _getAuthHeaders();
    if (!headers.containsKey('Authorization')) {
      return {'success': false, 'message': 'Người dùng chưa đăng nhập.'};
    }

    try {
      final response = await http.get(
        Uri.parse('$_orderBaseUrl/$orderId'), // Endpoint lấy đơn hàng theo ID
        headers: headers,
      );

      if (response.statusCode == 200) {
        return {'success': true, 'order': Order.fromJson(jsonDecode(response.body))};
      } else {
        print('Error fetching order by ID: Status ${response.statusCode}, Body: ${response.body}');
        final errorBody = jsonDecode(response.body);
        return {'success': false, 'message': errorBody['message'] ?? 'Không thể lấy đơn hàng: ${response.statusCode}.'};
      }
    } catch (e) {
      print('Network error fetching order by ID: $e');
      return {'success': false, 'message': 'Lỗi kết nối khi lấy đơn hàng: $e'};
    }
  }

  // --- PHƯƠNG THỨC UPDATE ORDER (PUT) ---
  static Future<Map<String, dynamic>> updateOrder(Order order) async {
    if (order.orderId == null) {
      return {'success': false, 'message': 'Order ID là bắt buộc để cập nhật.'};
    }
    final headers = await _getAuthHeaders();
    if (!headers.containsKey('Authorization')) {
      return {'success': false, 'message': 'Người dùng chưa đăng nhập.'};
    }

    try {
      final response = await http.put(
        Uri.parse('$_orderBaseUrl/${order.orderId}'), // Endpoint cập nhật đơn hàng theo ID
        headers: headers,
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) { // 200 OK hoặc 204 No Content
        return {'success': true, 'message': 'Đơn hàng đã được cập nhật thành công!'};
      } else {
        print('Error updating order: Status ${response.statusCode}, Body: ${response.body}');
        final errorBody = jsonDecode(response.body);
        return {'success': false, 'message': errorBody['message'] ?? 'Không thể cập nhật đơn hàng: ${response.statusCode}.'};
      }
    } catch (e) {
      print('Network error updating order: $e');
      return {'success': false, 'message': 'Lỗi kết nối khi cập nhật đơn hàng: $e'};
    }
  }

  // --- PHƯƠNG THỨC DELETE ORDER (DELETE) ---
  static Future<Map<String, dynamic>> deleteOrder(int orderId) async {
    final headers = await _getAuthHeaders();
    if (!headers.containsKey('Authorization')) {
      return {'success': false, 'message': 'Người dùng chưa đăng nhập.'};
    }

    try {
      final response = await http.delete(
        Uri.parse('$_orderBaseUrl/$orderId'), // Endpoint xóa đơn hàng theo ID
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) { // 200 OK hoặc 204 No Content
        return {'success': true, 'message': 'Đơn hàng đã được xóa thành công!'};
      } else {
        print('Error deleting order: Status ${response.statusCode}, Body: ${response.body}');
        final errorBody = jsonDecode(response.body);
        return {'success': false, 'message': errorBody['message'] ?? 'Không thể xóa đơn hàng: ${response.statusCode}.'};
      }
    } catch (e) {
      print('Network error deleting order: $e');
      return {'success': false, 'message': 'Lỗi kết nối khi xóa đơn hàng: $e'};
    }
  }
}