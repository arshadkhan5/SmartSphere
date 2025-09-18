class Alert {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String status;
  final String? severity;
  final String? type;
  final String? zone;
  final String? buildingName;
  final String? cancelReason;

  Alert({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.expiresAt,
    required this.status,
    this.severity,
    this.type,
    this.zone,
    this.buildingName,
    this.cancelReason,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  Alert copyWith({
    String? id,
    String? title,
    String? description,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? status,
    String? severity,
    String? type,
    String? zone,
    String? buildingName,
    String? cancelReason,
  }) {
    return Alert(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      severity: severity ?? this.severity,
      type: type ?? this.type,
      zone: zone ?? this.zone,
      buildingName: buildingName ?? this.buildingName,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }

  // Add fromJson method
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? 'Unknown Alert',
      description: json['description'] ?? 'No description',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'])
          : null,
      status: json['status'] ?? 'active',
      severity: json['severity'],
      type: json['type'],
      zone: json['zone'],
      buildingName: json['buildingName'],
      cancelReason: json['cancelReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'status': status,
      'severity': severity,
      'type': type,
      'zone': zone,
      'buildingName': buildingName,
      'cancelReason': cancelReason,
    };
  }
}