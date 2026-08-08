class DeviceModel {
  final String id;
  final String name;
  final bool connected;
  final int battery;
  final String signal;
  final String lastSeen;

  DeviceModel({
    required this.id,
    required this.name,
    required this.connected,
    required this.battery,
    required this.signal,
    required this.lastSeen,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'connected': connected,
      'battery': battery,
      'signal': signal,
      'lastSeen': lastSeen,
    };
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      name: json['name'],
      connected: json['connected'],
      battery: json['battery'],
      signal: json['signal'],
      lastSeen: json['lastSeen'],
    );
  }
}
