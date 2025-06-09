class AuthService {
  // Dữ liệu đăng nhập mẫu
  static final Map<String, Map<String, dynamic>> _users = {
    'admin@gmail.com': {
      'password': 'admin123',
      'role': 'admin',
      'name': 'Admin'
    },
    'minh@gmail.com': {
      'password': '123',
      'role': 'user',
      'name': 'User'
    },
  };

  static Future<Map<String, dynamic>> login(String email, String password) async {
    print('Login attempt - Email: $email, Password: $password'); // Debug print
    
    // Giả lập delay network
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_users.containsKey(email) && _users[email]!['password'] == password) {
      print('Login successful - Role: ${_users[email]!['role']}'); // Debug print
      return {
        'success': true,
        'role': _users[email]!['role'],
        'name': _users[email]!['name']
      };
    }
    
    print('Login failed - Invalid credentials'); // Debug print
    return {'success': false};
  }
}