import 'package:flutter/material.dart';
import '../screens/category_page.dart';
import '../screens/cart_page.dart';
import '../screens/favorite_page.dart';
import '../screens/notification_page.dart';
import '../screens/profile_page.dart';
import '../screens/chat_widget.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final String price;
  final String imageNumber;
  final bool isNew;
  final double rating;
  final int reviews;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageNumber,
    this.isNew = false,
    this.rating = 5.0,
    this.reviews = 0,
  });
}

// Khi tạo danh sách sản phẩm, đảm bảo truyền đầy đủ các tham số
final List<Product> productList = [
  Product(
    id: '1',
    name: 'Tôm Hùm Alaska',
    category: 'Hải sản cao cấp',
    price: '1.200.000₫/kg',
    imageNumber: 'sanpham1',
    isNew: true,
    rating: 4.9,
    reviews: 128,
  ),
  Product(
    id: '2',
    name: 'Cua Hoàng Đế',
    category: 'Hải sản cao cấp',
    price: '2.500.000₫/kg',
    imageNumber: 'sanpham2',
    rating: 5.0,
    reviews: 89,
  ),
  Product(
    id: '3',
    name: 'Mực Ống Tươi',
    category: 'Hải sản thông dụng',
    price: '180.000₫/kg',
    imageNumber: 'sanpham3',
    rating: 4.7,
    reviews: 256,
  ),
  Product(
    id: '4',
    name: 'Cá Hồi Nauy',
    category: 'Cá tươi',
    price: '550.000₫/kg',
    imageNumber: 'sanpham4',
    isNew: true,
    rating: 4.8,
    reviews: 167,
  ),
  Product(
    id: '5',
    name: 'Bào Ngư Hàn Quốc',
    category: 'Hải sản cao cấp',
    price: '3.200.000₫/kg',
    imageNumber: 'sanpham5',
    rating: 4.9,
    reviews: 45,
  ),
  Product(
    id: '6',
    name: 'Ghẹ Xanh',
    category: 'Hải sản thông dụng',
    price: '450.000₫/kg',
    imageNumber: 'sanpham6',
    rating: 4.6,
    reviews: 198,
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeContent(),
          CartPage(),
          FavoritePage(),
          NotificationPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFFF385C),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Giỏ hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Yêu thích',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatWidget(),
                ),
              );
            },
            backgroundColor: const Color(0xFFFF385C),
            child: const Icon(Icons.chat, color: Colors.white),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 14,
                minHeight: 14,
              ),
              child: Center(
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hải sản tươi sống',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Chất lượng cao, giá cả hợp lý',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
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
                    Icons.person,
                    size: 35,
                    color: Color(0xFFFF385C),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Xin chào!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'user@example.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Giỏ hàng'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cart');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Lịch sử đơn hàng'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Sản phẩm yêu thích'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Cài đặt'),
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

// Tạo widget mới cho nội dung trang chủ
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeroSection(),
        _buildCategorySection(),
        _buildProductGrid(),
      ],
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFFF385C),
        ),
        child: Stack(
          fit: StackFit.expand, // Add this to ensure Stack fills container
          children: [
            ClipRRect( // Wrap image in ClipRRect
              borderRadius: BorderRadius.circular(16),
              child: Align( // Use Align instead of Positioned
                alignment: Alignment.centerRight,
                child: Image.asset(
                  'assets/images/hero_image.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[300]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ưu đãi mùa hè',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24, // Reduced font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Giảm giá đến 30%',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16, // Reduced font size
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox( // Wrap button in SizedBox to control height
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF385C),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8, // Reduced padding
                        ),
                      ),
                      child: const Text('Xem ngay'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    final categories = [
      {'icon': Icons.star, 'name': 'Cao cấp'},
      {'icon': Icons.trending_up, 'name': 'Bán chạy'},
      {'icon': Icons.local_offer, 'name': 'Khuyến mãi'},
      {'icon': Icons.new_releases, 'name': 'Mới về'},
    ];

    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Container(
              width: 100,
              margin: EdgeInsets.only(
                left: index == 0 ? 16 : 8,
                right: index == categories
                    .length - 1 ? 16 : 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      category['icon'] as IconData,
                      color: const Color(0xFFFF385C),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/product-detail',
            arguments: {
              'id': product.id,
              'name': product.name,
              'price': product.price,
              'category': product.category,
              'imageNumber': product.imageNumber,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  'assets/images/${product.imageNumber}.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 50),
                      ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFFF385C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (product.isNew) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF385C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Mới',
                          style: TextStyle(
                            color: Color(0xFFFF385C),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update the grid delegate to use a fixed aspect ratio
  Widget _buildProductGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7, // Adjust this value to control card height
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildProductCard(productList[index], context),
          childCount: productList.length,
        ),
      ),
    );
  }
}