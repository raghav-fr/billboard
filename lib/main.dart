import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/firebase_options.dart';
import 'package:technova_billboard/provider/getReportsProvider/GetReportProvider.dart';
import 'package:technova_billboard/provider/getUserProvider/getUserProvider.dart';
import 'package:technova_billboard/provider/imageProvider/bannerImageProvider.dart';
import 'package:technova_billboard/provider/imageProvider/profileImageProvider.dart';
import 'package:technova_billboard/screens/authScreens/signinLogicScreen.dart';
// import 'package:technova_billboard/screens/locationPickerScreen/LocationPickerPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, _, _) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<Bannerimageprovider>(
              create: (_) => Bannerimageprovider(),
            ),
            ChangeNotifierProvider<Getreportprovider>(
              create: (_) => Getreportprovider(),
            ),
            ChangeNotifierProvider<Profileimageprovider>(
              create: (_) => Profileimageprovider(),
            ),
            ChangeNotifierProvider<Getuserprovider>(
              create: (_) => Getuserprovider(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'technova billboard',
            theme: ThemeData(),
            home: const Signinlogicscreen(),
          ),
        );
      },
    );
  }
}
