import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/services/authservices/authServices.dart';
// import 'package:technova_billboard/widgets/customTextbox.dart';
import 'package:technova_billboard/widgets/iconCustomTextbox.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  TextEditingController? emailController;
  TextEditingController? passwordController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image(image: AssetImage("assets/images/circle1.png")),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Account",
                    style: GoogleFonts.poppins(
                      fontSize: 3.8.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.poppins(),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "Sign In",
                        style: GoogleFonts.poppins(
                          color: Color.fromRGBO(83, 40, 225, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Iconcustomtextbox(
                    textEditingController: emailController,
                    height: 5.h,
                    icon: Icon(Icons.person, color: Colors.grey),
                    hint: "Name",
                  ),
                  SizedBox(height: 1.5.h),
                  Iconcustomtextbox(
                    textEditingController: emailController,
                    height: 5.h,
                    icon: Icon(Icons.email, color: Colors.grey),
                    hint: "Email",
                  ),
                  SizedBox(height: 1.5.h),
                  Iconcustomtextbox(
                    textEditingController: passwordController,
                    height: 5.h,
                    icon: Icon(Icons.lock, color: Colors.grey),
                    hint: "Password",
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 40.w,

                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Color.fromRGBO(83, 40, 225, 1),
                          ),
                        ),
                        onPressed: () {
                          Authservices.createUser(context: context, emailAddress: emailController!.text.trim(), password: passwordController!.text.trim());
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 13.h),
              width: 100.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Authservices.signInWithGoogle(context);
                    },
                    child: FaIcon(FontAwesomeIcons.google, size: 3.5.h, color: Colors.grey[700],)),
                  SizedBox(width: 6.w),
                  InkWell(
                    onTap: () {
                      Authservices.signInWithFacebook(context);
                    },
                    child: FaIcon(FontAwesomeIcons.facebook, size: 3.5.h, color: Colors.grey[700],)),
                  SizedBox(width: 6.w),
                  InkWell(
                    onTap: () {
                      Authservices.signInWithGitHub(context);
                    },
                    child: FaIcon(FontAwesomeIcons.github, size: 3.5.h, color: Colors.grey[700],)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 5.h,
            left: 8.w,
            child: IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios_new_rounded))),
        ],
      ),
    );
  }
}
