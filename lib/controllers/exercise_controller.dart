// lib/controllers/exercise_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';

class ExerciseController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener ejercicios por dificultad
  Stream<List<ExerciseModel>> getExercisesByDifficulty(String difficulty) {
    return _firestore
        .collection('exercises')
        .where('difficulty', isEqualTo: difficulty)
        .snapshots()
        .asyncMap((snapshot) async {
      List<ExerciseModel> exercises = [];
      for (var doc in snapshot.docs) {
        final exercise = ExerciseModel.fromMap(doc.data(), doc.id);
        final isFav = await isFavorite(exercise.id);
        exercises.add(exercise.copyWith(isFavorite: isFav));
      }
      return exercises;
    });
  }

  // Obtener ejercicios por categoría y dificultad
  Stream<List<ExerciseModel>> getExercisesByCategoryAndDifficulty(
      String category,
      String difficulty,
      ) {
    return _firestore
        .collection('exercises')
        .where('category', isEqualTo: category)
        .where('difficulty', isEqualTo: difficulty)
        .snapshots()
        .asyncMap((snapshot) async {
      List<ExerciseModel> exercises = [];
      for (var doc in snapshot.docs) {
        final exercise = ExerciseModel.fromMap(doc.data(), doc.id);
        final isFav = await isFavorite(exercise.id);
        exercises.add(exercise.copyWith(isFavorite: isFav));
      }
      return exercises;
    });
  }

  // Obtener ejercicios favoritos del usuario
  Stream<List<ExerciseModel>> getFavoriteExercises() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<ExerciseModel> exercises = [];
      for (var doc in snapshot.docs) {
        final exerciseId = doc.data()['exerciseId'];
        final exerciseDoc = await _firestore
            .collection('exercises')
            .doc(exerciseId)
            .get();
        if (exerciseDoc.exists) {
          final exercise = ExerciseModel.fromMap(
            exerciseDoc.data()!,
            exerciseDoc.id,
          );
          exercises.add(exercise.copyWith(isFavorite: true));
        }
      }
      return exercises;
    });
  }

  // Obtener un ejercicio específico
  Future<ExerciseModel?> getExerciseById(String exerciseId) async {
    try {
      final doc = await _firestore.collection('exercises').doc(exerciseId).get();
      if (doc.exists) {
        final exercise = ExerciseModel.fromMap(doc.data()!, doc.id);
        final isFav = await isFavorite(exercise.id);
        return exercise.copyWith(isFavorite: isFav);
      }
      return null;
    } catch (e) {
      debugPrint('Error obteniendo ejercicio: $e');
      return null;
    }
  }

  // Agregar ejercicio
  Future<void> addExercise(ExerciseModel exercise) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Usuario no autenticado');

      await _firestore.collection('exercises').add({
        ...exercise.toMap(),
        'createdBy': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      debugPrint('Error al agregar ejercicio: $e');
      rethrow;
    }
  }

  // Actualizar ejercicio
  Future<void> updateExercise(ExerciseModel exercise) async {
    try {
      await _firestore
          .collection('exercises')
          .doc(exercise.id)
          .update(exercise.toMap());
      notifyListeners();
    } catch (e) {
      debugPrint('Error al actualizar ejercicio: $e');
      rethrow;
    }
  }

  // Eliminar ejercicio
  Future<void> deleteExercise(String exerciseId) async {
    try {
      await _firestore.collection('exercises').doc(exerciseId).delete();
      notifyListeners();
    } catch (e) {
      debugPrint('Error al eliminar ejercicio: $e');
      rethrow;
    }
  }

  // Añadir ejercicio a favoritos
  Future<void> addToFavorites(String exerciseId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Usuario no autenticado');

      await _firestore.collection('favorites').add({
        'userId': userId,
        'exerciseId': exerciseId,
        'addedAt': FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      debugPrint('Error al añadir a favoritos: $e');
      rethrow;
    }
  }

  // Remover ejercicio de favoritos
  Future<void> removeFromFavorites(String exerciseId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('Usuario no autenticado');

      final querySnapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .where('exerciseId', isEqualTo: exerciseId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error al remover de favoritos: $e');
      rethrow;
    }
  }

  // Verificar si un ejercicio es favorito
  Future<bool> isFavorite(String exerciseId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final querySnapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .where('exerciseId', isEqualTo: exerciseId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error al verificar favorito: $e');
      return false;
    }
  }

  // Toggle favorito (añadir/remover)
  Future<void> toggleFavorite(String exerciseId) async {
    try {
      final isFav = await isFavorite(exerciseId);
      if (isFav) {
        await removeFromFavorites(exerciseId);
      } else {
        await addToFavorites(exerciseId);
      }
    } catch (e) {
      debugPrint('Error al toggle favorito: $e');
      rethrow;
    }
  }
}