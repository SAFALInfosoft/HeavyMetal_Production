import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:provider/provider.dart';

import '../../../../Utils/Constants.dart';
import '../../../../widgets/InfoRowItem.dart';
import '../../../Dashboard/Dashboard.dart';
import '../../Maintanance_Menu/Maintanance_Menu.dart';
import '../Preventing_Form/Preventing_Form_Screen.dart';
import 'Provider/Preventing_List_Provider.dart';

class Preventing_List extends StatefulWidget {
  const Preventing_List({Key? key}) : super(key: key);

  @override
  State<Preventing_List> createState() => _Preventing_ListState();
}

class _Preventing_ListState extends State<Preventing_List>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      final provider = context.read<Preventing_List_Provider>();

      if (_tabController.index == 0) {
        // 🔹 Pending tab
        provider.Preventing_Pending_List = [];
        provider.getPreventingPendingList(context);
      } else if (_tabController.index == 1) {
        // 🔹 Entry tab
        provider.Preventing_Entry_List = [];
        provider.getPreventingEntryList(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final recoveryListProvider = context.watch<Preventing_List_Provider>();

    if (recoveryListProvider.isInitialized == false) {
      recoveryListProvider.init(context);
      recoveryListProvider.isInitialized = true;
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.0,
        // size:  Size(360, 690), // optional: simulate consistent screen size
        // devicePixelRatio: 2.75,
      ),
      child: Scaffold(
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
              recoveryListProvider.Preventing_Pending_List = [];
              recoveryListProvider.Preventing_Entry_List = [];
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Maintanance_Menu()),
              );
            },
          ),
          title: Text(
            "Preventing",
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
              final provider = context.read<Preventing_List_Provider>();

              if (index == 0) {
                // 🔹 Pending tab
                provider.Preventing_Pending_List=[];
                provider.getPreventingPendingList(context);
              } else if (index == 1) {
                // 🔹 Entry tab
                provider.Preventing_Entry_List=[];
                provider.getPreventingEntryList(context);
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
            /// =============================================================
            /// PENDING TAB
            /// =============================================================
            Consumer<Preventing_List_Provider>(
              builder: (context, provider, _) {

                if (_tabController.index != 0) {
                  return const SizedBox();
                }

                return Column(
                  children: [

                    // =========================================================
                    // SEARCH
                    // =========================================================
                    _buildSearchBox(
                      provider.pendingSearchController,
                      "Search Pending...",
                      provider.updatePendingSearch,
                    ),

                    // =========================================================
                    // FILTER SECTION
                    // =========================================================
                    // =========================================================
// COMPACT FILTERS
// =========================================================
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 2, 10, 4),
                      child: Row(
                        children: [

                          // =====================================================
                          // FREQUENCY FILTER
                          // =====================================================
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: DropdownButtonFormField<String>(
                                value: provider.selectedFrequencyFilter,
                                isExpanded: true,
                                isDense: true,

                                decoration: InputDecoration(
                                  labelText: "Frequency",
                                  labelStyle: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),

                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),

                                items: provider.frequencyFilterOptions
                                    .map(
                                      (value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                    .toList(),

                                onChanged: provider.updateFrequencyFilter,
                              ),
                            ),
                          ),

                          const SizedBox(width: 6),

                          // =====================================================
                          // UNIT FILTER
                          // =====================================================
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: DropdownButtonFormField<String>(
                                value: provider.selectedUnitFilter,
                                isExpanded: true,
                                isDense: true,

                                decoration: InputDecoration(
                                  labelText: "Unit",
                                  labelStyle: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),

                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),

                                items: provider.unitFilterOptions
                                    .map(
                                      (unit) => DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(
                                      unit,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                    .toList(),

                                onChanged: provider.updateUnitFilter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

// =========================================================
// COUNT + CLEAR
// =========================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "${provider.filteredPendingList.length} Records",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const Spacer(),

                          if (provider.selectedFrequencyFilter != "All" ||
                              provider.selectedUnitFilter != "All")
                            InkWell(
                              onTap: () {
                                provider.updateFrequencyFilter("All");
                                provider.updateUnitFilter("All");
                              },
                              child: const Text(
                                "Clear Filters",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 2),

                    // =========================================================
                    // LIST
                    // =========================================================
                    Expanded(
                      child: provider.filteredPendingList.isEmpty
                          ? _buildEmptyPendingState(provider)
                          : _buildListView(
                        context,
                        provider,
                        provider.filteredPendingList,
                        "pending",
                      ),
                    ),
                  ],
                );
              },
            ),

            /// ENTRY TAB
            Consumer<Preventing_List_Provider>(
              builder: (context, provider, _) {

                if (_tabController.index != 1) {
                  return const SizedBox();
                }

                return Column(
                  children: [
                    _buildSearchBox(
                      provider.entrySearchController,
                      "Search Entry...",
                      provider.updateEntrySearch,
                    ),
                    Expanded(
                      child: provider.isLoading == true
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
                        "entry",
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),


        /// 🔹 FAB visible only on Entry tab
        // floatingActionButton: AnimatedBuilder(
        //   animation: _tabController.animation!,
        //   builder: (context, child) {
        //     return _tabController.index == 1
        //         ? Consumer<Preventing_List_Provider>(
        //       builder: (context, provider, child) {
        //         return FloatingActionButton(
        //           onPressed: () async {
        //             await provider.generateUrnNo(context);
        //             if(provider.generatedUrn!= null){
        //               // await Navigator.push(
        //               //   context,
        //               //   MaterialPageRoute(
        //               //     builder: (context) => Recovery_Form_Screen(
        //               //       URN_No: provider.generatedUrn,
        //               //       DocNo: provider.generatedDoc_No,
        //               //       Category: provider.generatedCategory,
        //               //       Status: "Draft",
        //               //       Mode: "Add",
        //               //     ),
        //               //   ),
        //               // );
        //               provider.isInitialized = false;
        //             }
        //
        //
        //           },
        //           backgroundColor: Colors.transparent,
        //           elevation: 0,
        //           child: Container(
        //             height: 60.0,
        //             width: 60.0,
        //             decoration: const BoxDecoration(
        //               shape: BoxShape.circle,
        //               gradient: kMainGradient,
        //             ),
        //             child: const Icon(
        //               Icons.add,
        //               color: Colors.white,
        //               size: 28,
        //             ),
        //           ),
        //         );
        //       },
        //     )
        //         : const SizedBox.shrink();
        //   },
        // ),
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
      BuildContext context, Preventing_List_Provider provider, List<dynamic> list,String type) {
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
              // enabled: provider.Operator_Role != "Admin",
              closeOnScroll: true,
              startActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.4,
                children: [
                  SlidableAction(
                    onPressed: (_) async {
                      BuildContext currentContext = context; // capture the parent context
                      if (type == "pending") {
                        await provider.generateUrnNo(context);
                        await provider.Insert_Pending_TO_New(item["URN_No"],item["Item_Sr_No"],);

                        // Use currentContext (not context from builder)
                        if (!currentContext.mounted) return;

                        if(provider.generatedUrn!= null){
                          Navigator.push(
                            currentContext,
                            MaterialPageRoute(
                              builder: (_) => Preventing_Form_Screen(
                                URN_No: provider.generatedUrn.toString(),
                                DocNo: provider.generatedDoc_No.toString(),
                                Category: provider.generatedCategory.toString(),
                                Status: "Draft",
                                Mode: "Edit",
                              ),
                            ),
                          ).then((value) => provider.isInitialized = false);
                        }

                      } else {
                        Navigator.push(
                          currentContext,
                          MaterialPageRoute(
                            builder: (_) => Preventing_Form_Screen(
                              URN_No: item["URN_No"],
                              DocNo: item["Doc_No"],
                              Category: item["Category_Name"],
                              Status: item["Status"],
                              Mode: "Edit",
                            ),
                          ),
                        );
                      }


                    },
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  )

                ],
              ),
              // endActionPane: ActionPane(
              //   motion: const DrawerMotion(),
              //   extentRatio: 0.4,
              //   children: [
              //     // SlidableAction(
              //     //   onPressed: (context) {
              //     //     ScaffoldMessenger.of(context).showSnackBar(
              //     //       SnackBar(content: Text("Deleted ${item["URN_No"]}")),
              //     //     );
              //     //   },
              //     //   backgroundColor: Colors.redAccent,
              //     //   foregroundColor: Colors.white,
              //     //   icon: Icons.delete,
              //     //   label: 'Delete',
              //     // ),
              //   ],
              // ),
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
                          item["URN_No"],
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
                    // InfoPair(label: "URN No", value: item["URN_No"]),
                    InfoPair(label: "Machine Name", value: item["MAchine_Name"]),
                    Visibility(
                        visible: type=="entry",
                        child: InfoPair(label: "Doc No", value: type=="entry"?item["Doc_No"].toString():"")),

                    Visibility(
                        visible: type=="entry",
                        child: InfoPair(label: "Category Name", value: type=="entry"?item["Category_Name"].toString():"")),

                    if (type == "pending")
                      InfoPair(
                        label: "Maintenance Date",
                        value: item["Maintenance Date"],
                      ),
                    Visibility(
                        visible: type=="pending",
                        child: InfoPair(label: "Frequecy In Days", value: type=="pending"?item["Frequecy In Days"].toString():"")),
                    Visibility(
                        visible: type=="pending",
                        child: InfoPair(label: "Check List", value: type=="pending"?item["Check List"]:"")),
                    // Visibility(
                    //     visible: type=="pending",
                    //     child: InfoPair(label: "Break Down Detail", value: type=="pending"?item["Breck_Down_Detail"]:"")),
                    //
                    // Visibility(
                    //     visible: type=="pending",
                    //     child: InfoPair(label: "Sub_Head", value: type=="pending"?item["Sub_Head"]:"")),
                    // Visibility(
                    //     visible: type=="pending",
                    //     child: InfoPair(label: "Remarks", value: type=="pending"?item["Remarks"]:"")),
                    //

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyPendingState(
      Preventing_List_Provider provider,
      ) {
    final bool hasFilter =
        provider.selectedFrequencyFilter != "All" ||
            provider.selectedUnitFilter != "All" ||
            provider.pendingSearch.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasFilter
                  ? Icons.filter_alt_off_outlined
                  : Icons.inbox_outlined,
              size: 55,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 12),

            Text(
              hasFilter
                  ? "No records match your filters"
                  : "No Pending Recovery Found",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),

            if (hasFilter) ...[
              const SizedBox(height: 12),

              TextButton.icon(
                onPressed: () {
                  provider.pendingSearchController.clear();
                  provider.updatePendingSearch("");
                  provider.updateFrequencyFilter("All");
                  provider.updateUnitFilter("All");
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 18,
                ),
                label: const Text("Clear Filters"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
