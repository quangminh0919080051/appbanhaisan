import 'package:flutter/material.dart';
import '../models/product.dart'; // Import Product model
import '../models/order.dart'; // Import Order model
import '../models/user.dart'; // Import User model (Đây là nơi định nghĩa User chính)
import '../services/api_service.dart'; // Import ApiService (cho Product)
import '../services/order_service.dart'; // Import OrderService (cho Order)
import '../services/auth_service.dart' as authService; // RẤT QUAN TRỌNG: Thêm 'as authService' để tránh xung đột tên
import '../screens/create_product_page.dart'; // Import CreateProductPage
import '../screens/edit_product_page.dart'; // Import EditProductPage

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  final GlobalKey<_ProductManagementContentState> _productManagementKey =
      GlobalKey<_ProductManagementContentState>();
  final GlobalKey<_OrderManagementContentState> _orderManagementKey =
      GlobalKey<_OrderManagementContentState>();
  final GlobalKey<_UserManagementContentState> _userManagementKey =
      GlobalKey<_UserManagementContentState>(); // Key cho UserManagement
  final GlobalKey<_AdminDashboardContentState> _dashboardKey =
      GlobalKey<_AdminDashboardContentState>(); // Key cho AdminDashboardContent

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản trị viên'),
        backgroundColor: const Color(0xFFFF385C),
        foregroundColor: Colors.white,
      ),
      drawer: _buildAdminDrawer(context),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            AdminDashboardContent(key: _dashboardKey), // Pass key to dashboard
            ProductManagementContent(key: _productManagementKey),
            OrderManagementContent(key: _orderManagementKey),
            UserManagementContent(key: _userManagementKey), // Truyền key cho UserManagement
            const AdminProfileContent(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF385C),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Sản phẩm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Người dùng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              _dashboardKey.currentState?.refreshDashboardData(); // Refresh dashboard data
            } else if (index == 1) {
              _productManagementKey.currentState?.refreshProducts();
            } else if (index == 2) {
              _orderManagementKey.currentState?.refreshOrders();
            } else if (index == 3) {
              _userManagementKey.currentState?.refreshUsers();
            }
          });
        },
      ),
    );
  }

  Widget _buildAdminDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFFF385C),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 35,
                    color: Color(0xFFFF385C),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'admin@gmail.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Tổng quan'),
            onTap: () {
              setState(() => _selectedIndex = 0);
              _dashboardKey.currentState?.refreshDashboardData(); // Refresh dashboard from drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Quản lý sản phẩm'),
            onTap: () {
              setState(() => _selectedIndex = 1);
              _productManagementKey.currentState?.refreshProducts();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Quản lý đơn hàng'),
            onTap: () {
              setState(() => _selectedIndex = 2);
              _orderManagementKey.currentState?.refreshOrders();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Quản lý người dùng'),
            onTap: () {
              setState(() => _selectedIndex = 3);
              _userManagementKey.currentState?.refreshUsers(); // Làm mới người dùng từ drawer
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Cài đặt hệ thống'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Trợ giúp'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFFF385C)),
            title: const Text(
              'Đăng xuất',
              style: TextStyle(color: Color(0xFFFF385C)),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}

// --- CÁC WIDGET CON NẰM TRONG CÙNG FILE ADMIN_PAGE.DART ---

class AdminDashboardContent extends StatefulWidget {
  const AdminDashboardContent({super.key});

  @override
  State<AdminDashboardContent> createState() => _AdminDashboardContentState();
}

class _AdminDashboardContentState extends State<AdminDashboardContent> {
  final ApiService _apiService = ApiService();
  int _productCount = 0;
  int _orderCount = 0;
  int _userCount = 0;
  double _totalRevenue = 0.0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    refreshDashboardData();
  }

  void refreshDashboardData() {
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Fetch products count
      final products = await _apiService.fetchProducts();
      _productCount = products.length;

      // Fetch orders and calculate total revenue and order count
      final orderResult = await OrderService.getOrders();
      if (orderResult['success'] == true) {
        final List<Order> orders = orderResult['orders'] as List<Order>;
        _orderCount = orders.length;
        _totalRevenue = orders.fold(0.0, (sum, order) => sum + (order.totalAmount ?? 0.0));
      } else {
        throw Exception(orderResult['message'] ?? 'Failed to fetch orders');
      }

      // Fetch user count
      final userResult = await authService.AuthService.getUsers();
      if (userResult['success'] == true) {
        final List<User> users = userResult['users'] as List<User>;
        _userCount = users.length;
      } else {
        throw Exception(userResult['message'] ?? 'Failed to fetch users');
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Không thể tải dữ liệu tổng quan: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  // Helper to format currency
  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B'; // Billions
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M'; // Millions
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K'; // Thousands
    }
    return amount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF385C)),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 50, color: Colors.red),
            const SizedBox(height: 10),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchDashboardData,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF385C), foregroundColor: Colors.white),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildStatCard(
          'Doanh thu',
          '${_formatCurrency(_totalRevenue)} VNĐ',
          Icons.monetization_on,
          Colors.green,
        ),
        _buildStatCard(
          'Đơn hàng',
          _orderCount.toString(),
          Icons.shopping_cart,
          Colors.blue,
        ),
        _buildStatCard(
          'Sản phẩm',
          _productCount.toString(),
          Icons.inventory,
          Colors.orange,
        ),
        _buildStatCard(
          'Người dùng',
          _userCount.toString(),
          Icons.people,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Optional: Add navigation based on the card tapped
          if (title == 'Sản phẩm') {
            final adminPage = context.findAncestorStateOfType<_AdminPageState>();
            adminPage?.setState(() => adminPage._selectedIndex = 1);
            adminPage?._productManagementKey.currentState?.refreshProducts();
          } else if (title == 'Đơn hàng') {
            final adminPage = context.findAncestorStateOfType<_AdminPageState>();
            adminPage?.setState(() => adminPage._selectedIndex = 2);
            adminPage?._orderManagementKey.currentState?.refreshOrders();
          } else if (title == 'Người dùng') {
            final adminPage = context.findAncestorStateOfType<_AdminPageState>();
            adminPage?.setState(() => adminPage._selectedIndex = 3);
            adminPage?._userManagementKey.currentState?.refreshUsers();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductManagementContent extends StatefulWidget {
  const ProductManagementContent({super.key});

  @override
  State<ProductManagementContent> createState() => _ProductManagementContentState();
}

class _ProductManagementContentState extends State<ProductManagementContent> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void refreshProducts() {
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final products = await _apiService.fetchProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Không thể tải sản phẩm: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(int productId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _apiService.deleteProduct(productId);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sản phẩm đã được xóa thành công!'), backgroundColor: Colors.green),
        );
        _fetchProducts();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa sản phẩm: ${e.toString()}'), backgroundColor: Colors.red),
        );
      } finally {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToEditProductPage(Product product) async {
    final result = await Navigator.pushNamed(
      context,
      '/edit-product',
      arguments: product,
    );

    if (result == true) {
      _fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateProductPage()),
              );
              if (result == true) {
                _fetchProducts();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF385C),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Thêm sản phẩm mới', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF385C)),
                  ),
                )
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 50, color: Colors.red),
                          const SizedBox(height: 10),
                          Text(_error!, textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _fetchProducts,
                            child: const Text('Thử lại'),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF385C), foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : _products.isEmpty
                      ? const Center(child: Text('Không có sản phẩm nào.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 2,
                              child: ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                    image: product.imageUrl != null && product.imageUrl!.isNotEmpty
                                        ? DecorationImage(
                                              image: NetworkImage(product.imageUrl!),
                                              fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: product.imageUrl == null || product.imageUrl!.isEmpty
                                      ? const Icon(Icons.image, color: Colors.grey)
                                      : null,
                                ),
                                title: Text(product.productName ?? 'Sản phẩm không tên'),
                                subtitle: Text('${product.price?.toStringAsFixed(0) ?? 'N/A'} VNĐ',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        if (product.productId != null) {
                                          _navigateToEditProductPage(product);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Không thể chỉnh sửa sản phẩm không có ID.')),
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: product.productId != null
                                          ? () => _deleteProduct(product.productId!)
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}

// --- Order Management Content ---
class OrderManagementContent extends StatefulWidget {
  const OrderManagementContent({super.key});

  @override
  State<OrderManagementContent> createState() => _OrderManagementContentState();
}

class _OrderManagementContentState extends State<OrderManagementContent> {
  List<Order> _orders = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  void refreshOrders() {
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await OrderService.getOrders();
      if (result['success'] == true) {
        setState(() {
          _orders = result['orders'] as List<Order>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = result['message'] ?? 'Không thể tải đơn hàng.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Lỗi kết nối hoặc xử lý dữ liệu: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteOrder(int orderId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa đơn hàng này?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        final result = await OrderService.deleteOrder(orderId);
        if (!mounted) return;
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message']!), backgroundColor: Colors.green),
          );
          _fetchOrders();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message']!), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa đơn hàng: ${e.toString()}'), backgroundColor: Colors.red),
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Danh sách đơn hàng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFFFF385C)),
                onPressed: _fetchOrders,
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF385C)),
                  ),
                )
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 50, color: Colors.red),
                          const SizedBox(height: 10),
                          Text(_error!, textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _fetchOrders,
                            child: const Text('Thử lại'),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF385C), foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : _orders.isEmpty
                      ? const Center(child: Text('Không có đơn hàng nào.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _orders.length,
                          itemBuilder: (context, index) {
                            final order = _orders[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 2,
                              child: ListTile(
                                leading: const Icon(Icons.shopping_bag, color: Color(0xFFFF385C)),
                                title: Text('Đơn hàng #${order.orderId ?? 'N/A'}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Khách hàng: ${order.customerName ?? 'N/A'}'),
                                    Text('Tổng tiền: ${order.totalAmount?.toStringAsFixed(0) ?? 'N/A'} VNĐ'),
                                    Text('Trạng thái: ${order.status ?? 'N/A'}'),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        // TODO: Implement navigation to an EditOrderPage
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Chức năng chỉnh sửa đơn hàng chưa được triển khai.')),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: order.orderId != null
                                          ? () => _deleteOrder(order.orderId!)
                                          : null,
                                    ),
                                  ],
                                ),
                                isThreeLine: true,
                                onTap: () {
                                  // Optional: Navigate to order details page
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(order: order)));
                                },
                              ),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}

