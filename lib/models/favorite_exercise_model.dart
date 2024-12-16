// lib/models/favorite_exercise_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteExerciseModel {
  final String userId;
  final String exerciseId;
  final DateTime addedAt;

  FavoriteExerciseModel({
    required this.userId,
    required this.exerciseId,
    required this.addedAt,
  });

  factory FavoriteExerciseModel.fromMap(Map<String, dynamic> map) {
    return FavoriteExerciseModel(
      userId: map['userId'] ?? '',
      exerciseId: map['exerciseId'] ?? '',
      addedAt: (map['addedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'exerciseId': exerciseId,
      'addedAt': addedAt,
    };
  }
}