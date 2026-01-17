import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'chat_screen.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late SharedPreferences _prefs;
  String? _currentUserEmail;

  // Mock contacts - in real app, would be fetched from server
  final List<Map<String, String>> _contacts = [
    {'id': '1', 'name': 'Alex Johnson', 'email': 'alex@example.com', 'status': 'Online'},
    {'id': '2', 'name': 'Sarah Smith', 'email': 'sarah@example.com', 'status': 'Away'},
    {'id': '3', 'name': 'Mike Davis', 'email': 'mike@example.com', 'status': 'Offline'},
    {'id': '4', 'name': 'Emma Wilson', 'email': 'emma@example.com', 'status': 'Online'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserEmail = _prefs.getString('user_email');
    });
  }

  Future<void> _logout() async {
    await ApiService.logout();
    await _prefs.remove('user_email');
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _currentUserEmail == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return _buildContactTile(contact);
              },
            ),
    );
  }

  Widget _buildContactTile(Map<String, String> contact) {
    final isOnline = contact['status'] == 'Online';
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                contactId: contact['id']!,
                contactName: contact['name']!,
                contactEmail: contact['email']!,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF503c32).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF848483).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFFdf9f1f),
                      child: Text(
                        contact['name']![0],
                        style: const TextStyle(
                          color: Color(0xFF1c1404),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: const Color(0xFF1c1404), width: 2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Contact info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['name']!,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact['status']!,
                        style: TextStyle(
                          color: isOnline
                              ? Colors.green
                              : const Color(0xFF848483),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF848483),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
