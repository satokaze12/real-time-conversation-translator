import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Start a new conversation by scanning a QR code',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showConnectionMenu,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showConnectionMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.qr_code_2),
            title: const Text('Scan QR Code'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to QR scanner
            },
          ),
          ListTile(
            leading: const Icon(Icons.dialpad),
            title: const Text('Enter Code'),
            onTap: () {
              Navigator.pop(context);
              // Show code input dialog
            },
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Join via Link'),
            onTap: () {
              Navigator.pop(context);
              // Handle link joining
            },
          ),
        ],
      ),
    );
  }
}
