import 'package:ar_object_flutter_app/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Flutter3DController controller = Flutter3DController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: //The 3D viewer widget for glb and gltf format
          Flutter3DViewer(
        //If you pass 'true' the flutter_3d_controller will add gesture interceptor layer
        //to prevent gesture recognizers from malfunctioning on iOS and some Android devices.
        //the default value is true
        activeGestureInterceptor: true,
        //If you don't pass progressBarColor, the color of defaultLoadingProgressBar will be grey.
        //You can set your custom color or use [Colors.transparent] for hiding loadingProgressBar.
        progressBarColor: Colors.orange,
        //You can disable viewer touch response by setting 'enableTouch' to 'false'
        enableTouch: true,
        //This callBack will return the loading progress value between 0 and 1.0
        onProgress: (double progressValue) {
          debugPrint('model loading progress : $progressValue');
        },
        //This callBack will call after model loaded successfully and will return model address
        onLoad: (String modelAddress) {
          debugPrint('model loaded : $modelAddress');
        },
        //this callBack will call when model failed to load and will return failure error
        onError: (String error) {
          debugPrint('model failed to load : $error');
        },

        //You can have full control of 3d model animations, textures and camera
        controller: controller,
        src: 'assets/black_myth.glb', //3D model with different animations
        //src: 'assets/sheen_chair.glb', //3D model with different textures
        //src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb', // 3D model from URL
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              controller.playAnimation();
            },
            icon: const Icon(Icons.play_arrow),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () {
              controller.pauseAnimation();
              //controller.stopAnimation();
            },
            icon: const Icon(Icons.pause),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () {
              controller.resetAnimation();
            },
            icon: const Icon(Icons.replay),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () async {
              List<String> availableAnimations =
                  await controller.getAvailableAnimations();
              debugPrint(
                  'Animations : $availableAnimations --- Length : ${availableAnimations.length}');
              var chosenAnimation =
                  await showPickerDialog('Animations', availableAnimations);
              controller.playAnimation(animationName: chosenAnimation);
            },
            icon: const Icon(Icons.format_list_bulleted_outlined),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () async {
              List<String> availableTextures =
                  await controller.getAvailableTextures();
              debugPrint(
                  'Textures : $availableTextures --- Length : ${availableTextures.length}');
              var chosenTexture =
                  await showPickerDialog('Textures', availableTextures);
              controller.setTexture(textureName: chosenTexture ?? '');
            },
            icon: const Icon(Icons.list_alt_rounded),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () {
              controller.setCameraOrbit(20, 20, 5);
              //controller.setCameraTarget(0.3, 0.2, 0.4);
            },
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          const SizedBox(
            height: 4,
          ),
          IconButton(
            onPressed: () {
              controller.resetCameraOrbit();
              //controller.resetCameraTarget();
            },
            icon: const Icon(Icons.cameraswitch_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ));
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  Future<String?> showPickerDialog(String title, List<String> inputList) async {
    return await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 250,
          child: inputList.isEmpty
              ? Center(
                  child: Text('$title list is empty'),
                )
              : ListView.separated(
                  itemCount: inputList.length,
                  padding: const EdgeInsets.only(top: 16),
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, inputList[index]);
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${index + 1}'),
                            Text(inputList[index]),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return const Divider(
                      color: Colors.grey,
                      thickness: 0.6,
                      indent: 10,
                      endIndent: 10,
                    );
                  },
                ),
        );
      },
    );
  }
}
