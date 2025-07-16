import 'package:flutter/material.dart';
import 'home/index.dart'; // Đảm bảo đường dẫn đúng
import 'auth/login_page.dart'; // Đảm bảo đường dẫn đúng
import 'auth/register_page.dart'; // Đảm bảo đường dẫn đúng
import 'models/product.dart';
import 'screens/cart_page.dart'; // Đảm bảo đường dẫn đúng
import 'screens/favorite_page.dart'; // Đảm bảo đường dẫn đúng
import 'screens/category_page.dart'; // Đảm bảo đường dẫn đúng
import 'screens/notification_page.dart'; // Đảm bảo đường dẫn đúng
import 'screens/profile_page.dart'; // Đảm bảo đường dẫn đúng
import 'screens/admin_page.dart'; // Đảm bảo đường dẫn đúng
import 'screens/product_detail_page.dart'; // Đảm bảo đường dẫn đúng
import 'screens/edit_product_page.dart'; // Đảm bảo đường dẫn đúng

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartPage());
      case '/favorite':
        return MaterialPageRoute(builder: (_) => const FavoritePage());
      case '/category':
        return MaterialPageRoute(builder: (_) => const CategoryPage());
      case '/notification':
        return MaterialPageRoute(builder: (_) => const NotificationPage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case '/product-detail': // Tên route cho trang chi tiết sản phẩm
        final String? productId = settings.arguments as String?; 
        if (productId != null) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailPage(
              id: productId,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Lỗi')),
            body: const Center(child: Text('ID sản phẩm không hợp lệ hoặc thiếu.')),
          ),
        );

      case '/edit-product': // Tên route cho trang chỉnh sửa sản phẩm
        final product = settings.arguments as Product?; // Nhận đối tượng Product
        if (product != null) {
          return MaterialPageRoute(
            builder: (_) => EditProductPage(product: product),
          );
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Lỗi')),
            body: const Center(child: Text('Không tìm thấy sản phẩm để chỉnh sửa.')),
          ),
        );

      case '/admin': // Tên route cho trang quản trị
        return MaterialPageRoute(builder: (_) => const AdminPage());

      default:
        // TRANG MẶC ĐỊNH KHI KHÔNG TÌM THẤY ROUTE NÀO KHỚP
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Không tìm thấy trang yêu cầu')), // TIÊU ĐỀ LỖI
            body: const Center(child: Text('Đường dẫn không hợp lệ hoặc không tồn tại.')),
          ),
        );
    }
  }
}