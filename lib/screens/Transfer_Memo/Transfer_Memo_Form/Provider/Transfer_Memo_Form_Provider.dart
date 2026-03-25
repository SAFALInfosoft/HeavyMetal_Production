import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../GlobalComponents/PreferenceManager.dart';
import '../../../../GlobalComponents/api_service.dart';
import '../../../../widgets/bottomsheetSelection.dart';
import '../../../../widgets/customInputDecoration.dart';
import '../../Transfer_Memo_List/Transfer_Memo_List_Screen.dart';
import '../Model/ProductModel.dart';

class Transfer_Memo_Form_Provider extends ChangeNotifier {
  late double height;
  late double width;

  bool isRunning = false;
  String selectedMachine = "";

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
  final FinishedTubeSize_Controller  = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TextEditingController odMmController = TextEditingController();
  TextEditingController G_RemarksController = TextEditingController();
  TextEditingController thkMinController = TextEditingController();
  TextEditingController thkMaxController = TextEditingController();
  TextEditingController thkMmController = TextEditingController();
  TextEditingController lengthMinController = TextEditingController();
  TextEditingController lengthMaxController = TextEditingController();
  TextEditingController Piece_lengthController = TextEditingController();
  TextEditingController noOfPiecesController = TextEditingController();
  // TextEditingController weightController = TextEditingController();


  bool isTransferMemoExpanded = true;

  void toggleTransferMemoExpansion() {
    isTransferMemoExpanded = !isTransferMemoExpanded;
    notifyListeners();
  }



  List<Map<String, String>> categoryName_List = [];

  String? selectedCategory;

  String selectedCategoryId="";




  List<Map<String, String>> WO_No_List = [];
  String selectedWO_No_ID="";
  String selectedWO_No="";

  List<Map<String, String>> Memo_Type_List = [];
  String selectedMemoTyppe="";
  String selectedMemoTyppe_ID="";

  List<String> Finished_Tube_Size_List = ["Size 1", "Size 2", "Size 3"];
  String? selectedFinishedTubeSize;

  List<Map<String, String>> Department_List = [];
  String selectedDepartment="";
  String selectedDepartment_ID="";

  List<Map<String, String>> Party_List = [];
  String selectedPartyName="";
  String selectedPartyName_ID="";

  List<Map<String, String>> itemName_List = [];
  String selecteditemName="";
  String selecteditemName_ID="";

  List<Map<String, String>> Grade_List = [];
  String selectedGrade="";
  String selectedGrade_ID="";

  List<Map<String, String>> UOM_List = [];
  String selectedUOM="";
  String selectedUOM_ID="";

  List<Map<String, String>> Location_List = [];
  String selectedLocation="";
  String selectedLocation_ID="";

  String selectedNextLocation="";
  String selectedNextLocation_ID="";

  List<Map<String, String>> Specification_List = [];
  String selectedSpecification="";
  String selectedSpecification_ID="";

  List<Map<String, String>> Heat_No_List = [];
  String selectedHeat_No="";
  String selectedHeat_No_ID="";


  List<String> ProcessList = ["Process A", "Process B", "Process C"];
  String? selectedProcess;

  String? selectedItemName;
  List<String> ItemName_List = ["Tube", "Pipe", "Rod"];

  bool isInitialized = false;


  List<Map<String, dynamic>> productList = [];




  bool isLoading=false;

  var Doc_No;

  bool _isUpdating = false;




  /// Called when MIN or MAX changes → update MM
  void updateFromMinMax() {
    if (_isUpdating) return;
    _isUpdating = true;

    final double? min = double.tryParse(thkMinController.text);
    final double? max = double.tryParse(thkMaxController.text);

    if (min != null && max != null) {
      final double avg = (min + max) / 2;
      thkMmController.text = avg.toStringAsFixed(2);
    } else {
      thkMmController.clear();
    }

    _isUpdating = false;
    notifyListeners();
  }

  /// Called when MM changes → update missing MIN or MAX
  void updateFromMm() {
    if (_isUpdating) return;
    _isUpdating = true;

    final double? mm = double.tryParse(thkMmController.text);
    final double? min = double.tryParse(thkMinController.text);
    final double? max = double.tryParse(thkMaxController.text);

    if (mm != null) {
      if (min != null && (max == null || max.isNaN)) {
        final double calcMax = (2 * mm) - min;
        thkMaxController.text = calcMax.toStringAsFixed(2);
      } else if (max != null && (min == null || min.isNaN)) {
        final double calcMin = (2 * mm) - max;
        thkMinController.text = calcMin.toStringAsFixed(2);
      }
    }

    _isUpdating = false;
    notifyListeners();
  }

