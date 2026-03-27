import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/features/home/data/datasource/remote_data.dart';
import 'package:ecosyncai/features/home/domain/entities/ward_entity.dart';
import 'package:ecosyncai/features/home/domain/repository/ward_repository.dart';

class WardRepoImpl implements WardRepository {
  final RemoteData remoteData;

  WardRepoImpl({required this.remoteData});

  @override
  Future<Either<String, List<WardEntity>>> getWards() {
    return remoteData.getWards();
  }
}

