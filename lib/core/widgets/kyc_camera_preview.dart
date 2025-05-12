import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

typedef CameraCallback = void Function(CameraController controller);

@RoutePage()
class KycCameraPreview extends StatefulWidget {
  const KycCameraPreview({
    super.key,
    required this.camera,
    this.onCameraCreated,
  });
  final CameraDescription camera;
  final CameraCallback? onCameraCreated;

  @override
  State<KycCameraPreview> createState() => _KycCameraPreviewState();
}

class _KycCameraPreviewState extends State<KycCameraPreview> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.setFocusMode(FocusMode.auto);
      controller.lockCaptureOrientation();
      widget.onCameraCreated?.call(controller);
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.value.isInitialized == false) {
      return const SizedBox();
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        height: 1,
        child: AspectRatio(
          // ignore: noop_primitive_operations
          aspectRatio: 1 / controller.value.aspectRatio.toDouble(),
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}