  void updateFromlengthMin() {
    if (_isUpdating) return;
    _isUpdating = true;

    final double? min = double.tryParse(lengthMinController.text);
    final double? max = double.tryParse(lengthMaxController.text);

    if (min != null && max != null) {
      final avg = (min + max) / 2;
      Piece_lengthController.text = avg.toStringAsFixed(2);
    } else {
      Piece_lengthController.clear();
    }

    _isUpdating = false;
    notifyListeners();
  }

  /// Called when Length MAX changes
  void updateFromLengthMAX() {
    if (_isUpdating) return;
    _isUpdating = true;

    final double? min = double.tryParse(lengthMinController.text);
    final double? max = double.tryParse(lengthMaxController.text);

    if (min != null && max != null) {
      final avg = (min + max) / 2;
      Piece_lengthController.text = avg.toStringAsFixed(2);
    } else {
      Piece_lengthController.clear();
    }

    _isUpdating = false;
    notifyListeners();
  }

  /// Called when Piece Length changes
  void updateFromPiecelength() {
    if (_isUpdating) return;
    _isUpdating = true;

    final double? piece = double.tryParse(Piece_lengthController.text);
    final double? min = double.tryParse(lengthMinController.text);
    final double? max = double.tryParse(lengthMaxController.text);

    if (piece != null) {
      if (min != null && (max == null || max.isNaN)) {
        final calcMax = (2 * piece) - min;
        lengthMaxController.text = calcMax.toStringAsFixed(2);
      } else if (max != null && (min == null || min.isNaN)) {
        final calcMin = (2 * piece) - max;
        lengthMinController.text = calcMin.toStringAsFixed(2);
      }
    }

    _isUpdating = false;
    notifyListeners();
  }


  void calculateWeight() {
    final itemName = selecteditemName?.toLowerCase() ?? "";

    final od = double.tryParse(odMmController.text) ?? 0.0;
    final thkMin = double.tryParse(thkMinController.text) ?? 0.0;
    final thkMax = double.tryParse(thkMaxController.text) ?? 0.0;
    final lenMin = double.tryParse(lengthMinController.text) ?? 0.0;
    final lenMax = double.tryParse(lengthMaxController.text) ?? 0.0;
    final pieces = double.tryParse(noOfPiecesController.text) ?? 0.0;

    double qtyWeight = 0.0;

    if (itemName.contains("pipe") || itemName.contains("tube")) {
      qtyWeight = (((od - ((thkMin + thkMax) / 2)) *
          ((thkMin + thkMax) / 2) ) *
          ((lenMin + lenMax) / 2) *
          pieces)*0.0246;
    } else if (itemName.contains("bar")) {
      qtyWeight = 0.006125 *
          (od * od * pieces * ((lenMin + lenMax) / 2) / 1000);
    }

    weightController.text = qtyWeight.toStringAsFixed(2);
    notifyListeners();
  }





  void removeProduct(int index) {
    productList.removeAt(index);
    notifyListeners();
  }


  void clearProductForm() {
    itemName_List = [];
    selecteditemName = "";
    odMmController.clear();
    G_RemarksController.clear();
    thkMinController.clear();
    thkMaxController.clear();
    thkMmController.clear();
    lengthMinController.clear();
    lengthMaxController.clear();
    noOfPiecesController.clear();
    weightController.clear();

    Grade_List = [];
    selectedGrade = "";
    selectedGrade_ID = "";

    UOM_List = [];
    selectedUOM = "";
    selectedUOM_ID = "";

    Location_List = [];
    selectedLocation = "";
    selectedLocation_ID = "";
    selectedNextLocation = "";
    selectedNextLocation_ID = "";

    Specification_List = [];
    selectedSpecification = "";
    selectedSpecification_ID = "";

    Heat_No_List = [];
    selectedHeat_No = "";
    selectedHeat_No_ID = "";

    notifyListeners();
  }

  void clearMainForm() {
    categoryName_List = [];
    selectedCategory = "";
    selectedCategoryId = "";
    WO_No_List = [];
    selectedWO_No_ID = "";
    selectedWO_No = "";
    Memo_Type_List = [];
    selectedMemoTyppe = "";
    selectedMemoTyppe_ID = "";
    Department_List = [];
    selectedDepartment = "";
    selectedDepartment_ID = "";
    Party_List = [];
    selectedPartyName = "";
    selectedPartyName_ID = "";
    Doc_No="";
    dateController.clear();
    Remarks_Controller.clear();
    FinishedTubeSize_Controller.clear();

    notifyListeners();
  }





