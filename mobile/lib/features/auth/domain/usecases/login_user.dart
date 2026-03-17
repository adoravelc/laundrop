import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, User>> execute(String email, String password) {
    // Usecase ini cuma nyuruh repository kerja, gak ngurusin hal lain
    return repository.login(email, password);
  }
}
