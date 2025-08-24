class CreateAlertModel {
  final String title;
  final String description;
  final String location;

  final String buildingName;
  final String phoneNumber;
  final String type;
  final DateTime createdAt;

  CreateAlertModel({
    required this.title,
    required this.description,
    required this.location,

    required this.buildingName,
    required this.phoneNumber,
    required this.type,
    required this.createdAt,
  });
}
