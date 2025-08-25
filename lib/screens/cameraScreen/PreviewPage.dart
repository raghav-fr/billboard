import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/screens/locationPickerScreen/LocationPickerPage.dart';

class PreviewPage extends StatelessWidget {
  final String imagePath;
  const PreviewPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PinLocationPicker(imagePath: imagePath),
        ),
      );
          }, icon: Icon(Icons.check_rounded, color: Colors.white, size: 4.h, ))
          ,SizedBox(width: 2.w,)
        ],
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
