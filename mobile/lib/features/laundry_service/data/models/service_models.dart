import '../../domain/entities/service.dart';

class ServiceModel extends Service {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.price,
    required super.unit,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['idservices'],
      name: json['name'],
      // Konversi ke double jaga-jaga kalau dari API formatnya string atau int
      price: double.parse(json['price'].toString()),
      unit: json['unit'],
    );
  }
}
