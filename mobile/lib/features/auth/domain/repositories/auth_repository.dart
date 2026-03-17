import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // Either <Kiri (Error), Kanan (Sukses)>
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
  });
  Future<Either<Failure, void>> logout();
}
