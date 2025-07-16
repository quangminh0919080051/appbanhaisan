// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart'; // Đảm bảo bạn đã import User model ở đây nếu cần dùng nó trong AuthService

class AuthService {
  // Thay đổi _authBaseUrl để trỏ đến API Node.js của bạn
  static const String _authBaseUrl = 'http://10.0.2.2:8000/api/auth';

  // Dữ liệu đăng nhập admin cứng (CHỈ DÙNG CHO MỤC ĐÍCH PHÁT TRIỂN/KIỂM THỬ NHANH)
  static final Map<String, Map<String, dynamic>> _hardcodedAdmin = {
    'admin': {
      'password': '123',
      'role': 'admin',
      'name': 'Dev Admin Local'
    },
  };

  static Future<Map<String, dynamic>> login(String email, String password) async {
    print('Login attempt - Email: $email, Password: $password');

    // Kiểm tra tài khoản admin cứng trước (CHỈ DÙNG CHO PHÁT TRIỂN)
    if (_hardcodedAdmin.containsKey(email) && _hardcodedAdmin[email]!['password'] == password) {
      print('Login successful with HARDCODED ADMIN: $email');
      return {
        'success': true,
        'role': _hardcodedAdmin[email]!['role'],
        'name': _hardcodedAdmin[email]!['name'],
        // Không có JWT token từ backend cho tài khoản hardcoded này
        'token': 'hardcoded_dev_token_no_api_access',
      };
    }

    // Nếu không phải tài khoản cứng, thì gọi API backend
    try {
      final response = await http.post(
        Uri.parse('$_authBaseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      print('Login API Response Status: ${response.statusCode}');
      print('Login API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true) {
          final prefs = await SharedPreferences.getInstance();
          if (responseBody.containsKey('token')) {
            await prefs.setString('jwt_token', responseBody['token']);
            print('JWT Token saved: ${responseBody['token']}');
          }

          print('Login successful as: ${responseBody['role']}');
          return {
            'success': true,
            'role': responseBody['role'],
            'name': responseBody['name'] ?? 'Người dùng',
            'userId': responseBody['userId'] ?? null,
            'token': responseBody['token'] ?? null,
          };
        } else {
          return {'success': false, 'message': responseBody['message'] ?? 'Đăng nhập thất bại.'};
        }
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        print('Login failed - API error: ${response.statusCode}, Message: ${errorBody['message']}');
        return {'success': false, 'message': errorBody['message'] ?? 'Lỗi từ server: ${response.statusCode}.'};
      }
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.'};
    }
  }

  // Phương thức đăng ký (vẫn gọi API)
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    print('Register attempt - Name: $name, Email: $email');

    try {
      final response = await http.post(
        Uri.parse('$_authBaseUrl/register'), // Endpoint đăng ký của Node.js API
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      print('Register API Response Status: ${response.statusCode}');
      print('Register API Response Body: ${response.body}');

      if (response.statusCode == 201) { // 201 Created là mã thành công khi đăng ký
        return {'success': true, 'message': 'Đăng ký thành công!'};
      } else {
        // Các lỗi HTTP khác (400, 500, v.v.)
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        print('Register failed - API error: ${response.statusCode}, Message: ${errorBody['message']}');
        return {'success': false, 'message': errorBody['message'] ?? 'Đăng ký thất bại.'};
      }
    } catch (e) {
      print('Register error: $e');
      return {'success': false, 'message': 'Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.'};
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    print('JWT Token removed.');
  }

  // Phương thức MỚI để lấy tất cả người dùng (chỉ dành cho admin)
  static Future<Map<String, dynamic>> getUsers() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'message': 'Không có token xác thực. Vui lòng đăng nhập.'};
      }

      final response = await http.get(
        Uri.parse('$_authBaseUrl/users'), // Giả định API của bạn có endpoint /api/auth/users
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Gửi token để xác thực
        },
      );

      print('Get Users API Response Status: ${response.statusCode}');
      print('Get Users API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          // Chuyển đổi danh sách dữ liệu người dùng thành danh sách đối tượng User
          List<User> users = (responseBody['users'] as List)
              .map((userData) => User.fromJson(userData))
              .toList();
          return {'success': true, 'users': users};
        } else {
          return {'success': false, 'message': responseBody['message'] ?? 'Không thể tải danh sách người dùng.'};
        }
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        return {'success': false, 'message': errorBody['message'] ?? 'Lỗi server khi tải người dùng.'};
      }
    } catch (e) {
      print('Error fetching users: $e');
      return {'success': false, 'message': 'Không thể kết nối đến server để tải người dùng.'};
    }
  }
}

// Lưu ý: Đảm bảo class User chỉ được định nghĩa trong models/user.dart
// Nếu bạn có định nghĩa class User ở đây, hãy xóa nó đi để tránh xung đột tên.