import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../GlobalComponents/PreferenceManager.dart';
import '../../../../../GlobalComponents/api_service.dart';
import '../../../../Production/Production_Form/Model/URN_No_Model.dart';


class BreakDown_List_Provider extends ChangeNotifier {
  late double height;
  late double width;



  bool isInitialized = false;

  String? generatedUrn;
  String? generatedCategory;
  String? generatedDoc_No;

  BreakDown_List_Provider() {
    final context = NavKey.navKey.currentState!.context;
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }

  Future<void> init() async {
    await getBreakDownList();
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

  List<Map<String, dynamic>> BreakDown_List = [];

  TextEditingController searchController = TextEditingController();
  String searchText = "";

  void updateSearch(String value) {
    searchText = value.toLowerCase();
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredList {
    return BreakDown_List.where((item) {
      final urn = item["URN_No"].toString().toLowerCase();
      final doc = item["Doc_No"].toString().toLowerCase();
      final machine = item["MAchine_Name"].toString().toLowerCase();
      final date = item["Doc_Date"].toString().toLowerCase();
      final category = item["Category_Name"].toString().toLowerCase();

      return urn.contains(searchText) ||
          doc.contains(searchText) ||
          machine.contains(searchText) ||
          date.contains(searchText) ||
          category.contains(searchText);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }




  void reload(){
    notifyListeners();
  }

  Future<void> generateUrnNo() async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final response = await apiService.post(
        'Production/Generate_URN_No',
        data: {
          'O_URN_No': urnNo,
          'User_Id': "2",
          'Access_Token': token,
          'Co_Code': coCode,
          'Vary': "Breakdown",
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

      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ Generate URN Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }


  Future<void> getBreakDownList() async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final response = await apiService.get(
        'BreakDown/Get_BreakDown_List',
        queryParameters: {
          'URN_No': "",
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "2",
          'SR_No': "",
        },
      );

      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      if (data['settings']?['success'] == "1" && data['message'] is List) {
        // ✅ Fill Production_List
        BreakDown_List = (data['message'] as List)
            .map((item) => {
          "URN_No": item["URN_No"] ?? "",
          "Doc_No": item["Doc_No"] ?? "",
          "Status": item["Status"] ?? "",
          "Doc_Date": item["Doc_Date"] ?? "",
          "MAchine_Name": item["MAchine_Name"] ?? "",
          "Category_Name": item["Category_Name"] ?? "",
        })
            .toList();

        debugPrint("✅ Transfer Memo List Loaded: ${BreakDown_List.length}");
      } else {
        BreakDown_List = [];
        debugPrint("⚠️ No valid data found or success != 1");
      }

      notifyListeners();
    } catch (e, st) {
      debugPrint('❌ getBreakDownList Error: $e');
      debugPrintStack(stackTrace: st);
    }
  }



}


