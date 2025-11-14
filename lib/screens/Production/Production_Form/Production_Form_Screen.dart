import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
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
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFA07A), Color(0xFFFF4C4C)], // orange → red
              begin: Alignment.topCenter,
              end: Alignment.topRight,
            ),
          ),
          child: Consumer<Production_Form_Provider>(
            builder: (BuildContext context, Production_Form_Provider provider,
                Widget? child) {
              return Container(
                height: provider.height,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: provider.processCardItems.any((item) =>
                              item.processCardUrnNo == provider.selectedItemUrn)
                          ? provider.selectedItemUrn
                          : null, // Prevent invalid preselected value
                      decoration: customInputDecoration("Card No"),
                      isExpanded: true, // helps prevent overflow
                      items: provider.processCardItems.map((item) {
                        final label =
                            item.Process_Doc_No ?? ''; // safer null handling
                        return DropdownMenuItem<String>(
                          value: item.processCardUrnNo,
                          child: Text(label, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        if (value == null) return;
                        provider.setSelectedCard(value);
                        await provider.loadProcessList();
                        await provider.loadMachineList();
                        provider.notifyListeners();
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: provider.selectedProcessUrn,
                      decoration: customInputDecoration("Process"),
                      items: provider.ProcessItems.map<
                              DropdownMenuItem<String>>(
                          (ProcessItem item) => DropdownMenuItem<String>(
                                value: item.locationUrnNo,
                                child: Text(
                                    item.processName),
                              )).toList(),
                      onChanged: (String? value) {
                        if (value != null) {
                          final selected = provider.ProcessItems.firstWhere(
                              (item) => item.locationUrnNo == value);
                          provider.selectedProcessUrn = selected.locationUrnNo;
                          provider.selectedProcessName = selected.processName;
                          provider.selectedvary = selected.vary;
                          provider.selectedSr_No = selected.Sr_No;
                          provider.notifyListeners();
                        }
                      },
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
                                            final machine =
                                                provider.MatchineItems[index];
                                            return ListTile(
                                                leading: const Icon(Icons
                                                    .precision_manufacturing),
                                                title: Text(
                                                    machine.machineName ?? ''),
                                                subtitle: Text(
                                                    "URN: ${machine.machineUrnNo}"),
                                                onTap: () async {
                                                  await provider
                                                      .generateUrnNo();
                                                  Navigator.pop(ctx, machine);
                                                });
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              // If user made a selection
                              if (selectedMachine != null) {
                                debugPrint(
                                  "Selected Machine → Name: ${selectedMachine.machineName}, "
                                  "URN: ${selectedMachine.machineUrnNo}",
                                );

                                if (provider.isRunning) {
                                  provider.stopMachine(
                                      selectedMachine.machineUrnNo);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Breakdown_Form_Screen(),
                                    ),
                                  );
                                } else {
                                  provider.startMachine(
                                      selectedMachine.machineUrnNo);
                                }
                              }
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
                                  children:  [
                                    Text(
                                      "Size :",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      card?.Size?.toStringAsFixed(2) ?? '0',
                                      style: TextStyle(color: Colors.black87),
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
                                      "Round Bar Qty. :",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      card?.Round_Bar_Qty?.toStringAsFixed(2) ?? '0',
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
                        Appbutton(
                          text: "ADD",
                          onPressed: provider.waitSeconds > 0
                              ? null // disables when Add is counting down
                              : () {
                            if (provider.generatedUrn == null ||provider.generatedUrn == "") {
                              provider.setError("No URN is selected");
                              return;
                            }else{
                              Map<String, dynamic> fieldstring = {"Mode": "Add"};
                              String fieldstringJson = jsonEncode(fieldstring);

                              provider.Update_Data(fieldstringJson,"Add");
                            }


                          },
                          color: provider.waitSeconds > 0
                              ? Colors.grey.shade300
                              : const Color(0xFFFF5252),
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController reasonController = TextEditingController();
                                return AlertDialog(
                                  title: const Text("Enter Reason"),
                                  content: TextField(
                                    controller: reasonController,
                                    decoration: const InputDecoration(
                                      hintText: "Type your reason here",
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 3,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        String reason = reasonController.text.trim();
                                        if (reason.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Please enter a reason")),
                                          );
                                          return;
                                        }
                                        Navigator.pop(context);
                                        if (provider.generatedUrn == null) {
                                          provider.setError("No URN is selected");
                                          return;
                                        }
                                        Map<String, dynamic> fieldstring = {"Mode": "Drop"};
                                        String fieldstringJson = jsonEncode(fieldstring);
                                        provider.Update_Data(fieldstringJson,"Drop");


                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Reason submitted: $reason")),
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
      floatingActionButton: Consumer<Production_Form_Provider>(
        builder: (BuildContext context, Production_Form_Provider provider,
            Widget? child) {
          return IgnorePointer(
            ignoring:
                provider.countdown > 0, // disable tap when countdown running
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Appbutton(
                      text: "Quality Check",
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (BuildContext context) {
                            Widget buildTable() {
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Table(
                                    border: TableBorder.all(
                                      color: Colors.grey.shade400,
                                      width: 1,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    columnWidths: const {
                                      0: FlexColumnWidth(2),
                                      1: FlexColumnWidth(3),
                                      2: FlexColumnWidth(3),
                                      3: FlexColumnWidth(3),
                                      4: FlexColumnWidth(3),
                                      5: FlexColumnWidth(3),
                                    },
                                    children: [
                                      const TableRow(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFFFF7E5F), Color(0xFFFFA07A)],
                                          ),
                                        ),
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(" ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("FE",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("CE",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("BE",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Min",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Max",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                      TableRow(children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("OD"),
                                        ),
                                        _buildCell(),
                                        _buildCell(),
                                        _buildCell(),
                                        _buildCell(),
                                        _buildCell(),
                                      ]),
                                      TableRow(children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("WT"),
                                        ),
                                        _buildCell(),
                                        _buildCell(),
                                        _buildCell(),
                                        _buildCell(),
                                        _buildCell(),
                                      ]),
                                      TableRow(children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Lg"),
                                        ),
                                        _buildCell(),
                                        _buildCell(),
                                        _buildCell(),
                                        _buildCell(),
                                        _buildCell(),
                                      ]),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return StatefulBuilder(
                              builder: (context, setState) {
                                // ✅ Initialize with one table only ONCE
                                if (provider.tables.isEmpty) {
                                  provider.tables.add(buildTable());
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // header
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Quality Check",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle, color: Colors.green),
                                            onPressed: () {
                                              setState(() {
                                                provider.tables.add(buildTable());
                                              });
                                            },
                                          ),
                                        ],
                                      ),

                                      const Divider(thickness: 1),

                                      Flexible(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: provider.tables,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // footer buttons
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          OutlinedButton(
                                            onPressed: () {
                                              provider.tables.clear(); // clear on cancel
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          const SizedBox(width: 12),
                                          ElevatedButton.icon(
                                            icon: const Icon(Icons.save),
                                            label: const Text("Save"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.deepOrange,
                                            ),
                                            onPressed: () {
                                              // TODO: handle table data collection here
                                              provider.tables.clear(); // reset after saving
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton(
                    heroTag: "audioRecord",
                    backgroundColor: Colors.redAccent,
                    onPressed: () async {
                      // await provider.toggleAudioRecording();
                      // if (!provider.isRecording && provider.recordedFilePath != null) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text("Audio saved: ${provider.recordedFilePath}")),
                      //   );
                      // }
                    },
                    child: const Icon(Icons.mic, color: Colors.white),
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
    );
  }

  Widget _buildCell() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(6),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
