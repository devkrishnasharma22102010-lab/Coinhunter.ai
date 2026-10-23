import 'package:flutter/material.dart';
import 'scanner.dart';
import 'chat.dart';
import 'guide.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _Tile('App Scanner', 'Find AI apps & their coin systems', Icons.search, const ScannerScreen()),
      _Tile('Free Chat', 'Talk to captured endpoints, no coins', Icons.chat_bubble, const ChatScreen()),
      _Tile('Setup Guide', 'MITM, Frida, cert install steps', Icons.menu_book, const GuideScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('CoinHunter',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00E5A0), Color(0xFF7C5CFF)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your AI apps,\nminus the coins.',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 8),
                Text('Capture APIs. Replay them free.',
                    style: TextStyle(color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...tiles.map((t) => Card(
            color: const Color(0xFF151B24),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(t.icon, color: const Color(0xFF00E5A0), size: 32),
              title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              subtitle: Text(t.sub, style: const TextStyle(color: Colors.white60)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => t.screen)),
            ),
          )),
        ],
      ),
    );
  }
}

class _Tile {
  final String title, sub;
  final IconData icon;
  final Widget screen;
  _Tile(this.title, this.sub, this.icon, this.screen);
}
