// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/screens/reportScreens/ReportPage.dart';

class PinLocationPicker extends StatefulWidget {
  final String imagePath;
  const PinLocationPicker({super.key, required this.imagePath});

  @override
  State<PinLocationPicker> createState() => _PinLocationPickerState();
}

class _PinLocationPickerState extends State<PinLocationPicker> {
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  String _address = "Move the map to select location";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      Placemark place = placemarks.first;
      setState(() {
        _address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      setState(() {
        _address = "Could not fetch address";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          ),
          title: Text(
            "Pick Location",
            style: GoogleFonts.poppins(fontSize: 18.sp, color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        body:
            _currentLatLng == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                  children: [
                    SizedBox(
                      height: 75.h,
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _currentLatLng!,
                              zoom: 16,
                            ),
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            onCameraMove: (position) {
                              _currentLatLng = position.target;
                            },
                            onCameraIdle: () {
                              if (_currentLatLng != null) {
                                _getAddressFromLatLng(_currentLatLng!);
                              }
                            },
                          ),
                          Center(
                            child: Icon(
                              Icons.location_pin,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Pin icon in center
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 10.h,
                        color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 3.w, top: 0.5.h),
                              width: 75.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    maxLines: 2,
                                    _address,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 0.2.h),
                                  Text(
                                    "longitude: ${_currentLatLng!.longitude}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "latiitude: ${_currentLatLng!.latitude}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 2.w),
                              child: IconButton(
                                onPressed: () {
                                  if (_currentLatLng != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ReportPage(
                                              imagePath: widget.imagePath,
                                              address: _address,
                                              latitude:
                                                  _currentLatLng!.latitude,
                                              longitude:
                                                  _currentLatLng!.longitude,
                                            ),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.check_rounded,
                                  size: 4.h,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
