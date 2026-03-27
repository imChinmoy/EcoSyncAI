import 'dart:developer';

import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/features/home/data/datasource/remote_data.dart';
import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';
import 'package:ecosyncai/features/home/domain/repository/bin_repository.dart';

class BinRepoImpl implements BinRepository {
  final RemoteData remoteData;

  BinRepoImpl({required this.remoteData});

  @override
  Future<Either<String, List<BinEntity>>> getBins({int wardId = 0}) {
    final data = remoteData.getBins(wardId: wardId);
    log(data.toString());
    return data;
  }

  @override
  Future<Either<String, BinEntity>> getBin(String id) {
    return remoteData.getBin(id);
  }

  @override
  Future<Either<String, BinEntity>> createBin(BinEntity bin) {
    return remoteData.createBin(bin);
  }

  @override
  Future<Either<String, BinEntity>> updateBin(BinEntity bin) {
    return remoteData.updateBin(bin);
  }

  @override
  Future<Either<String, BinEntity>> deleteBin(String id) {
    return remoteData.deleteBin(id);
  }
}