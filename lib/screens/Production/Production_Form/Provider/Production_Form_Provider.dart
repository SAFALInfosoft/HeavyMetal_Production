import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../GlobalComponents/PreferenceManager.dart';
import '../../../../GlobalComponents/api_service.dart';
import '../../../Login_Screens/Login_Page.dart';
import '../Model/Card_No_Get_Model.dart';
import '../Model/Matchine_Name_Get_Model.dart';
import '../Model/Process_Get_Model.dart';
import '../Model/URN_No_Model.dart';

// import 'package:record/record.dart';


class Production_Form_Provider extends ChangeNotifier {
  late double height;
  late double width;

  bool isRunning = false;
  String selectedMachine = "";

  List<Widget> tables = [];

  var weight;
  var length;
  var number;
  var extra;

  int addCount = 0;
  int waitSeconds = 0;
  int waitSeconds_Drop = 0;

  ProcessCardMessage? selectedCard;     // countdown seconds
  bool _isProcesscard = true;

  String? errorMessage;

  Future<void> init() async {
    if(_isProcesscard ==true){
      await _loadProcessCardList();

    }
  }



  // countdown seconds

  void incrementAddCount(fieldstringJson) {
    addCount++;
    startCountdown();


    notifyListeners();
  }
  void incrementAddCount_Drop(fieldstringJson) {
    addCount++;
    startCountdown_Drop();
    // Update_Data(fieldstringJson);

    notifyListeners();
  }

