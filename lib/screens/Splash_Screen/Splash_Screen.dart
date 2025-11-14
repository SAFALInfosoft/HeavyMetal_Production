// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/PreferenceManager.dart';
import '../../widgets/AppBackground.dart';
import '../Dashboard/Dashboard.dart';
import '../Login_Screens/Login_Page.dart';


// ignore_for_file: library_private_types_in_public_api
class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? Login;
  var role;

  @override
  void initState() {
    super.initState();

    // Save the API base URL once
    PreferenceManager.instance.setStringValue(
      'Base_URL',
      'https://app.metalerp.com/Backend/HMTLProducation/',
    );

    PreferenceManager.instance
        .getBooleanValue("Login")
        .then((value) => setState(() {
      Login = value;
      print("Login===>$value");
      init();
    }));
  }


  Future<void> init() async {
    await Future.delayed(Duration(seconds: 2));
    defaultBlurRadius = 10.0;
    defaultSpreadRadius = 0.5;

    if (Login!) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );

    } else {
      // If user is not logged in
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );

    }
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Screen size
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: AppBackground(
        child: Stack(
          children: [
            // Top circle
            Positioned(
              top: -height * 0.12,
              right: -width * 0.2,
              child: Container(
                width: width * 0.5,
                height: width * 0.5,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(50, 255, 255, 255), // faded circle
                ),
              ),
            ),

            // Bottom circle
            Positioned(
              bottom: -height * 0.15,
              left: -width * 0.25,
              child: Container(
                width: width * 0.7,
                height: width * 0.7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(50, 255, 255, 255),
                ),
              ),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Icon
                  Image.asset(
                    'images/Heavy_Metal_Logo.jpeg',
                    height: height * 0.18, // 18% of screen height
                    width: height * 0.18,
                  ),
                  SizedBox(height: height * 0.03), // 3% spacing
                  Text(
                    "Heavy Metal",
                    style: TextStyle(
                      fontSize: height * 0.04, // font size based on height
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
