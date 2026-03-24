import 'package:ecosyncai/features/home/domain/entities/bin_entity.dart';

class BinModel {
  BinModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final BinType type;
  final String createdAt;
  final String updatedAt;

  factory BinModel.fromJson(Map<String, dynamic> json) {
    return BinModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  BinEntity toEntity() {
    return BinEntity(
      id: id,
      title: title,
      description: description,
      type: type,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  BinModel copyWith({
    String? id,
    String? title,
    String? description,
    BinType? type,
    String? createdAt,
    String? updatedAt,
  }) {
    return BinModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}