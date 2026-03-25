import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:provider/provider.dart';

import '../../../Utils/Constants.dart';
import '../../../widgets/InfoRowItem.dart';
import '../../../widgets/_buildMenuCard.dart';
import '../../Dashboard/Dashboard.dart';
import '../../Scanner/Scanner_Screen.dart';
import '../../Production/Production_Form/Production_Form_Screen.dart';
import '../Transfer_Memo_Form/Transfer_Memo_Form_Screen.dart';
import 'Provider/Transfer_Memo_List_Provider.dart';


class Transfer_Memo_List extends StatelessWidget {
  const Transfer_Memo_List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Transfer_Memo_ListProvider =
    context.watch<Transfer_Memo_List_Provider>();

    if(Transfer_Memo_ListProvider.isInitialized==false){
      Transfer_Memo_ListProvider.init(context);
      Transfer_Memo_ListProvider.isInitialized=true;
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
            Transfer_Memo_ListProvider.isInitialized=false;

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
          },
        ),
        title: Consumer<Transfer_Memo_List_Provider>(
          builder: (BuildContext context, Transfer_Memo_List_Provider provider, Widget? child) {
            return Padding(
              padding: EdgeInsets.only(
                left: provider.width * 0.04,
                right: provider.width * 0.04,
              ),
              child: Text(
                "Transfer Memo",
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
        body: Consumer<Transfer_Memo_List_Provider>(
          builder: (context, provider, _) {

            return Column(
              children: [
                // 🔍 SEARCH BAR
                _buildSearchBox(
                  provider.searchController,
                  "Search Transfer Memo...",
                  provider.updateSearch,
                ),

                Expanded(
                  child: provider.filteredList.isEmpty
                      ? const Center(
                    child: Text(
                      "No Transfer Memos Found",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                      : ListView.separated(
                    itemCount: provider.filteredList.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10),
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

                          startActionPane: ActionPane(
                            motion: DrawerMotion(),
                            extentRatio: 0.4,
                            children: [
                              SlidableAction(
                                onPressed: (_) async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Transfer_Memo_Form_Screen(
                                            generatedUrn: item["URN_No"],
                                            DocNo: item["Doc_No"],
                                            Category: item["Category_Name"],
                                            Status: item["Status"],
                                            Mode: "Edit",
                                          ),
                                    ),
                                  );
                                },
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                            ],
                          ),

                          endActionPane: ActionPane(
                            motion: DrawerMotion(),
                            extentRatio: 0.4,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                    Text("Deleted ${item["URN_No"]}"),
                                  ));
                                },
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item["Doc_No"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    Text(
                                      item["Status"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: item["Status"] == "Approved"
                                            ? Colors.green
                                            : item["Status"] == "Not Approved"
                                            ? Colors.redAccent
                                            : Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 15),
                                InfoPair(label: "URN No", value: item["URN_No"]),
                                InfoPair(label: "Wo No", value: item["Wo_No"]),
                                InfoPair(label: "Doc Date", value: item["Doc_Date"]),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),


        floatingActionButton: Consumer<Transfer_Memo_List_Provider>(
          builder: (BuildContext context, Transfer_Memo_List_Provider provider, Widget? child) {
            return FloatingActionButton(
              onPressed: () async {
                await provider.generateUrnNo();

                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Transfer_Memo_Form_Screen(generatedUrn :provider.generatedUrn,DocNo:provider.generatedDoc_No,Category:provider.generatedCategory,Status:"Draft",Mode:"Add")));
                Transfer_Memo_ListProvider.isInitialized=false;
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
