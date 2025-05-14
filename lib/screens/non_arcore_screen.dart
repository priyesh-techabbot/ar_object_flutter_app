import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class NonArcoreScreen extends StatefulWidget {
  const NonArcoreScreen({super.key});

  @override
  State<NonArcoreScreen> createState() => _NonArcoreScreenState();
}

class _NonArcoreScreenState extends State<NonArcoreScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  Object? _object;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.back,
    );

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _initializeControllerFuture = _cameraController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_cameraController),
                Center(
                  child: Cube(
                    onSceneCreated: (Scene scene) {
                      _object = Object(
                        fileName: 'assets/black_myth.obj',
                        lighting: true,
                        scale: Vector3(0.5, 0.5, 0.5),
                        rotation: Vector3(0, 0, 0),
                      );
                      scene.world.add(_object!);
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
