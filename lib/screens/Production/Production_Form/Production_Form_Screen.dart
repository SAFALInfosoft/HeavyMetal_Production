import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:heavy_metal/screens/Production/Production_Form/Model/Card_No_Get_Model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../GlobalComponents/BlinkingIndicator.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/customInputDecoration.dart';
import '../../Dashboard/Dashboard.dart';
import '../../Maintanance/BreakDown/BreakDown_Form.dart';
import '../../Transfer_Memo/Transfer_Memo_List/Transfer_Memo_List_Screen.dart';
import 'Model/Matchine_Name_Get_Model.dart';
import 'Model/Process_Get_Model.dart';
import 'Provider/Production_Form_Provider.dart';

class Production_Form_Screen extends StatelessWidget {
  const Production_Form_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductionFormProvider = context.watch<Production_Form_Provider>();
    ProductionFormProvider.init();
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          final provider = Provider.of<Production_Form_Provider>(
            context,
            listen: false,
          );
          provider.clearMainForm();
        }
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              // Navigator.pushReplacementNamed(context, "/dashboard");
              // OR if you use MaterialPageRoute
              final provider =
                  Provider.of<Production_Form_Provider>(context, listen: false);

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashboardPage()));
              provider.clearMainForm();
            },
          ),
          title: Consumer<Production_Form_Provider>(
            builder: (BuildContext context, Production_Form_Provider provider,
                Widget? child) {
              return Padding(
                padding: EdgeInsets.only(
                  left: provider.width * 0.04,
                  right: provider.width * 0.04,
                ),
                child: Text(
                  "Production",
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
            Consumer<Production_Form_Provider>(
              builder: (BuildContext context, Production_Form_Provider provider,
                  Widget? child) {
                return Padding(
                  padding: EdgeInsets.only(right: provider.width * 0.04),
                  child: Row(
                    children: [
                      if (provider.isRunning) ...[
                        const BlinkingIndicator(color: Colors.green, size: 16),
                        const SizedBox(width: 6),
                        const Text(
                          "Running",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ] else ...[
                        const Icon(Icons.circle, color: Colors.grey, size: 16),
                        const SizedBox(width: 6),
                        const Text(
                          "Stopped",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFA07A),
                    Color(0xFFFF4C4C)
                  ], // orange → red
                  begin: Alignment.topCenter,
                  end: Alignment.topRight,
                ),
              ),
              child: Consumer<Production_Form_Provider>(
                builder: (BuildContext context,
                    Production_Form_Provider provider, Widget? child) {
                  return Container(
                    height: provider.height,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final selected = await showSearchableBottomSheet(
                              context: context,
                              items: provider.processCardItems,
                              label: (item) => item.Process_Doc_No ?? '',
                            );

                            if (selected != null) {
                              provider
                                  .setSelectedCard(selected.processCardUrnNo);
                              await provider.loadProcessList();
                              await provider.loadMachineList();
                              provider.notifyListeners();
                            }
                          },
                          child: InputDecorator(
                            decoration: customInputDecoration("Card No"),
                            child: Builder(
                              builder: (_) {
                                final selectedItem = provider.processCardItems
                                        .where((item) =>
                                            item.processCardUrnNo ==
                                            provider.selectedItemUrn)
                                        .isNotEmpty
                                    ? provider.processCardItems.firstWhere(
                                        (item) =>
                                            item.processCardUrnNo ==
                                            provider.selectedItemUrn)
                                    : null;

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedItem?.Process_Doc_No ??
                                            "Select Card",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: selectedItem == null
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final selected = await showSearchableBottomSheet(
                              context: context,
                              items: provider.ProcessItems,
                              label: (item) => item.processName,
                            );

                            if (selected != null) {
                              provider.selectedProcessUrn =
                                  selected.locationUrnNo;
                              provider.selectedProcessName =
                                  selected.processName;
                              provider.selectedvary = selected.vary;
                              provider.selectedSr_No = selected.Sr_No;
                              provider.QualityCheck = selected.QualityCheck;
                              provider.notifyListeners();
                            }
                          },
                          child: InputDecorator(
                            decoration: customInputDecoration("Process"),
                            child: Builder(
                              builder: (_) {
                                final selectedItem =
                                    provider.ProcessItems.where((item) =>
                                                item.locationUrnNo ==
                                                provider.selectedProcessUrn)
                                            .isNotEmpty
                                        ? provider.ProcessItems.firstWhere(
                                            (item) =>
                                                item.locationUrnNo ==
                                                provider.selectedProcessUrn)
                                        : null;

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedItem?.processName ??
                                            "Select Process",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: selectedItem == null
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Appbutton(
                                text: provider.isRunning ? "Stop" : "Start",
                                onPressed: () async {
                                  // ✅ Check if Card & Process are selected
                                  if (provider.selectedItemUrn == null ||
                                      provider.selectedItemUrn!.isEmpty ||
                                      provider.selectedProcessUrn == null ||
                                      provider.selectedProcessUrn!.isEmpty) {
                                    // Show a toast/snackbar and exit
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Please select both Card and Process first."),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    return; // stop execution here
                                  }

                                  // Show a bottom sheet with a simple ListView of machines
                                  // final selectedMachine =
                                  //     await showModalBottomSheet<MachineItem>(
                                  //   context: context,
                                  //   shape: const RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.vertical(
                                  //         top: Radius.circular(16)),
                                  //   ),
                                  //   builder: (ctx) {
                                  //     return Column(
                                  //       mainAxisSize: MainAxisSize.min,
                                  //       children: [
                                  //         const SizedBox(height: 12),
                                  //         const Text(
                                  //           "Select a Machine",
                                  //           style: TextStyle(
                                  //             fontSize: 18,
                                  //             fontWeight: FontWeight.bold,
                                  //           ),
                                  //         ),
                                  //         const Divider(),
                                  //         Flexible(
                                  //           child: ListView.separated(
                                  //             shrinkWrap: true,
                                  //             itemCount:
                                  //                 provider.MatchineItems.length,
                                  //             separatorBuilder: (_, __) =>
                                  //                 const Divider(height: 1),
                                  //             itemBuilder: (context, index) {
                                  //               final machine =
                                  //                   provider.MatchineItems[index];
                                  //               return ListTile(
                                  //                   leading: const Icon(Icons
                                  //                       .precision_manufacturing),
                                  //                   title: Text(
                                  //                       machine.machineName ?? ''),
                                  //                   subtitle: Text(
                                  //                       "URN: ${machine.machineUrnNo}"),
                                  //                   onTap: () async {
                                  //
                                  //                     if(provider.isRunning==false){
                                  //                       await provider
                                  //                           .generateUrnNo();
                                  //                     Navigator.pop(ctx, machine);
                                  //                       if(provider.generatedUrn != null &&provider.generatedUrn != ""){
                                  //                         provider.startMachine(
                                  //                             selectedMachine.machineUrnNo);
                                  //                       }else{
                                  //                         provider.setError("Some draft record(s) found, Please clear it before proceed.");
                                  //                       }
                                  //                     }else{
                                  //                       provider.stopMachine(
                                  //                           selectedMachine.machineUrnNo);
                                  //                       Navigator.push(
                                  //                         context,
                                  //                         MaterialPageRoute(
                                  //                           builder: (_) => Breakdown_Form_Screen(),
                                  //                         ),
                                  //                       );
                                  //                     }
                                  //
                                  //
                                  //                   });
                                  //             },
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     );
                                  //   },
                                  // );
                                  //
                                  // // If user made a selection
                                  // if (selectedMachine != null) {
                                  //   debugPrint(
                                  //     "Selected Machine → Name: ${selectedMachine.machineName}, "
                                  //     "URN: ${selectedMachine.machineUrnNo}",
                                  //   );
                                  //
                                  //   if (provider.isRunning) {
                                  //     provider.stopMachine(
                                  //         selectedMachine.machineUrnNo);
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (_) => Breakdown_Form_Screen(),
                                  //       ),
                                  //     );
                                  //   } else {
                                  //     if(provider.generatedUrn != null &&provider.generatedUrn != ""){
                                  //       provider.startMachine(
                                  //           selectedMachine.machineUrnNo);
                                  //     }else{
                                  //       provider.setError("Some draft record(s) found, Please clear it before proceed.");
                                  //     }
                                  //
                                  //
                                  //   }
                                  // }

                                  final selectedMachine =
                                      await showModalBottomSheet<MachineItem>(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (ctx) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 12),
                                          const Text(
                                            "Select a Machine",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Divider(),
                                          Flexible(
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount:
                                                  provider.MatchineItems.length,
                                              separatorBuilder: (_, __) =>
                                                  const Divider(height: 1),
                                              itemBuilder: (context, index) {
                                                final machine = provider
                                                    .MatchineItems[index];

                                                return ListTile(
                                                  leading: const Icon(Icons
                                                      .precision_manufacturing),
                                                  title: Text(
                                                      machine.machineName ??
                                                          ''),
                                                  subtitle: Text(
                                                      "URN: ${machine.machineUrnNo}"),
                                                  onTap: () async {
                                                    if (provider.isProcessing)
                                                      return;
                                                    provider.isProcessing =
                                                        true;
                                                    provider.notifyListeners();

                                                    try {
                                                      if (provider.isRunning ==
                                                          false) {
                                                        await provider
                                                            .generateUrnNo();

                                                        if (provider.generatedUrn !=
                                                                null &&
                                                            provider.generatedUrn !=
                                                                "") {
                                                          // if(provider.errorMessage!= null){
                                                          //   provider.clearError();
                                                          // }

                                                          provider.startMachine(
                                                              machine
                                                                  .machineUrnNo);

                                                          Navigator.pop(
                                                              ctx, machine);
                                                        } else {
                                                          provider.setError(
                                                            "Some draft record(s) found, Please clear it before proceed.",
                                                          );
                                                        }
                                                      } else {
                                                        provider.stopMachine(
                                                            machine
                                                                .machineUrnNo);

                                                        // Navigator.pop(ctx, machine);

                                                        provider
                                                            .clearMainForm();
                                                        provider
                                                            .generatebreakdownUrnNo(
                                                                context);

                                                        // Navigator.push(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //     builder: (_) =>
                                                        //         Breakdown_Form_Screen(),
                                                        //   ),
                                                        // );
                                                      }
                                                    } finally {
                                                      provider.isProcessing =
                                                          false;
                                                      provider
                                                          .notifyListeners();
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //
                        //       Expanded(
                        //         child: AppButton(
                        //           text: "ADD",
                        //           onPressed: () {
                        //             // Navigator.push(
                        //             //   context,
                        //             //   MaterialPageRoute(builder: (context) => DashboardPage()),
                        //             // );
                        //             // TODO: handle login
                        //           },
                        //         ),
                        //       ),
                        //       SizedBox(width: 10,),
                        // Expanded(
                        //   child: SizedBox(
                        //     width: double.infinity,
                        //     child: AppButton(
                        //       text: "Drop",
                        //       onPressed: () {
                        //
                        //       },
                        //     ),
                        //   ),
                        // ),
                        //
                        //     ],
                        //   ),

                        /// 🔹 Heading for Input Section
                        // const Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     "Input Fields",
                        //     style: TextStyle(
                        //       fontSize: 18,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 10),

                        const SizedBox(height: 8),

                        Consumer<Production_Form_Provider>(
                          builder: (context, provider, _) {
                            final card = provider.selectedCard;

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                    color: Colors.purple, width: 1.5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),

                                    /// W.O No
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "W.O No.:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          card?.Wo_No_Doc.toString() ?? '',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    /// Customer Name
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Customer Name :",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            card?.customerName ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign
                                                .right, // ✅ keeps text aligned to the right
                                            style: const TextStyle(
                                                color: Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    /// Process Name
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Process Name :",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          provider.selectedProcessName ??
                                              '', // example if you have it
                                          style: const TextStyle(
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    /// Size (dummy value if not available)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "FT Size :",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          card?.Size?.toString() ?? "",
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    /// Round Bar Qty
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Order Qty. :",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          card?.qty?.toStringAsFixed(2) ?? '0',
                                          style: const TextStyle(
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    /// Round Bar Qty
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Heat No :",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          card?.Heat_No?.toString() ?? '',
                                          style: const TextStyle(
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    /// Round Bar Qty
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Issue Piece :",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          card?.No_Of_Piece?.toString() ?? '0',
                                          style: const TextStyle(
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),

                        Column(
                          children: [
                            /// 🔹 Show Added Count
                            Text(
                              "Added Item: ${provider.addCount}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),

                            /// 🔹 ADD Button (AppButton)
                            if (provider.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  provider.errorMessage!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ),
                            // 🔹 ADD BUTTON
                            Row(
                              children: [
                                Expanded(
                                  child: Appbutton(
                                    text: "ADD",
                                    onPressed: provider.waitSeconds > 0
                                        ? null // disables when Add is counting down
                                        : () async {
                                            if (provider.generatedUrn == null ||
                                                provider.generatedUrn == "") {
                                              provider.setError(
                                                  "No URN is selected");
                                              return;
                                            } else {
                                              // if (provider.errorMessage == "") {
                                              //   provider.clearError();
                                              // }
                                              provider.startCountdown();
                                              Map<String, dynamic> fieldstring =
                                                  {"Mode": "Add"};
                                              String fieldstringJson =
                                                  jsonEncode(fieldstring);

                                              provider.Update_Data(
                                                  fieldstringJson, "Add");
                                            }
                                          },
                                    color: provider.waitSeconds > 0
                                        ? Colors.grey.shade300
                                        : const Color(0xFFFF5252),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                // Expanded(
                                //   child: Appbutton(
                                //     text: "Drop Add",
                                //     onPressed: () {
                                //       Map<String, dynamic> fieldstring = {
                                //         "Mode": "AddDrop"
                                //       };
                                //       String fieldstringJson =
                                //           jsonEncode(fieldstring);
                                //
                                //       provider.Update_Data(fieldstringJson, "AddDrop");
                                //     },
                                //
                                //     // provider.waitSeconds > 0
                                //     //     ? null // disables when Add is counting down
                                //     //     : () {
                                //     //   if (provider.generatedUrn == null ||provider.generatedUrn == "") {
                                //     //     provider.setError("No URN is selected");
                                //     //     return;
                                //     //   }else{
                                //     //
                                //     //   }
                                //     //
                                //     //
                                //     // },
                                //     color: const Color(0xFFFF5252),
                                //   ),
                                // ),
                              ],
                            ),
                            if (provider.waitSeconds > 0)
                              Text(
                                "Please wait ${provider.waitSeconds}s",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.redAccent,
                                ),
                              ),
                            const SizedBox(height: 6),

                            /// 🔹 Show Countdown Below Button

                            const SizedBox(height: 8),
                            // 🔹 DROP BUTTON
                            Appbutton(
                              text: "Drop",
                              onPressed: provider.waitSeconds_Drop > 0
                                  ? null // disables when Drop is counting down
                                  : () {
                                      TextEditingController reasonController =
                                          TextEditingController();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Enter Reason"),
                                            content: TextField(
                                              controller: reasonController,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    "Type your reason here",
                                                border: OutlineInputBorder(),
                                              ),
                                              maxLines: 3,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Cancel"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  String reason =
                                                      reasonController.text
                                                          .trim();
                                                  if (reason.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              "Please enter a reason")),
                                                    );
                                                    return;
                                                  }
                                                  Navigator.pop(context);
                                                  if (provider.generatedUrn ==
                                                      null) {
                                                    provider.setError(
                                                        "No URN is selected");
                                                    return;
                                                  }

                                                  if (provider.waitSeconds >
                                                      0) {
                                                    provider
                                                        .startCountdown_Drop();
                                                    Map<String, dynamic>
                                                        fieldstring = {
                                                      "Mode": "AddDrop"
                                                    };

                                                    String fieldstringJson =
                                                        jsonEncode(fieldstring);
                                                    provider.Update_Data(
                                                        fieldstringJson,
                                                        "AddDrop");
                                                  } else {
                                                    provider
                                                        .startCountdown_Drop();
                                                    Map<String, dynamic>
                                                        fieldstring = {
                                                      "Mode": "Drop"
                                                    };

                                                    String fieldstringJson =
                                                        jsonEncode(fieldstring);
                                                    provider.Update_Data(
                                                        fieldstringJson,
                                                        "Drop");
                                                  }
                                                  // Map<String, dynamic> fieldstring =
                                                  //     {"Mode": "AddDrop"};
                                                  // String fieldstringJson =
                                                  //     jsonEncode(fieldstring);
                                                  // provider.Update_Data(
                                                  //     fieldstringJson, "AddDrop");
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "Reason submitted: $reason")),
                                                  );
                                                },
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                              color: provider.waitSeconds_Drop > 0
                                  ? Colors.grey.shade300
                                  : const Color(0xFFFF5252),
                            ),

                            if (provider.waitSeconds_Drop > 0)
                              Text(
                                "Please wait ${provider.waitSeconds_Drop}s",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.redAccent,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )),
        ),
        floatingActionButton: Consumer<Production_Form_Provider>(
          builder: (BuildContext context, Production_Form_Provider provider,
              Widget? child) {
            return IgnorePointer(
              ignoring: provider.countdown > 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // bool shouldHighlight =
                    // provider.addCount % 10 == 0 && provider.addCount != 0;

                    Visibility(

                      visible:
                      provider.QualityCheck.isNotEmpty &&
                          provider.generatedUrn != null &&
                          provider.generatedUrn != "",

                      child: Expanded(

                        child: TweenAnimationBuilder<double>(

                          tween: Tween(

                            begin: 0,

                            end:
                            provider.isQualityHighlight
                                ? 1
                                : 0,
                          ),

                          duration:
                          const Duration(
                            milliseconds: 1200,
                          ),

                          curve: Curves.easeInOut,

                          builder: (
                              context,
                              value,
                              child,
                              ) {

                            /// 🔥 FLOATING + PULSE
                            final double scale =
                                1 + (0.08 * value);

                            final double rotate =
                                0.00;

                            final double moveY =
                                -10 * value;

                            final double glow =
                                15 * value;

                            return Transform.translate(

                              offset: Offset(
                                0,
                                moveY,
                              ),

                              child: Transform.rotate(

                                angle: rotate,

                                child: Transform.scale(

                                  scale: scale,

                                  child: AnimatedContainer(

                                    duration:
                                    const Duration(
                                      milliseconds: 500,
                                    ),

                                    curve:
                                    Curves.easeInOut,

                                    decoration: BoxDecoration(

                                      borderRadius:
                                      BorderRadius.circular(
                                        14,
                                      ),

                                      gradient:
                                      provider.isQualityHighlight

                                          ? LinearGradient(

                                        begin:
                                        Alignment.topLeft,

                                        end:
                                        Alignment.bottomRight,

                                        colors: [

                                          Colors.pink
                                              .shade400,
                                          Colors.pink
                                              .shade400,

                                          Colors.pink,
                                        ],
                                      )

                                          : null,

                                      boxShadow:
                                      provider.isQualityHighlight

                                          ? [

                                        BoxShadow(

                                          color:
                                          Colors.orange
                                              .withOpacity(
                                            0.5,
                                          ),

                                          blurRadius:
                                          glow,

                                          spreadRadius:
                                          4,

                                          offset:
                                          const Offset(
                                            0,
                                            10,
                                          ),
                                        ),

                                        BoxShadow(

                                          color:
                                          Colors.pink
                                              .withOpacity(
                                            0.3,
                                          ),

                                          blurRadius:
                                          glow + 10,

                                          spreadRadius:
                                          2,
                                        ),
                                      ]

                                          : [],
                                    ),

                                    child: child,
                                  ),
                                ),
                              ),
                            );
                          },

                          /// 🔥 LOOP ANIMATION
                          onEnd: () {

                            if (provider.isQualityHighlight) {

                              Future.delayed(

                                const Duration(
                                  milliseconds: 300,
                                ),

                                    () {

                                  provider.notifyListeners();
                                },
                              );
                            }
                          },

                          child: Appbutton(

                            text: "Quality Check",

                            onPressed: () async {

                              /// 🔥 LOAD DATA
                              await provider
                                  .loadQualityCheckData();

                              /// 🔥 OPEN BOTTOM SHEET
                              showModalBottomSheet(

                                context: context,

                                isScrollControlled: true,

                                backgroundColor:
                                Colors.transparent,

                                builder: (context) {

                                  return StatefulBuilder(

                                    builder: (
                                        context,
                                        setState,
                                        ) {

                                      Widget buildTable(
                                          int tableIndex,
                                          ) {

                                        List<String> rows = [

                                          "OD",
                                          "WT",
                                          "Lg",
                                          "SF"
                                        ];

                                        return Card(

                                          elevation: 4,

                                          margin:
                                          const EdgeInsets
                                              .symmetric(
                                            vertical: 10,
                                          ),

                                          shape:
                                          RoundedRectangleBorder(

                                            borderRadius:
                                            BorderRadius.circular(
                                              12,
                                            ),
                                          ),

                                          child: Padding(

                                            padding:
                                            const EdgeInsets.all(
                                              12,
                                            ),

                                            child: Table(

                                              border:
                                              TableBorder.all(

                                                color:
                                                Colors.grey
                                                    .shade400,

                                                width: 1,

                                                borderRadius:
                                                BorderRadius.circular(
                                                  8,
                                                ),
                                              ),

                                              columnWidths:
                                              const {

                                                0:
                                                FlexColumnWidth(
                                                  2.5,
                                                ),

                                                1:
                                                FlexColumnWidth(
                                                  3,
                                                ),

                                                2:
                                                FlexColumnWidth(
                                                  3,
                                                ),

                                                3:
                                                FlexColumnWidth(
                                                  3,
                                                ),

                                                4:
                                                FlexColumnWidth(
                                                  3,
                                                ),

                                                5:
                                                FlexColumnWidth(
                                                  3,
                                                ),
                                              },

                                              children: [

                                                TableRow(

                                                  decoration:
                                                  const BoxDecoration(

                                                    gradient:
                                                    LinearGradient(

                                                      colors: [

                                                        Color(
                                                          0xFFFF7E5F,
                                                        ),

                                                        Color(
                                                          0xFFFFA07A,
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  children: [

                                                    _headerCell(
                                                      " ",
                                                    ),

                                                    _headerCell(
                                                      "FE",
                                                    ),

                                                    _headerCell(
                                                      "CE",
                                                    ),

                                                    _headerCell(
                                                      "BE",
                                                    ),

                                                    _headerCell(
                                                      "Min",
                                                    ),

                                                    _headerCell(
                                                      "Max",
                                                    ),
                                                  ],
                                                ),

                                                ...List.generate(

                                                  rows.length,

                                                      (rowIndex) {

                                                    return TableRow(

                                                      children: [

                                                        Padding(

                                                          padding:
                                                          const EdgeInsets
                                                              .all(
                                                            8.0,
                                                          ),

                                                          child: Text(
                                                            rows[
                                                            rowIndex],
                                                          ),
                                                        ),

                                                        ...List.generate(

                                                          5,

                                                              (colIndex) {

                                                            return _buildCell(

                                                              provider
                                                                  .tableData[
                                                              tableIndex]
                                                              [rowIndex]
                                                              [colIndex],
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }

                                      return AnimatedPadding(

                                        duration:
                                        const Duration(
                                          milliseconds:
                                          200,
                                        ),

                                        padding:
                                        EdgeInsets.only(

                                          bottom:
                                          MediaQuery.of(
                                            context,
                                          )
                                              .viewInsets
                                              .bottom,
                                        ),

                                        child: Container(

                                          height:
                                          MediaQuery.of(
                                            context,
                                          )
                                              .size
                                              .height *
                                              0.65,

                                          decoration:
                                          const BoxDecoration(

                                            color:
                                            Colors.white,

                                            borderRadius:
                                            BorderRadius.vertical(

                                              top:
                                              Radius.circular(
                                                24,
                                              ),
                                            ),
                                          ),

                                          child: Padding(

                                            padding:
                                            const EdgeInsets.all(
                                              16.0,
                                            ),

                                            child: Column(

                                              children: [

                                                Row(

                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,

                                                  children:
                                                  const [

                                                    Text(

                                                      "Quality Check",

                                                      style:
                                                      TextStyle(

                                                        fontSize:
                                                        18,

                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const Divider(),

                                                Expanded(

                                                  child:
                                                  ListView.builder(

                                                    itemCount:
                                                    provider
                                                        .tableData
                                                        .length,

                                                    itemBuilder:
                                                        (
                                                        _,
                                                        index,
                                                        ) {

                                                      return buildTable(
                                                        index,
                                                      );
                                                    },
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 12,
                                                ),

                                                Row(

                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .end,

                                                  children: [

                                                    OutlinedButton(

                                                      onPressed: () {

                                                        provider
                                                            .tableData
                                                            .clear();

                                                        Navigator.pop(
                                                          context,
                                                        );
                                                      },

                                                      child:
                                                      const Text(
                                                        "Cancel",
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      width: 12,
                                                    ),

                                                    ElevatedButton.icon(

                                                      icon: const Icon(
                                                        Icons.save,
                                                      ),

                                                      label: const Text(
                                                        "Save",
                                                      ),

                                                      style:
                                                      ElevatedButton
                                                          .styleFrom(

                                                        backgroundColor:
                                                        Colors.deepOrange,
                                                      ),

                                                      onPressed: () {

                                                        List<String>
                                                        rows = [

                                                          "OD",
                                                          "WT",
                                                          "Lg",
                                                          "SF"
                                                        ];

                                                        List finalData =
                                                        [];

                                                        for (
                                                        int t = 0;
                                                        t <
                                                            provider
                                                                .tableData
                                                                .length;
                                                        t++
                                                        ) {

                                                          var table =
                                                          provider
                                                              .tableData[t];

                                                          for (
                                                          int i = 0;
                                                          i <
                                                              table
                                                                  .length;
                                                          i++
                                                          ) {

                                                            finalData
                                                                .add({

                                                              "type":
                                                              rows[
                                                              i],

                                                              "values": {

                                                                "FE":
                                                                table[i][0]
                                                                    .text,

                                                                "CE":
                                                                table[i][1]
                                                                    .text,

                                                                "BE":
                                                                table[i][2]
                                                                    .text,

                                                                "Min":
                                                                table[i][3]
                                                                    .text,

                                                                "Max":
                                                                table[i][4]
                                                                    .text,

                                                                "REF_SR":
                                                                t + 1,
                                                              }
                                                            });
                                                          }
                                                        }

                                                        String fieldstring =
                                                        jsonEncode(
                                                          finalData,
                                                        );

                                                        provider
                                                            .QualityCheckUpdate(
                                                          fieldstring,
                                                        );

                                                        provider
                                                            .tableData
                                                            .clear();

                                                        Navigator.pop(
                                                          context,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FloatingActionButton(
                      backgroundColor: Colors.redAccent,
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, // 📸 CAMERA
                          imageQuality: 70, // reduce size
                        );

                        if (image != null) {
                          File file = File(image.path);

                          // Convert to Base64
                          List<int> imageBytes = await file.readAsBytes();
                          String base64Image = base64Encode(imageBytes);

                          print("BASE64 IMAGE => $base64Image");

                          // 👉 store in provider / send API
                          // provider.base64Image = base64Image;
                        }
                      },
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    )
                  ],
                ),
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //
                //       Expanded(
                //         child: AppButton(
                //           text: "ADD",
                //           onPressed: () {
                //             // Navigator.push(
                //             //   context,
                //             //   MaterialPageRoute(builder: (context) => DashboardPage()),
                //             // );
                //             // TODO: handle login
                //           },
                //         ),
                //       ),
                //       SizedBox(width: 10,),
                // Expanded(
                //   child: SizedBox(
                //     width: double.infinity,
                //     child: AppButton(
                //       text: "Drop",
                //       onPressed: () {
                //         showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             TextEditingController reasonController = TextEditingController();
                //             return AlertDialog(
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(16),
                //               ),
                //               title: const Text("Enter Reason"),
                //               content: TextField(
                //                 controller: reasonController,
                //                 decoration: const InputDecoration(
                //                   hintText: "Type your reason here",
                //                   border: OutlineInputBorder(),
                //                 ),
                //                 maxLines: 3,
                //               ),
                //               actions: [
                //                 TextButton(
                //                   onPressed: () {
                //                     Navigator.pop(context); // close without saving
                //                   },
                //                   child: const Text("Cancel"),
                //                 ),
                //                 ElevatedButton(
                //                   onPressed: () {
                //                     String reason = reasonController.text.trim();
                //                     if (reason.isNotEmpty) {
                //                       Navigator.pop(context); // close dialog
                //                       ScaffoldMessenger.of(context).showSnackBar(
                //                         SnackBar(content: Text("Reason submitted: $reason")),
                //                       );
                //                       // TODO: handle your reason value (API, logic, etc.)
                //                     } else {
                //                       ScaffoldMessenger.of(context).showSnackBar(
                //                         const SnackBar(content: Text("Please enter a reason")),
                //                       );
                //                     }
                //                   },
                //                   child: const Text("OK"),
                //                 ),
                //               ],
                //             );
                //           },
                //         );
                //       },
                //     ),
                //   ),
                // ),
                // // FloatingActionButton(
                //       //   onPressed: () {
                //       //     showModalBottomSheet(
                //       //       context: context,
                //       //       isScrollControlled: true,
                //       //       shape: const RoundedRectangleBorder(
                //       //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                //       //       ),
                //       //       backgroundColor: Colors.transparent,
                //       //       builder: (context) {
                //       //         return Container(
                //       //           padding: EdgeInsets.only(
                //       //             left: 16,
                //       //             right: 16,
                //       //             top: 20,
                //       //             bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                //       //           ),
                //       //           decoration: const BoxDecoration(
                //       //             gradient: LinearGradient(
                //       //               colors: [Color(0xFFFFA07A), Color(0xFFFF4C4C)],
                //       //               begin: Alignment.topLeft,
                //       //               end: Alignment.bottomRight,
                //       //             ),
                //       //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                //       //           ),
                //       //           child: SingleChildScrollView(
                //       //             child: Column(
                //       //               mainAxisSize: MainAxisSize.min,
                //       //               children: [
                //       //                 const Text(
                //       //                   "Enter Details",
                //       //                   style: TextStyle(
                //       //                     fontSize: 18,
                //       //                     fontWeight: FontWeight.bold,
                //       //                     color: Colors.white,
                //       //                   ),
                //       //                 ),
                //       //                 const SizedBox(height: 16),
                //       //                 Row(
                //       //                   children: [
                //       //                     Expanded(
                //       //                       child: TextField(
                //       //                         controller: provider.weightController,
                //       //                         decoration: customInputDecoration("Weight"),
                //       //                         keyboardType: TextInputType.number,
                //       //                       ),
                //       //                     ),
                //       //                     const SizedBox(width: 8),
                //       //                     Expanded(
                //       //                       child: TextField(
                //       //                         controller: provider.ODMMController,
                //       //                         decoration: customInputDecoration("Length"),
                //       //                         keyboardType: TextInputType.number,
                //       //                       ),
                //       //                     ),
                //       //                   ],
                //       //                 ),
                //       //                 const SizedBox(height: 12),
                //       //                 Row(
                //       //                   children: [
                //       //                     Expanded(
                //       //                       child: TextField(
                //       //                         controller: provider.numberController,
                //       //                         decoration: customInputDecoration("Number"),
                //       //                         keyboardType: TextInputType.number,
                //       //                       ),
                //       //                     ),
                //       //                     const SizedBox(width: 8),
                //       //                     Expanded(
                //       //                       child: TextField(
                //       //                         controller: provider.extraController,
                //       //                         decoration: customInputDecoration("Extra"),
                //       //                       ),
                //       //                     ),
                //       //                   ],
                //       //                 ),
                //       //                 const SizedBox(height: 20),
                //       //                 Row(
                //       //                   mainAxisAlignment: MainAxisAlignment.end,
                //       //                   children: [
                //       //                     ElevatedButton(
                //       //                       style: ElevatedButton.styleFrom(
                //       //                         backgroundColor: Colors.white,
                //       //                         foregroundColor: const Color(0xFFFF4C4C),
                //       //                       ),
                //       //                       onPressed: () => Navigator.pop(context),
                //       //                       child: const Text("Cancel"),
                //       //                     ),
                //       //                     const SizedBox(width: 8),
                //       //                     ElevatedButton(
                //       //                       style: ElevatedButton.styleFrom(
                //       //                         backgroundColor: Colors.white,
                //       //                         foregroundColor: const Color(0xFFFF4C4C),
                //       //                       ),
                //       //                       onPressed: () {
                //       //                         provider.weight = provider.weightController.text;
                //       //                         provider.length = provider.ODMMController.text;
                //       //                         provider.number = provider.numberController.text;
                //       //                         provider.extra  = provider.extraController.text;
                //       //
                //       //                         provider.startCountdown(30);
                //       //                         Navigator.pop(context);
                //       //                       },
                //       //                       child: const Text("Save"),
                //       //                     ),
                //       //                   ],
                //       //                 ),
                //       //               ],
                //       //             ),
                //       //           ),
                //       //         );
                //       //       },
                //       //     );
                //       //   },
                //       //   backgroundColor: Colors.transparent,
                //       //   elevation: 0,
                //       //   child: Container(
                //       //     width: provider.width * 0.2,
                //       //     height: provider.height * 0.2,
                //       //     decoration: const BoxDecoration(
                //       //       shape: BoxShape.circle,
                //       //       gradient: LinearGradient(
                //       //         colors: [Color(0xFFFFA07A), Color(0xFFFF4C4C)],
                //       //         begin: Alignment.topCenter,
                //       //         end: Alignment.bottomCenter,
                //       //       ),
                //       //     ),
                //       //     child: Icon(
                //       //       Icons.add,
                //       //       color: provider.countdown > 0 ? Colors.grey.shade300 : Colors.white, // visual feedback
                //       //       size: 40,
                //       //     ),
                //       //   ),
                //       // ),
                //       // SizedBox(width: MediaQuery.of(context).size.width*0.09,),
                //       // FloatingActionButton(
                //       //   onPressed: () {
                //       //
                //       //   },
                //       //   backgroundColor: Colors.transparent,
                //       //   elevation: 0,
                //       //   child: Container(
                //       //     width: provider.width * 0.2,
                //       //     height: provider.height * 0.2,
                //       //     decoration: const BoxDecoration(
                //       //       shape: BoxShape.circle,
                //       //       gradient: LinearGradient(
                //       //         colors: [Color(0xFFFFA07A), Color(0xFFFF4C4C)],
                //       //         begin: Alignment.topCenter,
                //       //         end: Alignment.bottomCenter,
                //       //       ),
                //       //     ),
                //       //     child: Center(
                //       //       child: Icon(
                //       //         Icons.remove,
                //       //         color: provider.countdown > 0 ? Colors.grey.shade300 : Colors.white, // visual feedback
                //       //         size: 40,
                //       //       ),
                //       //     ),
                //       //   ),
                //       // ),
                //     ],
                //   ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCell(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        height: 40, // 👈 overall box height
        child: TextFormField(
          controller: controller,
          expands: true, // 👈 IMPORTANT (fills full height)
          maxLines: null, // 👈 REQUIRED with expands
          minLines: null,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 8), // 👈 only horizontal
            isDense: true,
          ),
        ),
      ),
    );
  }

  Future<T?> showSearchableBottomSheet<T>({
    required BuildContext context,
    required List<T> items,
    required String Function(T) label,
  }) {
    TextEditingController searchController = TextEditingController();
    List<T> filteredItems = List.from(items);

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true, // keep this true
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final halfHeight = MediaQuery.of(context).size.height * 0.7;

        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: halfHeight, // ✅ LIMIT HEIGHT TO HALF
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  /// 🔘 Drag Handle (nice UX)
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔍 Search
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredItems = items
                              .where((item) => label(item)
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),

                  /// 📋 List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          title: Text(label(item)),
                          onTap: () => Navigator.pop(context, item),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
