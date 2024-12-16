// lib/views/screens/exercise/workout_screen.dart

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import '../../../models/exercise_model.dart';
import '../../../controllers/exercise_controller.dart';
import '../workout/timer_screen.dart';
import '../workout/tutorial_ar_screen.dart';
import '../workout/tutorial_screen.dart';

class WorkoutScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const WorkoutScreen({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final exerciseController = context.read<ExerciseController>();
    final isFav = await exerciseController.isFavorite(widget.exercise.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade200,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header con botón de retroceso y título
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          widget.exercise.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Carrusel de imágenes
                if (widget.exercise.images.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(
                        height: 250,
                        child: Swiper(
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  widget.exercise.images[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          itemCount: widget.exercise.images.length,
                          pagination: SwiperPagination(
                            builder: DotSwiperPaginationBuilder(
                              activeColor: Colors.blue,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          control: const SwiperControl(
                            color: Colors.blue,
                          ),
                          autoplay: true,
                          autoplayDelay: 3000,
                          duration: 800,
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No hay imágenes disponibles',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Información del ejercicio
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoRow(
                        title: 'Dificultad',
                        value: widget.exercise.difficulty,
                        icon: Icons.signal_cellular_alt,
                      ),
                      const SizedBox(height: 10),
                      InfoRow(
                        title: 'Músculos implicados',
                        value: widget.exercise.musclesInvolved.join(', '),
                        icon: Icons.fitness_center,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Descripción',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(widget.exercise.description),
                      const SizedBox(height: 15),
                      if (widget.exercise.repetitions > 0) ...[
                        InfoRow(
                          title: 'Series',
                          value: '${widget.exercise.sets} series',
                          icon: Icons.repeat,
                        ),
                        const SizedBox(height: 10),
                        InfoRow(
                          title: 'Repeticiones',
                          value: '${widget.exercise.repetitions} reps',
                          icon: Icons.numbers,
                        ),
                        const SizedBox(height: 10),
                        InfoRow(
                          title: 'Descanso',
                          value: '${widget.exercise.restTime} segundos',
                          icon: Icons.timer,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Botones de acción
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ActionButton(
                          text: 'Tutorial',
                          icon: Icons.play_circle_outline,
                          onPressed: () {
                            String modelPath = 'assets/models/${widget.exercise.name.toLowerCase()}.glb';
                           /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Tutorial3DScreen(
                                  exercise: widget.exercise,
                                  modelPath: modelPath,
                                ),
                              ),
                            );*/
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ActionButton(
                          text: 'Iniciar',
                          icon: Icons.timer,
                          isPrimary: true,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TimerScreen(
                                  exercise: widget.exercise,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ActionButton(
                        text: _isFavorite ? 'Quitar' : 'Agregar',
                        icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                        isSmall: true,
                        color: _isFavorite ? Colors.red : Colors.blue,
                        onPressed: () async {
                          final exerciseController = context.read<ExerciseController>();
                          await exerciseController.toggleFavorite(widget.exercise.id);
                          if (mounted) {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InfoRow({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          '$title: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isSmall;
  final Color? color;

  const ActionButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
    this.isSmall = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? (isPrimary ? Colors.blue : Colors.white),
        foregroundColor: color != null
            ? Colors.white
            : (isPrimary ? Colors.white : Colors.blue),
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 12 : 15,
          horizontal: isSmall ? 15 : 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isSmall ? 20 : 24),
          if (!isSmall) const SizedBox(width: 8),
          if (!isSmall)
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}