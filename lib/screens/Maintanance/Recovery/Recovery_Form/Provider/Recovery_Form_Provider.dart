import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../../../../../GlobalComponents/PreferenceManager.dart';
import '../../../../../GlobalComponents/api_service.dart';
import '../../Recovery_Listing/Recovery_List.dart';



class Recovery_Form_Provider extends ChangeNotifier {
  late double height;
  late double width;

  bool isRunning = false;


  var weight;
  var length;
  var number;
  var extra;

  final weightController = TextEditingController();
  final ODMMController = TextEditingController();
  final numberController = TextEditingController();
  final extraController  = TextEditingController();
  final heat_no_Controller  = TextEditingController();
  final totalItemsController  = TextEditingController();
  final processController  = TextEditingController();
  final outputBatchController  = TextEditingController();
  final outputLengthController  = TextEditingController();
  final outputWeightController  = TextEditingController();
  final outputTotalItemsController  = TextEditingController();
  final outputProcessController  = TextEditingController();
  final itemController  = TextEditingController();
  final THK_MIN_Controller  = TextEditingController();
  final THK_MM_Controller  = TextEditingController();
  final Length_Min_Controller  = TextEditingController();
  final Length_Max_Controller  = TextEditingController();
  final ODMM_Out_Controller  = TextEditingController();
  final Min_THK_Out_Controller  = TextEditingController();
  final Max_THK_Out_Controller  = TextEditingController();
  final output_THK_Controller  = TextEditingController();
  final Min_Length_Out_Controller  = TextEditingController();
  final Max_Length_Out_Controller  = TextEditingController();
  final Finish_Length_Controller  = TextEditingController();
  final No_of_Piece_Out_Controller  = TextEditingController();
  final Draw_Out_Controller  = TextEditingController();
  final Remarks_Controller  = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController Memo_ByController = TextEditingController();
  final TextEditingController breakdownTimeController = TextEditingController();
  final TextEditingController RecoveryTimeController = TextEditingController();
  final TextEditingController RemarksController = TextEditingController();
  final TextEditingController AttendantController = TextEditingController();
  final TextEditingController SolutionController = TextEditingController();
  final TextEditingController SuggestionController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();
  final TextEditingController QuantityController = TextEditingController();

  bool isTransferMemoExpanded = true;

  List<Map<String, dynamic>> productList = [];
  List<Map<String, dynamic>> product_Item_List = [];

  bool isInitialized = false;

  List<Map<String, String>> itemName_List = [];
  String selecteditemName="";
  String selecteditemName_ID="";

  void clearProductForm() {
    productList.clear();
    product_Item_List.clear();
    Machine_Name_List_Product.clear();
    selectedMachine_Product = "";
    selectedMachine_ID_Product = "";
    Sub_Head_Name_List.clear();
    selectedSubHead="";
    selectedSubHead_ID="";
    Break_Detail_List.clear();
    selectedBreak_Detail="";
    selectedBreak_Detail_ID="";
    Std_Time_Min_List.clear();
    selectedStd_Time_Min="";
    selectedStd_Time_Min_ID="";
    Remarks_Controller.clear();
    SolutionController.clear();
    SuggestionController.clear();
    DescriptionController.clear();
    QuantityController.clear();
    productList.clear();
    product_Item_List.clear();
    selecteditemName_ID="";
    selecteditemName="";
    UOM_List.clear();
    selectedUOM="";
    selectedUOM_ID="";

    // notifyListeners();
  }

  void toggleTransferMemoExpansion() {
    isTransferMemoExpanded = !isTransferMemoExpanded;
    notifyListeners();
  }

  List<Map<String, String>> categoryName_List = [];
  String? selectedItem;

  List<Map<String, String>> Department_List = [];
  String selectedDepartment="";
  String selectedDepartment_ID="";

  List<Map<String, String>> Machine_Name_List = [];
  String selectedMachine = "";
  String selectedMachine_ID = "";

