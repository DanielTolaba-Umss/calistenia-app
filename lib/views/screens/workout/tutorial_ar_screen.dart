/*import 'package:flutter/material.dart' hide Colors;
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../../models/exercise_model.dart';

class Tutorial3DScreen extends StatefulWidget {
  final ExerciseModel exercise;
  final String modelPath;

  const Tutorial3DScreen({
    Key? key,
    required this.exercise,
    required this.modelPath,
  }) : super(key: key);

  @override
  State<Tutorial3DScreen> createState() => _Tutorial3DScreenState();
}

class _Tutorial3DScreenState extends State<Tutorial3DScreen> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorial: ${widget.exercise.name}'),
        backgroundColor: const Color(0x00000000), // Transparent color
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ModelViewer(
            src: 'assets/models/flexiones0.glb',
            alt: 'Un modelo 3D del ejercicio',
            ar: false,
            autoRotate: true,
            cameraControls: true,
            disableZoom: false,
            loading: Loading.eager,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          // Información del ejercicio
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Card(
              color: const Color(0xB3000000), // Black with opacity
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Repeticiones: ${widget.exercise.repetitions}',
                      style: const TextStyle(color: Color(0xFFFFFFFF)), // White
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Series: ${widget.exercise.sets}',
                      style: const TextStyle(color: Color(0xFFFFFFFF)), // White
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Instrucciones de uso
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xB3000000), // Black with opacity
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Usa un dedo para rotar • Dos dedos para zoom',
                  style: TextStyle(color: Color(0xFFFFFFFF)), // White
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
