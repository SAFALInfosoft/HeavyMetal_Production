class GenerateUrnResponse {
  final Settings settings;
  final List<UrnMessage> message;

  GenerateUrnResponse({
    required this.settings,
    required this.message,
  });

  factory GenerateUrnResponse.fromJson(Map<String, dynamic> json) {
    return GenerateUrnResponse(
      settings: Settings.fromJson(json['settings']),
      message: (json['message'] as List<dynamic>)
          .map((e) => UrnMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Settings {
  final String success;

  Settings({required this.success});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(success: json['success'] ?? '');
  }
}

class UrnMessage {
  final String urnNo;
  final String Doc_No;
  final String Category;

  UrnMessage({required this.urnNo,required this.Doc_No,required this.Category,});

  factory UrnMessage.fromJson(Map<String, dynamic> json) {
    return UrnMessage(urnNo: json['URN_No'] ?? '', Doc_No:json['Doc_No'] ??  '', Category:json['Category'] ??  '');
  }
}
