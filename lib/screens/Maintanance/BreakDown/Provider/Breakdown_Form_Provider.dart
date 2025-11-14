import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../GlobalComponents/PreferenceManager.dart';
import '../../../../GlobalComponents/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../BreakDown_Listing/BreakDown_List.dart';


class Breakdown_Form_Provider extends ChangeNotifier {
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
  final TextEditingController RemarksController = TextEditingController();

  bool isTransferMemoExpanded = true;

  List<Map<String, dynamic>> productList = [];

  bool isInitialized = false;

  void clearProductForm() {
    productList.clear();
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
  String? base64Image;
  List<File> selectedImages = [];
  List<String> base64Images = [];
  List<ApiImageItem> apiImages = [];


  Future<void> pickImage({
    bool fromCamera = false,
    required String URN_NO,
  }) async {
    try {
      // Step 1️⃣ Pick a single image (no multi-select)
      final XFile? pickedFile = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 70,
      );

      // Step 2️⃣ If user selected an image, upload it immediately
      if (pickedFile != null) {
        await _addImageAndUpload(pickedFile, URN_NO);

        // Step 3️⃣ After upload, ask user if they want to add another image
        await _askToAddAnotherImage(URN_NO);
      } else {
        debugPrint("❌ No image selected");
      }
    } catch (e) {
      debugPrint("⚠️ Image pick error: $e");
    }
  }

  Future<void> _askToAddAnotherImage(String URN_NO) async {
    // Use `BuildContext` safely by passing it from the UI
    final context = navigatorKey.currentContext; // You can keep a GlobalKey<NavigatorState>

    if (context == null) return;

    final shouldAddAnother = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Upload Another Image?"),
        content: const Text("Do you want to add another image?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (shouldAddAnother == true) {
      await pickImage(fromCamera: false, URN_NO: URN_NO);
    }
  }



  /// Add image to local list and upload immediately
  Future<void> _addImageAndUpload(XFile file, String URN_NO) async {
    final File imageFile = File(file.path);
    final bytes = await file.readAsBytes();
    final base64String = base64Encode(bytes);

    // selectedImages.add(imageFile);
    base64Images.add(base64String);

    notifyListeners();

    debugPrint("✅ Added image: ${file.name}");

    await _uploadSingleImage(base64String, URN_NO);
  }


  /// Upload a single image to API
  // Future<void> _uploadSingleImage(String base64Image) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(uploadApiUrl),
  //       headers: {
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({
  //         "image": base64Image,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       debugPrint("✅ Image uploaded successfully");
  //     } else {
  //       debugPrint(
  //           "❌ Upload failed: ${response.statusCode} - ${response.body}");
  //     }
  //   } catch (e) {
  //     debugPrint("⚠️ Upload error: $e");
  //   }
  // }

  Future<bool> _uploadSingleImage(String base64Image,URN_NO) async {
    final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
    final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);
    final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
    final token = await PreferenceManager.instance.getStringValue('Access_Token');
    final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
    final payload = {
      'Image_Path': base64Image,
      'Vary': "Breakdown",
      'Image_name': "Breakdown",
      'CO_CODE': coCode,
      'UR_CODE': "2",
      'O_URN_No': urnNo,
      'Access_Token': token,
      'URN_No': URN_NO,
    };

    try {
      final response = await apiService.post('BreakDown/UploadImage', data: payload);

      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data["settings"]["success"].toString()=="1"){
        Get_Images(URN_NO);
      }


      return false; // failed
    } catch (e) {
      debugPrint('❌ Login Error: $e');
      return false;
    }
  }


  Future<Map<String, dynamic>?> Get_Images(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);



