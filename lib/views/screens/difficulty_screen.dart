// lib/views/screens/difficulty_screen.dart

import 'package:flutter/material.dart';
import 'exercise/exercise_categories_screen.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        elevation: 0,
        title: const Text(
          "Selecciona tu nivel",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DifficultyButton(
                  difficulty: "Principiante",
                  description: "Ideal para comenzar tu entrenamiento",
                  icon: Icons.star_border,
                  onPressed: () => _navigateToExercises(context, "Principiante"),
                ),
                const SizedBox(height: 16),
                DifficultyButton(
                  difficulty: "Intermedio",
                  description: "Para quienes ya tienen experiencia",
                  icon: Icons.star_half,
                  onPressed: () => _navigateToExercises(context, "Intermedio"),
                ),
                const SizedBox(height: 16),
                DifficultyButton(
                  difficulty: "Avanzado",
                  description: "Ejercicios de alta dificultad",
                  icon: Icons.star,
                  onPressed: () => _navigateToExercises(context, "Avanzado"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToExercises(BuildContext context, String difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseCategoriesScreen(
          difficulty: difficulty,
        ),
      ),
    );
  }
}

class DifficultyButton extends StatelessWidget {
  final String difficulty;
  final String description;
  final IconData icon;
  final VoidCallback onPressed;

  const DifficultyButton({
    Key? key,
    required this.difficulty,
    required this.description,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 12),
              Text(
                difficulty,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}