import 'package:flutter/material.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:provider/provider.dart';

import '../../../widgets/_buildMenuCard.dart';
import '../../Dashboard/Dashboard.dart';
import '../BreakDown/BreakDown_Form.dart';
import '../BreakDown/BreakDown_Listing/BreakDown_List.dart';
import '../Recovery/Recovery_Listing/Recovery_List.dart';
import 'Provider/Maintanance_Menu_Provider.dart';


class Maintanance_Menu extends StatelessWidget {
  const Maintanance_Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
          onPressed: () {
            // Navigator.pushReplacementNamed(context, "/dashboard");
            // OR if you use MaterialPageRoute
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
          },
        ),
        title: Consumer<Maintanance_Menu_Provider>(
          builder: (BuildContext context, Maintanance_Menu_Provider provider, Widget? child) {
            return Padding(
              padding: EdgeInsets.only(
                left: provider.width * 0.04,
                right: provider.width * 0.04,
              ),
              child: Text(
                "Maintanance",
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA07A), Color(0xFFFF4C4C)], // orange → red
            begin: Alignment.topCenter,
            end: Alignment.topRight,
          ),
        ),
        child: Consumer<Maintanance_Menu_Provider>(
            builder: (BuildContext context,Maintanance_Menu_Provider provider, Widget? child){
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
                      onTap: () async {
                        // handle navigation
                        if(item["title"].toString() == "Breakdown"){

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BreakDown_List(/*URN_No :provider.generatedUrn*/)),
                          );
                        }
                        else if(item["title"].toString() == "Transfer Memo"){

                        }else if(item["title"].toString() == "Recovery"){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Recovery_List(/*URN_No :provider.generatedUrn*/)),
                          );
                        }
                        // else{
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => Production_Form_Screen()),
                        //   );
                        // }
                      },
                    );
                  },
                ),
              );
            }
        ),
      ),
    );
  }
}
