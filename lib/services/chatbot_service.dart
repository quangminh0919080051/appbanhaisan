// lib/services/chatbot_service.dart
import 'package:flutter/foundation.dart'; // Sửa lại thành: import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotService {
  late final GenerativeModel _model;

  ChatbotService() {
    
    const String apiKey = 'AIzaSyAV4WLROe2eHqPaOIDCgd-IZeGfF11SHjg'; 

    if (apiKey.isEmpty) {
      throw Exception('Lỗi: Google Gemini API Key chưa được cấu hình. Vui lòng thêm khóa của bạn.');
    }

    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  Future<String> getChatbotResponse(String message) async {
    try {
      final content = [Content.text(message)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        return response.text!;
      } else {
        return 'Xin lỗi, tôi không thể hiểu yêu cầu này hoặc không thể tạo phản hồi văn bản.';
      }
    } catch (e) {
      debugPrint('Lỗi khi gọi Gemini API: $e');
      return 'Đã xảy ra lỗi khi giao tiếp với AI. Vui lòng thử lại sau.';
    }
  }
}