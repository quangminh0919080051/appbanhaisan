// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5106/api/Products';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      print('Failed to load products. Status Code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product.toJson()), 
    );

    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to create product. Status Code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  Future<Product> updateProduct(Product product) async {
    if (product.productId == null) {
      throw Exception('Product ID is required for update.');
    }

    print('Updating product with ID: ${product.productId}');
    print('Request URL: $_baseUrl/${product.productId}');
    print('Request Body: ${jsonEncode(product.toJson())}');

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${product.productId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(product.toJson()),
      );

      print('Update Response Status Code: ${response.statusCode}');
      print('Update Response Body: ${response.body}');

      // SỬA ĐỔI QUAN TRỌNG TẠI ĐÂY: Chấp nhận cả 200 OK và 204 No Content
      if (response.statusCode == 200) {
        // Nếu server trả về 200 OK và có body, thì parse nó
        return Product.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 204) {
        // Nếu server trả về 204 No Content, nghĩa là thành công nhưng không có body.
        // Trả về chính đối tượng product đã được gửi đi để báo hiệu thành công.
        return product; // <--- TRẢ VỀ ĐỐI TƯỢNG SẢN PHẨM ĐÃ CẬP NHẬT
      } else {
        // Ném lỗi nếu status code không phải 200 hoặc 204
        throw Exception('Failed to update product. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('ClientException during update: ${e.message}');
      throw Exception('Network error during update: ${e.message}');
    } catch (e) {
      print('Unknown error during update: ${e.toString()}');
      throw Exception('An unexpected error occurred during update: ${e.toString()}');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$productId'));

    if (response.statusCode != 204) {
      print('Failed to delete product. Status Code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to delete product: ${response.body}');
    }
  }
}