import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../../../../GlobalComponents/PreferenceManager.dart';
import '../../../../../GlobalComponents/api_service.dart';
import '../../../../Login_Screens/Login_Page.dart';
import '../../../../Production/Production_Form/Model/URN_No_Model.dart';




class Recovery_List_Provider extends ChangeNotifier {
  late double height;
  late double width;



  bool isInitialized = false;

  String? generatedUrn;
  String? generatedCategory;
  String? generatedDoc_No;

  bool isLoading =false;

  Recovery_List_Provider() {
    final context = NavKey.navKey.currentState!.context;
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }

  Future<void> init(BuildContext context) async {
    await getRecoveryList(context);
    await getRecoveryEntryList(context);
  }

  final menuItems = [
    {
      "title": "Preventing",
      "icon": Icons.shield_outlined,
      "color": Colors.orange,
    },
    {
      "title": "Breakdown",
      "icon": Icons.construction,
      "color": Colors.red,
    },
    {
      "title": "Recovery",
      "icon": Icons.build_outlined,
      "color": Colors.blue,
    },
  ];

  List<Map<String, dynamic>> Recovery_List = [];
  List<Map<String, dynamic>> Recovery_Entry_List = [];

  TextEditingController pendingSearchController = TextEditingController();
  TextEditingController entrySearchController = TextEditingController();

  String pendingSearch = "";
  String entrySearch = "";

  /// 🔍 SET SEARCH TEXT
  void updatePendingSearch(String value) {
    pendingSearch = value.toLowerCase();
    notifyListeners();
  }

  void updateEntrySearch(String value) {
    entrySearch = value.toLowerCase();
    notifyListeners();
  }

