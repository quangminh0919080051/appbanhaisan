import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailPage extends StatefulWidget {
  final String id;
  const ProductDetailPage({super.key, required this.id});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchProductDetail();
  }

  Future<void> _fetchProductDetail() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      // Gọi trực tiếp API lấy chi tiết sản phẩm
      final response = await http.get(
        Uri.parse('http://10.0.0.2:7160/api/Products/${widget.id}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          product = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Không thể lấy chi tiết sản phẩm';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text('Lỗi: $error'));
    if (product == null) return const Center(child: Text('Không có dữ liệu'));

    return Scaffold(
      appBar: AppBar(
        title: Text(product!['productName'] ?? 'Chi tiết sản phẩm'),
        backgroundColor: const Color(0xFFFF385C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: (product!['imageUrl'] != null && product!['imageUrl'].toString().isNotEmpty)
                  ? Image.network(
                      product!['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, size: 50),
                          ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 50),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              product!['productName'] ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product!['price'] != null ? '${product!['price']} VNĐ' : '',
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFFFF385C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Mô tả sản phẩm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product!['description'] ?? 'Chưa có mô tả',
              style: const TextStyle(
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}