  void startCountdown() {
    waitSeconds = 30;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (waitSeconds > 0) {
        waitSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void startCountdown_Drop() {
    waitSeconds_Drop = 30;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (waitSeconds_Drop > 0) {
        waitSeconds_Drop--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

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

  List<ProcessCardMessage> processCardItems = [];

  List<MachineItem> MatchineItems = [];
  List<ProcessItem> ProcessItems = [];
  String selectedItemUrn="";
  String? selectedProcessUrn;
  String? selectedProcessName;
  String? selectedvary;
  String? selectedSr_No;

  List<String> ProcessList = ["Process A", "Process B", "Process C"];
  String? selectedProcess;

  final context = NavKey.navKey.currentState!.context;

  String? generatedUrn;


  // final AudioRecorder _audioRecorder = AudioRecorder();
  // bool isRecording = false;
  // String? recordedFilePath;
  //
  // Future<void> toggleAudioRecording() async {
  //   if (isRecording) {
  //     // 🔴 Stop recording
  //     recordedFilePath = await _audioRecorder.stop();
  //     isRecording = false;
  //   } else {
  //     // 🟢 Start recording
  //     if (await _audioRecorder.hasPermission()) {
  //       recordedFilePath = null; // reset
  //       await _audioRecorder.start(
  //         const RecordConfig(
  //           encoder: AudioEncoder.aacLc,
  //           bitRate: 128000,
  //           sampleRate: 44100,
  //         ),
  //         path: null!, // let plugin choose temporary file path
  //       );
  //       isRecording = true;
  //     }
  //   }
  //   notifyListeners();
  // }


  // void setItem(String value) {
  //   selectedItem = value;
  //   notifyListeners();
  // }


  List<String> gradeList = ["A", "B", "C", "D"];
  String? selectedGrade;


  // Specification dropdown
  List<String> specList = ["Spec 1", "Spec 2", "Spec 3"];
  String? selectedSpec;

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

  // void startCountdown(int seconds) {
  //   countdown = seconds;
  //   _timer?.cancel();
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (countdown > 0) {
  //       countdown--;
  //       notifyListeners();
  //     } else {
  //       timer.cancel();
  //     }
  //   });
  //   notifyListeners();
  // }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }


  void stopMachine(String machine) {
    isRunning = false;
    selectedMachine = machine;
    notifyListeners();
  }

  Production_Form_Provider() {

    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  Map<String, dynamic>? processCardData;
  bool isLoading = true;





  Future<Map<String, dynamic>?> _loadProcessCardList()  async{
    try {
      // Read stored values from SharedPreferences
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint('➡️ GET Production/LIST_FOR_Process_Card params: '
          'O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode');
      _isProcesscard = false;

      final response = await apiService.get(
        'Production/LIST_FOR_Process_Card',
        queryParameters: {
          'O_URN_No': urnNo.toString(),
          'Access_Token': token.toString(),
          'CO_CODE': coCode.toString(),
        },
      );

      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);
      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        clearMainForm();


      }

      final processCard = ProcessCardResponse.fromJson(data);



// store full objects
      processCardItems = processCard.message;


      notifyListeners();
    } catch (e) {
      debugPrint('❌ Fetch ProcessCard Error: $e');
      return null;
    }
  }


  Future<void> loadMachineList() async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Production/LIST_OF_Machine params: '
            'O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, '
            'URN_No=${selectedCard?.processCardUrnNo}',
      );

      final response = await apiService.get(
        'Production/LIST_OF_Machine',
        queryParameters: {
          'O_URN_No': urnNo,
          'Access_Token': token,
          'CO_CODE': coCode,
          'URN_No': selectedCard?.processCardUrnNo ?? '',
        },
      );

      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      final MatchineItem = MachineListResponse.fromJson(data);

// store full objects
      MatchineItems = MatchineItem.message;

      // final processCard = ProcessCardResponse.fromJson(data);
      // processCardItems = processCard.message;

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Fetch Machine List Error: $e');
    }
  }

  Future<void> loadProcessList() async {
    try {
      final urnNo  = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token  = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      debugPrint(
        '➡️ GET Production/LIST_OF_Process params: '
            'O_URN_No=$urnNo, Access_Token=$token, CO_CODE=$coCode, '
            'URN_No=${selectedCard?.processCardUrnNo}',
      );

      final response = await apiService.get(
        'Production/LIST_OF_Process',
        queryParameters: {
          'O_URN_No': urnNo,
          'Access_Token': token,
          'CO_CODE': coCode,
          'URN_No': selectedCard?.processCardUrnNo ?? '',
        },
      );

      log('Process API raw response: $response');

      // Ensure we have a Map<String, dynamic>
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      final processResponse = ProcessResponse.fromJson(data);

      // Store the full list of ProcessItem objects
      ProcessItems = processResponse.message;

      // Trigger UI update
      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ Fetch Process List Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }



  Future<void> generateUrnNo() async {
    try {
      final urnNo  = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token  = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL');
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final response = await apiService.post(
        'Production/Generate_URN_No',
        data: {
          'O_URN_No': urnNo,
          'User_Id': "2",
          'Access_Token': token,
          'Co_Code': coCode,
          'Vary': selectedvary,
        },
      );

      // Convert to Map
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      // Parse into model
      final generateUrnResponse = GenerateUrnResponse.fromJson(data);

      // Store the first URN_No (if exists) in a variable
      if (generateUrnResponse.message.isNotEmpty) {
        generatedUrn = generateUrnResponse.message.first.urnNo;
        debugPrint('✅ Generated URN: $generatedUrn');
      } else {
        generatedUrn = null;
        debugPrint('⚠️ No URN received');
      }

      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ Generate URN Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }


  Future<void> Update_Data(fieldstringJson,String Mode) async {
    try {
      final urnNo  = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token  = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final response = await apiService.post(
        'Production/Update_Data',
        data: {
          'CO_CODE': coCode,
          'User_Id': "2",
          'Access_Token': token,
          'Vary': selectedvary,
          'O_URN_No': urnNo,
          'Process_URN_NO': selectedItemUrn,
          'NEW_URN_No': generatedUrn,
          'Location': selectedProcessUrn,
          'Sr_No': selectedSr_No,
          'FieldString': fieldstringJson,
        },
      );

      // Convert to Map
      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['settings']['success'].toString() == "0") {
        showDialog(
          context: context,
          barrierDismissible: false, // user must press OK
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // title: Text(
              //   "Error",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 18,
              //   ),
              // ),
              content: Text(
                data['message'].toString(),
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }else{
        if(Mode == "Add"){
          incrementAddCount(fieldstringJson);
        }else if(Mode == "Drop"){
          incrementAddCount_Drop(fieldstringJson);
        }

      }


      // Parse into model
      // final generateUrnResponse = GenerateUrnResponse.fromJson(data);

      // Store the first URN_No (if exists) in a variable
      // if (generateUrnResponse.message.isNotEmpty) {
      //   generatedUrn = generateUrnResponse.message.first.urnNo;
      //   debugPrint('✅ Generated URN: $generatedUrn');
      // } else {
      //   generatedUrn = null;
      //   debugPrint('⚠️ No URN received');
      // }

      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ Generate URN Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }





  void setSelectedCard(String? urn) {
    selectedItemUrn = urn.toString();
    selectedCard = processCardItems.firstWhere(
          (e) => e.processCardUrnNo == urn,
      orElse: () => ProcessCardMessage(
        processCardUrnNo: '',
        woNo: '',
        customerName: '',
        Process_Doc_No: '',
        qty: 0,
        Wo_No_Doc: '',
        Round_Bar_Qty: 0,
        Size: 0,

      ),
    );
    notifyListeners();
  }

  void setError(String msg) {
    errorMessage = msg;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null!;
    notifyListeners();
  }

  void clearMainForm() {

    selectedItemUrn ="";
    selectedProcessUrn =null;
    selectedProcessName =null;
    selectedvary =null;
    selectedSr_No ="";
    selectedProcess ="";
    generatedUrn ="";
    isRunning =false;
    selectedMachine ="";
    _isProcesscard = true;
    Remarks_Controller.clear();
    processCardItems=[];
    ProcessItems = [];
    MatchineItems =[];
    selectedCard = null;
    waitSeconds=0;
    addCount=0;
  }

}
