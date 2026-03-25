import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/app_button.dart';
import '../../../../widgets/bottomsheetSelection.dart';
import '../../../../widgets/customInputDecoration.dart';
import '../Recovery_Listing/Recovery_List.dart';
import 'Provider/Recovery_Form_Provider.dart';



class Recovery_Form_Screen extends StatelessWidget {
  final URN_No;
  final String? DocNo; // ✅ define field
  final String? Category; // ✅ define field
  final String? Status; // ✅ define field
  final String? Mode;
  const Recovery_Form_Screen({Key? key, this.URN_No,this.DocNo,this.Category,this.Status,this.Mode,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(URN_No);
    final Recovery_FormProvider =
    context.watch<Recovery_Form_Provider>();
    if (Recovery_FormProvider.isInitialized == false) {
      Recovery_FormProvider.init(URN_No,Mode,DocNo,Category);

      Recovery_FormProvider.isInitialized = true;

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
              final provider = Provider.of<Recovery_Form_Provider>(context, listen: false);

              // ✅ First stop the provider logic
              provider.isInitialized = false;
              provider.clearMainForm();
              provider.clearProductForm();
              // provider.notifyListeners();

              if (!context.mounted) return; // ✅ ensures widget not disposed

              // ✅ Then navigate — after cleanup
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Recovery_List()),
              );
            }
        ),
        title: Consumer<Recovery_Form_Provider>(
          builder: (BuildContext context, Recovery_Form_Provider provider,
              Widget? child) {
            return Padding(
              padding: EdgeInsets.only(
                left: provider.width * 0.04,
                right: provider.width * 0.04,
              ),
              child: Text(
                "Recovery",
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
          child: Consumer<Recovery_Form_Provider>(
            builder: (BuildContext context, Recovery_Form_Provider provider,
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
                            Consumer<Recovery_Form_Provider>(
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
                                              "Draft",
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
                                        const SizedBox(height: 8),

                                        /// Process Name
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Difference :",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Text(
                                              provider.Difference ??
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
                            SizedBox(height: 12,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recovery Details",
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
                                  Provider.of<Recovery_Form_Provider>(context,
                                      listen: false);

                                  if (provider.categoryName_List.isEmpty) {
                                    provider.isLoading = true;
                                    provider.notifyListeners();

                                    await provider.fetchCategoryListFromAPI(
                                        URN_No.toString());

                                    provider.isLoading = false;
                                    provider.notifyListeners();
                                  }

                                  if (provider.categoryName_List.isNotEmpty) {
                                    showCategoryBottomSheet(
                                        context,
                                        provider.categoryName_List,
                                        "Category",
                                        URN_No.toString(),"Recovery");
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
                                        text: Provider.of<Recovery_Form_Provider>(
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
                                  Provider.of<Recovery_Form_Provider>(context,
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
                                        URN_No.toString(),"Recovery");
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
                                        text: Provider.of<Recovery_Form_Provider>(
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
                                  Provider.of<Recovery_Form_Provider>(context,
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
                                        URN_No.toString(),"Recovery");
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
                                        text: Provider.of<Recovery_Form_Provider>(
                                            context)
                                            .selectedDepartment ??
                                            ""),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller: provider.breakdownTimeController,
                                readOnly: true,
                                decoration: customInputDecoration("BreakDown Time"),
                                onTap: () async {
                                  // Step 1: Pick the date
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    // Step 2: Pick the time
                                    TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (pickedTime != null) {
                                      // Step 3: Combine date and time
                                      final DateTime fullDateTime = DateTime(
                                        pickedDate.year,
                                        pickedDate.month,
                                        pickedDate.day,
                                        pickedTime.hour,
                                        pickedTime.minute,
                                      );

                                      // Step 4: Format as "yyyy-MM-dd HH:mm"
                                      String formattedDateTime =
                                          "${fullDateTime.year}-${fullDateTime.month.toString().padLeft(2, '0')}-${fullDateTime.day.toString().padLeft(2, '0')} "
                                          "${pickedTime.format(context)}";

                                      provider.breakdownTimeController.text = formattedDateTime;
                                      await provider.fetchTimeDiffrenceFromAPI(
                                          URN_No.toString(),provider.RecoveryTimeController.text,provider.breakdownTimeController.text);
                                      provider.notifyListeners();
                                    }
                                  }
                                },
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller: provider.RecoveryTimeController,
                                readOnly: true,
                                decoration: customInputDecoration("Recovery Time"),
                                onTap: () async {
                                  // Step 1: Pick the date
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    // Step 2: Pick the time
                                    TimeOfDay? pickedTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (pickedTime != null) {
                                      // Step 3: Combine date and time
                                      final DateTime fullDateTime = DateTime(
                                        pickedDate.year,
                                        pickedDate.month,
                                        pickedDate.day,
                                        pickedTime.hour,
                                        pickedTime.minute,
                                      );

                                      // Step 4: Format as "yyyy-MM-dd HH:mm"
                                      String formattedDateTime =
                                          "${fullDateTime.year}-${fullDateTime.month.toString().padLeft(2, '0')}-${fullDateTime.day.toString().padLeft(2, '0')} "
                                          "${pickedTime.format(context)}";

                                      provider.RecoveryTimeController.text = formattedDateTime;
                                      await provider.fetchTimeDiffrenceFromAPI(
                                          URN_No.toString(),formattedDateTime,provider.breakdownTimeController.text);
                                      provider.notifyListeners();
                                    }
                                  }
                                },
                              ),

                              const SizedBox(height: 8),

                              GestureDetector(
                                onTap: () async {
                                  final provider =
                                  Provider.of<Recovery_Form_Provider>(context,
                                      listen: false);

                                  // if (provider.Send_To_List.isEmpty) {
                                    provider.isLoading = true;
                                    provider.notifyListeners();

                                    await provider.fetchSend_ToListFromAPI(
                                        URN_No.toString());

                                    provider.isLoading = false;
                                    provider.notifyListeners();
                                  // }

                                  if (provider.Send_To_List.isNotEmpty) {
                                    showCategoryBottomSheet(
                                        context,
                                        provider.Send_To_List,
                                        "Send To",
                                        URN_No.toString(),"Recovery");
                                  }
                                },
                                child: AbsorbPointer(
                                  absorbing: true, // prevent manual typing
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration:
                                    customInputDecoration("Send To").copyWith(
                                      suffixIcon: const Icon(Icons.arrow_drop_down),
                                    ),
                                    controller: TextEditingController(
                                        text: Provider.of<Recovery_Form_Provider>(
                                            context)
                                            .selectedSendto ??
                                            ""),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),
                              // TextFormField(
                              //   controller: provider.Memo_ByController,
                              //   decoration: customInputDecoration("Memo By"),
                              //   maxLines: 1,
                              //   keyboardType: TextInputType.emailAddress,
                              //   textInputAction: TextInputAction.newline,
                              // ),
                              // const SizedBox(height: 8),

                              TextField(
                                controller: provider.AttendantController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: customInputDecoration("Attendant"),
                              ),

                              // DropdownButtonFormField<String>(
                              //   value: provider
                              //       .selectedBreakdownReason, // must be a String or null
                              //   decoration:
                              //   customInputDecoration("Breakdown Reason"),
                              //   items: provider.Breakdown_Reason_List.map((item) {
                              //     return DropdownMenuItem(
                              //       value: item,
                              //       child: Text(item),
                              //     );
                              //   }).toList(),
                              //   onChanged: (value) {
                              //     provider.selectedBreakdownReason = value!;
                              //     provider.notifyListeners(); // if using Provider
                              //   },
                              // ),
                              // const SizedBox(height: 8),
                              // Image input field
                              // TextFormField(
                              //   readOnly: true,
                              //   decoration: InputDecoration(
                              //     labelText: "Add Image",
                              //     prefixIcon: const Icon(Icons.image),
                              //     suffixIcon: IconButton(
                              //       icon: const Icon(Icons.camera_alt),
                              //       onPressed: () {
                              //         provider.pickImage(
                              //             fromCamera: true); // Capture from camera
                              //       },
                              //     ),
                              //     border: const OutlineInputBorder(),
                              //   ),
                              //   onTap: () {
                              //     provider.pickImage(); // Default gallery picker
                              //   },
                              // ),
                              // const SizedBox(height: 8),
                              //
                              // if (provider.selectedImage != null)
                              //   Padding(
                              //     padding: const EdgeInsets.only(top: 10),
                              //     child: Image.file(
                              //       provider.selectedImage!,
                              //       height: 100,
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              //
                              // // Video input field
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     TextFormField(
                              //       readOnly: true,
                              //       decoration: InputDecoration(
                              //         labelText: "Add Video",
                              //         prefixIcon: const Icon(Icons.videocam),
                              //         suffixIcon: IconButton(
                              //           icon: const Icon(Icons.videocam_outlined),
                              //           onPressed: () {
                              //             provider.pickVideo(fromCamera: true); // Record from camera
                              //           },
                              //         ),
                              //         border: const OutlineInputBorder(),
                              //       ),
                              //       onTap: () {
                              //         provider.pickVideo(); // Pick from gallery
                              //       },
                              //     ),
                              //     if (provider.selectedVideo != null) ...[
                              //       Padding(
                              //         padding: const EdgeInsets.only(top: 10),
                              //         child: Text(
                              //           "Video Selected: ${provider.selectedVideo!.path.split('/').last}",
                              //           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              //           overflow: TextOverflow.ellipsis,
                              //         ),
                              //       ),
                              //       const SizedBox(height: 10),
                              //       ElevatedButton.icon(
                              //         icon: const Icon(Icons.cloud_upload),
                              //         label: const Text("Upload Video"),
                              //         onPressed: () async {
                              //           if (provider.selectedVideo != null) {
                              //             String result = await provider.uploadVideo(
                              //               vary: "yourVary",
                              //               uid: "yourUID",
                              //               token: "yourToken",
                              //               urn: "yourURN",
                              //               tag: "yourTag",
                              //               des: "yourDescription",
                              //               size: "videoSize",
                              //               type: "videoType",
                              //               srno: "yourSrNo",
                              //               gridvary: "yourGridVary",
                              //               clientUrl: "https://demo.datanote.co.in/formezy/backend",
                              //             );
                              //             print("Upload Result: $result");
                              //           }
                              //         },
                              //       ),
                              //     ],
                              //   ],
                              // ),
                              // const SizedBox(height: 20),
                              // // Appbutton(
                              // //     text: "Submit",
                              // //     onPressed: () {
                              // //       Map<String, dynamic> fieldString = {
                              // //         "Doc_Date": provider.dateController.text?? "",
                              // //         "Machine_Name": provider.selectedMachine_ID,
                              // //         "Department": provider.selectedDepartment_ID,
                              // //         "Break_Down_Time": provider.breakdownTimeController.text,
                              // //         "Send_To": provider.selectedSendto_ID ?? "",
                              // //         "Break_Down_By": provider.Memo_ByController.text ?? "",
                              // //         "Remarks": "",
                              // //         "Machine_Name1": "",
                              // //         "BreckDown_Detail": "",
                              // //         "Sub_Head": "",
                              // //         "Standard_Time_Min": "",
                              // //       };
                              // //
                              // //       print("📦 Field String: $fieldString");
                              // //       provider.submitForm(fieldString,URN_No.toString(),"Master","");
                              // //     }),
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
                                                    product["Machine_Sub_Head"] ?? "Unknown Item",
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
                                                      "Remarks: ${product["Remarks"] ?? '-'}",
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
                                Appbutton(
                                  text: "Add Product",
                                  icon: Icons.add, // ✅ optional icon
                                  // color: Colors.blueAccent,
                                  onPressed: () {
                                    provider.clearProductForm();

                                    showProductForm(context, provider, URN_No.toString(),"");
                                  },
                                )

                              ],
                            ),
                            Divider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Item to be Used",
                                  style: TextStyle(
                                    fontSize: provider.height * 0.024,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueGrey[800],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                provider.product_Item_List.isEmpty
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
                                    "No data added yet",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                )
                                    : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: provider.product_Item_List.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final product = provider.product_Item_List[index];

                                    return Slidable(
                                      startActionPane: ActionPane(
                                          motion: const DrawerMotion(),
                                          extentRatio: 0.4, // how wide the slide actions appear
                                          children: [
                                            SlidableAction(
                                              onPressed: (_) async {
                                                await provider.Get_Recovery_List(URN_No.toString(), product["SR_No"]);
                                                // Use the context from your widget tree, not the SlidableAction callback
                                                showItemtobeUsedForm(
                                                  context, // <-- main page context
                                                  provider,
                                                  URN_No.toString(),
                                                  product["SR_No"],
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
                                                    "Sr No: ${product["SR_No"] ?? '-'}",
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    product["Item_Name"] ?? "Unknown Item",
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
                                                      "Description: ${product["Description"] ?? '-'}",
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
                                Appbutton(
                                  text: "Add Item to be Used",
                                  icon: Icons.add, // ✅ optional icon
                                  // color: Colors.blueAccent,
                                  onPressed: () {
                                    provider.clearProductForm();

                                    showItemtobeUsedForm(context, provider, URN_No.toString(),"");
                                  },
                                )

                              ],
                            ),
                            Divider(),
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
        child: Consumer<Recovery_Form_Provider>(
          builder: (BuildContext context, Recovery_Form_Provider provider, Widget? child) {
            return Appbutton(
              text: "Submit",
              onPressed: () {
                Map<String, dynamic> fieldString = {
                  "Doc_Date": provider.dateController.text,
                  "Machine_Name": provider.selectedMachine_ID,
                  "from_urn_no": "",
                  "Department": provider.selectedDepartment_ID,
                  "Break_Down_Time": provider.breakdownTimeController.text,
                  "Recovery_Time": provider.RecoveryTimeController.text,
                  "Send_To": provider.selectedSendto_ID ?? "",
                  "Attendent_Name": provider.AttendantController.text,
                  "Machine_Name1": "",
                  "Modification": "",
                  "Extra_Work": "",
                  "Solution": "",
                  "Suggestion": "",
                  "Remarks": "",
                  "From_Item_Sr_No": "",
                  "BreckDown_Detail":"",
                  "Sub_Head":"",
                  "Standard_Time_Min": "",
                  "Item_Name": "",
                  "Description": "",
                  "UOM": "",
                  "Quantity": "",
                };

                print("📦 Field String: $fieldString");
                provider.submitForm(fieldString, URN_No.toString(), "Master", "");
              },
            );
          },
        ),
      ),
    );

  }

  void showProductForm(BuildContext context,
      Recovery_Form_Provider provider,String generatedUrn ,String SR_No ,{int? index}) {
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
                //     Provider.of<Recovery_Form_Provider>(context,
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
                //           text: Provider.of<Recovery_Form_Provider>(
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
                    Provider.of<Recovery_Form_Provider>(context,
                        listen: false);

                    // if (provider.Sub_Head_Name_List.isEmpty) {
                    provider.isLoading = true;
                    provider.notifyListeners();

                    await provider.fetchSub_Head_NameListFromAPI(
                        URN_No.toString());

                    provider.isLoading = false;
                    provider.notifyListeners();
                    // }

                    if (provider.Sub_Head_Name_List.isNotEmpty) {
                      showCategoryBottomSheet(
                          context,
                          provider.Sub_Head_Name_List,
                          "Sub Head",
                          URN_No.toString(),"Recovery");
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true, // prevent manual typing
                    child: TextFormField(
                      readOnly: true,
                      decoration:
                      customInputDecoration("Sub Head").copyWith(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      controller: TextEditingController(
                          text: Provider.of<Recovery_Form_Provider>(
                              context)
                              .selectedSubHead ??
                              ""),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final provider =
                    Provider.of<Recovery_Form_Provider>(context,
                        listen: false);

                    if (provider.Break_Detail_List.isEmpty) {
                      provider.isLoading = true;
                      provider.notifyListeners();

                      await provider.fetchBreak_Detail_ListFromAPI(
                          URN_No.toString());

                      provider.isLoading = false;
                      provider.notifyListeners();
                    }

                    if (provider.Break_Detail_List.isNotEmpty) {
                      showCategoryBottomSheet(
                          context,
                          provider.Break_Detail_List,
                          "BreakDown Detail",
                          URN_No.toString(),"Recovery");
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true, // prevent manual typing
                    child: TextFormField(
                      readOnly: true,
                      decoration:
                      customInputDecoration("BreakDown Detail").copyWith(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      controller: TextEditingController(
                          text: Provider.of<Recovery_Form_Provider>(
                              context)
                              .selectedBreak_Detail ??
                              ""),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final provider =
                    Provider.of<Recovery_Form_Provider>(context,
                        listen: false);

                    if (provider.Std_Time_Min_List.isEmpty) {
                      provider.isLoading = true;
                      provider.notifyListeners();

                      await provider.fetchStd_Time_Min_ListFromAPI(
                          URN_No.toString());

                      provider.isLoading = false;
                      provider.notifyListeners();
                    }

                    if (provider.Std_Time_Min_List.isNotEmpty) {
                      showCategoryBottomSheet(
                          context,
                          provider.Std_Time_Min_List,
                          "Standard Time Min",
                          URN_No.toString(),"Recovery");
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true, // prevent manual typing
                    child: TextFormField(
                      readOnly: true,
                      decoration:
                      customInputDecoration("Standard Time Min").copyWith(
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      controller: TextEditingController(
                          text: Provider.of<Recovery_Form_Provider>(
                              context)
                              .selectedStd_Time_Min ??
                              ""),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.SolutionController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: customInputDecoration("Solution"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.SuggestionController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: customInputDecoration("Suggestion"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.RemarksController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: customInputDecoration("Remarks"),
                ),

                const SizedBox(height: 20),

                Appbutton(
                    text: isEdit ? "Update" : "Save",
                    onPressed: () {
                      Map<String, dynamic> fieldString = {
                        "Doc_Date": "",
                        "Machine_Name": "",
                        "from_urn_no": "",
                        "Department": "",
                        "Break_Down_Time": "",
                        "Recovery_Time": "",
                        "Send_To": "",
                        "Attendent_Name": "",
                        "Modification": "",
                        "Extra_Work": "",
                        "Machine_Name1": provider.selectedMachine_ID,
                        "Solution": provider.SolutionController.text,
                        "Suggestion": provider.SuggestionController.text,
                        "Remarks": provider.RemarksController.text,
                        "From_Item_Sr_No": SR_No,
                        "BreckDown_Detail": provider.selectedBreak_Detail_ID,
                        "Sub_Head":provider.selectedSubHead_ID,
                        "Standard_Time_Min": provider.selectedStd_Time_Min_ID,
                        "Item_Name": "",
                        "Description": "",
                        "UOM": "",
                        "Quantity": "",
                      };

                      print("📦 Field String: $fieldString");
                      provider.submitForm(fieldString,URN_No.toString(),"Details","");
                    }),


                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }


  void showItemtobeUsedForm(BuildContext context,
      Recovery_Form_Provider provider,String generatedUrn ,String SR_No ,{int? index}) {
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
                    // if (provider.itemName_List.isEmpty) {
                      provider.isLoading = true;
                      provider.notifyListeners();

                      await provider.fetchitemNameListFromAPI(generatedUrn.toString(),"");

                      provider.isLoading = false;
                      provider.notifyListeners();
                    // }

                    if (provider.itemName_List.isNotEmpty) {
                      showCategoryBottomSheet(
                        context,
                        provider.itemName_List,
                        "Item Name",
                        generatedUrn.toString(),"Recovery",
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
                          text: Provider.of<Recovery_Form_Provider>(
                              context)
                              .selecteditemName ??
                              ""),
                    ),
                  ),
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
                        generatedUrn.toString(),"Recovery",
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
                          text: Provider.of<Recovery_Form_Provider>(
                              context)
                              .selectedUOM ??
                              ""),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: provider.QuantityController,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: customInputDecoration("Quantity"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: provider.DescriptionController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: customInputDecoration("Description"),
                ),





                const SizedBox(height: 20),


                Appbutton(
                    text: isEdit ? "Update" : "Save",
                    onPressed: () {
                      Map<String, dynamic> fieldString = {
                        "Doc_Date": "",
                        "Machine_Name": "",
                        "from_urn_no": "",
                        "Department": "",
                        "Break_Down_Time": "",
                        "Recovery_Time": "",
                        "Send_To": "",
                        "Attendent_Name": "",
                        "Machine_Name1":"",
                        "Modification": "",
                        "Extra_Work": "",
                        "Solution": "",
                        "Suggestion": "",
                        "From_Item_Sr_No": "",
                        "BreckDown_Detail": "",
                        "Sub_Head":"",
                        "Standard_Time_Min": "",
                        "Item_Name": provider.selecteditemName_ID,
                        "Description": provider.DescriptionController.text,
                        "UOM": provider.selectedUOM_ID,
                        "Quantity": provider.QuantityController.text,
                      };

                      print("📦 Field String: $fieldString");
                      provider.submitForm(fieldString,URN_No.toString(),"Item_Details","");
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
