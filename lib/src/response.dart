/// Response for a settings backup or fetch operation.
class SettingsBackupResponse {
  final Map? _data;

  /// The fetched or backed-up data.
  Map? get data => _data;

  /// Error message if the operation failed.
  final String? error;

  /// Successful response.
  const SettingsBackupResponse.ok(Map value)
      : _data = value,
        error = null;

  /// Failed response.
  const SettingsBackupResponse.failure(this.error) : _data = null;
}
