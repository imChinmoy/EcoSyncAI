import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';
import 'package:ecosyncai/features/home/domain/repository/bin_repository.dart';

class BinRepoImpl implements BinRepository {
  @override
  Future<Either<String, List<BinEntity>>> getBins() async {
    return Either.right([]);
  }

  @override
  Future<Either<String, BinEntity>> createBin(BinEntity bin) {
    // TODO: implement createBin
    throw UnimplementedError();
  }

  @override
  Future<Either<String, BinEntity>> deleteBin(String id) {
    // TODO: implement deleteBin
    throw UnimplementedError();
  }

  @override
  Future<Either<String, BinEntity>> getBin(String id) {
    // TODO: implement getBin
    throw UnimplementedError();
  }

  @override
  Future<Either<String, BinEntity>> updateBin(BinEntity bin) {
    // TODO: implement updateBin
    throw UnimplementedError();
  }
}