import 'dart:developer';
import 'dart:io';

// import 'package:englishaitutor/controllers/services/imageServices/imageServices.dart';
import 'package:flutter/material.dart';
import 'package:technova_billboard/services/imageServices/imageServices.dart';

class Profileimageprovider extends ChangeNotifier {
  File profileImage = File('');
  String profileUrl = "";

  getProfileImage(BuildContext context) async{
    profileImage = await Imageservices.getSingleImageFromGallery(context: context);
    log(profileImage.path);
    notifyListeners(); 
  }
  getProfileImageUrl(BuildContext context)async{
    profileUrl = await Imageservices.uploadSingleImageFireStore(context: context, images: profileImage);
    notifyListeners();
  }

  void setnull() {
    profileImage = File('');
    profileUrl = "";
  }
}