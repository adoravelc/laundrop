import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../models/service_models.dart';

abstract class LaundryRemoteDataSource {
  Future<List<ServiceModel>> getServices();
}

class LaundryRemoteDataSourceImpl implements LaundryRemoteDataSource {
  final Dio dio;
  LaundryRemoteDataSourceImpl({required this.dio});

  // Sesuaikan IP ini dengan yang sukses jalan di komputermu kemarin ya
  final String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await dio.get('$baseUrl/services');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        throw const ServerFailure('Gagal mengambil data layanan');
      }
    } catch (e) {
      throw const ServerFailure('Terjadi kesalahan pada server');
    }
  }
}
