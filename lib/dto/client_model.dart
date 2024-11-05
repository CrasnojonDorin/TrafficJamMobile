import 'location.dart';

class ClientModel {
  final String name;
  final String phone;
  final String id;
  LocationModel? location;
  double? velocity;

  ClientModel(
      {required this.name,
      required this.phone,
      this.location,
      this.velocity,
      required this.id});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'id': id,
      'velocity': velocity.toString(),
      'location': location?.toMap(),
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      name: map['name'] as String,
      phone: map['phone'] as String,
      location: LocationModel.fromMap(map['location']),
      id: map['id'],
    );
  }
}
