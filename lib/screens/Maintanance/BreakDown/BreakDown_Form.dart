import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/bottomsheetSelection.dart';
import '../../../widgets/customInputDecoration.dart';
import '../../Dashboard/Dashboard.dart';
import 'BreakDown_Listing/BreakDown_List.dart';
import 'Provider/Breakdown_Form_Provider.dart';

class Breakdown_Form_Screen extends StatelessWidget {
  final URN_No;
  final String? DocNo; // ✅ define field
  final String? Category; // ✅ define field
  final String? Status; // ✅ define field
  final String? Mode;
  const Breakdown_Form_Screen({Key? key, this.URN_No,this.DocNo,this.Category,this.Status,this.Mode,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(URN_No);
    final BreakDown_FormProvider =
    context.watch<Breakdown_Form_Provider>();
    if (BreakDown_FormProvider.isInitialized == false) {
      BreakDown_FormProvider.init(URN_No,Mode,DocNo,Category);
      BreakDown_FormProvider.isInitialized = true;
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
            final provider = Provider.of<Breakdown_Form_Provider>(context, listen: false);
            provider.clearMainForm();
            provider.clearProductForm();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => BreakDown_List()));
          },
        ),
        title: Consumer<Breakdown_Form_Provider>(
          builder: (BuildContext context, Breakdown_Form_Provider provider,
              Widget? child) {
            return Padding(
              padding: EdgeInsets.only(
                left: provider.width * 0.04,
                right: provider.width * 0.04,
              ),
              child: Text(
                "Breakdown",
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
          child: Consumer<Breakdown_Form_Provider>(
            builder: (BuildContext context, Breakdown_Form_Provider provider,
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
                            Consumer<Breakdown_Form_Provider>(
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
                                  "BreakDown Details",
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
                                  Provider.of<Breakdown_Form_Provider>(context,
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
                                        URN_No.toString(),"Breakdown");
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
                                        text: Provider.of<Breakdown_Form_Provider>(
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
                                  Provider.of<Breakdown_Form_Provider>(context,
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
                                        URN_No.toString(),"Breakdown");
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
                                        text: Provider.of<Breakdown_Form_Provider>(
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
                                  Provider.of<Breakdown_Form_Provider>(context,
                                      listen: false);

                                  if (provider.Department_List.isEmpty) {
                                    provider.isLoading = true;
                                    provider.notifyListeners();

                                    await provider.fetchDepartmentListFromAPI(
                                        URN_No.toString());

                                    provider.isLoading = false;
                                    provider.notifyListeners();
                                  }

                                  if (provider.Department_List.isNotEmpty) {
                                    showCategoryBottomSheet(
                                        context,
                                        provider.Department_List,
                                        "Department",
                                        URN_No.toString(),"Breakdown");
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
                                        text: Provider.of<Breakdown_Form_Provider>(
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
                                      provider.notifyListeners();
                                    }
                                  }
                                },
                              ),


                              // DropdownButtonFormField<String>(
                              //   value: provider
                              //       .selectedSubMatchine, // must be a String or null
                              //   decoration:
                              //       customInputDecoration("Sub Matchine Name"),
                              //   items: provider.Sub_Matchine_Name_List.map((item) {
                              //     return DropdownMenuItem(
                              //       value: item,
                              //       child: Text(item),
                              //     );
                              //   }).toList(),
                              //   onChanged: (value) {
                              //     provider.selectedSubMatchine = value!;
                              //     provider.notifyListeners(); // if using Provider
                              //   },
                              // ),

                              const SizedBox(height: 8),

                              GestureDetector(
                                onTap: () async {
                                  final provider =
                                  Provider.of<Breakdown_Form_Provider>(context,
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
                                        URN_No.toString(),"Breakdown");
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
                                        text: Provider.of<Breakdown_Form_Provider>(
                                            context)
                                            .selectedSendto ??
                                            ""),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),
                              TextFormField(
                                controller: provider.Memo_ByController,
                                decoration: customInputDecoration("Memo By"),
                                maxLines: 1,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.newline,
                              ),
                              const SizedBox(height: 8),

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
                              TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Add Image",
                                  prefixIcon: const Icon(Icons.image),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.camera_alt),
                                    onPressed: () {
                                      provider.pickImage(
                                          fromCamera: true, URN_NO: URN_No.toString(),); // Capture from camera
                                    },
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                                onTap: () async {
                                  await provider.pickImage(URN_NO: URN_No.toString()); // Default gallery picker

                                },
                              ),
                              const SizedBox(height: 8),

                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  height: 110,
                                  child: Builder(
                                    builder: (context) {
                                      final apiImages = provider.apiImages; // List<ApiImageItem>
                                      final localImages = provider.selectedImages; // List<File>
                                      final totalImages = apiImages.length + localImages.length;

                                      if (totalImages == 0) {
                                        return Center(
                                          child: Text(
                                            "No images available",
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        );
                                      }

                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: totalImages,
                                        itemBuilder: (context, index) {
                                          final bool isApiImage = index < apiImages.length;

                                          // 🖼 Image data
                                          final imageWidget = isApiImage
                                              ? Image.memory(
                                            apiImages[index].bytes,
                                            height: 100,
                                            width: 110,
                                            fit: BoxFit.cover,
                                          )
                                              : Image.file(
                                            localImages[index - apiImages.length],
                                            height: 100,
                                            width: 110,
                                            fit: BoxFit.cover,
                                          );

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                // Wrap image in GestureDetector for preview
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) => Dialog(
                                                        backgroundColor: Colors.black,
                                                        insetPadding: EdgeInsets.zero,
                                                        child: Stack(
                                                          children: [
                                                            InteractiveViewer(
                                                              child: Center(
                                                                child: isApiImage
                                                                    ? Image.memory(apiImages[index].bytes)
                                                                    : Image.file(localImages[index - apiImages.length]),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 30,
                                                              right: 20,
                                                              child: IconButton(
                                                                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                                                                onPressed: () => Navigator.pop(context),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 110,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(16),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.1),
                                                          blurRadius: 6,
                                                          offset: const Offset(2, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(16),
                                                      child: imageWidget,
                                                    ),
                                                  ),
                                                ),

                                                // ❌ Delete Button (for both API & local images)
                                                Positioned(
                                                  top: -6,
                                                  right: -6,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (isApiImage) {
                                                        final srNo = apiImages[index].srNo;
                                                        provider.deleteImage(srNo.toString(), URN_No);
                                                      } else {
                                                        // provider.removeImage(index - apiImages.length);
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      padding: const EdgeInsets.all(4),
                                                      child: const Icon(
                                                        Icons.close,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),


                              // Video input field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: "Add Video",
                                      prefixIcon: const Icon(Icons.videocam),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.videocam_outlined),
                                        onPressed: () {
                                          provider.pickVideo(fromCamera: true); // Record from camera
                                        },
                                      ),
                                      border: const OutlineInputBorder(),
                                    ),
                                    onTap: () {
                                      provider.pickVideo(); // Pick from gallery
                                    },
                                  ),
                                  if (provider.selectedVideo != null) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        "Video Selected: ${provider.selectedVideo!.path.split('/').last}",
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.cloud_upload),
                                      label: const Text("Upload Video"),
                                      onPressed: () async {
                                        if (provider.selectedVideo != null) {
                                          String result = await provider.uploadVideo(
                                            vary: "yourVary",
                                            uid: "yourUID",
                                            token: "yourToken",
                                            urn: "yourURN",
                                            tag: "yourTag",
                                            des: "yourDescription",
                                            size: "videoSize",
                                            type: "videoType",
                                            srno: "yourSrNo",
                                            gridvary: "yourGridVary",
                                            clientUrl: "https://demo.datanote.co.in/formezy/backend",
                                          );
                                          print("Upload Result: $result");
                                        }
                                      },
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Appbutton(
                              //     text: "Submit",
                              //     onPressed: () {
                              //       Map<String, dynamic> fieldString = {
                              //         "Doc_Date": provider.dateController.text?? "",
                              //         "Machine_Name": provider.selectedMachine_ID,
                              //         "Department": provider.selectedDepartment_ID,
                              //         "Break_Down_Time": provider.breakdownTimeController.text,
                              //         "Send_To": provider.selectedSendto_ID ?? "",
                              //         "Break_Down_By": provider.Memo_ByController.text ?? "",
                              //         "Remarks": "",
                              //         "Machine_Name1": "",
                              //         "BreckDown_Detail": "",
                              //         "Sub_Head": "",
                              //         "Standard_Time_Min": "",
                              //       };
                              //
                              //       print("📦 Field String: $fieldString");
                              //       provider.submitForm(fieldString,URN_No.toString(),"Master","");
                              //     }),
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
                                                await provider.getBreakDownList(URN_No.toString(), product["Sr_no"]);
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

                                              // Row(
                                              //   children: [
                                              //     // const Icon(Icons.qr_code_2, color: Colors.grey, size: 18),
                                              //     const SizedBox(width: 6),
                                              //     Expanded(
                                              //       child: Text(
                                              //         "Machine Sub Head: ${product["Machine_Sub_Head"] ?? '-'}",
                                              //         style: const TextStyle(
                                              //           fontSize: 13,
                                              //           color: Colors.black87,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              // const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  // const Icon(Icons.qr_code_2, color: Colors.grey, size: 18),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      "Breck Down Detail: ${product["Breck_Down_Detail"] ?? '-'}",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
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
        child: Consumer<Breakdown_Form_Provider>(
          builder: (BuildContext context, Breakdown_Form_Provider provider, Widget? child) {
            return Appbutton(
              text: "Submit",
              onPressed: () {
                Map<String, dynamic> fieldString = {
                  "Doc_Date": provider.dateController.text ?? "",
                  "Machine_Name": provider.selectedMachine_ID,
                  "Department": provider.selectedDepartment_ID,
                  "Break_Down_Time": provider.breakdownTimeController.text,
                  "Send_To": provider.selectedSendto_ID ?? "",
                  "Break_Down_By": provider.Memo_ByController.text ?? "",
                  "Remarks": "",
                  "Machine_Name1": "",
                  "BreckDown_Detail": "",
                  "Sub_Head": "",
                  "Standard_Time_Min": "",
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
      Breakdown_Form_Provider provider,String generatedUrn ,String SR_No ,{int? index}) {
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
                //     Provider.of<Breakdown_Form_Provider>(context,
                //         listen: false);
                //
                //     // if (provider.Machine_Name_List_Product.isEmpty) {
                //       provider.isLoading = true;
                //       provider.notifyListeners();
                //
                //       await provider.fetchMachine_NameListFromAPI(
                //           URN_No.toString());
                //
                //       provider.isLoading = false;
                //       provider.notifyListeners();
                //     // }
                //
                //     if (provider.Machine_Name_List_Product.isNotEmpty) {
                //       showCategoryBottomSheet(
                //           context,
                //           provider.Machine_Name_List_Product,
                //           "Product Machine Name",
                //           URN_No.toString(),"Breakdown");
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
                //           text: Provider.of<Breakdown_Form_Provider>(
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
                    Provider.of<Breakdown_Form_Provider>(context,
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
                          URN_No.toString(),"Breakdown");
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
                          text: Provider.of<Breakdown_Form_Provider>(
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
                    Provider.of<Breakdown_Form_Provider>(context,
                        listen: false);

                    // if (provider.Break_Detail_List.isEmpty) {
                      provider.isLoading = true;
                      provider.notifyListeners();

                      await provider.fetchBreak_Detail_ListFromAPI(
                          URN_No.toString());

                      provider.isLoading = false;
                      provider.notifyListeners();
                    // }

                    if (provider.Break_Detail_List.isNotEmpty) {
                      showCategoryBottomSheet(
                          context,
                          provider.Break_Detail_List,
                          "BreakDown Detail",
                          URN_No.toString(),"Breakdown");
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
                          text: Provider.of<Breakdown_Form_Provider>(
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
                    Provider.of<Breakdown_Form_Provider>(context,
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
                          URN_No.toString(),"Breakdown");
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
                          text: Provider.of<Breakdown_Form_Provider>(
                              context)
                              .selectedStd_Time_Min ??
                              ""),
                    ),
                  ),
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
                        "Department": "",
                        "Break_Down_Time": "",
                        "Send_To": "",
                        "Break_Down_By": "",
                        "Machine_Name1": provider.selectedMachine_ID,
                        "Remarks": provider.RemarksController.text,
                        "BreckDown_Detail": provider.selectedBreak_Detail_ID,
                        "Sub_Head": provider.selectedSubHead_ID,
                        "Standard_Time_Min": provider.selectedStd_Time_Min_ID,
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
