import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../../../../GlobalComponents/PreferenceManager.dart';
import '../../../../../GlobalComponents/api_service.dart';
import '../../../../Login_Screens/Login_Page.dart';
import '../../../../Production/Production_Form/Model/URN_No_Model.dart';




class Preventing_List_Provider extends ChangeNotifier {
  late double height;
  late double width;



  bool isInitialized = false;

  String? generatedUrn;
  String? generatedCategory;
  String? generatedDoc_No;

  bool isLoading =false;

  var Operator_Role;

  Preventing_List_Provider() {
    final context = NavKey.navKey.currentState!.context;
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }

  Future<void> init(BuildContext context) async {
    Operator_Role = await PreferenceManager.instance.getStringValue('Operator_Role');
    await getPreventingPendingList(context);
    await getPreventingEntryList(context);
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

  List<Map<String, dynamic>> Preventing_Pending_List = [];
  List<Map<String, dynamic>> Preventing_Entry_List = [];

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


  String selectedFrequencyFilter = "All";
  String selectedUnitFilter = "All";

  final List<String> frequencyFilterOptions = [
    "All",
    "Weekly",
    "Monthly",
    "Quarterly",
    "Half Yearly",
    "Yearly",
  ];

  void updateFrequencyFilter(String? value) {
    if (value == null) return;

    selectedFrequencyFilter = value;
    notifyListeners();
  }

  void updateUnitFilter(String? value) {
    if (value == null) return;

    selectedUnitFilter = value;
    notifyListeners();
  }
  /// 🔍 FILTERED LISTS
  List<Map<String, dynamic>> get filteredPendingList {
    return Preventing_Pending_List.where((item) {
      final String search = pendingSearch.trim().toLowerCase();

      // ============================================================
      // SEARCH
      // ============================================================

      final String urn =
          item["URN_No"]?.toString().toLowerCase() ?? "";

      final String machine =
          item["MAchine_Name"]?.toString().toLowerCase() ?? "";

      final String date =
          item["Maintenance Date"]?.toString().toLowerCase() ?? "";

      final String unit =
          item["Unit"]?.toString().toLowerCase() ?? "";

      final String frequency =
          item["Frequecy In Days"]?.toString().toLowerCase() ?? "";

      final String checkList =
          item["Check List"]?.toString().toLowerCase() ?? "";

      final bool matchesSearch =
          search.isEmpty ||
              urn.contains(search) ||
              machine.contains(search) ||
              date.contains(search) ||
              unit.contains(search) ||
              frequency.contains(search) ||
              checkList.contains(search);

      // ============================================================
      // UNIT FILTER
      // ============================================================

      bool matchesUnit = true;

      if (selectedUnitFilter != "All") {
        matchesUnit =
            item["Unit"]?.toString().trim() ==
                selectedUnitFilter;
      }

      // ============================================================
      // FREQUENCY FILTER
      // ============================================================

      final double frequencyDays =
          double.tryParse(
            item["Frequecy In Days"]?.toString() ?? "0",
          ) ??
              0;

      bool matchesFrequency = true;

      switch (selectedFrequencyFilter) {
        case "Weekly":
          matchesFrequency =
              frequencyDays > 0 && frequencyDays <= 7;
          break;

        case "Monthly":
          matchesFrequency =
              frequencyDays > 7 && frequencyDays <= 31;
          break;

        case "Quarterly":
          matchesFrequency =
              frequencyDays > 31 && frequencyDays <= 93;
          break;

        case "Half Yearly":
          matchesFrequency =
              frequencyDays >= 180 && frequencyDays <= 183;
          break;

        case "Yearly":
          matchesFrequency =
              frequencyDays > 93 && frequencyDays <= 366;
          break;

        case "All":
        default:
          matchesFrequency = true;
          break;
      }

      return matchesSearch &&
          matchesUnit &&
          matchesFrequency;
    }).toList();
  }

  List<Map<String, dynamic>> get filteredEntryList {
    return Preventing_Entry_List.where((item) {
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
          'Vary': "Machine Maintenance",
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

  Future<void> Insert_Pending_TO_New(String OLD_URN_No,String OLD_SR_No,) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final response = await apiService.post(
        'Preventing/Insert_Pending_TO_New_FOR_MM',
        data: {
          'CO_CODE': coCode.toString(),
          'O_URN_No': urnNo,
          'UR_CODE': "1",
          'Access_Token': token.toString(),
          'URN_No': generatedUrn,
          'SR_No': "",
          'Mode': "",
          'FieldString': "",
          'OLD_URN_No': OLD_URN_No,
          'OLD_SR_No': OLD_SR_No,
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


  Future<void> getPreventingPendingList(context) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);


      final response = await apiService.get(
        'Preventing/Pending_MC_Registration_TO_MM',
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
        Preventing_Pending_List = (data['message'] as List)
            .map<Map<String, dynamic>>((item) {
          return {
            "URN_No": item["Urn_No"] ?? "",
            "Status": item["Status"] ?? "",

            "MAchine_Name":
            item["Machine Name"] ?? "",

            // IMPORTANT
            "Unit":
            item["Unit"] ?? "",

            "Maintenance Date":
            item["Maintenance Date"] ?? "",

            "Frequecy In Days":
            item["Frequecy In Days"] ?? 0,

            "Check List":
            item["Check List"] ?? "",

            "Sr_No":
            item["Sr_No"] ?? "",

            "Item_Sr_No":
            item["Item_Sr_No"] ?? "",

            "Breck_Down_Detail":
            item["Breck_Down_Detail"] ?? "",

            "Sub_Head":
            item["Sub_Head"] ?? "",
          };
        }).toList();

        debugPrint("✅ Recovery List Loaded: ${Preventing_Pending_List.length}");
      } else {
        Preventing_Pending_List = [];
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


  Future<void> getPreventingEntryList(context) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final response = await apiService.get(
        'Preventing/Get_Machine_Maintenance_List',
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
        Preventing_Entry_List = (data['message'] as List)
            .map((item) => {
          "URN_No": item["URN_No"] ?? "",
          "Doc_No": item["Doc_No"] ?? "",
          "Status": item["Status"] ?? "",
          "Doc_Date": item["Doc_Date"] ?? "",
          "MAchine_Name": item["MAchine_Name"] ?? "",
          "Category_Name": item["Category_Name"] ?? "",
        })
            .toList();

        debugPrint("✅ Recovery_Entry_List List Loaded: ${Preventing_Entry_List.length}");
      } else {
        Preventing_Entry_List = [];
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



  List<String> get unitFilterOptions {
    final units = Preventing_Pending_List
        .map(
          (item) =>
      item["Unit"]?.toString().trim() ?? "",
    )
        .where((unit) => unit.isNotEmpty)
        .toSet()
        .toList();

    units.sort();

    return [
      "All",
      ...units,
    ];
  }



}


