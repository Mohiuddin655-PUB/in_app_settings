import 'package:data_type_detector/detector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_settings/in_app_settings.dart';

/// A simple in-memory delegate for testing purposes.
class TestSettingsDelegate implements SettingsDelegate {
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
  Future<void> clean() async {
    _store.clear();
  }

  @override
  Future<SettingsBackupResponse> get() async {
    return SettingsBackupResponse.ok(_store);
  }

  @override
  Future<void> set(SettingsWriteRequest request) async {
    _store[request.path] = request.value;
  }
}

void main() {
  group('Settings package tests', () {
    late TestSettingsDelegate delegate;

    setUp(() async {
      delegate = TestSettingsDelegate();
      await Settings.init(showLogs: true, delegate: delegate);
      await Settings.clear();
    });

    test('Set and get primitive values', () {
      expect(Settings.set('int', 42), true);
      expect(Settings.get('int', 0), 42);

      expect(Settings.set('double', 3.14), true);
      expect(Settings.get('double', 0.0), 3.14);

      expect(Settings.set('bool', true), true);
      expect(Settings.get('bool', false), true);

      expect(Settings.set('string', 'hello'), true);
      expect(Settings.get('string', ''), 'hello');
    });

    test('Increment numeric values', () {
      expect(Settings.set('counter', 10), true);
      expect(Settings.increment('counter', 5), true);
      expect(Settings.get('counter', 0), 15);
    });

    test('Array union and remove', () {
      expect(Settings.set('list', [1, 2]), true);
      expect(Settings.arrayUnion('list', [2, 3]), true);
      expect(Settings.get('list', []), [1, 2, 3]);

      expect(Settings.arrayRemove('list', [1]), true);
      expect(Settings.get('list', []), [2, 3]);
    });

    test('Detect DataType for settings', () {
      Settings.set('json', {'a': 1, 'b': true});
      final value = Settings.get('json', {});
      expect(value.dataType, DataType.JSON);

      Settings.set('map', {Object(): 'x'});
      final mapValue = Settings.get('map', {});
      expect(mapValue.dataType, DataType.MAP);
    });

    test('Fallback to default value', () {
      final missing = Settings.get('missingKey', 100);
      expect(missing, 100);
    });
  });
}
