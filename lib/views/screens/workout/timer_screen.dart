// lib/views/screens/workout/timer_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import '../../../models/exercise_model.dart';

class TimerScreen extends StatefulWidget {
final ExerciseModel exercise;

const TimerScreen({
Key? key,
required this.exercise,
}) : super(key: key);

@override
State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
int _currentSet = 1;
int _currentSeconds = 0;
bool _isResting = false;
Timer? _timer;
bool _isRunning = false;

@override
void initState() {
super.initState();
// Iniciar con el tiempo para repeticiones
_currentSeconds = widget.exercise.repetitions * 5; // 3 segundos por repetición
}

@override
void dispose() {
_timer?.cancel();
super.dispose();
}

void _startTimer() {
_timer = Timer.periodic(const Duration(seconds: 1), (timer) {
if (_currentSeconds > 0) {
setState(() {
_currentSeconds--;
});
} else {
timer.cancel();
if (_currentSet >= widget.exercise.sets) {
// Ejercicio completado
_showCompletionDialog();
} else {
if (_isResting) {
// Fin del descanso, comenzar nueva serie
setState(() {
_currentSet++;
_isResting = false;
_currentSeconds = widget.exercise.repetitions * 3;
_isRunning = true;
});
_startTimer();
} else {
// Fin de la serie, comenzar descanso
setState(() {
_isResting = true;
_currentSeconds = widget.exercise.restTime;
_isRunning = true;
});
_startTimer();
}
}
}
});
}

void _toggleTimer() {
if (_isRunning) {
_timer?.cancel();
} else {
_startTimer();
}
setState(() {
_isRunning = !_isRunning;
});
}

void _skipToRest() {
if (!_isResting && _isRunning) {
_timer?.cancel();
setState(() {
_isResting = true;
_isRunning = true;
_currentSeconds = widget.exercise.restTime;
});
_startTimer();
}
}

void _resetTimer() {
_timer?.cancel();
setState(() {
_currentSet = 1;
_isResting = false;
_isRunning = false;
_currentSeconds = widget.exercise.repetitions * 3;
});
}


void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Ejercicio Completado!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.stars,
                color: Colors.yellow,
                size: 50,
              ),
              const SizedBox(height: 20),
              Text(
                '¡Felicitaciones! Has completado todas las series de ${widget.exercise.name}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.exercise.sets} series × ${widget.exercise.repetitions} repeticiones',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTimer();
              },
              child: const Text('Reiniciar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Finalizar'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            widget.exercise.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            _isResting ? 'Descanso' : 'Serie $_currentSet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _resetTimer,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Timer display
              Container(
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(_currentSeconds),
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _isResting ? 'Descanso' : 'Repeticiones',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Exercise info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _InfoColumn(
                      title: 'Serie',
                      value: '$_currentSet/${widget.exercise.sets}',
                    ),
                    _InfoColumn(
                      title: 'Repeticiones',
                      value: '${widget.exercise.repetitions}',
                    ),
                    _InfoColumn(
                      title: 'Descanso',
                      value: '${widget.exercise.restTime}s',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Control buttons
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_isResting && _isRunning)
                      FloatingActionButton(
                        heroTag: 'skip',
                        onPressed: _skipToRest,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.skip_next),
                      ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      heroTag: 'play',
                      onPressed: _toggleTimer,
                      backgroundColor: _isRunning ? Colors.red : Colors.green,
                      child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const _InfoColumn({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}