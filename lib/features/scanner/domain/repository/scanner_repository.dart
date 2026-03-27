import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/features/scanner/domain/entities/scanner_result_entity.dart';

abstract class ScannerRepository {
  Future<Either<String, ScannerResultEntity>> classifyImage(String imagePath);
}
