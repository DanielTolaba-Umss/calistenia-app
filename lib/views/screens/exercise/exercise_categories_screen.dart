// lib/views/screens/exercise/exercise_categories_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/exercise_controller.dart';
import '../../../models/exercise_model.dart';
import 'workout_screen.dart';

class ExerciseCategoriesScreen extends StatelessWidget {
  final String difficulty;

  const ExerciseCategoriesScreen({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'accessibility_new':
        return Icons.accessibility_new;
      case 'push_pin':
        return Icons.push_pin;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'directions_walk':
        return Icons.directions_walk;
      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Ejercicios para $difficulty"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.lightBlue.shade400,
        child: StreamBuilder<List<ExerciseModel>>(
          stream: context
              .read<ExerciseController>()
              .getExercisesByDifficulty(difficulty),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final exercises = snapshot.data ?? [];

            if (exercises.isEmpty) {
              return const Center(
                child: Text(
                  'No hay ejercicios disponibles para este nivel',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ExerciseCard(
                  name: exercise.name,
                  description: exercise.description,
                  icon: _getIconData(exercise.iconName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutScreen(
                          exercise: exercise,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const ExerciseCard({
    Key? key,
    required this.name,
    required this.description,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.blue.shade800,
            size: 30,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}