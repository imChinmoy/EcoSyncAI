import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/features/scanner/data/datasource/scanner_remote_data.dart';
import 'package:ecosyncai/features/scanner/domain/entities/scanner_result_entity.dart';
import 'package:ecosyncai/features/scanner/domain/repository/scanner_repository.dart';

class ScannerRepoImpl implements ScannerRepository {
  final ScannerRemoteData remoteData;

  ScannerRepoImpl({required this.remoteData});

  @override
  Future<Either<String, ScannerResultEntity>> classifyImage(String imagePath) async {
    final result = await remoteData.classifyImage(imagePath);
    return result.fold(
      (error) => Either.left(error),
      (model) => Either.right(model.toEntity()),
    );
  }
}
