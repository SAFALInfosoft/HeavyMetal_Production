import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../../Utils/Constants.dart';
import '../../../../widgets/InfoRowItem.dart';
import '../../../Dashboard/Dashboard.dart';
import '../../Maintanance_Menu/Maintanance_Menu.dart';
import '../BreakDown_Form.dart';
import 'Provider/BreakDown_List_Provider.dart';



class BreakDown_List extends StatelessWidget {
  const BreakDown_List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BreakDown_ListProvider =
    context.watch<BreakDown_List_Provider>();

    if(BreakDown_ListProvider.isInitialized==false){
      BreakDown_ListProvider.init(context);
      BreakDown_ListProvider.isInitialized=true;
    }



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
              BreakDown_ListProvider.isInitialized=false;
              BreakDown_ListProvider.BreakDown_List =[];


              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Maintanance_Menu()));
            },
          ),
          title: Consumer<BreakDown_List_Provider>(
            builder: (BuildContext context, BreakDown_List_Provider provider, Widget? child) {
              return Padding(
                padding: EdgeInsets.only(
                  left: provider.width * 0.04,
                  right: provider.width * 0.04,
                ),
                child: Text(
                  "BreakDown",
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

        // 🔹 Your Page
        body: Consumer<BreakDown_List_Provider>(
          builder: (BuildContext context, BreakDown_List_Provider provider, Widget? child) {

            return Column(
              children: [
                /// 🔍 SEARCH BAR
                _buildSearchBox(
                  provider.searchController,
                  "Search BreakDown...",
                  provider.updateSearch,
                ),

                /// 🔹 FILTERED LIST
                Expanded(
                  child: provider.filteredList.isEmpty
                      ? const Center(
                    child: Text(
                      "No BreakDown Found",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                      : Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                    child: ListView.separated(
                      itemCount: provider.filteredList.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = provider.filteredList[index];

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Slidable(
                            key: ValueKey(item["URN_No"]),
                            closeOnScroll: true,

                            /// 👉 SLIDE LEFT (EDIT)
                            startActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              extentRatio: 0.4,
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Breakdown_Form_Screen(
                                              URN_No: item["URN_No"],
                                              DocNo: item["Doc_No"],
                                              Category: item["Category_Name"],
                                              Status: item["Status"],
                                              Mode: "Edit",
                                            ),
                                      ),
                                    );

                                    provider.isInitialized = false;
                                  },
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ],
                            ),

                            /// 👉 SLIDE RIGHT (DELETE)
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              extentRatio: 0.4,
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                          Text("Deleted ${item["URN_No"]}")),
                                    );
                                  },
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),

                            /// 👉 CARD CONTENT UI
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// HEADER (Doc No - Status)
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item["Doc_No"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      Text(
                                        item["Status"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: item["Status"] == "Approved"
                                              ? Colors.green
                                              : item["Status"] == "Not Approved"
                                              ? Colors.redAccent
                                              : Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Divider(height: 15),

                                  /// DETAILS
                                  InfoPair(
                                      label: "URN No", value: item["URN_No"]),
                                  InfoPair(
                                      label: "Machine Name",
                                      value: item["MAchine_Name"]),
                                  InfoPair(
                                      label: "Doc Date",
                                      value: item["Doc_Date"]),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),


        floatingActionButton: Consumer<BreakDown_List_Provider>(
          builder: (BuildContext context, BreakDown_List_Provider provider, Widget? child) {
            return FloatingActionButton(
              onPressed: () async {
                await provider.generateUrnNo(context);


              },
              backgroundColor: Colors.transparent, // so gradient is visible
              elevation: 0,
              child: Container(
                height: 60.0,
                width: 60.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: kMainGradient, // your reusable gradient
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            );
          },
        )



    );
  }

  Widget _buildSearchBox(
      TextEditingController controller,
      String hint,
      Function(String) onChange,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChange,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

}
