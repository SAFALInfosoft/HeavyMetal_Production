// lib/error_data.dart

/// Represents error or status responses coming from your API.
class ErrorData implements Exception {
  final Settings? settings;
  final String? type;
  final String? message;

  ErrorData({this.settings, this.type, this.message});

  /// Factory constructor to build from JSON
  factory ErrorData.fromJson(Map<String, dynamic> json) {
    return ErrorData(
      settings:
      json['settings'] != null ? Settings.fromJson(json['settings']) : null,
      type: json['type'],
      message: json['message'],
    );
  }

  /// Convert this object to JSON
  Map<String, dynamic> toJson() {
    return {
      'settings': settings?.toJson(),
      'type': type,
      'message': message,
    };
  }

  /// Quick check: true if this represents an error response
  bool get isError => type?.toLowerCase() == 'error';

  @override
  String toString() =>
      'ErrorData(type: $type, message: $message, success: ${settings?.success})';
}

class Settings {
  final String? success;

  Settings({this.success});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(success: json['success']);
  }

  Map<String, dynamic> toJson() {
    return {'success': success};
  }
}
