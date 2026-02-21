part of 'delegate.dart';

/// Represents a request to read a setting from storage.
class SettingsReadRequest {
  /// Path or key of the setting.
  final String path;

  /// Expected data type of the setting.
  final DataType type;

  /// Default value to return if the setting is missing.
  final Object? defaultValue;

  /// Optional additional options for reading.
  final Object? options;

  /// Private constructor used internally.
  const SettingsReadRequest({
    required this.path,
    required this.defaultValue,
    required this.type,
    required this.options,
  });

  @override
  String toString() {
    return "$SettingsReadRequest(path: $path, type: $type, defaultValue: $defaultValue, options: $options)";
  }
}

/// Represents a request to write a setting to storage.
class SettingsWriteRequest {
  /// Path or key of the setting.
  final String path;

  /// Value to write.
  final Object? value;

  /// Detected type of the value.
  final DataType type;

  /// All current properties for context.
  final Map<String, dynamic> props;

  /// Optional additional options for writing.
  final Object? options;

  /// Private constructor used internally.
  const SettingsWriteRequest({
    required this.path,
    required this.value,
    required this.type,
    required this.props,
    required this.options,
  });

  @override
  String toString() {
    return "$SettingsWriteRequest(path: $path, type: $type, value: $value, props: $props, options: $options)";
  }
}
