import 'dart:developer';

import 'package:ecosyncai/core/Exception/either.dart';
import 'package:ecosyncai/core/network/app_constants.dart';
import 'package:ecosyncai/core/network/network.dart';

abstract class ReportRemoteData {
  Future<Either<String, bool>> submitComplaint({
    required int wardId,
    required double lat,
    required double lng,
    required String message,
    required String imageUrl,
  });
}

class ReportRemoteDataImpl implements ReportRemoteData {
  @override
  Future<Either<String, bool>> submitComplaint({
    required int wardId,
    required double lat,
    required double lng,
    required String message,
    required String imageUrl,
  }) async {
    try {
      final response = await Network.post(ApiEndpoints.complaint, {
        'wardId': wardId,
        'lat': lat,
        'lng': lng,
        'message': message,
        'imageUrl': imageUrl,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Either.right(true);
      }

      final apiMessage = response.data is Map<String, dynamic>
          ? response.data['message']?.toString()
          : null;
      return Either.left(
        apiMessage ?? 'Submission failed with status ${response.statusCode}',
      );
    } catch (e) {
      log('Complaint submission API error: $e');
      return Either.left(e.toString());
    }
  }
}
