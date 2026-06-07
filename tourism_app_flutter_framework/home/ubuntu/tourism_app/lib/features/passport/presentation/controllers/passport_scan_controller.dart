import 'dart:io';
import 'package:get/get.dart';
import 'package:camera/camera.dart'; // Assuming camera package for scanning
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


class PassportScanController extends GetxController {
  // TODO: Implement passport scanning logic (camera initialization, OCR)
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  final RxBool isCameraInitialized = false.obs;
  final RxBool isScanning = false.obs;
  final RxString scannedText = ''.obs;


  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> initializeCamera() async {
    // Check permissions
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        // Initialize the camera controller with the back camera
        cameraController = CameraController(cameras![0], ResolutionPreset.high);
        await cameraController!.initialize();
        isCameraInitialized.value = true;
        print('Camera initialized.');
      } else {
        Get.snackbar('Error', 'No cameras available.');
      }
    } else {
      Get.snackbar('Permission Denied', 'Camera permission is required to scan passport.');
    }
  }

  

  Future<void> startScan() async {
    if (!isCameraInitialized.value) return;
    isScanning.value = true;
    print('Starting passport scan...');

    // Pick image from camera
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null) {
      isScanning.value = false;
      return;
    }

    final inputImage = InputImage.fromFile(File(pickedFile.path));
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    scannedText.value = recognizedText.text;
    textRecognizer.close();

    isScanning.value = false;
    Get.snackbar('Scan Complete', 'Passport details extracted.');
    print('Passport scan stopped.');
    // You can now use scannedText.value for further processing or navigation
  }

  void stopScan() {
    isScanning.value = false;
    print('Passport scan stopped.');
  }

}