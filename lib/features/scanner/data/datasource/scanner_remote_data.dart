import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/core/network/app_constants.dart';
import 'package:ecosyncai/core/network/network.dart';
import 'package:ecosyncai/features/scanner/data/model/scanner_result_model.dart';
import 'package:path/path.dart' as p;

abstract class ScannerRemoteData {
  Future<Either<String, ScannerResultModel>> classifyImage(String imagePath);
}

class ScannerRemoteDataImpl implements ScannerRemoteData {
  @override
  Future<Either<String, ScannerResultModel>> classifyImage(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: p.basename(imagePath),
        ),
      });

      final response = await Network.dio.post(
        ApiEndpoints.classifyWaste,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return Either.right(ScannerResultModel.fromJson(data));
        }
        return Either.left('Invalid API response format');
      }

      return Either.left('Error: ${response.statusCode}');
    } catch (e) {
      log('Scanner classify API error: $e');
      return Either.left(e.toString());
    }
  }
}
