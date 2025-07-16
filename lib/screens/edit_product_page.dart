import 'dart:convert'; // <--- THÊM DÒNG NÀY
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/api_service.dart';

class EditProductPage extends StatefulWidget {
  final Product product; // Nhận đối tượng Product để chỉnh sửa

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _imageUrlController;

  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controllers với dữ liệu sản phẩm hiện có
    _nameController = TextEditingController(text: widget.product.productName);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price?.toString());
    _stockController = TextEditingController(text: widget.product.stock?.toString());
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final updatedProduct = Product(
          productId: widget.product.productId,
          productName: _nameController.text,
          description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
          price: double.tryParse(_priceController.text) ?? 0.0,
          stock: int.tryParse(_stockController.text) ?? 0,
          imageUrl: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
          createdAt: widget.product.createdAt 
        );

        // Debug: In ra dữ liệu sản phẩm trước khi gửi
        print('Attempting to update product:');
        print('Product ID: ${updatedProduct.productId}');
        print('Product Name: ${updatedProduct.productName}');
        print('Product Price: ${updatedProduct.price}');
        print('Product Stock: ${updatedProduct.stock}');
        print('Product ImageUrl: ${updatedProduct.imageUrl}');
        print('JSON Body to be sent: ${jsonEncode(updatedProduct.toJson())}'); // jsonEncode ở đây cần import dart:convert


        final resultProduct = await _apiService.updateProduct(updatedProduct);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sản phẩm "${resultProduct.productName}" đã được cập nhật thành công!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật sản phẩm: ${e.toString()}')),
        );
      } finally {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Sản Phẩm'),
        backgroundColor: const Color(0xFFFF385C),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF385C)),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên sản phẩm *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên sản phẩm';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả sản phẩm',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Giá (VNĐ) *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập giá';
                        }
                        if (double.tryParse(value) == null || double.parse(value) < 0) {
                          return 'Giá phải là một số không âm';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(
                        labelText: 'Số lượng trong kho *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số lượng tồn kho';
                        }
                        if (int.tryParse(value) == null || int.parse(value) < 0) {
                          return 'Số lượng phải là một số nguyên không âm';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL hình ảnh',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _updateProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF385C),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Cập Nhật Sản Phẩm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}