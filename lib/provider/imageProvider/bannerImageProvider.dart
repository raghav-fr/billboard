import 'dart:io';

import 'package:flutter/material.dart';
import 'package:technova_billboard/services/imageServices/imageServices.dart';

class Bannerimageprovider extends ChangeNotifier{
  List<File> reportBannerImage = [];
  List<String> reportBannerImageUrl = [];

  getReportBannerImage( BuildContext context ) async{
    List<File> reportsBannerImage = await Imageservices.getImageFromGallery(context: context);
    reportBannerImage.addAll(reportsBannerImage);
    notifyListeners();
  }
  updateReportBannerImageUrl( BuildContext context ) async{
    reportBannerImageUrl = await Imageservices.UplaodImagesToFirebaseNGetUrl(context: context, images: reportBannerImage);
    notifyListeners();
  }

  setNull(){
    reportBannerImage = [];
    reportBannerImageUrl = [];
    notifyListeners();
  }
}