  void setItem(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  List<String> gradeList = ["A", "B", "C", "D"];

  List<String> specList = ["Spec 1", "Spec 2", "Spec 3"];
  String? selectedSpec;


  final TextEditingController searchController = TextEditingController();
  List<String> filteredList = [];

  final List<Map<String, String>> machines = [
    {"value": "Machine 3", "label": "Machine 3"},
    {"value": "Machine 4", "label": "Machine 4"},
    {"value": "All", "label": "All Machines"},
  ];

  void startMachine(String machine) {
    isRunning = true;
    selectedMachine = machine;
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
    selectedMachine = "";
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
      maxDuration: const Duration(minutes: 2), // limit video duration if needed
    );

    if (pickedFile != null) {
      selectedVideo = File(pickedFile.path);
      notifyListeners();
    }
  }




  Transfer_Memo_Form_Provider() {
    final context = NavKey.navKey.currentState!.context;
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }

  @override
  void dispose() {
    _timer?.cancel();
    thkMinController.dispose();
    thkMaxController.dispose();
    thkMmController.dispose();
    super.dispose();
  }

  Future<void> init(URNNO,Mode,DocNo,Category) async {
    Doc_No =DocNo;
    selectedCategory =Category;

    if(Mode=="Edit"){
      await getTransferMemoList(URNNO,"");
    }

    if (dateController.text.isEmpty) {
      final now = DateTime.now();
      dateController.text =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    }

    // notifyListeners();
  }


  Future<Map<String, dynamic>?> fetchCategoryListFromAPI(String URN,String Search_text) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/List_Of_Category_IN_Transfer params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
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
          'UR_CODE': "1",
          'item_filertext': Search_text,
          'TableName': "",
          'FrmName': "frmTransferMemo",
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
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/Generate_New_DOC_No',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': token.toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
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

