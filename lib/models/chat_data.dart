class ChatData {
  String pfp;
  String author;
  String message;
  String timestamp;

  ChatData({
    required this.pfp,
    required this.author,
    required this.message,
    required this.timestamp
  });

  factory ChatData.fromJson(Map<String, dynamic> json){
    return ChatData(
      pfp: json['pfp'] ?? '',
      author: json['author'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}