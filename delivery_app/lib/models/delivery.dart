class Delivery {
  final String id;
  final double latitude;
  final double longitude;
  final String address;

  Delivery({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
    );
  }
}