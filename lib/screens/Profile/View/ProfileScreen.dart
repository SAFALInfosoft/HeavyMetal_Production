import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../GlobalComponents/PreferenceManager.dart';
import '../../../widgets/app_button.dart';
import '../../Dashboard/Dashboard.dart';
import '../../Login_Screens/Login_Page.dart';
import '../provider/ProfileProvider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data (replace with API / Preference data)
    String name = "Kaushik Khandala";
    String phone = "9876543210";
    final provider =
    Provider.of<ProfileProvider>(context, listen: false);
    provider.loadProfile();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFA07A), Color(0xFFFF4C4C)], // gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            // Navigator.pushReplacementNamed(context, "/dashboard");
            // OR if you use MaterialPageRoute
            final provider =
            Provider.of<ProfileProvider>(context, listen: false);

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DashboardPage()));
          },
        ),
        title: Consumer<ProfileProvider>(
          builder: (BuildContext context, ProfileProvider provider,
              Widget? child) {
            return Padding(
              padding: EdgeInsets.only(
                left: provider.width * 0.04,
                right: provider.width * 0.04,
              ),
              child: Text(
                "Profile Details",
                style: TextStyle(
                  fontSize: provider.height * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),

      ),
      body: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Color(0xFFFFA07A), Color(0xFFFF4C4C)], // orange → red
        //     begin: Alignment.topCenter,
        //     end: Alignment.topRight,
        //   ),
        // ),
        child: Consumer<ProfileProvider>(builder:
            (BuildContext context, ProfileProvider provider, Widget? child) {
              return Container(
                height: provider.height,
                padding: EdgeInsets.only(left: 20.0, right: 20, top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      /// Profile Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFA07A),
                              Color(0xFFFF4C4C),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Name
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text("Name"),
                        subtitle: Text(provider.name),
                      ),

                      /// Phone
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text("Phone"),
                        subtitle: Text(provider.phone),
                      ),
                      ListTile(
                        leading: const Icon(Icons.apartment),
                        title: const Text("Unit"),
                        subtitle: Text(provider.Unit_Name),
                      ),


                    ],
                  ),
                ),
              );
            }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ProfileProvider>(
          builder: (BuildContext context, ProfileProvider provider, Widget? child) {
            return Appbutton(
              text: "Logout",
              onPressed: () async {
                await PreferenceManager.instance
                    .setBooleanValue("Login", false);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
            );
          },
        ),
      ),
    );
  }
}