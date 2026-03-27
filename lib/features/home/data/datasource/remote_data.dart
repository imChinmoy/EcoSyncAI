import 'dart:developer';

import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/core/network/app_constants.dart';
import 'package:ecosyncai/core/network/network.dart';
import 'package:ecosyncai/features/home/data/model/bin_model.dart';
import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';
import 'package:ecosyncai/features/home/data/model/ward_model.dart';
import 'package:ecosyncai/features/home/domain/entities/ward_entity.dart';

abstract class RemoteData {
  Future<Either<String, List<BinEntity>>> getBins({int wardId = 0});
  Future<Either<String, BinEntity>> getBin(String id);
  Future<Either<String, BinEntity>> createBin(BinEntity bin);
  Future<Either<String, BinEntity>> updateBin(BinEntity bin);
  Future<Either<String, BinEntity>> deleteBin(String id);
  Future<Either<String, List<WardEntity>>> getWards();
}

class RemoteDataImpl implements RemoteData {
  // 🔥 Common handler (BIG improvement)
  Future<Either<String, T>> _handleRequest<T>({
    required Future<dynamic> Function() request,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await request();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Either.right(parser(response.data));
      } else {
        return Either.left("Error: ${response.statusCode}");
      }
    } catch (e) {
      log('API ERROR: $e');
      return Either.left(e.toString());
    }
  }

  @override
  Future<Either<String, List<BinEntity>>> getBins({int wardId = 0}) {
    return _handleRequest(
      request: () => Network.get(
        ApiEndpoints.getBins,
        queryParameters: wardId == 0 ? null : {'ward': wardId},
      ),
      parser: (data) {
        final list = (data as List);
        return list.map((e) => BinModel.fromJson(e).toEntity()).toList();
      },
    );
  }

  @override
  Future<Either<String, BinEntity>> getBin(String id) {
    return _handleRequest(
      request: () => Network.get(ApiEndpoints.getBin.replaceAll('{id}', id)),
      parser: (data) => BinModel.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Either<String, BinEntity>> createBin(BinEntity bin) {
    return _handleRequest(
      request: () => Network.post(ApiEndpoints.createBin, _mapToPayload(bin)),
      parser: (data) => BinModel.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Either<String, BinEntity>> updateBin(BinEntity bin) {
    return _handleRequest(
      request: () => Network.patch(
        ApiEndpoints.updateBin.replaceAll('{id}', bin.id),
        _mapToPayload(bin),
      ),
      parser: (data) => BinModel.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Either<String, BinEntity>> deleteBin(String id) {
    return _handleRequest(
      request: () =>
          Network.delete(ApiEndpoints.deleteBin.replaceAll('{id}', id)),
      parser: (data) => BinModel.fromJson(data).toEntity(),
    );
  }

  @override
  Future<Either<String, List<WardEntity>>> getWards() {
    return _handleRequest(
      request: () => Network.get(ApiEndpoints.getWards),
      parser: (data) {
        final list = (data as List);
        return list.map((e) => WardModel.fromJson(e).toEntity()).toList();
      },
    );
  }

  // 🔥 Central payload mapping (fix inconsistency)
  Map<String, dynamic> _mapToPayload(BinEntity bin) {
    return {
      'id': bin.id,
      'wardId': bin.wardId,
      'lat': bin.lat,
      'lng': bin.lng,
      'status': bin.status,
      'category': bin.category,
      'capacity': bin.capacity,
      'address': bin.address,
      'lastUpdated': bin.lastUpdated.toIso8601String(),
    };
  }
}
