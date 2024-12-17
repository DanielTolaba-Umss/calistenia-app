import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../../../models/exercise_model.dart';

class TutorialARScreen extends StatefulWidget {
  final ExerciseModel exercise;
  final String modelPath;

  const TutorialARScreen({
    Key? key,
    required this.exercise,
    required this.modelPath,
  }) : super(key: key);

  @override
  State<TutorialARScreen> createState() => _TutorialARScreenState();
}

class _TutorialARScreenState extends State<TutorialARScreen> {
  ArCoreController? arCoreController;
  bool isModelPlaced = false;

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  void onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onPlaneTap = _handlePlaneTap;
  }

  void _handlePlaneTap(List<ArCoreHitTestResult> hits) {
    if (!isModelPlaced && hits.isNotEmpty) {
      final hit = hits.first;
      _addModel(hit);
      setState(() {
        isModelPlaced = true;
      });
    }
  }

  Future<void> _addModel(ArCoreHitTestResult hit) async {
    print('Intentando cargar el modelo: ${widget.modelPath}');

    final node = ArCoreReferenceNode(
      object3DFileName: widget.modelPath,
      position: hit.pose.translation,
      rotation: hit.pose.rotation,
      scale: vector.Vector3(0.2, 0.2, 0.2),
    );

    try {
      await arCoreController?.addArCoreNode(node);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Modelo cargado: ${widget.modelPath}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error al cargar el modelo 3D: $e');
      print('Ruta del modelo: ${widget.modelPath}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar el modelo: ${widget.modelPath}\nError: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isModelPlaced = false;
              });
              arCoreController?.removeNode(nodeName: "exercise_model");
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: onArCoreViewCreated,
            enableTapRecognizer: true,
            enablePlaneRenderer: true,
          ),
          if (!isModelPlaced)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Toca la superficie plana detectada para colocar el modelo 3D',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}