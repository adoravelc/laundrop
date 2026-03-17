import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/service.dart';

abstract class LaundryRepository {
  Future<Either<Failure, List<Service>>> getServices();
}
