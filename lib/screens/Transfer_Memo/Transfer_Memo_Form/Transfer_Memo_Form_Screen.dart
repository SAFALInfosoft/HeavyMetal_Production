import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../widgets/bottomsheetSelection.dart';
import '../../../widgets/customInputDecoration.dart';
import '../../Dashboard/Dashboard.dart';
import '../Transfer_Memo_List/Transfer_Memo_List_Screen.dart';
import 'Model/ProductModel.dart';
import 'Provider/Transfer_Memo_Form_Provider.dart';
import '../../../widgets/app_button.dart';

class Transfer_Memo_Form_Screen extends StatelessWidget {
  final String? generatedUrn; // ✅ define field
  final String? DocNo; // ✅ define field
  final String? Category; // ✅ define field
  final String? Status; // ✅ define field
  final String? Mode; // ✅ define field

  const Transfer_Memo_Form_Screen({Key? key, this.generatedUrn,this.DocNo,this.Category,this.Status,this.Mode,})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    log(generatedUrn);
    final Transfer_Memo_FormProvider =
        context.watch<Transfer_Memo_Form_Provider>();
    if (Transfer_Memo_FormProvider.isInitialized == false) {
      Transfer_Memo_FormProvider.init(generatedUrn,Mode,DocNo,Category);
      Transfer_Memo_FormProvider.isInitialized = true;
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
            final provider = Provider.of<Transfer_Memo_Form_Provider>(context, listen: false);


            provider.clearMainForm();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Transfer_Memo_List()),
            );
            Transfer_Memo_FormProvider.isInitialized = false;
          },
        ),
        title: Consumer<Transfer_Memo_Form_Provider>(
          builder: (BuildContext context, Transfer_Memo_Form_Provider provider,
              Widget? child) {
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA07A), Color(0xFFFF4C4C)],
            begin: Alignment.topCenter,
            end: Alignment.topRight,
          ),
        ),
        child: Consumer<Transfer_Memo_Form_Provider>(
          builder: (BuildContext page_context, Transfer_Memo_Form_Provider provider,
              Widget? child) {
            return Container(
              height: provider.height,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Consumer<Transfer_Memo_Form_Provider>(
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
                                      generatedUrn.toString(),
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
                                      Status.toString(),
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    /// 🔹 First Form Section (Transfer Memo Details)
                    // Text("Transfer Memo Details",
                    //     style: TextStyle(
                    //         fontSize: provider.height * 0.022,
                    //         fontWeight: FontWeight.bold)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transfer Memo Details",
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
                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: () async {
                          final provider =
                          Provider.of<Transfer_Memo_Form_Provider>(page_context,
                              listen: false);

                          if (provider.categoryName_List.isEmpty) {
                            provider.isLoading = true;
                            provider.notifyListeners();

                            await provider.fetchCategoryListFromAPI(
                                generatedUrn.toString(),"");

                            provider.isLoading = false;
                            provider.notifyListeners();
                          }

                          if (provider.categoryName_List.isNotEmpty) {
                            showCategoryBottomSheet(
                                page_context,
                                provider.categoryName_List,
                                "Category",
                                generatedUrn.toString(),"Transfer Memo");
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
                                text: Provider.of<Transfer_Memo_Form_Provider>(
                                    page_context)
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
                            context: page_context,
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

                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final provider =
                          Provider.of<Transfer_Memo_Form_Provider>(page_context,
                              listen: false);

                          if (provider.WO_No_List.isEmpty) {
                            provider.isLoading = true;
                            provider.notifyListeners();

                            await provider
                                .fetchWO_NoListFromAPI(generatedUrn.toString());

                            provider.isLoading = false;
                            provider.notifyListeners();
                          }

                          if (provider.WO_No_List.isNotEmpty) {
                            showCategoryBottomSheet(page_context, provider.WO_No_List,
                                "WO No", generatedUrn.toString(),"");
                          }
                        },
                        child: AbsorbPointer(
                          absorbing: true, // prevent manual typing
                          child: TextFormField(
                            readOnly: true,
                            decoration: customInputDecoration("WO No").copyWith(
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                            ),
                            controller: TextEditingController(
                                text: Provider.of<Transfer_Memo_Form_Provider>(
                                    page_context)
                                    .selectedWO_No ??
                                    ""),
                          ),
                        ),
                      ),

                      // DropdownButtonFormField<String>(
                      //   value: provider.selectedWO_No,
                      //   decoration: customInputDecoration("WO No"),
                      //   items: provider.WO_No_List.map((item) {
                      //     return DropdownMenuItem(value: item, child: Text(item));
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     provider.selectedWO_No = value!;
                      //     provider.notifyListeners();
                      //   },
                      // ),

                      const SizedBox(height: 8),

                      // DropdownButtonFormField<String>(
                      //   value: provider.selectedFinishedTubeSize,
                      //   decoration: customInputDecoration("Finished Tube Size"),
                      //   items: provider.Finished_Tube_Size_List.map((item) {
                      //     return DropdownMenuItem(value: item, child: Text(item));
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     provider.selectedFinishedTubeSize = value!;
                      //     provider.notifyListeners();
                      //   },
                      // ),
                      TextFormField(
                        controller: provider.FinishedTubeSize_Controller,
                        decoration: customInputDecoration("Finished Tube Size"),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.newline,
                      ),

                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: () async {
                          final provider =
                          Provider.of<Transfer_Memo_Form_Provider>(page_context,
                              listen: false);

                          if (provider.Memo_Type_List.isEmpty) {
                            provider.isLoading = true;
                            provider.notifyListeners();

                            await provider.fetchMemoTypeListFromAPI(
                                generatedUrn.toString());

                            provider.isLoading = false;
                            provider.notifyListeners();
                          }

                          if (provider.Memo_Type_List.isNotEmpty) {
                            showCategoryBottomSheet(
                                page_context,
                                provider.Memo_Type_List,
                                "Memo Type",
                                generatedUrn.toString(),"");
                          }
                        },
                        child: AbsorbPointer(
                          absorbing: true, // prevent manual typing
                          child: TextFormField(
                            readOnly: true,
                            decoration:
                            customInputDecoration("Memo Type").copyWith(
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                            ),
                            controller: TextEditingController(
                                text: Provider.of<Transfer_Memo_Form_Provider>(
                                    page_context)
                                    .selectedMemoTyppe ??
                                    ""),
                          ),
                        ),
                      ),

                      // DropdownButtonFormField<String>(
                      //   value: provider.selectedMemoTyppe,
                      //   decoration: customInputDecoration("Memo Type"),
                      //   items: provider.Memo_Type_List.map((item) {
                      //     return DropdownMenuItem(value: item, child: Text(item));
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     provider.selectedMemoTyppe = value!;
                      //     provider.notifyListeners();
                      //   },
                      // ),

                      const SizedBox(height: 8),

                      Visibility(
                        visible: provider.selectedMemoTyppe != "External",
                        child: GestureDetector(
                          onTap: () async {
                            final provider =
                            Provider.of<Transfer_Memo_Form_Provider>(page_context,
                                listen: false);

                            if (provider.Department_List.isEmpty) {
                              provider.isLoading = true;
                              provider.notifyListeners();

                              await provider.fetchDepartmentListFromAPI(
                                  generatedUrn.toString(),"");

                              provider.isLoading = false;
                              provider.notifyListeners();
                            }

                            if (provider.Department_List.isNotEmpty) {
                              showCategoryBottomSheet(
                                  page_context,
                                  provider.Department_List,
                                  "Department",
                                  generatedUrn.toString(),"",);
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
                                  text: Provider.of<Transfer_Memo_Form_Provider>(
                                      page_context)
                                      .selectedDepartment ??
                                      ""),
                            ),
                          ),
                        ),
                      ),
                      // DropdownButtonFormField<String>(
                      //   value: provider.selectedDepartment,
                      //   decoration: customInputDecoration("Department"),
                      //   items: provider.Department_List.map((item) {
                      //     return DropdownMenuItem(value: item, child: Text(item));
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     provider.selectedDepartment = value!;
                      //     provider.notifyListeners();
                      //   },
                      // ),
                      const SizedBox(height: 8),
                      Visibility(
                        visible: provider.selectedMemoTyppe != "Internal",
                        child: GestureDetector(
                          onTap: () async {
                            final provider =
                            Provider.of<Transfer_Memo_Form_Provider>(page_context,
                                listen: false);

                            if (provider.Party_List.isEmpty) {
                              provider.isLoading = true;
                              provider.notifyListeners();

                              await provider
                                  .fetchPartyListFromAPI(generatedUrn.toString());

                              provider.isLoading = false;
                              provider.notifyListeners();
                            }

                            if (provider.Party_List.isNotEmpty) {
                              showCategoryBottomSheet(
                                  page_context,
                                  provider.Party_List,
                                  "Party Name",
                                  generatedUrn.toString(),"");
                            }
                          },
                          child: AbsorbPointer(
                            absorbing: true, // prevent manual typing
                            child: TextFormField(
                              readOnly: true,
                              decoration:
                              customInputDecoration("Party Name").copyWith(
                                suffixIcon: const Icon(Icons.arrow_drop_down),
                              ),
                              controller: TextEditingController(
                                  text: Provider.of<Transfer_Memo_Form_Provider>(
                                      page_context)
                                      .selectedPartyName ??
                                      ""),
                            ),
                          ),
                        ),
                      ),

                      // DropdownButtonFormField<String>(
                      //   value: provider.selectedPartyName,
                      //   decoration: customInputDecoration("Party Name"),
                      //   items: provider.Party_List.map((item) {
                      //     return DropdownMenuItem(value: item, child: Text(item));
                      //   }).toList(),
                      //   onChanged: (value) {
                      //     provider.selectedPartyName = value!;
                      //     provider.notifyListeners();
                      //   },
                      // ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: provider.Remarks_Controller,
                        decoration: customInputDecoration("Remarks"),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),

                      const SizedBox(height: 20),
                      // Appbutton(
                      //     text: "Submit",
                      //     onPressed: () {
                      //       Map<String, dynamic> fieldString = {
                      //         "Department": provider.selectedDepartment_ID?? "",
                      //         "Doc_Date": provider.dateController.text,
                      //         "Wo_No": provider.selectedWO_No_ID,
                      //         "Finished_Tubes_Size": provider.FinishedTubeSize_Controller.text,
                      //         "Memo_Type": provider.selectedMemoTyppe_ID ?? "",
                      //         "AC_CODE": provider.selectedPartyName_ID ?? "",
                      //         "Remarks": provider.Remarks_Controller.text,
                      //         "IT_CODE": "",
                      //         "Quantity": "",
                      //         "Grade": "",
                      //         "Specification": "",
                      //         "Heat_No": "",
                      //         "OD_MM": "",
                      //         "THK_MIN": "",
                      //         "THK_MAX": "",
                      //         "THK_MM": "",
                      //         "Length_MIN": "",
                      //         "Length_MAX": "",
                      //         "No_Of_Piece": "",
                      //         "UOM": "",
                      //         "Location": "",
                      //         "To_Location": "",
                      //         "Stock": "",
                      //         "G_Remarks": "",
                      //         "Rate": "",
                      //         "Piece_length": "",
                      //       };
                      //
                      //       print("📦 Field String: $fieldString");
                      //       provider.submitForm(fieldString,generatedUrn.toString(),"Master","");
                      //     }),
                    ],

                    Divider(),



                    /// 🔹 Second Form Section (Product Details)
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
                                        await provider.getTransferMemoList(generatedUrn.toString(), product["Sr_no"]);
                                        // Use the context from your widget tree, not the SlidableAction callback
                                        showProductForm(
                                          page_context, // <-- main page context
                                          provider,
                                          generatedUrn.toString(),
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
                                            product["Item_name"] ?? "Unknown Item",
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
                                              "Item ID: ${product["Item_ID"] ?? '-'}",
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
                                      Row(
                                        children: [
                                          // const Icon(Icons.inventory_2, color: Colors.green, size: 18),
                                          const SizedBox(width: 6),
                                          Text(
                                            "Quantity: ${product["Quantity"]?.toString() ?? '-'}",
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Appbutton(
                          text: "Add Product",
                          icon: Icons.add, // ✅ optional icon
                          // color: Colors.blueAccent,
                          onPressed: () {
                            provider.clearProductForm();

                            showProductForm(page_context, provider, generatedUrn.toString(),"");
                          },
                        )

                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height*0.03),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<Transfer_Memo_Form_Provider>(
          builder: (BuildContext context, Transfer_Memo_Form_Provider provider, Widget? child) {
            return Appbutton(
                text: "Submit",
                onPressed: () {
                  Map<String, dynamic> fieldString = {
                    "Department": provider.selectedDepartment_ID?? "",
                    "Doc_Date": provider.dateController.text,
                    "Wo_No": provider.selectedWO_No_ID,
                    "Finished_Tubes_Size": provider.FinishedTubeSize_Controller.text,
                    "Memo_Type": provider.selectedMemoTyppe_ID ?? "",
                    "AC_CODE": provider.selectedPartyName_ID ?? "",
                    "Remarks": provider.Remarks_Controller.text,
                    "IT_CODE": "",
                    "Quantity": "",
                    "Grade": "",
                    "Specification": "",
                    "Heat_No": "",
                    "OD_MM": "",
                    "THK_MIN": "",
                    "THK_MAX": "",
                    "THK_MM": "",
                    "Length_MIN": "",
                    "Length_MAX": "",
                    "No_Of_Piece": "",
                    "UOM": "",
                    "Location": "",
                    "To_Location": "",
                    "Stock": "",
                    "G_Remarks": "",
                    "Rate": "",
                    "Piece_length": "",
                  };

                  print("📦 Field String: $fieldString");
                  provider.submitForm(fieldString,generatedUrn.toString(),"Master","");
                });
          },
        ),
      ),
    );
  }

  void showProductForm(BuildContext context,
      Transfer_Memo_Form_Provider provider,String generatedUrn ,String SR_No ,{int? index}) {
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
                GestureDetector(
                  onTap: () async {
                    if (provider.itemName_List.isEmpty) {
                      provider.isLoading = true;
                      provider.notifyListeners();

                      await provider.fetchitemNameListFromAPI(generatedUrn.toString(),"");

                      provider.isLoading = false;
                      provider.notifyListeners();
                    }

                    if (provider.itemName_List.isNotEmpty) {
                      showCategoryBottomSheet(
                        context,
                        provider.itemName_List,
                        "Item Name",
                        generatedUrn.toString(),"Transfer Memo",
                      );
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true, // prevent manual typing
                    child: TextFormField(
                      readOnly: true,
                      decoration: customInputDecoration("Item Name").copyWith(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      controller: TextEditingController(
                          text: Provider.of<Transfer_Memo_Form_Provider>(
                              context)
                              .selecteditemName ??
                              ""),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                GestureDetector(
                  onTap: () async {
                    if (provider.Grade_List.isEmpty) {
                      provider.isLoading = true;
                      provider.notifyListeners();
                      await provider.fetchgradeListFromAPI(generatedUrn.toString());
                      provider.isLoading = false;
                      provider.notifyListeners();
                    }

                    if (provider.Grade_List.isNotEmpty) {
                      showCategoryBottomSheet(
                        context,
                        provider.Grade_List,
                        "Grade",
                        generatedUrn.toString(),"",
                      );
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true, // prevent manual typing
                    child: TextFormField(
                      readOnly: true,
                      decoration: customInputDecoration("Grade").copyWith(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      controller: TextEditingController(
                          text: Provider.of<Transfer_Memo_Form_Provider>(
                              context)
                              .selectedGrade ??
                              ""),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: provider.odMmController,
                  keyboardType: TextInputType.number,
                  decoration: customInputDecoration("OD MM"),
                  onChanged: (_) => provider.calculateWeight(),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.thkMinController,
                  keyboardType: TextInputType.number,
                  decoration: customInputDecoration("THK MIN"),
                  onChanged: (_) {
                    provider.updateFromMinMax();
                    provider.calculateWeight();
                  }, // 👈 auto-update on typing
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.thkMaxController,
                  keyboardType: TextInputType.number,
                  decoration: customInputDecoration("THK MAX"),
                  onChanged: (_) {
                    provider.updateFromMinMax();
                    provider.calculateWeight();
                  },

                  // 👈 auto-update on typing
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.thkMmController,
                  keyboardType: TextInputType.number,
                  decoration: customInputDecoration("THK MM"),
                  onChanged: (_) => provider.updateFromMm(), // 👈 auto-update on typing
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.lengthMinController,
                  keyboardType: TextInputType.number,
                  decoration: customInputDecoration("Length MIN"),
                  onChanged: (_) {
                    provider.updateFromlengthMin();
                    provider.calculateWeight();
                  },

                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.lengthMaxController,
                  keyboardType: TextInputType.number,
                  decoration: customInputDecoration("Length MAX"),
                  onChanged: (_) {
                    provider.updateFromLengthMAX();
                    provider.calculateWeight();
                  },

                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.Piece_lengthController,
                  keyboardType: TextInputType.number,
                  decoration: customInputDecoration("Piece length"),
                  onChanged: (_) => provider.updateFromPiecelength(),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.noOfPiecesController,
                  keyboardType: TextInputType.number,
                  decoration: customInputDecoration("No of Pieces"),
                  onChanged: (_) => provider.calculateWeight(),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.weightController,
                  keyboardType: TextInputType.number,
                  decoration: customInputDecoration("Weight"),
                ),
                const SizedBox(height: 8),

                GestureDetector(
                  onTap: () async {
                    // if (provider.UOM_List.isEmpty) {
                    //
                    // }
                    provider.isLoading = true;
                    provider.notifyListeners();
                    // if(provider.selecteditemName_ID!=""){
                    //   provider.selecteditemName_ID="";
                    // }

                    await provider.fetchItemUnitListFromAPI(generatedUrn.toString(),"");

                    provider.isLoading = false;
                    provider.notifyListeners();

                    if (provider.UOM_List.isNotEmpty) {
                      showCategoryBottomSheet(
                        context,
                        provider.UOM_List,
                        "UOM",
                        generatedUrn.toString(),"Transfer Memo",
                      );
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true, // prevent manual typing
                    child: TextFormField(
                      readOnly: true,
                      decoration: customInputDecoration("UOM").copyWith(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      controller: TextEditingController(
                          text: Provider.of<Transfer_Memo_Form_Provider>(
                              context)
                              .selectedUOM ??
                              ""),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    if (provider.Location_List.isEmpty) {
                      provider.isLoading = true;
                      provider.notifyListeners();

                      await provider.fetchLocationListFromAPI(generatedUrn.toString(),"");

                      provider.isLoading = false;
                      provider.notifyListeners();
                    }

                    if (provider.Location_List.isNotEmpty) {
                      showCategoryBottomSheet(
                        context,
                        provider.Location_List,
                        "Location",
                        generatedUrn.toString(),"",
                      );
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true, // prevent manual typing
                    child: TextFormField(
                      readOnly: true,
                      decoration: customInputDecoration("Location").copyWith(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      controller: TextEditingController(
                          text: Provider.of<Transfer_Memo_Form_Provider>(
                              context)
                              .selectedLocation ??
                              ""),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    if (provider.Location_List.isEmpty) {
                      provider.isLoading = true;
                      provider.notifyListeners();

                      await provider.fetchLocationListFromAPI(generatedUrn.toString(),"");

                      provider.isLoading = false;
                      provider.notifyListeners();
                    }

                    if (provider.Location_List.isNotEmpty) {
                      showCategoryBottomSheet(
                        context,
                        provider.Location_List,
                        "Next Location",
                        generatedUrn.toString(),"",
                      );
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true, // prevent manual typing
                    child: TextFormField(
                      readOnly: true,
                      decoration: customInputDecoration("Next Location").copyWith(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      controller: TextEditingController(
                          text: Provider.of<Transfer_Memo_Form_Provider>(
                              context)
                              .selectedNextLocation ??
                              ""),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    if (provider.Specification_List.isEmpty) {
                      provider.isLoading = true;
                      provider.notifyListeners();

                      await provider.fetchSpecificationListFromAPI(generatedUrn.toString());

                      provider.isLoading = false;
                      provider.notifyListeners();
                    }

                    if (provider.Specification_List.isNotEmpty) {
                      showCategoryBottomSheet(
                        context,
                        provider.Specification_List,
                        "Specification",
                        generatedUrn.toString(),"",
                      );
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true, // prevent manual typing
                    child: TextFormField(
                      readOnly: true,
                      decoration: customInputDecoration("Specification").copyWith(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      controller: TextEditingController(
                          text: Provider.of<Transfer_Memo_Form_Provider>(
                              context)
                              .selectedSpecification ??
                              ""),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    if (provider.Heat_No_List.isEmpty) {
                      provider.isLoading = true;
                      provider.notifyListeners();

                      await provider.fetchHeatNoListFromAPI(generatedUrn.toString());

                      provider.isLoading = false;
                      provider.notifyListeners();
                    }

                    if (provider.Heat_No_List.isNotEmpty) {
                      showCategoryBottomSheet(
                        context,
                        provider.Heat_No_List,
                        "Heat No",
                        generatedUrn.toString(),"",
                      );
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true, // prevent manual typing
                    child: TextFormField(
                      readOnly: true,
                      decoration: customInputDecoration("Heat No").copyWith(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      controller: TextEditingController(
                          text: Provider.of<Transfer_Memo_Form_Provider>(
                              context)
                              .selectedHeat_No ??
                              ""),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.G_RemarksController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: customInputDecoration("Remarks"),
                ),


                const SizedBox(height: 20),


                Appbutton(
                    text: isEdit ? "Update" : "Save",
                    onPressed: () {
                      Map<String, dynamic> fieldString = {
                        "Department": "",
                        // "date": provider.dateController.text,
                        "Wo_No": "",
                        "Finished_Tubes_Size": "",
                        "memo_type":  "",
                        "AC_CODE": "",
                        "remarks": "",
                        "IT_CODE": provider.selecteditemName_ID?? "",
                        "Quantity": provider.weightController.text,
                        "Grade": provider.selectedGrade_ID,
                        "Specification": provider.selectedSpecification_ID,
                        "Heat_No": provider.selectedHeat_No_ID,
                        "OD_MM": provider.odMmController.text,
                        "THK_MIN": provider.thkMinController.text,
                        "THK_MAX": provider.thkMaxController.text,
                        "THK_MM": provider.thkMmController.text,
                        "Length_MIN": provider.lengthMinController.text,
                        "Length_MAX": provider.lengthMaxController.text,
                        "No_Of_Piece": provider.noOfPiecesController.text,
                        "UOM": provider.selectedUOM_ID ?? "",
                        "Location": provider.selectedLocation_ID ?? "",
                        "To_Location": provider.selectedNextLocation_ID,
                        "Stock": "",
                        "G_Remarks": provider.G_RemarksController.text,
                        "Rate": "",
                        "Piece_length": provider.Piece_lengthController.text,

                      };

                      print("📦 Field String: $fieldString");
                      provider.submitForm(fieldString,generatedUrn.toString(),"Details",SR_No);
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
