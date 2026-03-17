import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import 'entities/service.dart';
import 'repositories/laundry_repository.dart';

class GetServices {
  final LaundryRepository repository;
  GetServices(this.repository);

  Future<Either<Failure, List<Service>>> execute() {
    return repository.getServices();
  }
}