// --- User Management Content ---
class UserManagementContent extends StatefulWidget {
  const UserManagementContent({super.key});

  @override
  State<UserManagementContent> createState() => _UserManagementContentState();
}

class _UserManagementContentState extends State<UserManagementContent> {
  List<User> _users = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void refreshUsers() {
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // Đã sửa: Sử dụng tiền tố authService.AuthService
      final result = await authService.AuthService.getUsers();
      if (result['success'] == true) {
        setState(() {
          _users = result['users'] as List<User>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = result['message'] ?? 'Không thể tải danh sách người dùng.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Lỗi kết nối hoặc xử lý dữ liệu: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Danh sách người dùng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFFFF385C)),
                onPressed: _fetchUsers,
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF385C)),
                  ),
                )
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 50, color: Colors.red),
                          const SizedBox(height: 10),
                          Text(_error!, textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _fetchUsers,
                            child: const Text('Thử lại'),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF385C), foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : _users.isEmpty
                      ? const Center(child: Text('Không có người dùng nào.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            final user = _users[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 2,
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(user.name ?? 'Người dùng không tên'),
                                subtitle: Text(user.email ?? 'Không có email'),
                                trailing: Text(
                                  user.role ?? 'N/A',
                                  style: TextStyle(
                                    color: user.role == 'admin' ? Colors.red : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  // TODO: Triển khai trang chi tiết/chỉnh sửa người dùng nếu cần
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Chức năng quản lý người dùng cho ${user.name} chưa được triển khai.')),
                                  );
                                },
                              ),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}

class AdminProfileContent extends StatelessWidget {
  const AdminProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFFF385C),
                child: Icon(
                  Icons.admin_panel_settings,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Admin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Đã đổi thành màu đen để dễ nhìn hơn trên nền trắng
                ),
              ),
              Text(
                'admin@gmail.com',
                style: TextStyle(
                  color: Colors.black54, // Đã đổi thành màu đen nhạt hơn
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Thông tin cá nhân'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Bảo mật tài khoản'),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Cài đặt hệ thống'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Trợ giúp & Hỗ trợ'),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Color(0xFFFF385C)),
          title: const Text(
            'Đăng xuất',
            style: TextStyle(color: Color(0xFFFF385C)),
          ),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }
}