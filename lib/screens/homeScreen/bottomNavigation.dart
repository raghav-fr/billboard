import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:technova_billboard/screens/accountScreens/AccountPage.dart';
import 'package:technova_billboard/screens/homeScreen/Homepage.dart';
import 'package:technova_billboard/screens/publicReviewScreen/PublicReviewPage.dart';
import 'package:technova_billboard/screens/publicReviewScreen/personalReviewPage.dart';
import 'package:technova_billboard/screens/reportScreens/ReportHistory.dart';
// import 'package:technova_billboard/screens/userRegistrationScreens/UserRegistrationPage.dart';
import 'package:technova_billboard/utils/colors.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: Homepage(),
            item: ItemConfig(
              activeForegroundColor: customBlue,
              inactiveForegroundColor: customBlue,
              activeColorSecondary: customBlue,
              icon: Icon(Icons.home),
              title: "Home",
            ),
          ),
          PersistentTabConfig(
            screen: Reporthistory(),
            item: ItemConfig(
              activeForegroundColor: customBlue,
              inactiveForegroundColor: customBlue,
              activeColorSecondary: customBlue,
              icon: Icon(Icons.format_list_numbered_rtl_rounded),
              title: "Status",
            ),
          ),
          PersistentTabConfig(
            screen: Personalreviewpage(),
            item: ItemConfig(
              activeForegroundColor: customBlue,
              inactiveForegroundColor: customBlue,
              activeColorSecondary: customBlue,
              icon: Icon(Icons.menu_book_rounded),
              title: "public_review",
            ),
          ),
          PersistentTabConfig(
            screen: PublicReviewPage(),
            item: ItemConfig(
              activeForegroundColor: customBlue,
              inactiveForegroundColor: customBlue,
              activeColorSecondary: customBlue,
              icon: Icon(Icons.post_add_rounded),
              title: "give_public_review",
            ),
          ),
          PersistentTabConfig(
            screen: AccountPage(),
            item: ItemConfig(
              activeForegroundColor: customBlue,
              inactiveForegroundColor: customBlue,
              activeColorSecondary: customBlue,
              icon: Icon(Icons.person),
              title: "Account",
            ),
          ),
        ],
        navBarBuilder:
            (navBarConfig) => Style5BottomNavBar(
              navBarConfig: navBarConfig,
              navBarDecoration: NavBarDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
      );
  }
}