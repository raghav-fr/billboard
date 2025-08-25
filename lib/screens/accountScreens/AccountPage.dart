import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/models/userRegistrationModel.dart';
import 'package:technova_billboard/provider/getUserProvider/getUserProvider.dart';
import 'package:technova_billboard/services/authservices/authServices.dart';
import 'package:technova_billboard/services/getUserDetailService/getUserDetailServices.dart';
import 'package:technova_billboard/utils/colors.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{ 
      await context.read<Getuserprovider>().getUser();
    });
  }
  @override
  Widget build(BuildContext context) {
    Userregistrationmodel? curruser = context.read<Getuserprovider>().user;
    String imageurl = curruser!.profileimg!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
           

            // Profile image
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              height: 30.h,
              width: 30.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: customBlue, width: 2),
                image: DecorationImage(
                  image: NetworkImage(imageurl), // sample image
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Info containers
            _buildInfoContainer(Icons.person, curruser!.name!),
            _buildInfoContainer(Icons.calendar_today, curruser!.dob!),
            _buildInfoContainer(Icons.phone_android, curruser!.phonenumber!),

            const Spacer(),

            // Sign Out Button
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ElevatedButton(
                onPressed: () {
                  Authservices.signOut(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: customBlue),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
