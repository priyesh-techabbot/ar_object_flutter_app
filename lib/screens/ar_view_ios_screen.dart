import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARViewIosScreen extends StatefulWidget {
  const ARViewIosScreen({super.key});

  @override
  State<ARViewIosScreen> createState() => _ARViewIosScreenState();
}

class _ARViewIosScreenState extends State<ARViewIosScreen> {
  late ARKitController arkitController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ARKit Model View")),
      body: ARKitSceneView(
        onARKitViewCreated: onARKitViewCreated,
        planeDetection: ARPlaneDetection.horizontal,
      ),
    );
  }

  void onARKitViewCreated(ARKitController controller) {
    arkitController = controller;
    arkitController.onAddNodeForAnchor = onAddAnchor;
  }

  void onAddAnchor(ARKitAnchor anchor) {
    final node = ARKitReferenceNode(
      url: 'assets/black_myth.usdz',
      position: vector.Vector3(0, 0, 0),
      scale: vector.Vector3(0.01, 0.01, 0.01),
    );

    arkitController.add(node);
  }

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }
}
