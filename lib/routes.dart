import 'package:flutter/material.dart';
import 'home/index.dart';
import 'auth/login_page.dart';
import 'auth/register_page.dart';
import 'screens/cart_page.dart';
import 'screens/favorite_page.dart';
import 'screens/category_page.dart';
import 'screens/notification_page.dart';
import 'screens/profile_page.dart';

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
      case '/category':
        return MaterialPageRoute(builder: (_) => const CategoryPage());
      case '/favorite':
        return MaterialPageRoute(builder: (_) => const FavoritePage());
      case '/notification':
        return MaterialPageRoute(builder: (_) => const NotificationPage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Không tìm thấy trang: ${settings.name}'),
            ),
          ),
        );
    }
  }
}