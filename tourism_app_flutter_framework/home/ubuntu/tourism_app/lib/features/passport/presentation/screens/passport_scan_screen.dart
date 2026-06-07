import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:tourism_app/features/passport/presentation/controllers/passport_scan_controller.dart';

class PassportScanScreen extends GetView<PassportScanController> {
  const PassportScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Passport Stamp')),
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.cameraController == null) {
          return const Center(child: Text('Error initializing camera.'));
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            CameraPreview(controller.cameraController!),
            Positioned(
              child: ScanOverlayWidget(),
            ),
            Positioned(
              bottom: 50,
              child: FloatingActionButton(
                onPressed: controller.isScanning.value ? null : controller.startScan,
                child: Obx(() => Icon(
                      controller.isScanning.value ? Icons.stop : Icons.camera_alt,
                    )),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Placeholder for Scan Overlay Widget

class ScanOverlayWidget extends StatelessWidget {
  const ScanOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 250,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.greenAccent,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}

