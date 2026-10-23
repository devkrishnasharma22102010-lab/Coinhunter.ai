import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _urlCtrl = TextEditingController();
  final _authCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController(
    text: '{"message":"%MSG%"}');

  final List<Map<String, String>> _log = [];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    _urlCtrl.text = p.getString('url') ?? '';
    _authCtrl.text = p.getString('auth') ?? '';
    _bodyCtrl.text = p.getString('body') ?? '{"message":"%MSG%"}';
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('url', _urlCtrl.text);
    await p.setString('auth', _authCtrl.text);
    await p.setString('body', _bodyCtrl.text);
  }

  Future<void> _send() async {
    if (_urlCtrl.text.isEmpty) return;
    setState(() {
      _busy = true;
      _log.add({'role': 'you', 'text': _msgCtrl.text});
    });
    final body = _bodyCtrl.text.replaceAll('%MSG%', _msgCtrl.text);
    try {
      final res = await http.post(
        Uri.parse(_urlCtrl.text),
        headers: {
          'Content-Type': 'application/json',
          if (_authCtrl.text.isNotEmpty) 'Authorization': _authCtrl.text,
        },
        body: body,
      );
      setState(() {
        _log.add({'role': 'ai', 'text': res.body});
      });
    } catch (e) {
      setState(() => _log.add({'role': 'error', 'text': e.toString()}));
    }
    _msgCtrl.clear();
    setState(() => _busy = false);
    _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Free Chat')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              TextField(controller: _urlCtrl,
                decoration: const InputDecoration(labelText: 'Endpoint URL')),
              TextField(controller: _authCtrl,
                decoration: const InputDecoration(labelText: 'Authorization header')),
              TextField(controller: _bodyCtrl,
                decoration: const InputDecoration(labelText: 'Body template (%MSG% = message)')),
            ]),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _log.length,
              itemBuilder: (_, i) {
                final m = _log[i];
                return Align(
                  alignment: m['role'] == 'you'
                      ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: m['role'] == 'you'
                          ? const Color(0xFF00E5A0)
                          : const Color(0xFF151B24),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      m['text'] ?? '',
                      style: TextStyle(
                        color: m['role'] == 'you' ? Colors.black : Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              Expanded(child: TextField(controller: _msgCtrl,
                decoration: const InputDecoration(hintText: 'Message...'))),
              IconButton(
                icon: _busy
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.send, color: Color(0xFF00E5A0)),
                onPressed: _busy ? null : _send),
            ]),
          ),
        ],
      ),
    );
  }
}
