import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thông báo'),
          backgroundColor: const Color(0xFFFF385C),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Đơn hàng'),
              Tab(text: 'Khuyến mãi'),
              Tab(text: 'Cập nhật'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNotificationList('order'),
            _buildNotificationList('promotion'),
            _buildNotificationList('update'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(String type) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFFF385C).withOpacity(0.1),
              child: Icon(
                type == 'order'
                    ? Icons.local_shipping
                    : type == 'promotion'
                        ? Icons.local_offer
                        : Icons.update,
                color: const Color(0xFFFF385C),
              ),
            ),
            title: Text(
              type == 'order'
                  ? 'Đơn hàng #${1000 + index} đang được giao'
                  : type == 'promotion'
                      ? 'Giảm giá 20% cho đơn hàng từ 1 triệu'
                      : 'Cập nhật giá sản phẩm mới',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  type == 'order'
                      ? 'Đơn hàng của bạn sẽ được giao trong hôm nay'
                      : type == 'promotion'
                          ? 'Áp dụng từ 01/06 đến 30/06'
                          : 'Cập nhật bảng giá mới nhất tháng 6',
                ),
                const SizedBox(height: 4),
                Text(
                  '2 giờ trước',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}