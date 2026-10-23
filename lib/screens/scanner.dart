import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  List<Application> _apps = [];
  List<Application> _filtered = [];
  bool _loading = true;

  final _keywords = [
    'kavana', 'talkie', 'chai', 'character', 'replika', 'ai',
    'chat', 'story', 'candy', 'poly', 'linky', 'momo'
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await DeviceApps.getInstalledApplications(
      includeAppName: true, includeSystemApps: false);
    final hits = all.where((a) {
      final n = (a.appName).toLowerCase();
      return _keywords.any((k) => n.contains(k));
    }).toList();
    setState(() {
      _apps = hits;
      _filtered = hits;
      _loading = false;
    });
  }

  void _search(String q) {
    setState(() {
      _filtered = _apps
          .where((a) => a.appName.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI App Scanner')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: _search,
                    decoration: InputDecoration(
                      hintText: 'Filter apps...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFF151B24),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final a = _filtered[i];
                      return ListTile(
                        leading: a.icon != null
                            ? Image.memory(a.icon!, width: 40, height: 40)
                            : const Icon(Icons.android),
                        title: Text(a.appName),
                        subtitle: Text(a.packageName,
                            style: const TextStyle(fontSize: 11)),
                        trailing: const Icon(Icons.bug_report,
                            color: Color(0xFF00E5A0)),
                        onTap: () => _showDetail(a),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _showDetail(Application a) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151B24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(a.appName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(a.packageName, style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 16),
            const Text('Next steps:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox
