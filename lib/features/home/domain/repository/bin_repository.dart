import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';

abstract class BinRepository {

  Future<Either<String, List<BinEntity>>> getBins({int wardId = 0});
  Future<Either<String, BinEntity>> getBin(String id);
  Future<Either<String, BinEntity>> createBin(BinEntity bin);
  Future<Either<String, BinEntity>> updateBin(BinEntity bin);
  Future<Either<String, BinEntity>> deleteBin(String id);

}