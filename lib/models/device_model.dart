import 'location_model.dart';

class DeviceModel {
  final String id;
  final String name;
  final bool connected;
  final int battery;
  final String signal;
  final String lastSeen;
  final String? imagePath;

  // BLE-related data
  final int rssi;
  final String? bleId;
  final String? geoLinkerId;
  final LocationModel? location;

  DeviceModel({
    required this.id,
    required this.name,
    required this.connected,
    required this.battery,
    required this.signal,
    required this.lastSeen,
    this.imagePath,
    this.rssi = -55,
    this.bleId,
    this.geoLinkerId,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'connected': connected,
      'battery': battery,
      'signal': signal,
      'lastSeen': lastSeen,
      'imagePath': imagePath,
      'rssi': rssi,
      'bleId': bleId,
      'geoLinkerId': geoLinkerId,
      'location': location?.toMap(),
    };
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unnamed Device',
      connected: json['connected'] ?? false,
      battery: json['battery'] ?? 0,
      signal: json['signal'] ?? 'Unknown',
      lastSeen: json['lastSeen'] ?? 'Unknown',
      imagePath: json['imagePath'],
      rssi: json['rssi'] ?? -55,
      bleId: json['bleId'],
      geoLinkerId: json['geoLinkerId'],
      location: json['location'] != null
          ? LocationModel.fromMap(
              Map<String, dynamic>.from(json['location']),
            )
          : null,
    );
  }
}
