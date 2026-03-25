class ProcessCardResponse {
  final Settings settings;
  final List<ProcessCardMessage> message;

  ProcessCardResponse({
    required this.settings,
    required this.message,
  });

  factory ProcessCardResponse.fromJson(Map<String, dynamic> json) {
    return ProcessCardResponse(
      settings: Settings.fromJson(json['settings'] ?? {}),
      message: (json['message'] as List<dynamic>? ?? [])
          .map((e) => ProcessCardMessage.fromJson(e))
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
      Settings(success: json['success']?.toString() ?? '');

  Map<String, dynamic> toJson() => {'success': success};
}

class ProcessCardMessage {
  final String processCardUrnNo;
  final String
  woNo;
  final String customerName;
  final String Process_Doc_No;
  final double qty;
  final String Wo_No_Doc;
  final double Round_Bar_Qty;
  final String Size;

  ProcessCardMessage({
    required this.processCardUrnNo,
    required this.woNo,
    required this.customerName,
    required this.Process_Doc_No,
    required this.qty,
    required this.Wo_No_Doc,
    required this.Round_Bar_Qty,
    required this.Size,
  });

  factory ProcessCardMessage.fromJson(Map<String, dynamic> json) {
    return ProcessCardMessage(
      processCardUrnNo: json['Process_Card_URN_No']?.toString() ?? '',
      woNo: json['Wo_No']?.toString() ?? '',
      Wo_No_Doc: json['Wo_No_Doc'] ?? '',
      customerName: json['Customer_Name']?.toString() ?? '',
      Process_Doc_No: json['Process_Doc_No']?.toString() ?? '',
      qty: (json['Qty'] is num) ? (json['Qty'] as num).toDouble() : 0.0,
      Round_Bar_Qty: (json['Round_Bar_Qty'] is num) ? (json['Round_Bar_Qty'] as num).toDouble() : 0.0,
      Size: json['Size'] ,
    );
  }

  Map<String, dynamic> toJson() => {
    'Process_Card_URN_No': processCardUrnNo,
    'Wo_No': woNo,
    'Customer_Name': customerName,
    'Process_Doc_No': Process_Doc_No,
    'Qty': qty,
    'Round_Bar_Qty': Round_Bar_Qty,
    'Size': Size,
  };
}
