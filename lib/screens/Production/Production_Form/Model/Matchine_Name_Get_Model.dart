class MachineListResponse {
  final Settings settings;
  final List<MachineItem> message;

  MachineListResponse({
    required this.settings,
    required this.message,
  });

  factory MachineListResponse.fromJson(Map<String, dynamic> json) {
    return MachineListResponse(
      settings: Settings.fromJson(json['settings']),
      message: (json['message'] as List<dynamic>)
          .map((e) => MachineItem.fromJson(e as Map<String, dynamic>))
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

class MachineItem {
  final String machineName;
  final String machineUrnNo;

  MachineItem({
    required this.machineName,
    required this.machineUrnNo,
  });

  factory MachineItem.fromJson(Map<String, dynamic> json) {
    return MachineItem(
      machineName: json['Machine_Name']?.toString() ?? '',
      machineUrnNo: json['MAchine_URN_No']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'Machine_Name': machineName,
    'MAchine_URN_No': machineUrnNo,
  };
}
