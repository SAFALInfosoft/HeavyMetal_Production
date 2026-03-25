import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:provider/provider.dart';

import '../../../../Utils/Constants.dart';
import '../../../../widgets/InfoRowItem.dart';
import '../../../Dashboard/Dashboard.dart';
import '../../Maintanance_Menu/Maintanance_Menu.dart';
import '../Recovery_Form/Recovery_Form_Screen.dart';
import 'Provider/Recovery_List_Provider.dart';

class Recovery_List extends StatefulWidget {
  const Recovery_List({Key? key}) : super(key: key);

  @override
  State<Recovery_List> createState() => _Recovery_ListState();
}

class _Recovery_ListState extends State<Recovery_List>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final recoveryListProvider = context.watch<Recovery_List_Provider>();

    if (recoveryListProvider.isInitialized == false) {
      recoveryListProvider.init(context);
      recoveryListProvider.isInitialized = true;
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
              colors: [Color(0xFFFFA07A), Color(0xFFFF4C4C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            recoveryListProvider.isInitialized = false;
            recoveryListProvider.Recovery_List = [];
            recoveryListProvider.Recovery_Entry_List = [];
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Maintanance_Menu()),
            );
          },
        ),
        title: Text(
          "Recovery",
          style: TextStyle(
            fontSize: recoveryListProvider.height * 0.03,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          onTap: (index) {
            final provider = context.read<Recovery_List_Provider>();

            if (index == 0) {
              // 🔹 Pending tab
              provider.Recovery_List=[];
              provider.getRecoveryList(context);
            } else if (index == 1) {
              // 🔹 Entry tab
              provider.Recovery_Entry_List=[];
              provider.getRecoveryEntryList(context);
            }
          },
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Entry"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          /// PENDING TAB
          Consumer<Recovery_List_Provider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  _buildSearchBox(
                    provider.pendingSearchController,
                    "Search Pending...",
                    provider.updatePendingSearch,
                  ),
                  Expanded(
                    child: provider.filteredPendingList.isEmpty
                        ? Center(child: Text("No Pending Recovery Found"))
                        : _buildListView(
                      context,
                      provider,
                      provider.filteredPendingList,
                      "pending"
                    ),
                  ),
                ],
              );
            },
          ),

          /// ENTRY TAB
          Consumer<Recovery_List_Provider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  _buildSearchBox(
                    provider.entrySearchController,
                    "Search Entry...",
                    provider.updateEntrySearch,
                  ),
                  Expanded(
                    child: provider.isLoading ==true
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : provider.filteredEntryList.isEmpty
                        ? const Center(
                      child: Text("No Entry Found"),
                    )
                        : _buildListView(
                      context,
                      provider,
                      provider.filteredEntryList,
                      "entry"
                    ),
                  ),

                ],
              );
            },
          ),
        ],
      ),


      /// 🔹 FAB visible only on Entry tab
      floatingActionButton: AnimatedBuilder(
        animation: _tabController.animation!,
        builder: (context, child) {
          return _tabController.index == 1
              ? Consumer<Recovery_List_Provider>(
            builder: (context, provider, child) {
              return FloatingActionButton(
                onPressed: () async {
                  await provider.generateUrnNo(context);
                  if(provider.generatedUrn!= null){
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Recovery_Form_Screen(
                          URN_No: provider.generatedUrn,
                          DocNo: provider.generatedDoc_No,
                          Category: provider.generatedCategory,
                          Status: "Draft",
                          Mode: "Add",
                        ),
                      ),
                    );
                    provider.isInitialized = false;
                  }


                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: kMainGradient,
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
              : const SizedBox.shrink();
        },
      ),
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


  /// 🔹 Reusable ListView Builder
  Widget _buildListView(
      BuildContext context, Recovery_List_Provider provider, List<dynamic> list,String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: ListView.separated(
        itemCount: list.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = list[index];

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Slidable(
              key: ValueKey(item["URN_No"]),
              closeOnScroll: true,
              startActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.4,
                children: [
                  SlidableAction(
                    onPressed: (_) async {
                      BuildContext currentContext = context; // capture the parent context

                      await provider.generateUrnNo(context);
                      await provider.Insert_Pending_TO_New(item["URN_No"]);

                      // Use currentContext (not context from builder)
                      if (!currentContext.mounted) return;

                      if(provider.generatedUrn!= null){
                        Navigator.push(
                          currentContext,
                          MaterialPageRoute(
                            builder: (_) => Recovery_Form_Screen(
                              URN_No: provider.generatedUrn.toString(),
                              DocNo: item["Doc_No"],
                              Category: item["Category_Name"],
                              Status: item["Status"],
                              Mode: "Edit",
                            ),
                          ),
                        ).then((value) => provider.isInitialized = false);
                      }




                    },
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  )


                ],
              ),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.4,
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Deleted ${item["URN_No"]}")),
                      );
                    },
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    InfoPair(label: "URN No", value: item["URN_No"]),
                    InfoPair(label: "Machine Name", value: item["MAchine_Name"]),
                    InfoPair(label: "Doc Date", value: item["Doc_Date"]),
                    Visibility(
                      visible: type=="pending",
                        child: InfoPair(label: "Department", value: type=="pending"?item["Department"]:"")),
                    Visibility(
                      visible: type=="pending",
                        child: InfoPair(label: "Send to", value: type=="pending"?item["Send to Department"]:"")),


                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
