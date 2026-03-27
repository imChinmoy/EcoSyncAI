import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/features/home/domain/entities/ward_entity.dart';

abstract class WardRepository {
  Future<Either<String, List<WardEntity>>> getWards();
}

