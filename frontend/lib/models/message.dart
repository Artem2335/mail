class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String? fileUrl;
  final String fileType; // text, image, video
  final String? fileName;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.fileUrl,
    this.fileType = 'text',
    this.fileName,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      senderId: json['sender_id'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      content: json['content'] ?? '',
      fileUrl: json['file_url'],
      fileType: json['file_type'] ?? 'text',
      fileName: json['file_name'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'file_url': fileUrl,
      'file_type': fileType,
      'file_name': fileName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
