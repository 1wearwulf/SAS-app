import 'package:flutter/material.dart';

class NoConnectionBanner extends StatelessWidget {
  const NoConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.orange.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Row(
        children: [
          Icon(Icons.wifi_off, size: 16, color: Colors.orange),
          SizedBox(width: 8),
          Text(
            'No internet connection — some features are limited.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
