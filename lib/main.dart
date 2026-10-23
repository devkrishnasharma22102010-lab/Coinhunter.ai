import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() => runApp(const CoinHunterApp());

class CoinHunterApp extends StatelessWidget {
  const CoinHunterApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinHunter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F14),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5A0),
          secondary: Color(0xFF7C5CFF),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0F14),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
