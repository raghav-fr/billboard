import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/constants/constant.dart';

class Imageservices {
  /// Pick **single image** either from gallery or camera
  static getSingleImageFromGallery({required BuildContext context}) async {
    File selectedFile = File('');
    final ImageSource? source = await _showImageSourceDialog(context);

    if (source != null) {
      final pickedFile = await imagePicker.pickImage(
        source: source,
        imageQuality: 100,
      );
      if (pickedFile != null) {
        selectedFile = File(pickedFile.path);
      }
    }
    return selectedFile;
  }

  /// Upload a single image to Firestore
  static uploadSingleImageFireStore({
    required BuildContext context,
    required File images,
  }) async {
    String sellerUid = auth.currentUser!.uid;
    String imageName = "$sellerUid${uuid.v1()}";
    Reference ref = storage.ref().child('ProfileImages').child(imageName);
    await ref.putFile(File(images.path));
    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  /// Pick **multiple images** either from gallery or camera
  static getImageFromGallery({required BuildContext context}) async {
    List<File> selectedImage = [];
    final ImageSource? source = await _showImageSourceDialog(context);

    if (source == ImageSource.gallery) {
      final pickedFile = await imagePicker.pickMultiImage(imageQuality: 100);
      if (pickedFile.isNotEmpty) {
        for (var image in pickedFile) {
          selectedImage.add(File(image.path));
        }
      }
    } else if (source == ImageSource.camera) {
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
      if (pickedFile != null) {
        selectedImage.add(File(pickedFile.path));
      }
    }

    log("the images are : ${selectedImage.toList().toString()}");
    return selectedImage;
  }

  /// Upload multiple images and return their URLs
  static UplaodImagesToFirebaseNGetUrl({
    required BuildContext context,
    required List<File> images,
  }) async {
    List<String> imagesUrl = [];
    String sellerUid = auth.currentUser!.uid;

    await Future.forEach(images, (image) async {
      String imageName = "$sellerUid${uuid.v1()}";
      Reference ref = storage
          .ref()
          .child('ReportBannerImages')
          .child(imageName);
      await ref.putFile(File(image.path));
      String imageUrl = await ref.getDownloadURL();
      imagesUrl.add(imageUrl);
    });
    return imagesUrl;
  }

  /// Show a dialog to pick Camera or Gallery
  static Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text("Select Image Source", style: GoogleFonts.poppins(fontSize: 20.sp,fontWeight: FontWeight.normal) ,),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text("Camera",style: GoogleFonts.poppins(fontSize: 16.sp,fontWeight: FontWeight.bold) ,),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text("Gallery", style: GoogleFonts.poppins(fontSize: 16.sp,fontWeight: FontWeight.bold) ,),
          ),
        ],
      ),
    );
  }
}
