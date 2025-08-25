import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/screens/authScreens/SignupPage.dart';
import 'package:technova_billboard/services/authservices/authServices.dart';
// import 'package:technova_billboard/widgets/customTextbox.dart';
import 'package:technova_billboard/widgets/iconCustomTextbox.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
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
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 4.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.poppins(),
                      ),
                      SizedBox(width: 2.w),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade,child: Signuppage()));
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            color: Color.fromRGBO(83, 40, 225, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
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
                  SizedBox(height: 3.h),
                  Text(
                    "Forget Password ?",
                    style: GoogleFonts.poppins(
                      color: Color.fromRGBO(83, 40, 225, 1),
                      fontWeight: FontWeight.bold,
                    ),
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
                          Authservices.loginUser(context: context, emailAddress: emailController!.text, password: passwordController!.text);
                        },
                        child: Text(
                          "Login",
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Authservices.signInAsGuest(context);
                      },
                      child: Text(
                        "Skip now",
                        style: GoogleFonts.poppins(
                          color: Color.fromRGBO(83, 40, 225, 1),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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
        ],
      ),
    );
  }
}
