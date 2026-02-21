part of 'delegate.dart';

/// Response for a settings backup or fetch operation.
class SettingsBackupResponse {
  /// The fetched or backed-up data.
  final Map<String, dynamic>? data;

  /// Error message if the operation failed.
  final String? error;

  /// Successful response.
  const SettingsBackupResponse.ok(Map<String, dynamic> value)
      : data = value,
        error = null;

  /// Failed response.
  const SettingsBackupResponse.failure(this.error) : data = null;
}
