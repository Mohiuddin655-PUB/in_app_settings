import 'package:flutter/material.dart';
import 'package:in_app_settings/settings.dart';

/// Example delegate storing settings in memory.
class MySettingsDelegate implements SettingsDelegate {
  final Map<String, dynamic> _store = {};

  @override
  bool backup(SettingsWriteRequest request) {
    _store[request.path] = request.value;
    return true;
  }

  @override
  Object? cache(SettingsReadRequest request) {
    return _store[request.path];
  }

  @override
  Future<void> clean() async => _store.clear();

  @override
  Future<SettingsBackupResponse> get() async {
    // GET FROM REMOTE
    return SettingsBackupResponse.ok(_store);
  }

  @override
  Future<void> set(SettingsWriteRequest request) async {
    // SAVE TO REMOTE
    _store[request.path] = request.value;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Settings
  await Settings.init(showLogs: true, delegate: MySettingsDelegate());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('Settings Example')),
        body: const SettingsDemo(),
      ),
    );
  }
}

class SettingsDemo extends StatefulWidget {
  const SettingsDemo({super.key});

  @override
  State<SettingsDemo> createState() => _SettingsDemoState();
}

class _SettingsDemoState extends State<SettingsDemo> {
  @override
  Widget build(BuildContext context) {
    final counter = Settings.get('counter', 0);
    final items = Settings.get('items', <String>[]);
    final user = Settings.get('user', {'name': 'Guest'});

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Counter: $counter'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Settings.increment('counter', 1);
              setState(() {});
            },
            child: const Text('Increment Counter'),
          ),
          const SizedBox(height: 16),
          Text('Items: ${items.join(', ')}'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Settings.arrayUnion('items', ['apple', 'banana']);
              setState(() {});
            },
            child: const Text('Add Items'),
          ),
          ElevatedButton(
            onPressed: () {
              Settings.arrayRemove('items', ['banana']);
              setState(() {});
            },
            child: const Text('Remove Banana'),
          ),
          const SizedBox(height: 16),
          Text('User: ${user['name']}'),
          ElevatedButton(
            onPressed: () {
              Settings.set('user', {'name': 'Alice'});
              setState(() {});
            },
            child: const Text('Set User Name to Alice'),
          ),
        ],
      ),
    );
  }
}