  Future<Map<String, dynamic>?> fetchWO_NoListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/Wo_No_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/Wo_No_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
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
            WO_No_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ WO No loaded: ${WO_No_List.length}");
          } else {
            WO_No_List = [];
            selectedWO_No_ID="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          WO_No_List = [];
          selectedWO_No_ID="";
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


  Future<Map<String, dynamic>?> fetchMemoTypeListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/List_MemoType params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/List_MemoType',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
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
            Memo_Type_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Memo Type loaded: ${Memo_Type_List.length}");
          } else {
            Memo_Type_List = [];
            selectedMemoTyppe="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Memo_Type_List = [];
          selectedMemoTyppe="";
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

  Future<Map<String, dynamic>?> fetchDepartmentListFromAPI(String URN,String Search_text) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/Department_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
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
          'UR_CODE': "1",
          'item_filertext': Search_text,
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

  Future<Map<String, dynamic>?> fetchPartyListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/Suppiler_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/Suppiler_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
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
            Party_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Party List loaded: ${Party_List.length}");
          } else {
            Party_List = [];
            selectedPartyName="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Party_List = [];
          selectedPartyName="";
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
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
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
          'UR_CODE': "1",
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
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
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
          'UR_CODE': "1",
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

  Future<Map<String, dynamic>?> fetchgradeListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/Grade_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/Grade_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
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
            Grade_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Grade loaded: ${Grade_List.length}");
          } else {
            Grade_List = [];
            selectedGrade="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Grade_List = [];
          selectedGrade="";
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

  Future<Map<String, dynamic>?> fetchLocationListFromAPI(String URN,String Search_text) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/Location_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/Location_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
          'item_filertext': Search_text,
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
            Location_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Location loaded: ${Grade_List.length}");
          } else {
            Location_List = [];
            selectedLocation="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Location_List = [];
          selectedLocation="";
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

  Future<Map<String, dynamic>?> fetchSpecificationListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/Specification_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/Specification_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
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
            Specification_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Specification loaded: ${Specification_List.length}");
          } else {
            Specification_List = [];
            selectedSpecification="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Specification_List = [];
          selectedSpecification="";
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

  Future<Map<String, dynamic>?> fetchHeatNoListFromAPI(String URN) async {
    try {
      // Read stored values
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Transfer/Heat_No_List params: '
            'New_URN_No=$URN, O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, UR_CODE=1, '
            'item_filertext= , TableName= , FrmName= , GridName= , SR_No= , Field_Name= , '
            'P_SR_No= , LINK= , DB_CODE_= ',
      );

      // API call
      final response = await apiService.get(
        'Transfer/Heat_No_List',
        queryParameters: {
          'New_URN_No': URN.toString(),
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
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
            Heat_No_List = (data['message'] as List)
                .map((item) => {
              "Select_Value": item["Select_Value"]?.toString() ?? "",
              "Select_Value_Code": item["Select_Value_Code"]?.toString() ?? "",
            })
                .toList();
            debugPrint("✅ Heat No loaded: ${Heat_No_List.length}");
          } else {
            Heat_No_List = [];
            selectedHeat_No="";
            debugPrint("⚠️ No success flag or empty list received.");
          }
        } else {
          Heat_No_List = [];
          selectedHeat_No="";
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
        'UR_CODE': "1",
        'Access_Token': token,
        'O_URN_No': urnNo,
        'URN_No': URN_NO,
        'SR_No': SR_No,
        'Mode': Mode,
        'FieldString': jsonEncode(fieldString),
      };

      // ✅ Log the complete payload for debugging
      log("📦 Transfer Memo Submit Payload:\n${jsonEncode(payload)}");

      final response = await apiService.post(
        'Transfer/Insert_Data_For_Transfer_Memo',
        data: payload,
      );

      // ✅ Log API response
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      log("✅ Transfer/Insert_Data_For_Transfer_Memo Response:\n$data");
      if(Mode =="Master"){
        final context = NavKey.navKey.currentState!.context;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Transfer_Memo_List()),
        );
        isInitialized = false;
      }else{
        final context = NavKey.navKey.currentState!.context;
        Navigator.pop(context);
        getTransferMemoList(URN_NO,"");
      }



      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ submitForm Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  Future<void> getTransferMemoList(String URNNO,String Sr_no,) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final response = await apiService.get(
        'Transfer/Get_Transfer_Memo_Data',
        queryParameters: {
          'URN_No': URNNO,
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
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
          selectedWO_No_ID = data['message'][0]['WO_No_URN_No'];
          selectedWO_No = data['message'][0]['WO_No'];
          selectedMemoTyppe_ID = data['message'][0]['Memo_Type_ID'];
          selectedMemoTyppe = data['message'][0]['Memo_Type'];
          selectedDepartment_ID = data['message'][0]['Department_URN_No'];
          selectedDepartment = data['message'][0]['Department_Name'];
          selectedPartyName_ID = data['message'][0]['Party_URN_No'];
          selectedPartyName = data['message'][0]['Party_name'];
          FinishedTubeSize_Controller.text = data['message'][0]['Finished_Tubes_Size'];
          Remarks_Controller.text = data['message'][0]['Remarks'];

          if (data['Grid_data'] is List) {
            productList = List<Map<String, dynamic>>.from(data['Grid_data']);
          } else {
            productList = [];
          }
        }else{
          selecteditemName_ID = data['message'][0]['Item_ID'];
          selecteditemName = data['message'][0]['Item_name'];
          selectedGrade_ID = data['message'][0]['Grade_URN_No'];
          selectedGrade = data['message'][0]['Grade_Name'];
          odMmController.text = data['message'][0]['OD_MM'].toString();
          thkMinController.text = data['message'][0]['THK_MIN'].toString();
          thkMaxController.text = data['message'][0]['THK_MAX'].toString();
          thkMmController.text = data['message'][0]['THK_MM'].toString();
          lengthMinController.text = data['message'][0]['Length_MIN'].toString();
          lengthMaxController.text = data['message'][0]['Length_MAX'].toString();
          noOfPiecesController.text = data['message'][0]['No_Of_Piece'].toString();
          weightController.text = data['message'][0]['Quantity'].toString();
          selectedUOM_ID = data['message'][0]['UOM_URN_No'].toString();
          selectedUOM = data['message'][0]['UOM_Name'].toString();
          selectedLocation_ID = data['message'][0]['Location_Code'].toString();
          selectedLocation = data['message'][0]['Location_Name'].toString();
          selectedNextLocation_ID = data['message'][0]['Next_Location_code'].toString();
          selectedNextLocation = data['message'][0]['Next_Location_Name'].toString();
          selectedSpecification_ID = data['message'][0]['Specification_URN_No'].toString();
          selectedSpecification = data['message'][0]['Specification_Name'].toString();
          selectedHeat_No_ID = data['message'][0]['Heat_No'].toString();
          selectedHeat_No = data['message'][0]['Heat_No'].toString();
          G_RemarksController.text = data['message'][0]['Remarks'].toString();
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



