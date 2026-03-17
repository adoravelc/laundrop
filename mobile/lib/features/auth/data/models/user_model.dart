import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.email,
    required super.role,
    required super.token,
  });

  // Fungsi untuk mengubah JSON dari API Laravel menjadi objek Flutter
  factory UserModel.fromJson(Map<String, dynamic> json, String token) {
    return UserModel(
      id: json['idusers'], // Sesuai dengan primary key yang kamu buat di Laravel
      firstName: json['first_name'],
      email: json['email'],
      role: json['role'],
      token: token,
    );
  }

  // Fungsi untuk mengubah objek Flutter kembali menjadi JSON (opsional, berguna kalau mau simpan ke cache lokal)
  Map<String, dynamic> toJson() {
    return {
      'idusers': id,
      'first_name': firstName,
      'email': email,
      'role': role,
    };
  }
}
