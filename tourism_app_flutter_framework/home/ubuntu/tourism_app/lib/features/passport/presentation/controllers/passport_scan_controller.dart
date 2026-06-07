import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/core/utils/mrz_parser.dart';

class PassportScanController extends GetxController {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  final RxBool isCameraInitialized = false.obs;
  final RxBool isScanning = false.obs;
  final RxString scannedText = ''.obs;
  final RxMap<String, String> parsedFields = <String, String>{}.obs;
  final RxBool fieldsSaved = false.obs;

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
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        cameraController =
            CameraController(cameras![0], ResolutionPreset.high);
        await cameraController!.initialize();
        isCameraInitialized.value = true;
        appLogger.i('Camera initialized.');
      } else {
        Get.snackbar('Error', 'No cameras available.');
      }
    } else {
      Get.snackbar(
          'Permission Denied', 'Camera permission is required to scan passport.');
    }
  }

  Future<void> startScan() async {
    if (!isCameraInitialized.value) return;
    isScanning.value = true;

    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        isScanning.value = false;
        return;
      }

      final inputImage = InputImage.fromFile(File(pickedFile.path));
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      scannedText.value = recognizedText.text;
      appLogger.i('OCR complete. Attempting MRZ parse...');

      final fields = MrzParser.parse(recognizedText.text);
      parsedFields.assignAll(fields);

      if (fields.isNotEmpty) {
        Get.snackbar(
          'Scan Complete',
          'Passport data extracted. Tap "Save Fields" to continue.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Scan Complete',
          'Text extracted but MRZ could not be read. Try again with better lighting.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      appLogger.e('Scan error', error: e);
      Get.snackbar('Error', 'Scan failed: $e');
    } finally {
      isScanning.value = false;
    }
  }

  Future<void> savePassportFields() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || parsedFields.isEmpty) return;

    try {
      final update = <String, dynamic>{};
      if (parsedFields['passportNumber'] != null) {
        update['passportNumber'] = parsedFields['passportNumber'];
      }
      if (parsedFields['country'] != null) {
        update['passportCountry'] = parsedFields['country'];
      }
      if (parsedFields['nationality'] != null) {
        update['passportNationality'] = parsedFields['nationality'];
      }
      if (parsedFields['givenNames'] != null) {
        update['passportGivenNames'] = parsedFields['givenNames'];
      }
      if (parsedFields['surname'] != null) {
        update['passportSurname'] = parsedFields['surname'];
      }
      if (parsedFields['dateOfBirth'] != null) {
        update['passportDateOfBirth'] = parsedFields['dateOfBirth'];
      }
      if (parsedFields['expiryDate'] != null) {
        update['passportExpiryDate'] = parsedFields['expiryDate'];
      }
      if (parsedFields['mrzLine1'] != null &&
          parsedFields['mrzLine2'] != null) {
        update['passportMrz'] =
            '${parsedFields['mrzLine1']}\n${parsedFields['mrzLine2']}';
      }
      update['passportScannedAt'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(uid)
          .update(update);

      fieldsSaved.value = true;
      Get.snackbar('Saved', 'Passport fields stored successfully.');
    } catch (e) {
      appLogger.e('Error saving passport fields', error: e);
      Get.snackbar('Error', 'Could not save passport data: $e');
    }
  }

  void stopScan() {
    isScanning.value = false;
  }
}
