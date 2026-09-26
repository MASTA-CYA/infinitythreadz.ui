import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraWidget extends StatefulWidget {
  final CameraDescription camera;
  const CameraWidget({super.key, required this.camera});

  @override
  State<StatefulWidget> createState() => _CameraWidget();
}

class _CameraWidget extends State<CameraWidget> {
  String title = 'Camera';
  late CameraController controller;
  late Future<void> initializeControllerFuture;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    initializeControllerFuture = controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      final bool isDenied =
          e is CameraException && e.code == 'CameraAccessDenied';
      if (mounted) {
        setState(() {
          errorMessage = isDenied
              ? 'Camera access was denied. Allow it in your settings to take a profile photo.'
              : 'The camera could not be started.';
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      body: FutureBuilder<void>(
        future: initializeControllerFuture,
        builder: (context, snapshot) {
          if (errorMessage != null) {
            return buildError(context, errorMessage!);
          }
          if (snapshot.connectionState == ConnectionState.done &&
              controller.value.isInitialized) {
            return Stack(
              children: [
                Transform.scale(
                  scale: controller.value.aspectRatio / deviceRatio,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: FloatingActionButton(
                      heroTag: 'camera',
                      shape: const CircleBorder(),
                      onPressed: () async {
                        try {
                          await initializeControllerFuture;
                          final image = await controller.takePicture();
                          if (!context.mounted) {
                            return;
                          }
                          Navigator.of(context).pop(image);
                        } on CameraException catch (e) {
                          debugPrint('Could not take picture: ${e.code}');
                        }
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildError(BuildContext context, String message) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography_outlined, size: 48),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
