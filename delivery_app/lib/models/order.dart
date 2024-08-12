class Order {
  final String id;
  final String status;
  final String customerName;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;
  final DateTime placedTime;

  Order({
    required this.id,
    required this.status,
    required this.customerName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.placedTime,
  });
}