import 'package:flutter/material.dart';
import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';
import 'package:ecosyncai/features/home/domain/repository/bin_repository.dart';

class BinProvider extends ChangeNotifier {
  final BinRepository binRepository;

  BinProvider({required this.binRepository});

  Future<List<BinEntity>> getBins() async {
    final response = await binRepository.getBins();
    return response.fold((l) => [], (r) => r);
  }

  Future<BinEntity> createBin(BinEntity bin) async {
    final response = await binRepository.createBin(bin);
    return response.fold(
      (l) => BinEntity(
        id: '',
        title: '',
        description: '',
        type: BinType.other,
        createdAt: '',
        updatedAt: '',
      ),
      (r) => r,
    );
  }

  Future<BinEntity> updateBin(BinEntity bin) async {
    final response = await binRepository.updateBin(bin);
    return response.fold(
      (l) => BinEntity(
        id: '',
        title: '',
        description: '',
        type: BinType.other,
        createdAt: '',
        updatedAt: '',
      ),
      (r) => r,
    );
  }

  Future<BinEntity> deleteBin(String id) async {
    final response = await binRepository.deleteBin(id);
    return response.fold(
      (l) => BinEntity(
        id: '',
        title: '',
        description: '',
        type: BinType.other,
        createdAt: '',
        updatedAt: '',
      ),
      (r) => r,
    );
  }

  Future<BinEntity> getBin(String id) async {
    final response = await binRepository.getBin(id);
    return response.fold(
      (l) => BinEntity(
        id: '',
        title: '',
        description: '',
        type: BinType.other,
        createdAt: '',
        updatedAt: '',
      ),
      (r) => r,
    );
  }
}
