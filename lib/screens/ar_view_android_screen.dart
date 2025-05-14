import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARViewAndroidScreen extends StatefulWidget {
  const ARViewAndroidScreen({super.key});

  @override
  State<ARViewAndroidScreen> createState() => _ARViewAndroidScreenState();
}

class _ARViewAndroidScreenState extends State<ARViewAndroidScreen> {
  late ArCoreController arCoreController;
  bool arCoreAvailable = false;
  bool arCoreInstalled = false;
  bool isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkArCoreSupport();
  }

  Future<void> _checkArCoreSupport() async {
    try {
      final available = await ArCoreController.checkArCoreAvailability();
      final installed = await ArCoreController.checkIsArCoreInstalled();

      setState(() {
        arCoreAvailable = available;
        arCoreInstalled = installed;
        isChecking = false;
      });

      print('ARCORE IS AVAILABLE? $available');
      print('AR SERVICES INSTALLED? $installed');
    } catch (e) {
      debugPrint('Error checking ARCore support: $e');
      setState(() {
        arCoreAvailable = false;
        arCoreInstalled = false;
        isChecking = false;
      });
    }
  }

  @override
  void dispose() {
    if (arCoreAvailable && arCoreInstalled) {
      arCoreController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isChecking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!arCoreAvailable || !arCoreInstalled) {
      return Scaffold(
        appBar: AppBar(title: const Text("AR Not Supported")),
        body: const Center(
          child: Text(
            "ARCore is not supported or not installed on this device.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('AR Outdoor Demo')),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) async {
    try {
      final hit = hits.first;

      final node = ArCoreReferenceNode(
        name: "Myth",
        object3DFileName: "assets/black_myth.glb",
        rotation: hit.pose.rotation,
        scale: vector.Vector3(0.5, 0.5, 0.5),
      );

      await arCoreController.addArCoreNodeWithAnchor(node);
    } catch (e) {
      debugPrint("Error adding 3D model: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load 3D model")),
        );
      }
    }
  }
}
