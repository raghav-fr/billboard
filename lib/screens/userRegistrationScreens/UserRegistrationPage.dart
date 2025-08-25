// ignore_for_file: unused_field, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/constants/constant.dart';
import 'package:technova_billboard/models/userRegistrationModel.dart';
import 'package:technova_billboard/provider/imageProvider/profileImageProvider.dart';
import 'package:technova_billboard/services/userCRUDServices/userCRUDServices.dart';
import 'package:technova_billboard/utils/colors.dart';
import 'package:technova_billboard/widgets/iconCustomTextbox.dart';

class Userregistrationpage extends StatefulWidget {
  const Userregistrationpage({super.key});

  @override
  State<Userregistrationpage> createState() => _UserregistrationpageState();
}

class _UserregistrationpageState extends State<Userregistrationpage> {
  TextEditingController nametextcontroller = TextEditingController();
  TextEditingController phonetextcontroller = TextEditingController();
  TextEditingController dobtextcontroller = TextEditingController();
  bool isSavedClicked = false;
  DateTime? _selectedDate;

  Future<void> _pickDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        controller.text =
            "${picked.day}-${picked.month}-${picked.year}"; // nicely formatted
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 95.h),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 7.h),

                      Consumer<Profileimageprovider>(
                        builder: (context, imageprovider, child) {
                          if (imageprovider.profileImage.path.isEmpty) {
                            return InkWell(
                              onTap: () {
                                context
                                    .read<Profileimageprovider>()
                                    .getProfileImage(context);
                              },
                              splashColor: Colors.white,
                              child: Container(
                                height: 20.h,
                                width: 20.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 1,
                                    color: customBlue,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_a_photo_rounded,
                                    size: 6.h,
                                    color: customBlue,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            File profileImage = imageprovider.profileImage;
                            log(profileImage.path);
                            return InkWell(
                              onTap: () {
                                context
                                    .read<Profileimageprovider>()
                                    .getProfileImage(context);
                              },
                              splashColor: Colors.white,
                              child: Container(
                                height: 20.h,
                                width: 20.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 1,
                                    color: customBlue,
                                  ),
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: FileImage(profileImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 5.h),
                      Iconcustomtextbox(
                        hint: "Name",
                        textEditingController: nametextcontroller,
                        height: 6.h,
                        icon: Icon(Icons.person),
                      ),
                      SizedBox(height: 3.h),
                      InkWell(
                        onTap: () {
                          _pickDate(context, dobtextcontroller);
                        },
                        child: Iconcustomtextbox(
                          hint: "dd-mm-yyyy",
                          textEditingController: dobtextcontroller,
                          height: 6.h,
                          icon: Icon(Icons.calendar_month_rounded),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Iconcustomtextbox(
                        hint: "Phone number",
                        textEditingController: phonetextcontroller,
                        height: 6.h,
                        icon: Icon(Icons.phone_android_rounded),
                      ),
                      SizedBox(height: 4.h),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 50.w,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isSavedClicked = true;
                              });
                              await context
                                  .read<Profileimageprovider>()
                                  .getProfileImageUrl(context);
                              Userregistrationmodel data = Userregistrationmodel(
                                userId: auth.currentUser!.uid,
                                dob: dobtextcontroller.text.trim(),
                                name: nametextcontroller.text.trim(),
                                profileimg:
                                    context
                                        .read<Profileimageprovider>()
                                        .profileUrl,
                                phonenumber: phonetextcontroller.text.trim(),
                              );
                              
                              await Usercrudservices.userRegistrer(context, data);
                          
                              context.read<Profileimageprovider>().setnull();
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Color.fromRGBO(83, 40, 225, 1),
                              ),
                            ),
                            child:
                                isSavedClicked
                                    ? CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                    : Text(
                                      "Save",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