  /// 🔍 FILTERED LISTS
  List<Map<String, dynamic>> get filteredPendingList {
    return Recovery_List.where((item) {
      final urn = item["URN_No"].toString().toLowerCase();
      final doc = item["Doc_No"].toString().toLowerCase();
      final machine = item["MAchine_Name"].toString().toLowerCase();
      final date = item["Doc_Date"].toString().toLowerCase();

      return urn.contains(pendingSearch) ||
          doc.contains(pendingSearch) ||
          machine.contains(pendingSearch) ||
          date.contains(pendingSearch);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredEntryList {
    return Recovery_Entry_List.where((item) {
      final urn = item["URN_No"].toString().toLowerCase();
      final doc = item["Doc_No"].toString().toLowerCase();
      final machine = item["MAchine_Name"].toString().toLowerCase();
      final date = item["Doc_Date"].toString().toLowerCase();

      return urn.contains(entrySearch) ||
          doc.contains(entrySearch) ||
          machine.contains(entrySearch) ||
          date.contains(entrySearch);
    }).toList();
  }

  void reload() {
    notifyListeners();
  }

  @override
  void dispose() {
    pendingSearchController.dispose();
    entrySearchController.dispose();
    super.dispose();
  }



  Future<void> generateUrnNo(BuildContext context) async {
    try {
      isLoading =true;
      notifyListeners();
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final response = await apiService.post(
        'Production/Generate_URN_No',
        data: {
          'O_URN_No': urnNo,
          'User_Id': "1",
          'Access_Token': token.toString(),
          'Co_Code': coCode,
          'Vary': "Recovery",
        },
      );

      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['settings'] != null && data['settings']['success'] == "0") {
        final String msg = data['message'] ?? "Something went wrong";



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
                msg.toString(),
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

        return;
      }

      // 🧩 Merge all maps inside message[]
      if (data['message'] != null && data['message'] is List) {
        final merged = <String, dynamic>{};
        for (var item in data['message']) {
          if (item is Map<String, dynamic>) {
            merged.addAll(item);
          }
        }

        generatedUrn = merged['URN_No'] ?? '';
        generatedDoc_No = merged['Doc_No'] ?? '';
        generatedCategory = merged['Category'] ?? '';
      } else {
        generatedUrn = null;
        generatedDoc_No = null;
        generatedCategory = null;
      }

      debugPrint('✅ URN: $generatedUrn');
      debugPrint('✅ Doc No: $generatedDoc_No');
      debugPrint('✅ Category: $generatedCategory');

      isLoading =false;

      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ Generate URN Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  Future<void> Insert_Pending_TO_New(String OLD_URN_No) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final response = await apiService.post(
        'Recovery/Insert_Pending_TO_New',
        data: {
          'CO_CODE': coCode.toString(),
          'O_URN_No': urnNo,
          'UR_CODE': "1",
          'Access_Token': Uri.encodeComponent(token).toString(),
          'URN_No': generatedUrn,
          'SR_No': "",
          'Mode': "",
          'FieldString': "",
          'OLD_URN_No': OLD_URN_No,
        },
      );

      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      // 🧩 Merge all maps inside message[]
      if (data['message'] != null && data['message'] is List) {
        final merged = <String, dynamic>{};
        for (var item in data['message']) {
          if (item is Map<String, dynamic>) {
            merged.addAll(item);
          }
        }

        // generatedUrn = merged['URN_No'] ?? '';
        // generatedDoc_No = merged['Doc_No'] ?? '';
        // generatedCategory = merged['Category'] ?? '';
      } else {

      }

      // debugPrint('✅ URN: $generatedUrn');
      // debugPrint('✅ Doc No: $generatedDoc_No');
      // debugPrint('✅ Category: $generatedCategory');

      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ Generate URN Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }


  Future<void> getRecoveryList(context) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);


      final response = await apiService.get(
        'Recovery/Pending_Breakdown_To_Recovery',
        queryParameters: {
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
          'item_filertext': "",
        },
      );

      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['settings']?['success'] == "1" && data['message'] is List) {
        // ✅ Fill Production_List
        Recovery_List = (data['message'] as List)
            .map((item) => {
          "URN_No": item["Urn_No"] ?? "",
          "Doc_No": item["Doc No"] ?? "",
          "Status": item["status"] ?? "",
          "Doc_Date": item["Doc Date"] ?? "",
          "MAchine_Name": item["Machine Name"] ?? "",
          "Category_Name": item["Category"] ?? "",
          "Department": item["Department"] ?? "",
          "Send to Department": item["Send to Department"] ?? "",
        })
            .toList();

        debugPrint("✅ Recovery List Loaded: ${Recovery_List.length}");
      } else {
        Recovery_List = [];
        debugPrint("⚠️ No valid data found or success != 1");

        // if (data['message'] == "User Id or Token is Invalid.") {
          await PreferenceManager.instance.setBooleanValue("Login", false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
          // clearMainForm();


        // }
      }

      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ getRecoveryList Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }


  Future<void> getRecoveryEntryList(context) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final response = await apiService.get(
        'Recovery/Get_Recovery_List',
        queryParameters: {
          'O_URN_No': urnNo.toString(),
          'URN_No': "",
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
          'SR_No': "",
        },
      );

      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['settings']?['success'] == "1" && data['message'] is List) {
        // ✅ Fill Production_List
        Recovery_Entry_List = (data['message'] as List)
            .map((item) => {
          "URN_No": item["URN_No"] ?? "",
          "Doc_No": item["Doc_No"] ?? "",
          "Status": item["Status"] ?? "",
          "Doc_Date": item["Doc_Date"] ?? "",
          "MAchine_Name": item["MAchine_Name"] ?? "",
          "Category_Name": item["Category_Name"] ?? "",
        })
            .toList();

        debugPrint("✅ Recovery_Entry_List List Loaded: ${Recovery_Entry_List.length}");
      } else {
        Recovery_Entry_List = [];
        debugPrint("⚠️ No valid data found or success != 1");
        await PreferenceManager.instance.setBooleanValue("Login", false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }

      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ Recovery_Entry_List Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }



}


