import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/screens/cameraScreen/PreviewPage.dart';

class Camerapage extends StatefulWidget {
  const Camerapage({super.key});

  @override
  State<Camerapage> createState() => _CamerapageState();
}

class _CamerapageState extends State<Camerapage> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isDetecting = false;
  int statecam = 0;
  bool _isInitialized = false;

  Future<void> _initCamera(BuildContext context, int s) async {
    cameras = await availableCameras();
    controller = CameraController(cameras![s], ResolutionPreset.ultraHigh);
    await controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _captureAndRecognize(BuildContext context) async {
    try {
      final XFile picture = await controller!.takePicture();
      final File imageFile = File(picture.path);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(imagePath: imageFile.path),
        ),
      );
    } catch (e) {
      print("Error in recognition: $e");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        _initCamera(context, statecam);
        _isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(83, 40, 225, 1),
          ),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 7.w,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (statecam == 1) {
                    statecam = 0;
                  } else {
                    statecam = 1;
                  }
                });
                _initCamera(context, statecam);
              },
              icon: Icon(
                Icons.cameraswitch_rounded,
                color: Colors.white,
                size: 7.w,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(width: 100, child: CameraPreview(controller!)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.center,
                height: 12.h,
                width: 100.w,
                color: Colors.black,
                child: InkWell(
                  onTap: () {
                    _captureAndRecognize(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 19.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.w, color: Colors.white),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: 14.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
