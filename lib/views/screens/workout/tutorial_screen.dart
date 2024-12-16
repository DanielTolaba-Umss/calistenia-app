// lib/views/screens/workout/tutorial_screen.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../models/exercise_model.dart';

class TutorialScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const TutorialScreen({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isRearCameraSelected = true;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final camera = _isRearCameraSelected ? cameras.first : cameras.last;

      final controller = CameraController(
        camera,
        ResolutionPreset.max,
        enableAudio: false,
      );

      _controller = controller;
      _initializeControllerFuture = controller.initialize();

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error iniciando cámara: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _toggleRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      if (_isRecording) {
        await _controller!.stopVideoRecording();
        setState(() => _isRecording = false);
      } else {
        await _controller!.startVideoRecording();
        setState(() => _isRecording = true);
      }
    } catch (e) {
      debugPrint('Error en grabación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Camera Preview
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    _controller != null &&
                    _controller!.value.isInitialized) {
                  return CameraPreview(_controller!);
                }
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
            ),

            // Header Controls
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.exercise.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isRearCameraSelected
                            ? Icons.camera_front
                            : Icons.camera_rear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isRearCameraSelected = !_isRearCameraSelected;
                          _initializeCamera();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Tutorial Information
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Exercise Info
                    const Text(
                      'Instrucciones:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.exercise.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Exercise Details and Camera Controls
                    Row(
                      children: [
                        // Exercise Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('Repeticiones:', '${widget.exercise.repetitions}'),
                              const SizedBox(height: 5),
                              _buildInfoRow('Series:', '${widget.exercise.sets}'),
                              if (widget.exercise.restTime > 0) ...[
                                const SizedBox(height: 5),
                                _buildInfoRow(
                                  'Descanso:',
                                  '${widget.exercise.restTime} segundos',
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Camera Controls
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isRecording ? Colors.red : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: IconButton(
                            onPressed: _toggleRecording,
                            icon: Icon(
                              _isRecording ? Icons.stop : Icons.fiber_manual_record,
                              color: _isRecording ? Colors.red : Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Tutorial Tips
                    if (widget.exercise.musclesInvolved.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      const Text(
                        'Músculos trabajados:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.exercise.musclesInvolved.join(', '),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}