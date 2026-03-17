import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final int id;
  final String name;
  final double price;
  final String unit;

  const Service({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
  });

  @override
  List<Object?> get props => [id, name, price, unit];
}
