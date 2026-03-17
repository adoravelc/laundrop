import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';

// Kita bikin "Kontrak" (Interface) dulu untuk Data Source
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
  });
}

// Ini adalah implementasi aslinya
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  // Nanti URL ini kita ganti dengan IP lokal laptopmu pas ngetes
  final String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '$baseUrl/login',
        data: {'email': email, 'password': password},
      );

      // Kalau sukses (Status 200), kita ubah JSON jadi UserModel
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return UserModel.fromJson(data['user'], data['token']);
      } else {
        throw const ServerFailure(
          'Gagal login, periksa kembali email dan password.',
        );
      }
    } on DioException catch (e) {
      // Menangkap error pesan dari Laravel (misal: "Email atau Password salah!")
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan pada server';
      throw ServerFailure(errorMessage);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/register',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'phone_number': phoneNumber,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data['data'];
        return UserModel.fromJson(data['user'], data['token']);
      } else {
        throw const ServerFailure('Gagal mendaftar.');
      }
    } on DioException catch (e) {
      // Menangkap pesan error validasi dari Laravel
      final errorMessage =
          e.response?.data['message'] ?? 'Validasi gagal atau server error';
      throw ServerFailure(errorMessage);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
