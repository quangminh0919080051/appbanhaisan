import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Thêm package provider
import 'auth/login_page.dart';
import 'routes.dart';
import '../provide/cart_provider.dart'; // Giả sử CartProvider nằm trong thư mục providers


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Bọc CartProvider và các Provider khác ở đây
        ChangeNotifierProvider(create: (context) => CartProvider()),
        
        // Thêm các Provider khác nếu cần
        // Provider(create: (context) => OtherProvider()),
      ],
      child: MaterialApp(
        title: 'Hải Sản Tươi Sống',
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Arial',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}