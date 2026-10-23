import 'package:flutter/material.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('1. Install the CA certificate',
       'CoinHunter generates a CA cert. Install it under Settings > Security > Install Certificate. This lets you read HTTPS traffic.'),
      ('2. Open your target AI app',
       'Launch Kavana / Talkie / Chai and send a normal message.'),
      ('3. Copy the endpoint + token',
       'In the captured list, find the POST request. Copy its URL and Authorization header.'),
      ('4. Paste into Free Chat',
       'Open Free Chat, paste URL + token + body template, then chat freely.'),
      ('5. Optional: Frida',
       'For local-coin apps, hook SharedPreferences and set coins = 999999.'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Setup Guide')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: steps.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => Card(
          color: const Color(0xFF151B24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(steps[i].$1,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00E5A0),
                        fontSize: 16)),
                const SizedBox(height: 8),
                Text(steps[i].$2, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
