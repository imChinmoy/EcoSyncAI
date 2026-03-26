import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/features/home/data/datasource/remote_data.dart';
import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';
import 'package:ecosyncai/features/home/domain/repository/bin_repository.dart';

class BinRepoImpl implements BinRepository {
  final RemoteData remoteData;

  BinRepoImpl({required this.remoteData});

  @override
  Future<Either<String, List<BinEntity>>> getBins() async {
    try {
      final response = await remoteData.getBins();
      return response.fold((l) => Either.left(l), (r) => Either.right(r));
    } catch (e) {
      return Either.left(e.toString());
    }
  }

  @override
  Future<Either<String, BinEntity>> createBin(BinEntity bin) async {
    try {
      final response = await remoteData.createBin(bin);
      return response.fold((l) => Either.left(l), (r) => Either.right(r));
    } catch (e) {
      return Either.left(e.toString());
    }
  }

  @override
  Future<Either<String, BinEntity>> deleteBin(String id) async {
    try {
      final response = await remoteData.deleteBin(id);
      return response.fold((l) => Either.left(l), (r) => Either.right(r));
    } catch (e) {
      return Either.left(e.toString());
    }
  }

  @override
  Future<Either<String, BinEntity>> getBin(String id) async {
    try {
      final response = await remoteData.getBin(id);
      return response.fold((l) => Either.left(l), (r) => Either.right(r));
    } catch (e) {
      return Either.left(e.toString());
    }
  }

  @override
  Future<Either<String, BinEntity>> updateBin(BinEntity bin) async {
    try {
      final response = await remoteData.updateBin(bin);
      return response.fold((l) => Either.left(l), (r) => Either.right(r));
    } catch (e) {
      return Either.left(e.toString());
    }
  }
}
