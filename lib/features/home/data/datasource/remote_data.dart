import 'dart:developer';

import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/core/network/app_constants.dart';
import 'package:ecosyncai/core/network/network.dart';
import 'package:ecosyncai/features/home/data/model/bin_model.dart';
import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';

abstract class RemoteData {
  Future<Either<String, List<BinEntity>>> getBins();
  Future<Either<String, BinEntity>> getBin(String id);
  Future<Either<String, BinEntity>> createBin(BinEntity bin);
  Future<Either<String, BinEntity>> updateBin(BinEntity bin);
  Future<Either<String, BinEntity>> deleteBin(String id);
}

class RemoteDataImpl implements RemoteData {
  @override
  Future<Either<String, List<BinEntity>>> getBins() async {
    return Either.right([]);
  }

  @override
  Future<Either<String, BinEntity>> createBin(BinEntity bin) async {
    final payload = {
      'title': bin.title,
      'description': bin.description,
      'type': bin.type.name,
    };
    final response = await Network.post(ApiEndpoints.createBin, payload);
    log('createBin response: ${response.data}');

    if (response.statusCode == 200) {
      return Either.right(BinModel.fromJson(response.data).toEntity());
    } else {
      return Either.left(response.statusCode.toString());
    }
  }

  @override
  Future<Either<String, BinEntity>> deleteBin(String id) async {
    final response = await Network.delete(
      ApiEndpoints.deleteBin.replaceAll('{id}', id),
    );
    if (response.statusCode == 200) {
      return Either.right(BinModel.fromJson(response.data).toEntity());
    } else {
      return Either.left(response.statusCode.toString());
    }
  }

  @override
  Future<Either<String, BinEntity>> getBin(String id) async {
    final response = await Network.get(
      ApiEndpoints.getBin.replaceAll('{id}', id),
    );
    log('getBin response: ${response.data}');
    if (response.statusCode == 200) {
      return Either.right(BinModel.fromJson(response.data).toEntity());
    } else {
      return Either.left(response.statusCode.toString());
    }
  }

  @override
  Future<Either<String, BinEntity>> updateBin(BinEntity bin) async {
    final payload = {
      'title': bin.title,
      'description': bin.description,
      'type': bin.type.name,
    };
    final response = await Network.put(
      ApiEndpoints.updateBin.replaceAll('{id}', bin.id),
      payload,
    );
    log('updateBin response: ${response.data}');
    if (response.statusCode == 200) {
      return Either.right(BinModel.fromJson(response.data).toEntity());
    } else {
      return Either.left(response.statusCode.toString());
    }
  }
}
