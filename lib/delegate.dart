import 'package:data_type_detector/detector.dart';

part 'request.dart';
part 'response.dart';

/// Delegate interface for providing custom storage mechanisms.
abstract class SettingsDelegate {
  /// Backup a setting.
  bool backup(SettingsWriteRequest request);

  /// Fetch a cached value for a setting.
  Object? cache(SettingsReadRequest request);

  /// Clean all settings in storage.
  Future<void> clean();

  /// Fetch all settings from storage.
  Future<SettingsBackupResponse> get();

  /// Set a value in storage.
  Future<void> set(SettingsWriteRequest request);
}
