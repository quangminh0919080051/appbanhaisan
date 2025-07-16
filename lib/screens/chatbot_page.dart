// lib/screens/chatbot_page.dart
import 'package:flutter/material.dart';
import '../services/chatbot_service.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ChatbotService _chatbotService = ChatbotService();

  @override
  void initState() {
    super.initState();
    _messages.add({'sender': 'ai', 'message': 'Chào bạn, tôi là trợ lý AI của cửa hàng hải sản. Tôi có thể giúp gì cho bạn?'});
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Lần setState đầu tiên: Thêm tin nhắn của người dùng
    setState(() {
      _messages.add({'sender': 'user', 'message': text});
    });
    _messageController.clear();

    // Lần setState thứ hai: Hiển thị tin nhắn "Đang suy nghĩ..."
    setState(() {
      _messages.add({'sender': 'ai', 'message': 'Đang suy nghĩ...'});
    });

    try {
      final aiResponse = await _chatbotService.getChatbotResponse(text);

      // ####################################################################
      // ## KIỂM TRA mounted TRƯỚC KHI GỌI setState() SAU TÁC VỤ ASYNC    ##
      // ####################################################################
      if (!mounted) return; // Rất quan trọng: Thoát nếu widget không còn trên cây

      setState(() {
        _messages.removeLast(); // Xóa tin nhắn "Đang suy nghĩ..."
        _messages.add({'sender': 'ai', 'message': aiResponse});
      });
    } catch (e) {
      // ####################################################################
      // ## KIỂM TRA mounted TRƯỚC KHI GỌI setState() SAU TÁC VỤ ASYNC    ##
      // ####################################################################
      if (!mounted) return; // Rất quan trọng: Thoát nếu widget không còn trên cây

      setState(() {
        _messages.removeLast(); // Xóa tin nhắn "Đang suy nghĩ..."
        _messages.add({'sender': 'ai', 'message': 'Đã xảy ra lỗi khi giao tiếp với AI. Vui lòng thử lại sau.'});
      });
      debugPrint('Lỗi khi gửi tin nhắn đến AI: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat với AI'),
        backgroundColor: const Color(0xFFFF385C),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFFFF385C).withOpacity(0.8) : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isUser ? const Radius.circular(12) : const Radius.circular(0),
                        bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      message['message']!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: const Color(0xFFFF385C),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}