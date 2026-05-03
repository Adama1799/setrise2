// lib/presentation/screens/shop/chat/chat_message.dart

class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });

  static List<ChatMessage> getMockMessages() {
    final now = DateTime.now();
    return [
      ChatMessage(
        id: '1',
        text: 'Hello! I am interested in your products.',
        isMe: true,
        timestamp: now.subtract(const Duration(minutes: 30)),
      ),
      ChatMessage(
        id: '2',
        text: 'Hi there! Thank you for your interest. Which product would you like to know more about?',
        isMe: false,
        timestamp: now.subtract(const Duration(minutes: 28)),
      ),
      ChatMessage(
        id: '3',
        text: 'The wireless headphones look great. Do you have them in black?',
        isMe: true,
        timestamp: now.subtract(const Duration(minutes: 25)),
      ),
      ChatMessage(
        id: '4',
        text: 'Yes, we have them in black, white, and blue. Black is our most popular color!',
        isMe: false,
        timestamp: now.subtract(const Duration(minutes: 23)),
      ),
      ChatMessage(
        id: '5',
        text: 'Perfect! What is the shipping time to Algiers?',
        isMe: true,
        timestamp: now.subtract(const Duration(minutes: 20)),
      ),
      ChatMessage(
        id: '6',
        text: 'Shipping to Algiers usually takes 2-3 business days. We also offer express delivery.',
        isMe: false,
        timestamp: now.subtract(const Duration(minutes: 18)),
      ),
    ];
  }
}
