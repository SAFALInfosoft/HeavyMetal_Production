import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heavy_metal/screens/Login_Screens/Provider/Login_Page_Provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/AppBackground.dart';
import '../../widgets/app_button.dart';
import '../Dashboard/Dashboard.dart';
import '../Splash_Screen/Splash_Screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () async {
        bool? exitApp = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to close the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("OK"),
              ),
            ],
          ),
        );

        if (exitApp == true) {
          // Option 1 (best for Android & iOS):
          SystemNavigator.pop();

          // Option 2 (alternative, works only on Android):
          // exit(0);
        }
        return Future.value(false); // prevent default pop
      },
      child: Scaffold(
        body: Consumer<LoginPageProvider>(
          builder: (BuildContext context, LoginPageProvider provider, Widget? child){
            return AppBackground(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: provider.width * 0.08), // 8% of screen width
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Image.asset(
                        'images/Heavy_Metal_Logo.jpeg',
                        height: provider.height * 0.10, // 12% of screen height
                        width: provider.height * 0.10,
                      ),
                      SizedBox(height: provider.height * 0.015),

                      // Title
                      Text(
                        "Heavy Metal",
                        style: TextStyle(
                          fontSize: provider.height * 0.035, // ~3.5% of screen height
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: provider.height * 0.05),

                      // Card-like login form
                      Container(
                        padding: EdgeInsets.all(provider.width * 0.05),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(provider.width * 0.04),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: provider.width * 0.03,
                              offset: Offset(0, provider.height * 0.005),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            /// 🔹 Mobile Number Input
                            TextField(
                              controller: provider.mobileNoController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10, // typical mobile number length
                              decoration: InputDecoration(
                                counterText: "", // hides the counter below
                                labelText: "Mobile Number",
                                prefixIcon: const Icon(Icons.phone_android),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(provider.width * 0.03),
                                ),
                              ),
                            ),
                            SizedBox(height: provider.height * 0.020),

                            /// 🔹 M-PIN Input
                            TextField(
                              controller: provider.MPinController,
                              keyboardType: TextInputType.number,
                              obscureText: true, // hide pin input
                              maxLength: 4, // typical M-PIN length
                              decoration: InputDecoration(
                                counterText: "", // hides counter
                                labelText: "M-PIN",
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(provider.width * 0.03),
                                ),
                              ),
                            ),
                            SizedBox(height: provider.height * 0.025),

                            /// 🔹 Login Button
                            SizedBox(
                              width: double.infinity,
                              child: Appbutton(
                                text: "Login",
                                onPressed: () async {
                                  final success = await provider.login(
                                    provider.mobileNoController.text,
                                    provider.MPinController.text,
                                  );

                                  if (success) {
                                    // 🔑 Navigate to next screen
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (_) => const DashboardPage()),
                                    );
                                    provider.mobileNoController.clear();
                                    provider.MPinController.clear();
                                  } else {
                                    // show error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Login failed, please try again')),
                                    );
                                  }
                                },
                              ),
                            ),

                            SizedBox(height: provider.height * 0.02),

                            /// 🔹 Forgot M-PIN Button
                            TextButton(
                              onPressed: () {
                                // TODO: forgot M-PIN navigation
                              },
                              child: Text(
                                "Forgot M-PIN?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: provider.height * 0.018,
                                ),
                              ),
                            ),
                          ],
                        )

                      ),

                      SizedBox(height: provider.height * 0.03),

                      // Signup link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: provider.height * 0.018,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: navigate to signup
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: provider.height * 0.018,
                              ),
                            ),
                          ),
                        ],
                      )
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