  List<Map<String, String>> Machine_Name_List_Product = [];
  String selectedMachine_Product = "";
  String selectedMachine_ID_Product = "";

  List<Map<String, String>> Sub_Head_Name_List = [];
  String selectedSubHead="";
  String selectedSubHead_ID="";

  List<Map<String, String>> Break_Detail_List = [];
  String selectedBreak_Detail="";
  String selectedBreak_Detail_ID="";


  List<Map<String, String>> Std_Time_Min_List = [];
  String selectedStd_Time_Min="";
  String selectedStd_Time_Min_ID="";

  List<Map<String, String>> Send_To_List = [];
  String? selectedSendto;
  String? selectedSendto_ID;

  List<Map<String, String>> Item_Name_List = [];
  String? selectedItemName;
  String? selectedItemName_ID;

  List<Map<String, String>> UOM_List = [];
  String? selectedUOM;
  String? selectedUOM_ID;

  List<String> Breakdown_Reason_List = ["Reason 1", "Reason 2", "Reason 3"];
  String? selectedBreakdownReason;

  List<String> ProcessList = ["Process A", "Process B", "Process C"];
  String? selectedProcess;
  bool isLoading=false;



  String? selectedCategory;

  String selectedCategoryId="";

  var Doc_No;

  void setItem(String value) {
    selectedItem = value;
    notifyListeners();
  }

  List<String> gradeList = ["A", "B", "C", "D"];
  String? selectedGrade;

  List<String> specList = ["Spec 1", "Spec 2", "Spec 3"];
  String? selectedSpec;

  final List<Map<String, String>> machines = [
    {"value": "Machine 3", "label": "Machine 3"},
    {"value": "Machine 4", "label": "Machine 4"},
    {"value": "All", "label": "All Machines"},
  ];

  void startMachine(String machine) {
    isRunning = true;
    // selectedMachine = machine;
    notifyListeners();
  }

  int countdown = 0;
  Timer? _timer;

