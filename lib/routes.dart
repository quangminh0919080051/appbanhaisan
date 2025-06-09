import 'package:flutter/material.dart';
import 'home/index.dart';
import 'auth/login_page.dart';
import 'auth/register_page.dart';
import 'screens/cart_page.dart';
import 'screens/favorite_page.dart';
import 'screens/category_page.dart';
import 'screens/notification_page.dart';
import 'screens/profile_page.dart';
import 'screens/admin_page.dart';
import 'screens/product_detail_page.dart';

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
      case '/product-detail':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ProductDetailPage(
            id: args['id'],
            name: args['name'],
            price: args['price'],
            category: args['category'],
            imageNumber: args['imageNumber'],
          ),
        );
      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}