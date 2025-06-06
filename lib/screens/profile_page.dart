import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFFF385C),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFFFF385C),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFFFF385C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nguyễn Văn A',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'user@example.com',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileSection(
                  'Thông tin tài khoản',
                  [
                    _buildProfileTile(
                      Icons.person_outline,
                      'Thông tin cá nhân',
                      () {},
                    ),
                    _buildProfileTile(
                      Icons.location_on_outlined,
                      'Địa chỉ giao hàng',
                      () {},
                    ),
                    _buildProfileTile(
                      Icons.payment_outlined,
                      'Phương thức thanh toán',
                      () {},
                    ),
                  ],
                ),
                _buildProfileSection(
                  'Đơn hàng',
                  [
                    _buildProfileTile(
                      Icons.shopping_bag_outlined,
                      'Đơn hàng của tôi',
                      () {},
                    ),
                    _buildProfileTile(
                      Icons.favorite_border,
                      'Sản phẩm yêu thích',
                      () {},
                    ),
                    _buildProfileTile(
                      Icons.history,
                      'Lịch sử mua hàng',
                      () {},
                    ),
                  ],
                ),
                _buildProfileSection(
                  'Khác',
                  [
                    _buildProfileTile(
                      Icons.settings_outlined,
                      'Cài đặt',
                      () {},
                    ),
                    _buildProfileTile(
                      Icons.help_outline,
                      'Trợ giúp & Hỗ trợ',
                      () {},
                    ),
                    _buildProfileTile(
                      Icons.logout,
                      'Đăng xuất',
                      () => Navigator.pushReplacementNamed(context, '/login'),
                      color: const Color(0xFFFF385C),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...tiles,
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProfileTile(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}