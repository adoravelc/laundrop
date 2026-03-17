import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      // Mandor menyuruh Data Source kerja nembak API
      final userModel = await remoteDataSource.login(email, password);
      // Kalau sukses, kembalikan posisi Kanan (Right)
      return Right(userModel);
    } on ServerFailure catch (e) {
      // Kalau dari Data Source ngelempar error, tangkap dan kembalikan di posisi Kiri (Left)
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Terjadi kesalahan yang tidak terduga.'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      return Right(userModel);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Terjadi kesalahan saat mendaftar.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    // Nanti kita implementasi logika hapus token di local storage di sini
    return const Right(null);
  }
}
