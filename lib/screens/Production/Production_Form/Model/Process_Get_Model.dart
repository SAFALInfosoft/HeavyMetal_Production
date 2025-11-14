// process_response.dart

class ProcessResponse {
  final Settings settings;
  final List<ProcessItem> message;

  ProcessResponse({
    required this.settings,
    required this.message,
  });

  factory ProcessResponse.fromJson(Map<String, dynamic> json) {
    return ProcessResponse(
      settings: Settings.fromJson(json['settings']),
      message: (json['message'] as List)
          .map((e) => ProcessItem.fromJson(e))
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

class ProcessItem {
  final String locationUrnNo;
  final String processName;
  final String vary;
  final String Sr_No;

  ProcessItem({
    required this.locationUrnNo,
    required this.processName,
    required this.vary,
    required this.Sr_No,
  });

  factory ProcessItem.fromJson(Map<String, dynamic> json) {
    return ProcessItem(
      locationUrnNo: json['Location_URN_No'] ?? '',
      processName: json['Process_Name'] ?? '',
      vary: json['vary'] ?? '',
      Sr_No: json['Sr_No'] ?? '',
    );
  }
}
