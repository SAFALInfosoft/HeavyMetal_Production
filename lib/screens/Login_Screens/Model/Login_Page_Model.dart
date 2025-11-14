class LoginResponse {
  final Settings settings;
  final List<LoginMessage> message;

  LoginResponse({
    required this.settings,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      settings: Settings.fromJson(json['settings']),
      message: (json['message'] as List<dynamic>)
          .map((e) => LoginMessage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'settings': settings.toJson(),
    'message': message.map((e) => e.toJson()).toList(),
  };
}

class Settings {
  final String success;

  Settings({required this.success});

  factory Settings.fromJson(Map<String, dynamic> json) =>
      Settings(success: json['success'] ?? '');

  Map<String, dynamic> toJson() => {'success': success};
}

class LoginMessage {
  final String operatorUrnNo;
  final String accessToken;
  final String coCode;

  LoginMessage({
    required this.operatorUrnNo,
    required this.accessToken,
    required this.coCode,
  });

  factory LoginMessage.fromJson(Map<String, dynamic> json) {
    return LoginMessage(
      operatorUrnNo: json['Operator_URN_No'] ?? '',
      accessToken: json['Access_Token'] ?? '',
      coCode: json['CO_CODE'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'Operator_URN_No': operatorUrnNo,
    'Access_Token': accessToken,
    'CO_CODE': coCode,
  };
}
