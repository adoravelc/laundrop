import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/service.dart';
import '../../domain/repositories/laundry_repository.dart';
import '../datasources/laundry_remote_data_source.dart';

class LaundryRepositoryImpl implements LaundryRepository {
  final LaundryRemoteDataSource remoteDataSource;
  LaundryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Service>>> getServices() async {
    try {
      final services = await remoteDataSource.getServices();
      return Right(services);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Gagal memuat layanan.'));
    }
  }
}
