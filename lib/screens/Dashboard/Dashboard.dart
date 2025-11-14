import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:provider/provider.dart';

import '../../GlobalComponents/PreferenceManager.dart';
import '../../widgets/AppBackground.dart';
import '../../widgets/_buildMenuCard.dart';
import '../Login_Screens/Login_Page.dart';
import '../Maintanance/Maintanance_Menu/Maintanance_Menu.dart';
import '../Production/Production_Form/Production_Form_Screen.dart';
import '../Transfer_Memo/Transfer_Memo_List/Transfer_Memo_List_Screen.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

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
          title: Consumer<DashboardProvider>(
            builder: (BuildContext context, DashboardProvider provider,
                Widget? child) {
              return Padding(
                padding: EdgeInsets.only(
                  left: provider.width * 0.04,
                  right: provider.width * 0.04,
                ),
                child: Text(
                  "Heavy Metal",
                  style: TextStyle(
                    fontSize: provider.height * 0.03,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          actions: [
            Consumer<DashboardProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding: EdgeInsets.only(right: provider.width * 0.04),
                  child: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'logout') {
                        // Call your logout logic here
                        // provider.logout();
                        await PreferenceManager.instance.setBooleanValue("Login", false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text('Logout'),
                      ),
                    ],
                    child: CircleAvatar(
                      radius: provider.height * 0.022,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.person, color: Color(0xFFFF4C4C)),
                    ),
                  ),
                );
              },
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFA07A), Color(0xFFFF4C4C)], // orange → red
              begin: Alignment.topCenter,
              end: Alignment.topRight,
            ),
          ),
          child: Consumer<DashboardProvider>(builder:
              (BuildContext context, DashboardProvider provider, Widget? child) {
            return Container(
              height: provider.height,
              padding: EdgeInsets.only(left: 20.0, right: 20, top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: Colors.white,
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: provider.menuItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = provider.menuItems[index];
                  return MenuCard(
                    title: item["title"] as String,
                    icon: item["icon"] as IconData,
                    color: item["color"] as Color,
                    onTap: () {
                      // handle navigation
                      if (item["title"].toString() == "Production") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Production_Form_Screen()));
                      } else if (item["title"].toString() == "Transfer Memo") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Transfer_Memo_List()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Maintanance_Menu()),
                        );
                      }
                    },
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