      // API call
      final response = await apiService.get(
        'BreakDown/Get_Images',
        queryParameters: {
          'URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'Vary': "Breakdown",
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
        if (data['settings']?['success'] == "1") {
          loadImagesFromApi(data); // ✅ add this line
        }
      }

      notifyListeners();
      return data;
    } catch (e) {
      debugPrint('❌ FetchCategoryList Error: $e');
      return null;
    }
  }

  void loadImagesFromApi(Map<String, dynamic> data) {
    apiImages.clear();

    if (data["message"] != null && data["message"] is List) {
      for (var item in data["message"]) {
        final base64String = item["image_path1"];
        final srNo = item["Sr_No"];

        if (base64String != null && base64String.toString().isNotEmpty) {
          try {
            final bytes = base64Decode(base64String);
            apiImages.add(ApiImageItem(bytes: bytes, srNo: srNo));
          } catch (e) {
            debugPrint("⚠️ Base64 decode error: $e");
          }
        }
      }
    }

    debugPrint("✅ Loaded ${apiImages.length} images from API");
    notifyListeners();
  }


  /// Remove an image
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      base64Images.removeAt(index);
      notifyListeners();
    }
  }

  /// Clear all images
  void clearAllImages() {
    selectedImages.clear();
    base64Images.clear();
    notifyListeners();
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


  Breakdown_Form_Provider() {
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
          'FrmName': "frmBreakdown",
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
          'FrmName': "frmBreakdown",
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
          'FrmName': "frmBreakdown",
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

      log("📦 Transfer Memo Submit Payload:\n${jsonEncode(payload)}");

      final response = await apiService.post(
        'BreakDown/Insert_Data_For_Machine_Breakdown',
        data: payload,
      );

      // ✅ Log API response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      log("✅ Transfer/Insert_Data_For_Transfer_Memo Response:\n$data");
      if(Mode =="Master"){
        clearMainForm();
        clearProductForm();
        final context = NavKey.navKey.currentState!.context;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BreakDown_List()),
        );
        isInitialized = false;
      }else{
        final context = NavKey.navKey.currentState!.context;
        Navigator.pop(context);
        getBreakDownList(URN_NO,"");
      }



      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ submitForm Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }


  Future<void> deleteImage(String SR_No,String URN_NO) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final Map<String, dynamic> payload = {
        'URN_No': URN_NO,
        'O_URN_No': urnNo,
        'Access_Token': token,
        'CO_CODE': coCode,
        'UR_CODE': "2",
        'Vary': "Breakdown",
        'Sr_No': SR_No,
      };

      log("📦 Transfer Memo Submit Payload:\n${jsonEncode(payload)}");

      final response = await apiService.post(
        'BreakDown/Delete_Images',
        data: payload,
      );

      // ✅ Log API response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      log("✅ BreakDown/Delete_Images Response:\n$data");
      Get_Images(URN_NO);



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
      await getBreakDownList(URNNO,"");
      Get_Images(URNNO);
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
    selectedImages=[];
    apiImages=[];
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


  }

  Future<void> getBreakDownList(String URNNO,String Sr_no,) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);
      final response = await apiService.get(
        'BreakDown/Get_BreakDown_List',
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



          if (data['Grid_data'] is List) {
            productList = List<Map<String, dynamic>>.from(data['Grid_data']);
          } else {
            productList = [];
          }
        }else{
          selectedSubHead_ID = data['message'][0]['MAchine_sub_Head_Value'];
          selectedSubHead = data['message'][0]['Machine_Sub_Head'];
          selectedBreak_Detail_ID =data['message'][0]['Breck_Down_Detail_URN_No'];
          selectedBreak_Detail = data['message'][0]['Breck_Down_Detail'];
          selectedStd_Time_Min = data['message'][0]['Standard_Time_MIn'].toString();
          selectedStd_Time_Min_ID = data['message'][0]['Standard_Time_MIn_URN_No'];
          RemarksController.text = data['message'][0]['Remarks'];
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

class ApiImageItem {
  final Uint8List bytes;
  final int srNo;

  ApiImageItem({required this.bytes, required this.srNo});
}

