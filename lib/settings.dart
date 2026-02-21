import 'dart:developer';

import 'package:data_type_detector/detector.dart';

import 'delegate.dart';

/// Singleton manager for application settings.
class Settings {
  Settings._();

  static Settings? _i;

  /// Singleton instance.
  static Settings get i => _i ??= Settings._();

  bool _showLogs = false;
  bool _lazy = false;
  Map<String, dynamic> _props = {};
  SettingsDelegate? _delegate;
  bool initialized = false;

  bool get _local => _delegate == null;

  bool get isLazy => _lazy;

  /// Initialize the settings manager.
  ///
  /// [showLogs] enables logging.
  /// [initial] provides initial key/value pairs.
  /// [delegate] provides a custom storage mechanism.
  static Future<void> init({
    bool showLogs = false,
    bool lazy = true,
    Map<String, dynamic>? initial,
    SettingsDelegate? delegate,
  }) async {
    i._lazy = lazy;
    i._showLogs = showLogs;
    i._delegate = delegate;
    if (initial != null) i._props = initial;
    i.initialized = true;
    if (lazy) {
      load();
    } else {
      await load();
    }
  }

  /// Executes a callback on the singleton instance.
  static T _execute<T>(T Function(Settings) callback) {
    if (i.initialized) return callback(i);
    throw "$Settings hasn't initialized yet!";
  }

  /// Logs a message if logging is enabled.
  static void _log(Object? msg) {
    if (!i._showLogs) return;
    log(msg.toString(), name: "$Settings");
  }

  /// Load settings from the delegate (if provided) into local cache.
  static Future<void> load() async {
    try {
      if (i._delegate == null) return;
      final response = await i._delegate!.get();
      if (response.data == null) return _log(response.error);
      i._props.addAll(response.data!);
    } catch (msg) {
      _log(msg);
    }
  }

  /// Clear all settings.
  static Future<bool> clear() async {
    try {
      if (i._delegate != null) await i._delegate!.clean();
      i._props.clear();
      return true;
    } catch (msg) {
      _log(msg);
      return false;
    }
  }

  /// Get a value for a given [key].
  ///
  /// Returns [defaultValue] if not found or type mismatches.
  /// Optional [options] can be passed for delegate-specific behavior.
  static T get<T>(String key, T defaultValue, {Object? options}) {
    try {
      if (i._local) {
        final data = i._props[key];
        return data is T ? data : defaultValue;
      }
      return _execute((i) {
        Object? cached;
        final request = SettingsReadRequest(
          path: key,
          type: defaultValue.dataType,
          defaultValue: defaultValue,
          options: options,
        );
        if (i._delegate != null) {
          cached = i._delegate?.cache(request);
        }
        cached ??= i._props[key];
        if (cached is T) {
          return cached;
        }
        return defaultValue;
      });
    } catch (msg) {
      _log(msg);
      return defaultValue;
    }
  }

  /// Set a value for a given [key].
  ///
  /// Returns true if successfully set locally or via delegate.
  static bool set(String key, Object? value, {Object? options}) {
    try {
      i._props[key] = value;
      if (i._local) return true;
      return _execute((i) {
        final request = SettingsWriteRequest(
          path: key,
          value: value,
          type: value.dataType,
          props: i._props,
          options: options,
        );
        final feedback = i._delegate?.backup(request);
        i._delegate?.set(request);
        return feedback ?? i._delegate == null;
      });
    } catch (msg) {
      _log(msg);
      return false;
    }
  }

  /// Increment a numeric setting by [value].
  static bool increment(String key, num value, {Object? options}) {
    try {
      value = value + get(key, 0, options: options);
      return set(key, value, options: options);
    } catch (msg) {
      _log(msg);
      return false;
    }
  }

  /// Add elements to a list setting, avoiding duplicates.
  static bool arrayUnion(String key, Iterable value, {Object? options}) {
    try {
      Set current = Set.of(get(key, [], options: options));
      current.addAll(value);
      return set(key, current.toList(), options: options);
    } catch (msg) {
      _log(msg);
      return false;
    }
  }

  /// Remove elements from a list setting.
  static bool arrayRemove(String key, Iterable value, {Object? options}) {
    try {
      Set current = Set.of(get(key, [], options: options));
      current.removeAll(value);
      return set(key, current.toList(), options: options);
    } catch (msg) {
      _log(msg);
      return false;
    }
  }
}