  void startCountdown(int seconds) {
    countdown = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
    notifyListeners();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void stopMachine() {
    isRunning = false;
    // selectedMachine = "";
    notifyListeners();
  }

  // 🔹 IMAGE & VIDEO PICKER SECTION
  final ImagePicker picker = ImagePicker();
  File? selectedImage;
  File? selectedVideo;

  Future<void> pickImage({bool fromCamera = false}) async {
    final pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> pickVideo({bool fromCamera = false}) async {
    final pickedFile = await picker.pickVideo(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxDuration: const Duration(minutes: 2),
    );

    if (pickedFile != null) {
      selectedVideo = File(pickedFile.path);
      notifyListeners();
    }
  }


  Future<String> uploadVideo({
    required String vary,
    required String uid,
    required String token,
    required String urn,
    required String tag,
    required String des,
    required String size,
    required String type,
    required String srno,
    required String gridvary,
    required String clientUrl,
  }) async {
    if (selectedVideo == null) return "No video selected";

    try {
      XFile videoFile = XFile(selectedVideo!.path);
      var result = await callbasicdetailupdate(
        videoFile,
        vary,
        uid,
        token,
        urn,
        tag,
        des,
        size,
        type,
        srno,
        gridvary,
        clientUrl,
      );
      return result ?? "Upload failed";
    } catch (e) {
      print("Upload Error: $e");
      return "Error during upload";
    }
  }

  /// Multipart upload function
  Future<String?> callbasicdetailupdate(
      XFile imagefile,
      String vary,
      String uid,
      String token,
      String urn,
      String tag,
      String des,
      String size,
      String type,
      String srno,
      String gridvary,
      String clientUrl,
      ) async {
    try {
      var uri = Uri.parse("$clientUrl/Collection/CollectionAttachment");
      var request = http.MultipartRequest("POST", uri);

      var stream = http.ByteStream(imagefile.openRead())..cast();
      var length = await imagefile.length();
      var multipartfile = http.MultipartFile(
        "files",
        stream,
        length,
        filename: path.basename(imagefile.path),
      );

      request.files.add(multipartfile);

      request.fields["Vary"] = vary;
      request.fields["SAL_URN_NO"] = uid;
      request.fields["Access_Token"] = token;
      request.fields["URN_No"] = urn;
      request.fields["Sr_No"] = srno;
      request.fields["Grid_Vary"] = gridvary;

      print("Request Fields: ${request.fields}");

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var result = String.fromCharCodes(responseData);
      print("Upload Response: $result");
      return result;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Future<void> uploadVideo() async {
  //   if (selectedVideo == null) return;
  //
  //   try {
  //     // Example using Dio
  //     final dio = Dio();
  //     String fileName = selectedVideo!.path.split('/').last;
  //
  //     FormData formData = FormData.fromMap({
  //       "video": await MultipartFile.fromFile(
  //         selectedVideo!.path,
  //         filename: fileName,
  //       ),
  //     });
  //
  //     Response response = await dio.post(
  //       "https://your-api-endpoint.com/upload",
  //       data: formData,
  //       options: Options(
  //         headers: {"Content-Type": "multipart/form-data"},
  //       ),
  //     );
  //
  //     print("Upload success: ${response.data}");
  //   } catch (e) {
  //     print("Upload failed: $e");
  //   }
  // }


  Recovery_Form_Provider() {
    final context = NavKey.navKey.currentState!.context;
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>?> fetchCategoryListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/List_Of_Category_IN_Transfer params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=2, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/List_Of_Category_IN_Transfer',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'item_filertext': "",
          'TableName': "",
          'FrmName': "frmBreakdown",
          'GridName': "",
          'SR_No': "",
          'Field_Name': "",
          'P_SR_No': "",
          'LINK': "",
          'DB_CODE_': selectedCategoryId,
        },
      );

      // Handle response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        debugPrint("⚠️ Invalid token or user ID. Logged out.");
      } else {
        // Check if 'message' is a valid list
        if (data.containsKey('message') && data['message'] is List) {
          if (data['settings']?['success'] == "1") {
            // Map category list with both value and code
            categoryName_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Categories loaded: ${categoryName_List.length}");
          } else {
            categoryName_List = [];
            selectedCategoryId="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          categoryName_List = [];
          selectedCategoryId="";
          debugPrint("⚠️ Invalid message format.");
        }
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('❌ FetchCategoryList Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchDocNoFromAPI(String URN,String frmname) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/Generate_New_DOC_No params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=2, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/Generate_New_DOC_No',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'item_filertext': "",
          'TableName': "",
          'FrmName': frmname,
          'GridName': "",
          'SR_No': "",
          'Field_Name': "",
          'P_SR_No': "",
          'LINK': "",
        },
      );

      // Handle response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        debugPrint("⚠️ Invalid token or user ID. Logged out.");
      } else {
        // Check if 'message' is a valid list
        if (data.containsKey('message') && data['message'] is List) {
          if (data['settings']?['success'] == "1") {

            Doc_No =data['message'][0]['Field_Value'];


            // Map category list with both value and code
            // categoryName_List = (data['message'] as List)
            //     .map((item) => {
            //   "Select_Value": item["Select_Value"]?.toString() ?? "",
            //   "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            // })
            //     .toList();
            // debugPrint("✅ Categories loaded: ${categoryName_List.length}");
          } else {
            // categoryName_List = [];
            // selectedCategoryId="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          // categoryName_List = [];
          // selectedCategoryId="";
          debugPrint("⚠️ Invalid message format.");
        }
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('❌ FetchCategoryList Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchDepartmentListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/Department_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=2, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/Department_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'item_filertext': "",
          'TableName': "",
          'FrmName': "frmRecovery",
          'GridName': "",
          'SR_No': "",
          'Field_Name': "",
          'P_SR_No': "",
          'LINK': "",
        },
      );

      // Handle response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        debugPrint("⚠️ Invalid token or user ID. Logged out.");
      } else {
        // Check if 'message' is a valid list
        if (data.containsKey('message') && data['message'] is List) {
          if (data['settings']?['success'] == "1") {
            // Map category list with both value and code
            Department_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Memo Type loaded: ${Department_List.length}");
          } else {
            Department_List = [];
            selectedDepartment="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Department_List = [];
          selectedDepartment="";
          debugPrint("⚠️ Invalid message format.");
        }
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('❌ FetchCategoryList Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchMachine_NameListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET BreakDown/Machine_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=2, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'BreakDown/Machine_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'item_filertext': "",
          'TableName': "",
          'FrmName': "frmRecovery",
          'GridName': "",
          'SR_No': "",
          'Field_Name': "",
          'P_SR_No': "",
          'LINK': "",
        },
      );

      // Handle response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        debugPrint("⚠️ Invalid token or user ID. Logged out.");
      } else {
        // Check if 'message' is a valid list
        if (data.containsKey('message') && data['message'] is List) {
          if (data['settings']?['success'] == "1") {
            // Map category list with both value and code
            Machine_Name_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();

            Machine_Name_List_Product = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Memo Type loaded: ${Machine_Name_List.length}");
          } else {
            Machine_Name_List = [];
            Machine_Name_List_Product = [];
            selectedMachine="";
            selectedMachine_Product="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Machine_Name_List = [];
          Machine_Name_List_Product = [];
          selectedMachine="";
          selectedMachine_Product="";
          debugPrint("⚠️ Invalid message format.");
        }
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('❌ FetchCategoryList Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchSend_ToListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET BreakDown/Send_To_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=2, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'BreakDown/Send_To_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'item_filertext': "",
          'TableName': "",
          'FrmName': "",
          'GridName': "",
          'SR_No': "",
          'Field_Name': "",
          'P_SR_No': "",
          'LINK': "",
        },
      );

      // Handle response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        debugPrint("⚠️ Invalid token or user ID. Logged out.");
      } else {
        // Check if 'message' is a valid list
        if (data.containsKey('message') && data['message'] is List) {
          if (data['settings']?['success'] == "1") {
            // Map category list with both value and code
            Send_To_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Memo Type loaded: ${Send_To_List.length}");
          } else {
            Send_To_List = [];
            selectedSendto="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Send_To_List = [];
          selectedSendto="";
          debugPrint("⚠️ Invalid message format.");
        }
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('❌ FetchCategoryList Error: $e');
      return null;
    }
  }


  Future<Map<String, dynamic>?> fetchSub_Head_NameListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET BreakDown/Machine_sub_Head_detail_List( params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=2, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'BreakDown/Machine_sub_Head_detail_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'item_filertext': "",
          'TableName': "",
          'FrmName': "frmRecovery",
          'GridName': "",
          'SR_No': "",
          'Field_Name': "",
          'P_SR_No': "",
          'LINK': "",
          'M_Machine_Code': selectedMachine_ID,
        },
      );

      // Handle response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        debugPrint("⚠️ Invalid token or user ID. Logged out.");
      } else {
        // Check if 'message' is a valid list
        if (data.containsKey('message') && data['message'] is List) {
          if (data['settings']?['success'] == "1") {
            // Map category list with both value and code
            Sub_Head_Name_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Sub Head loaded: ${Sub_Head_Name_List.length}");
          } else {
            Sub_Head_Name_List = [];
            selectedSubHead="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Sub_Head_Name_List = [];
          selectedSubHead="";
          debugPrint("⚠️ Invalid message format.");
        }
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('❌ FetchCategoryList Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchBreak_Detail_ListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET BreakDown/Breck_Details_List( params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=2, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'BreakDown/Breck_Details_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'item_filertext': "",
          'TableName': "",
          'FrmName': "frmRecovery",
          'GridName': "",
          'SR_No': "",
          'Field_Name': "",
          'P_SR_No': "",
          'LINK': "",
          'M_Machine_Code': selectedMachine_ID,
          'Sub_Head': selectedSubHead_ID,
        },
      );

      // Handle response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        debugPrint("⚠️ Invalid token or user ID. Logged out.");
      } else {
        // Check if 'message' is a valid list
        if (data.containsKey('message') && data['message'] is List) {
          if (data['settings']?['success'] == "1") {
            // Map category list with both value and code
            Break_Detail_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Sub Head loaded: ${Break_Detail_List.length}");
          } else {
            Break_Detail_List = [];
            selectedBreak_Detail="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Break_Detail_List = [];
          selectedBreak_Detail="";
          debugPrint("⚠️ Invalid message format.");
        }
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('❌ FetchCategoryList Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchStd_Time_Min_ListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET BreakDown/Standard_Time_Breckdown( params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=2, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'BreakDown/Standard_Time_Breckdown',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'item_filertext': "",
          'TableName': "",
          'FrmName': "frmBreakdown",
          'GridName': "",
          'SR_No': "",
          'Field_Name': "",
          'P_SR_No': "",
          'LINK': "",
          'Breckdown_detail_Code': selectedBreak_Detail_ID,
        },
      );

      // Handle response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        debugPrint("⚠️ Invalid token or user ID. Logged out.");
      } else {
        // Check if 'message' is a valid list
        if (data.containsKey('message') && data['message'] is List) {
          if (data['settings']?['success'] == "1") {
            // Map category list with both value and code
            Std_Time_Min_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Sub Head loaded: ${Std_Time_Min_List.length}");
          } else {
            Std_Time_Min_List = [];
            selectedStd_Time_Min="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Std_Time_Min_List = [];
          selectedStd_Time_Min="";
          debugPrint("⚠️ Invalid message format.");
        }
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('❌ FetchCategoryList Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchitemNameListFromAPI(String URN, String Search_Text) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/Item_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=2, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/Item_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'item_filertext': Search_Text,
          'TableName': "",
          'FrmName': "",
          'GridName': "",
          'SR_No': "",
          'Field_Name': "",
          'P_SR_No': "",
          'LINK': "",
        },
      );

      // Handle response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        debugPrint("⚠️ Invalid token or user ID. Logged out.");
      } else {
        // Check if 'message' is a valid list
        if (data.containsKey('message') && data['message'] is List) {
          if (data['settings']?['success'] == "1") {
            // Map category list with both value and code
            itemName_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Item Name loaded: ${itemName_List.length}");
          } else {
            itemName_List = [];
            selecteditemName="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          itemName_List = [];
          selecteditemName="";
          debugPrint("⚠️ Invalid message format.");
        }
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('❌ FetchCategoryList Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchItemUnitListFromAPI(String URN,String IT_CODE,) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/Item_Unit_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=2, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/Item_Unit_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'item_filertext': "",
          'TableName': "",
          'FrmName': "",
          'GridName': "",
          'SR_No': "",
          'Field_Name': "",
          'P_SR_No': "",
          'LINK': "",
          'M_IT_CODE': IT_CODE,
        },
      );

      // Handle response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        debugPrint("⚠️ Invalid token or user ID. Logged out.");
      } else {
        // Check if 'message' is a valid list
        if (data.containsKey('message') && data['message'] is List) {
          if (data['settings']?['success'] == "1") {
            // Map category list with both value and code
            UOM_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ UOM loaded: ${UOM_List.length}");

          } else {
            UOM_List = [];
            selectedUOM="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          UOM_List = [];
          selectedUOM="";
          debugPrint("⚠️ Invalid message format.");
        }
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('❌ FetchCategoryList Error: $e');
      return null;
    }
  }

  Future<void> submitForm(Map<String, dynamic> fieldString, String URN_NO,String Mode,String SR_No) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final Map<String, dynamic> payload = {
        'CO_CODE': coCode,
        'UR_CODE': "2",
        'Access_Token': token,
        'O_URN_No': urnNo,
        'URN_No': URN_NO,
        'SR_No': SR_No,
        'Mode': Mode,
        'FieldString': jsonEncode(fieldString),
      };

      log("📦 Recovery Submit Payload:\n${jsonEncode(payload)}");

      final response = await apiService.post(
        'Recovery/Insert_Data_For_Machine_Recovery',
        data: payload,
      );

      // ✅ Log API response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      log("✅ Recovery/Insert_Data_For_Machine_Recovery:\n$data");
      if(Mode =="Master"){
        final context = NavKey.navKey.currentState!.context;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Recovery_List()),
        );
        isInitialized = false;
      }else{
        final context = NavKey.navKey.currentState!.context;
        Navigator.pop(context);
        Get_Recovery_List(URN_NO,"");
      }



      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ submitForm Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  Future<void> init(URNNO,Mode,DocNo,Category) async {
    Doc_No =DocNo;
    selectedCategory =Category;

    if(Mode=="Edit"){
      await Get_Recovery_List(URNNO,"");
    }

    if (dateController.text.isEmpty) {
      final now = DateTime.now();
      dateController.text =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    }


    // notifyListeners();
  }

  void clearMainForm() {
    Doc_No ="";
    categoryName_List = [];
    selectedCategory = "";
    selectedCategoryId = "";
    dateController.clear();
    Remarks_Controller.clear();
    Machine_Name_List=[];
    selectedMachine="";
    selectedMachine_ID="";
    Send_To_List=[];
    selectedSendto="";
    selectedSendto_ID="";
    Department_List=[];
    selectedDepartment="";
    selectedDepartment_ID="";
    breakdownTimeController.clear();
    Memo_ByController.clear();
    isInitialized=false;
    RecoveryTimeController.clear();
    AttendantController.clear();

    // notifyListeners();


  }

  Future<void> Get_Recovery_List(String URNNO,String Sr_no,) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);
      final response = await apiService.get(
        'Recovery/Get_Recovery_List',
        queryParameters: {
          'URN_No': URNNO,
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'SR_No': Sr_no,
        },
      );

      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['settings']?['success'] == "1" && data['message'] is List) {

        if(Sr_no==""){
          dateController.text = data['message'][0]['Doc_Date'];
          selectedCategoryId = data['message'][0]['Category_URN_No'];
          selectedCategory = data['message'][0]['Category_Name'];
          selectedCategory = data['message'][0]['Category_Name'];
          selectedMachine = data['message'][0]['MAchine_Name'];
          selectedMachine_ID = data['message'][0]['Machine_CODE'];
          selectedDepartment = data['message'][0]['Department_Name'];
          selectedDepartment_ID = data['message'][0]['Department_URN_No'];
          breakdownTimeController.text = data['message'][0]['Break_Down_Time'];
          RecoveryTimeController.text =data['message'][0]['Recovery_Time'];
          selectedSendto_ID =data['message'][0]['Send_To_URN_No'];
          selectedSendto =data['message'][0]['Send_To_Name'];
          AttendantController.text =data['message'][0]['Attendent_Name'];


          if (data['Grid_data'] is List) {
            productList = List<Map<String, dynamic>>.from(data['Grid_data']);
          } else {
            productList = [];
          }

          if (data['Item_data'] is List) {
            product_Item_List = List<Map<String, dynamic>>.from(data['Item_data']);
          } else {
            product_Item_List = [];
          }
        }else{


        }



        notifyListeners();

      } else {
        // Production_List = [];
        debugPrint("⚠️ No valid data found or success != 1");
      }

      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ getTransferMemoList Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }
}
