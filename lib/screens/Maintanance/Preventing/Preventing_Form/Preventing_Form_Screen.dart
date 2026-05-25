import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/app_button.dart';
import '../../../../widgets/bottomsheetSelection.dart';
import '../../../../widgets/customInputDecoration.dart';
import '../Preventing_Listing/Preventing_List.dart';
import 'Provider/Preventing_Form_Provider.dart';




class Preventing_Form_Screen extends StatelessWidget {
  final URN_No;
  final String? DocNo; // ✅ define field
  final String? Category; // ✅ define field
  final String? Status; // ✅ define field
  final String? Mode;
  const Preventing_Form_Screen({Key? key, this.URN_No,this.DocNo,this.Category,this.Status,this.Mode,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(URN_No);
    final Recovery_FormProvider =
    context.watch<Preventing_Form_Provider>();
    if (Recovery_FormProvider.isInitialized == false) {
      Recovery_FormProvider.init(URN_No,Mode,DocNo,Category);

      Recovery_FormProvider.isInitialized = true;

    }
    return WillPopScope(
      onWillPop: () async {
        final provider =
        Provider.of<Preventing_Form_Provider>(context, listen: false);

        /// Clear data
        provider.isInitialized = false;
        provider.clearMainForm();
        provider.clearProductForm();

        /// Navigate
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Preventing_List()),
        );

        return false; // ✅ VERY IMPORTANT
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
              onPressed: () {
                final provider = Provider.of<Preventing_Form_Provider>(context, listen: false);

                // ✅ First stop the provider logic
                provider.isInitialized = false;
                provider.clearMainForm();
                provider.clearProductForm();
                // provider.notifyListeners();

                if (!context.mounted) return; // ✅ ensures widget not disposed

                // ✅ Then navigate — after cleanup
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Preventing_List()),
                );
              }
          ),
          title: Consumer<Preventing_Form_Provider>(
            builder: (BuildContext context, Preventing_Form_Provider provider,
                Widget? child) {
              return Padding(
                padding: EdgeInsets.only(
                  left: provider.width * 0.04,
                  right: provider.width * 0.04,
                ),
                child: Text(
                  "Preventing",
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
            child: Consumer<Preventing_Form_Provider>(
              builder: (BuildContext context, Preventing_Form_Provider provider,
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        /// 🔹 Heading for Input Section

                        /// 🔹 Top Part (Input Fields)
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Consumer<Preventing_Form_Provider>(
                                builder: (context, provider, _) {
                                  // final card = provider.selectedCard;

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
                                                "URN:",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                URN_No.toString(),
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
                                                "Status :",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                Status ?? '',
                                                style: const TextStyle(
                                                    color: Colors.black87),
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
                                                "Doc No :",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                provider.Doc_No ??
                                                    '', // example if you have it
                                                style: const TextStyle(
                                                    color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                          // const SizedBox(height: 8),
                                          //
                                          // /// Process Name
                                          // Row(
                                          //   mainAxisAlignment:
                                          //   MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     const Text(
                                          //       "Difference :",
                                          //       style: TextStyle(
                                          //         fontWeight: FontWeight.bold,
                                          //         color: Colors.black54,
                                          //       ),
                                          //     ),
                                          //     Text(
                                          //       provider.Difference ??
                                          //           '', // example if you have it
                                          //       style: const TextStyle(
                                          //           color: Colors.black87),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 12,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Preventing Details",
                                    style: TextStyle(
                                      fontSize: provider.height * 0.022,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      provider.isTransferMemoExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                    onPressed: () {
                                      provider.toggleTransferMemoExpansion();
                                    },
                                  ),
                                ],
                              ),
                              if (provider.isTransferMemoExpanded) ...[
                                GestureDetector(
                                  onTap: () async {
                                    final provider =
                                    Provider.of<Preventing_Form_Provider>(context,
                                        listen: false);

                                    if (provider.categoryName_List.isEmpty) {
                                      provider.isLoading = true;
                                      provider.notifyListeners();

                                      await provider.fetchCategoryListFromAPI(
                                          URN_No.toString(),"");

                                      provider.isLoading = false;
                                      provider.notifyListeners();
                                    }

                                    if (provider.categoryName_List.isNotEmpty) {
                                      showCategoryBottomSheet(
                                          context,
                                          provider.categoryName_List,
                                          "Category",
                                          URN_No.toString(),"Machine Maintenance");
                                    }
                                  },
                                  child: AbsorbPointer(
                                    absorbing: true, // prevent manual typing
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration:
                                      customInputDecoration("Category").copyWith(
                                        suffixIcon: const Icon(Icons.arrow_drop_down),
                                      ),
                                      controller: TextEditingController(
                                          text: Provider.of<Preventing_Form_Provider>(
                                              context)
                                              .selectedCategory ??
                                              ""),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                TextFormField(
                                  controller: provider.dateController,
                                  readOnly: true,
                                  decoration: customInputDecoration("Doc Date"),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      String formattedDate =
                                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                      provider.dateController.text = formattedDate;
                                      provider.notifyListeners();
                                    }
                                  },
                                ),

                                // const SizedBox(height: 8),
                                //
                                // Row(
                                //   children: [
                                //     /// Batch No (Text Input)
                                //     // Expanded(
                                //     //   child: TextField(
                                //     //     controller: provider.batch_no_Controller,
                                //     //     decoration: customInputDecoration("Batch No"),
                                //     //     keyboardType: TextInputType.number,
                                //     //   ),
                                //     // ),
                                //     // const SizedBox(width: 5),
                                //
                                //     /// Grade (Dropdown)
                                //     Expanded(
                                //       child: DropdownButtonFormField<String>(
                                //         value: provider.selectedGrade,
                                //         decoration: customInputDecoration("Grade"),
                                //         items: provider.gradeList.map((grade) {
                                //           return DropdownMenuItem(
                                //             value: grade,
                                //             child: Text(grade),
                                //           );
                                //         }).toList(),
                                //         onChanged: (value) {
                                //           provider.selectedGrade = value!;
                                //           provider.notifyListeners();
                                //         },
                                //       ),
                                //     ),
                                //     const SizedBox(width: 5),
                                //
                                //     /// Specification (Dropdown)
                                //     Expanded(
                                //       child: DropdownButtonFormField<String>(
                                //         value: provider.selectedSpec,
                                //         decoration: customInputDecoration("Specification"),
                                //         items: provider.specList.map((spec) {
                                //           return DropdownMenuItem(
                                //             value: spec,
                                //             child: Text(spec),
                                //           );
                                //         }).toList(),
                                //         onChanged: (value) {
                                //           provider.selectedSpec = value!;
                                //           provider.notifyListeners();
                                //         },
                                //       ),
                                //     ),
                                //   ],
                                // ),

                                const SizedBox(height: 8),

                                GestureDetector(
                                  onTap: () async {
                                    final provider =
                                    Provider.of<Preventing_Form_Provider>(context,
                                        listen: false);

                                    // if (provider.Machine_Name_List.isEmpty) {
                                    provider.isLoading = true;
                                    provider.notifyListeners();

                                    await provider.fetchMachine_NameListFromAPI(
                                        URN_No.toString());

                                    provider.isLoading = false;
                                    provider.notifyListeners();
                                    // }

                                    if (provider.Machine_Name_List.isNotEmpty) {
                                      showCategoryBottomSheet(
                                          context,
                                          provider.Machine_Name_List,
                                          "Machine Name",
                                          URN_No.toString(),"Machine Maintenance");
                                    }
                                  },
                                  child: AbsorbPointer(
                                    absorbing: true, // prevent manual typing
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration:
                                      customInputDecoration("Machine Name").copyWith(
                                        suffixIcon: const Icon(Icons.arrow_drop_down),
                                      ),
                                      controller: TextEditingController(
                                          text: Provider.of<Preventing_Form_Provider>(
                                              context)
                                              .selectedMachine ??
                                              ""),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                GestureDetector(
                                  onTap: () async {
                                    final provider =
                                    Provider.of<Preventing_Form_Provider>(context,
                                        listen: false);

                                    // if (provider.Department_List.isEmpty) {
                                    provider.isLoading = true;
                                    provider.notifyListeners();

                                    await provider.fetchDepartmentListFromAPI(
                                        URN_No.toString());

                                    provider.isLoading = false;
                                    provider.notifyListeners();
                                    // }

                                    if (provider.Department_List.isNotEmpty) {
                                      showCategoryBottomSheet(
                                          context,
                                          provider.Department_List,
                                          "Department",
                                          URN_No.toString(),"Machine Maintenance");
                                    }
                                  },
                                  child: AbsorbPointer(
                                    absorbing: true, // prevent manual typing
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration:
                                      customInputDecoration("Department").copyWith(
                                        suffixIcon: const Icon(Icons.arrow_drop_down),
                                      ),
                                      controller: TextEditingController(
                                          text: Provider.of<Preventing_Form_Provider>(
                                              context)
                                              .selectedDepartment ??
                                              ""),
                                    ),
                                  ),
                                ),


                              ],

                              Divider(),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Products",
                                    style: TextStyle(
                                      fontSize: provider.height * 0.024,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  provider.productList.isEmpty
                                      ? Container(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                      Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: const Text(
                                      "No products added yet",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                  )
                                      : ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: provider.productList.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                                    itemBuilder: (context, index) {
                                      final product = provider.productList[index];

                                      return Slidable(
                                        startActionPane: ActionPane(
                                            motion: const DrawerMotion(),
                                            extentRatio: 0.4, // how wide the slide actions appear
                                            children: [
                                              SlidableAction(
                                                onPressed: (_) async {
                                                  await provider.Get_Recovery_List(URN_No.toString(), product["Sr_no"]);
                                                  // Use the context from your widget tree, not the SlidableAction callback
                                                  showProductForm(
                                                    context, // <-- main page context
                                                    provider,
                                                    URN_No.toString(),
                                                    product["Sr_no"],
                                                    index: index,
                                                  );
                                                },
                                                backgroundColor: Colors.blueAccent,
                                                foregroundColor: Colors.white,
                                                icon: Icons.edit,
                                                label: 'Edit',
                                              ),
                                            ]
                                        ),
                                        child: Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          color: Colors.white,
                                          shadowColor: Colors.grey.shade300,
                                          child: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // 🔹 Row 1 — Sr No + Item Name
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Sr No: ${product["Sr_no"] ?? '-'}",
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      product["checklist_name"] ?? "Unknown Item",
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Colors.blueAccent,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 8),
                                                const Divider(height: 8, color: Colors.grey),

                                                // 🔹 Row 2 — Item ID
                                                Row(
                                                  children: [
                                                    // const Icon(Icons.qr_code_2, color: Colors.grey, size: 18),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        "Frequency start Date: ${product["Frequency_start_Date"] ?? '-'}",
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                Row(
                                                  children: [
                                                    // const Icon(Icons.qr_code_2, color: Colors.grey, size: 18),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        "Frequency In Days: ${product["Frequency_In_Days"] ?? '-'}",
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 8),

                                                // 🔹 Row 3 — Quantity
                                                // Row(
                                                //   children: [
                                                //     // const Icon(Icons.inventory_2, color: Colors.green, size: 18),
                                                //     const SizedBox(width: 6),
                                                //     Text(
                                                //       "Quantity: ${product["Quantity"]?.toString() ?? '-'}",
                                                //       style: const TextStyle(
                                                //         fontSize: 13.5,
                                                //         color: Colors.black87,
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  // Appbutton(
                                  //   text: "Add Product",
                                  //   icon: Icons.add, // ✅ optional icon
                                  //   // color: Colors.blueAccent,
                                  //   onPressed: () {
                                  //     provider.clearProductForm();
                                  //
                                  //     showProductForm(context, provider, URN_No.toString(),"");
                                  //   },
                                  // )

                                ],
                              ),
                              Divider(),
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       "Item to be Used",
                              //       style: TextStyle(
                              //         fontSize: provider.height * 0.024,
                              //         fontWeight: FontWeight.w600,
                              //         color: Colors.blueGrey[800],
                              //       ),
                              //     ),
                              //     const SizedBox(height: 10),
                              //     provider.product_Item_List.isEmpty
                              //         ? Container(
                              //       padding:
                              //       const EdgeInsets.symmetric(vertical: 20),
                              //       alignment: Alignment.center,
                              //       decoration: BoxDecoration(
                              //         color: Colors.grey.shade100,
                              //         borderRadius: BorderRadius.circular(12),
                              //         border:
                              //         Border.all(color: Colors.grey.shade300),
                              //       ),
                              //       child: const Text(
                              //         "No data added yet",
                              //         style: TextStyle(
                              //             color: Colors.grey, fontSize: 15),
                              //       ),
                              //     )
                              //         : ListView.separated(
                              //       shrinkWrap: true,
                              //       physics: const NeverScrollableScrollPhysics(),
                              //       itemCount: provider.product_Item_List.length,
                              //       separatorBuilder: (_, __) => const SizedBox(height: 10),
                              //       itemBuilder: (context, index) {
                              //         final product = provider.product_Item_List[index];
                              //
                              //         return Slidable(
                              //           startActionPane: ActionPane(
                              //               motion: const DrawerMotion(),
                              //               extentRatio: 0.4, // how wide the slide actions appear
                              //               children: [
                              //                 SlidableAction(
                              //                   onPressed: (_) async {
                              //                     await provider.Get_Recovery_List(URN_No.toString(), product["SR_No"]);
                              //                     // Use the context from your widget tree, not the SlidableAction callback
                              //                     showItemtobeUsedForm(
                              //                       context, // <-- main page context
                              //                       provider,
                              //                       URN_No.toString(),
                              //                       product["SR_No"],
                              //                       index: index,
                              //                     );
                              //                   },
                              //                   backgroundColor: Colors.blueAccent,
                              //                   foregroundColor: Colors.white,
                              //                   icon: Icons.edit,
                              //                   label: 'Edit',
                              //                 ),
                              //               ]
                              //           ),
                              //           child: Card(
                              //             elevation: 3,
                              //             shape: RoundedRectangleBorder(
                              //               borderRadius: BorderRadius.circular(12),
                              //             ),
                              //             color: Colors.white,
                              //             shadowColor: Colors.grey.shade300,
                              //             child: Padding(
                              //               padding: const EdgeInsets.all(14.0),
                              //               child: Column(
                              //                 crossAxisAlignment: CrossAxisAlignment.start,
                              //                 children: [
                              //                   // 🔹 Row 1 — Sr No + Item Name
                              //                   Row(
                              //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                     children: [
                              //                       Text(
                              //                         "Sr No: ${product["SR_No"] ?? '-'}",
                              //                         style: const TextStyle(
                              //                           fontWeight: FontWeight.w600,
                              //                           fontSize: 14,
                              //                           color: Colors.black87,
                              //                         ),
                              //                       ),
                              //                       Text(
                              //                         product["Item_Name"] ?? "Unknown Item",
                              //                         style: const TextStyle(
                              //                           fontWeight: FontWeight.bold,
                              //                           fontSize: 15,
                              //                           color: Colors.blueAccent,
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   ),
                              //
                              //                   const SizedBox(height: 8),
                              //                   const Divider(height: 8, color: Colors.grey),
                              //
                              //                   // 🔹 Row 2 — Item ID
                              //                   Row(
                              //                     children: [
                              //                       // const Icon(Icons.qr_code_2, color: Colors.grey, size: 18),
                              //                       const SizedBox(width: 6),
                              //                       Expanded(
                              //                         child: Text(
                              //                           "Description: ${product["Description"] ?? '-'}",
                              //                           style: const TextStyle(
                              //                             fontSize: 13,
                              //                             color: Colors.black87,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   ),
                              //
                              //                   const SizedBox(height: 8),
                              //
                              //                   // 🔹 Row 3 — Quantity
                              //                   // Row(
                              //                   //   children: [
                              //                   //     // const Icon(Icons.inventory_2, color: Colors.green, size: 18),
                              //                   //     const SizedBox(width: 6),
                              //                   //     Text(
                              //                   //       "Quantity: ${product["Quantity"]?.toString() ?? '-'}",
                              //                   //       style: const TextStyle(
                              //                   //         fontSize: 13.5,
                              //                   //         color: Colors.black87,
                              //                   //       ),
                              //                   //     ),
                              //                   //   ],
                              //                   // ),
                              //                 ],
                              //               ),
                              //             ),
                              //           ),
                              //         );
                              //       },
                              //     ),
                              //     const SizedBox(height: 16),
                              //     Appbutton(
                              //       text: "Add Item to be Used",
                              //       icon: Icons.add, // ✅ optional icon
                              //       // color: Colors.blueAccent,
                              //       onPressed: () {
                              //         provider.clearProductForm();
                              //
                              //         showItemtobeUsedForm(context, provider, URN_No.toString(),"");
                              //       },
                              //     )
                              //
                              //   ],
                              // ),
                              // Divider(),
                              SizedBox(height: MediaQuery.of(context).size.height*0.03),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<Preventing_Form_Provider>(
            builder: (BuildContext context, Preventing_Form_Provider provider, Widget? child) {
              return Appbutton(
                text: "Submit",
                onPressed: () {
                  Map<String, dynamic> fieldString = {
                    "Doc_Date": provider.dateController.text,
                    "Machine_Name": provider.selectedMachine_ID,
                    "Department": provider.selectedDepartment_ID,
                    "Checklist_Name": "",
                    "Frequency_start_Date": "",
                    "Frequency_In_Days": "",
                    "Work_Start": "",
                    "Work_End": "",
                    "Next_Due_Date": "",
                  };

                  print("📦 Field String: $fieldString");
                  provider.submitForm(fieldString, URN_No.toString(), "Master", "");
                },
              );
            },
          ),
        ),
      ),
    );

  }

  void showProductForm(BuildContext context,
      Preventing_Form_Provider provider,String generatedUrn ,String SR_No ,{int? index}) {
    final isEdit = index != null;



    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isEdit ? "Edit Product" : "Add Product",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),

                const SizedBox(height: 12),

                // TextField(
                //   controller: itemNameController,
                //   decoration: const InputDecoration(labelText: "Item Name"),
                // ),
                // GestureDetector(
                //   onTap: () async {
                //     final provider =
                //     Provider.of<Preventing_Form_Provider>(context,
                //         listen: false);
                //
                //     // if (provider.Machine_Name_List_Product.isEmpty) {
                //     provider.isLoading = true;
                //     provider.notifyListeners();
                //
                //     await provider.fetchMachine_NameListFromAPI(
                //         URN_No.toString());
                //
                //     provider.isLoading = false;
                //     provider.notifyListeners();
                //     // }
                //
                //     if (provider.Machine_Name_List_Product.isNotEmpty) {
                //       showCategoryBottomSheet(
                //           context,
                //           provider.Machine_Name_List_Product,
                //           "Product Machine Name",
                //           URN_No.toString(),"Recovery");
                //     }
                //   },
                //   child: AbsorbPointer(
                //     absorbing: true,
                //     child: TextFormField(
                //       readOnly: true,
                //       decoration:
                //       customInputDecoration("Machine Name").copyWith(
                //         suffixIcon: const Icon(Icons.arrow_drop_down),
                //       ),
                //       controller: TextEditingController(
                //           text: Provider.of<Preventing_Form_Provider>(
                //               context)
                //               .selectedMachine_Product ??
                //               ""),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final provider =
                    Provider.of<Preventing_Form_Provider>(context,
                        listen: false);

                    // if (provider.Sub_Head_Name_List.isEmpty) {
                    provider.isLoading = true;
                    provider.notifyListeners();

                    await provider.fetchCheckListFromAPI(
                        URN_No.toString(),"");

                    provider.isLoading = false;
                    provider.notifyListeners();
                    // }

                    if (provider.Checklist_Name_List.isNotEmpty) {
                      showCategoryBottomSheet(
                          context,
                          provider.Checklist_Name_List,
                          "Checklist Name",
                          URN_No.toString(),"Machine Maintenance");
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true, // prevent manual typing
                    child: TextFormField(
                      readOnly: true,
                      decoration:
                      customInputDecoration("Checklist Name").copyWith(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      controller: TextEditingController(
                          text: Provider.of<Preventing_Form_Provider>(
                              context)
                              .selectedChecklist_Name ??
                              ""),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => provider.pickDate(
                    context,
                    provider.frequencyStartDateController,
                  ),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: provider.frequencyStartDateController,
                      decoration: customInputDecoration("Frequency Start Date")
                          .copyWith(
                        suffixIcon: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: provider.Frequency_In_DaysController,
                  keyboardType: TextInputType.number,
                  decoration: customInputDecoration("Frequency In Days"),
                ),
                const SizedBox(height: 8),

                GestureDetector(
                  onTap: () => provider.pickDateTime(
                    context,
                    provider.workStartController,
                  ),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: provider.workStartController,
                      decoration: customInputDecoration("Work Start")
                          .copyWith(
                        suffixIcon: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                GestureDetector(
                  onTap: () => provider.pickDateTime(
                    context,
                    provider.workDoneController,
                  ),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: provider.workDoneController,
                      decoration: customInputDecoration("Work Done")
                          .copyWith(
                        suffixIcon: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                GestureDetector(
                  onTap: () => provider.pickDate(
                    context,
                    provider.nextDueDateController,
                  ),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: provider.nextDueDateController,
                      decoration: customInputDecoration("Next Due Date")
                          .copyWith(
                        suffixIcon: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                ),



                const SizedBox(height: 20),

                Appbutton(
                    text: isEdit ? "Update" : "Save",
                    onPressed: () {
                      Map<String, dynamic> fieldString = {
                        "Doc_Date": provider.dateController.text,
                        "Machine_Name": provider.selectedMachine_ID,
                        "Department": provider.selectedDepartment_ID,
                        "Checklist_Name": provider.selectedChecklist_ID,
                        "Frequency_start_Date": provider.frequencyStartDateController.text,
                        "Frequency_In_Days":provider.Frequency_In_DaysController.text,
                        "Work_Start": provider.workStartController.text,
                        "Work_End": provider.workDoneController.text,
                        "Next_Due_Date": provider.nextDueDateController.text,

                      };

                      print("📦 Field String: $fieldString");
                      provider.submitForm(fieldString,URN_No.toString(),"Details",SR_No);
                    }),


                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

}
