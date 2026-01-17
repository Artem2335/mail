import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/message.dart';
import '../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  final String contactId;
  final String contactName;
  final String contactEmail;

  const ChatScreen({
    Key? key,
    required this.contactId,
    required this.contactName,
    required this.contactEmail,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _imagePicker = ImagePicker();
  List<Message> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    try {
      final messages = await ApiService.getMessages(widget.contactId);
      setState(() => _messages = messages);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load messages: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final messageText = _messageController.text;
    _messageController.clear();

    setState(() => _isSending = true);
    try {
      final message = await ApiService.sendMessage(
        receiverId: widget.contactId,
        content: messageText,
      );

      setState(() {
        _messages.add(message);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() => _isSending = true);
        final message = await ApiService.uploadFile(
          receiverId: widget.contactId,
          filePath: image.path,
        );

        setState(() {
          _messages.add(message);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _pickAndUploadVideo() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );

      if (video != null) {
        setState(() => _isSending = true);
        final message = await ApiService.uploadFile(
          receiverId: widget.contactId,
          filePath: video.path,
        );

        setState(() {
          _messages.add(message);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload video: $e')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.contactName),
            Text(
              widget.contactEmail,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(
                        child: Text('No messages yet. Start a conversation!'),
                      )
                    : ListView.builder(
                        reverse: true,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[_messages.length - 1 - index];
                          return _buildMessageBubble(message);
                        },
                      ),
          ),
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isOwn = true; // In real app, compare with current user ID

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment:
            isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isOwn)
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFdf9f1f),
              child: Text(
                widget.contactName[0],
                style: const TextStyle(
                  color: Color(0xFF1c1404),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isOwn
                    ? const Color(0xFFdf9f1f)
                    : const Color(0xFF503c32),
                borderRadius: BorderRadius.circular(12),
              ),
              child: message.fileType == 'text'
                  ? Text(
                      message.content,
                      style: TextStyle(
                        color:
                            isOwn ? const Color(0xFF1c1404) : const Color(0xFFeecd8a),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.fileType == 'image')
                          Image.network(
                            'http://localhost:8080${message.fileUrl}',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        else
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.video_file),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  message.fileName ?? 'Video',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
            ),
          ),
          const SizedBox(width: 8),
          if (isOwn)
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFdf9f1f),
              child: const Text(
                'U',
                style: TextStyle(
                  color: Color(0xFF1c1404),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF503c32).withOpacity(0.5),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF848483).withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.attach_file,
              color: Color(0xFFdf9f1f),
            ),
            onPressed: () => _showMediaMenu(),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFF848483),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              minLines: 1,
              maxLines: 3,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: _isSending
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(Color(0xFFdf9f1f)),
                    ),
                  )
                : const Icon(
                    Icons.send,
                    color: Color(0xFFdf9f1f),
                  ),
            onPressed: _isSending ? null : _sendMessage,
          ),
        ],
      ),
    );
  }

  void _showMediaMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.image,
                color: Color(0xFFdf9f1f),
              ),
              title: const Text('Send Image'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.video_file,
                color: Color(0xFFdf9f1f),
              ),
              title: const Text('Send Video'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadVideo();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
