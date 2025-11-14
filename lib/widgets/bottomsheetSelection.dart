import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../screens/Maintanance/BreakDown/Provider/Breakdown_Form_Provider.dart';
import '../screens/Maintanance/Recovery/Recovery_Form/Provider/Recovery_Form_Provider.dart';
import '../screens/Transfer_Memo/Transfer_Memo_Form/Provider/Transfer_Memo_Form_Provider.dart';

Future<void> showCategoryBottomSheet(
  BuildContext context,
  List<Map<String, String>> categoryList,
  String fieldtype,
  String generatedUrn,
  String frmname,
) async {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredList = List.from(categoryList);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search $fieldtype",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) async {
                      if (fieldtype == "Department") {
                        final provider = Provider.of<Transfer_Memo_Form_Provider>(
                          context,
                          listen: false,
                        );

                        // Fetch new data from API
                        await provider.fetchDepartmentListFromAPI(
                          generatedUrn.toString(),
                          value.toString(),
                        );

                        // Update filtered list with API response
                        setState(() {
                          filteredList = provider.Department_List
                              .where((e) => e["Select_Value"]!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();
                        });
                      }else if (fieldtype == "Location") {
                        final provider = Provider.of<Transfer_Memo_Form_Provider>(
                          context,
                          listen: false,
                        );

                        // Fetch new data from API
                        await provider.fetchLocationListFromAPI(
                          generatedUrn.toString(),
                          value.toString(),
                        );

                        // Update filtered list with API response
                        setState(() {
                          filteredList = provider.Location_List
                              .where((e) => e["Select_Value"]!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();
                        });
                      }else if (fieldtype == "Next Location") {
                        final provider = Provider.of<Transfer_Memo_Form_Provider>(
                          context,
                          listen: false,
                        );

                        // Fetch new data from API
                        await provider.fetchLocationListFromAPI(
                          generatedUrn.toString(),
                          value.toString(),
                        );

                        // Update filtered list with API response
                        setState(() {
                          filteredList = provider.Location_List
                              .where((e) => e["Select_Value"]!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();
                        });
                      }else if (fieldtype == "Category") {
                        final provider = Provider.of<Transfer_Memo_Form_Provider>(
                          context,
                          listen: false,
                        );

                        // Fetch new data from API
                        await provider.fetchCategoryListFromAPI(
                          generatedUrn.toString(),
                          value.toString(),
                        );

                        // Update filtered list with API response
                        setState(() {
                          filteredList = provider.categoryName_List
                              .where((e) => e["Select_Value"]!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();
                        });
                      }else if (fieldtype == "Item Name") {
                        if (frmname == "Transfer Memo") {
                          final provider = Provider.of<Transfer_Memo_Form_Provider>(
                            context,
                            listen: false,
                          );

                          // Fetch new data from API
                          await provider.fetchitemNameListFromAPI(
                            generatedUrn.toString(),
                            value.toString(),
                          );

                          // Update filtered list with API response
                          setState(() {
                            filteredList = provider.categoryName_List
                                .where((e) => e["Select_Value"]!
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                                .toList();
                          });
                        }
                        if (frmname == "Recovery") {
                          final provider = Provider.of<Recovery_Form_Provider>(
                            context,
                            listen: false,
                          );

                          // Fetch new data from API
                          // await provider.fetchitemNameListFromAPI(
                          //   generatedUrn.toString(),
                          //   value.toString(),
                          // );

                          // Update filtered list with API response
                          setState(() {
                            filteredList = provider.categoryName_List
                                .where((e) => e["Select_Value"]!
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                                .toList();
                          });
                        }

                      } else {
                        // Normal filtering for other field types
                        setState(() {
                          filteredList = categoryList
                              .where((e) => e["Select_Value"]!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();
                        });
                      }
                    },

                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredList.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return ListTile(
                        title: Text(item["Select_Value"] ?? ""),
                        onTap: () async {
                          final provider =
                              Provider.of<Transfer_Memo_Form_Provider>(
                            context,
                            listen: false,
                          );

                          if (fieldtype == "Category") {
                            // Update selected item

                            if (frmname == "Breakdown") {
                              final provider =
                                  Provider.of<Breakdown_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedCategory = item["Select_Value"];
                              provider.selectedCategoryId =
                                  item["Select_Value_Code"].toString();

                              await provider.fetchCategoryListFromAPI(
                                  generatedUrn.toString());
                              await provider.fetchDocNoFromAPI(
                                  generatedUrn.toString(), frmname);
                            }else if (frmname == "Recovery") {
                              final provider =
                                  Provider.of<Recovery_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedCategory = item["Select_Value"];
                              provider.selectedCategoryId =
                                  item["Select_Value_Code"].toString();

                              await provider.fetchCategoryListFromAPI(
                                  generatedUrn.toString());
                              await provider.fetchDocNoFromAPI(
                                  generatedUrn.toString(), frmname);
                            } else {
                              provider.selectedCategory = item["Select_Value"];
                              provider.selectedCategoryId =
                                  item["Select_Value_Code"].toString();
                              await provider.fetchCategoryListFromAPI(
                                  generatedUrn.toString(),"");
                              await provider.fetchDocNoFromAPI(
                                  generatedUrn.toString(), frmname);
                            }
                            provider.notifyListeners();

                            // Close this bottom sheet
                            Navigator.pop(context);

                            // Call same API again

                            // Reopen updated bottom sheet automatically
                          } else if (fieldtype == "WO No") {
                            provider.selectedWO_No_ID =
                                item["Select_Value_Code"].toString();
                            provider.selectedWO_No =
                                item["Select_Value"].toString();
                            log(provider.selectedWO_No_ID);
                            provider.notifyListeners();

                            Navigator.pop(context);
                          } else if (fieldtype == "Memo Type") {
                            provider.selectedMemoTyppe_ID =
                                item["Select_Value_Code"].toString();
                            provider.selectedMemoTyppe =
                                item["Select_Value"].toString();
                            log(provider.selectedWO_No_ID);

                            if (provider.selectedMemoTyppe == "External") {
                              provider.selectedDepartment = "";
                              provider.selectedDepartment_ID = "";
                            } else if (provider.selectedMemoTyppe ==
                                "Internal") {
                              provider.selectedPartyName = "";
                              provider.selectedPartyName_ID = "";
                            }
                            provider.notifyListeners();

                            Navigator.pop(context);
                          } else if (fieldtype == "Department") {

                            if (frmname == "Breakdown") {
                              final provider =
                                  Provider.of<Breakdown_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedDepartment_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedDepartment =
                                  item["Select_Value"].toString();
                              log(provider.selectedDepartment);
                              provider.notifyListeners();
                            }else if (frmname == "Recovery") {
                              final provider =
                                  Provider.of<Recovery_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedDepartment_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedDepartment =
                                  item["Select_Value"].toString();
                              log(provider.selectedDepartment);
                              provider.notifyListeners();
                            }else{
                              provider.selectedDepartment_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedDepartment =
                                  item["Select_Value"].toString();
                              log(provider.selectedDepartment);
                            }
                            provider.notifyListeners();

                            Navigator.pop(context);
                          } else if (fieldtype == "Party Name") {
                            provider.selectedPartyName_ID =
                                item["Select_Value_Code"].toString();
                            provider.selectedPartyName =
                                item["Select_Value"].toString();
                            log(provider.selectedPartyName);
                            provider.notifyListeners();

                            Navigator.pop(context);
                          } else if (fieldtype == "Item Name") {
                            if (frmname == "Transfer Memo") {
                              provider.selecteditemName_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selecteditemName =
                                  item["Select_Value"].toString();
                              log(provider.selecteditemName);
                              log(provider.selecteditemName_ID);
                              provider.notifyListeners();

                              await provider.fetchItemUnitListFromAPI(
                                  generatedUrn.toString(),
                                  provider.selecteditemName_ID);
                              Navigator.pop(context);
                            }else if (frmname == "Recovery") {
                              final provider =
                              Provider.of<Recovery_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selecteditemName_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selecteditemName =
                                  item["Select_Value"].toString();
                              log(provider.selecteditemName);
                              log(provider.selecteditemName_ID);
                              provider.notifyListeners();

                              await provider.fetchItemUnitListFromAPI(
                                  generatedUrn.toString(),
                                  provider.selecteditemName_ID);
                              Navigator.pop(context);
                            }

                          } else if (fieldtype == "Grade") {
                            provider.selectedGrade_ID =
                                item["Select_Value_Code"].toString();
                            provider.selectedGrade =
                                item["Select_Value"].toString();
                            log(provider.selectedGrade);
                            provider.notifyListeners();

                            Navigator.pop(context);
                          } else if (fieldtype == "UOM") {
                            if (frmname == "Transfer Memo") {
                              provider.selectedUOM_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedUOM =
                                  item["Select_Value"].toString();
                              log(provider.selectedUOM);
                              provider.notifyListeners();

                              Navigator.pop(context);
                              provider.UOM_List = [];
                            }else if (frmname == "Recovery") {
                              final provider =
                              Provider.of<Recovery_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedUOM_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedUOM =
                                  item["Select_Value"].toString();
                              log(provider.selectedUOM);
                              provider.notifyListeners();

                              Navigator.pop(context);
                              provider.UOM_List = [];
                            }

                          } else if (fieldtype == "Location") {
                            provider.selectedLocation_ID =
                                item["Select_Value_Code"].toString();
                            provider.selectedLocation =
                                item["Select_Value"].toString();
                            log(provider.selectedLocation);
                            provider.notifyListeners();

                            Navigator.pop(context);
                          } else if (fieldtype == "Next Location") {
                            provider.selectedNextLocation_ID =
                                item["Select_Value_Code"].toString();
                            provider.selectedNextLocation =
                                item["Select_Value"].toString();
                            log(provider.selectedNextLocation);
                            provider.notifyListeners();

                            Navigator.pop(context);
                          } else if (fieldtype == "Specification") {
                            provider.selectedSpecification_ID =
                                item["Select_Value_Code"].toString();
                            provider.selectedSpecification =
                                item["Select_Value"].toString();
                            log(provider.selectedSpecification);
                            provider.notifyListeners();

                            Navigator.pop(context);
                          } else if (fieldtype == "Heat No") {
                            provider.selectedHeat_No_ID =
                                item["Select_Value_Code"].toString();
                            provider.selectedHeat_No =
                                item["Select_Value"].toString();
                            log(provider.selectedHeat_No);
                            provider.notifyListeners();

                            Navigator.pop(context);
                          }else if (fieldtype == "Machine Name") {
                            if (frmname == "Breakdown") {
                              final provider =
                              Provider.of<Breakdown_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedMachine_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedMachine =
                                  item["Select_Value"].toString();
                              log(provider.selectedMachine);
                              provider.notifyListeners();

                              Navigator.pop(context);
                            }else if (frmname == "Recovery"){
                              final provider =
                              Provider.of<Recovery_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedMachine_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedMachine =
                                  item["Select_Value"].toString();
                              log(provider.selectedMachine);
                              provider.notifyListeners();

                              Navigator.pop(context);
                            }

                          }else if (fieldtype == "Send To") {
                            if (frmname == "Breakdown") {
                              final provider =
                              Provider.of<Breakdown_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedSendto_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedSendto =
                                  item["Select_Value"].toString();
                              log(provider.selectedSendto);
                              provider.notifyListeners();

                              Navigator.pop(context);
                            }else if (frmname == "Recovery") {
                              final provider =
                              Provider.of<Recovery_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedSendto_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedSendto =
                                  item["Select_Value"].toString();
                              log(provider.selectedSendto);
                              provider.notifyListeners();

                              Navigator.pop(context);
                            }

                          }else if (fieldtype == "Sub Head") {
                            if (frmname == "Breakdown") {
                              final provider =
                              Provider.of<Breakdown_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedSubHead_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedSubHead =
                                  item["Select_Value"].toString();
                              log(provider.selectedSubHead);
                              provider.notifyListeners();

                              Navigator.pop(context);
                            }else if (frmname == "Recovery") {
                              final provider =
                              Provider.of<Recovery_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedSubHead_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedSubHead =
                                  item["Select_Value"].toString();
                              log(provider.selectedSubHead);
                              provider.notifyListeners();

                              Navigator.pop(context);
                            }

                          }else if (fieldtype == "BreakDown Detail") {
                            if (frmname == "Breakdown") {
                              final provider =
                              Provider.of<Breakdown_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedBreak_Detail_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedBreak_Detail =
                                  item["Select_Value"].toString();
                              log(provider.selectedBreak_Detail);
                              provider.notifyListeners();

                              Navigator.pop(context);
                            }else if (frmname == "Recovery") {
                              final provider =
                              Provider.of<Recovery_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedBreak_Detail_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedBreak_Detail =
                                  item["Select_Value"].toString();
                              log(provider.selectedBreak_Detail);
                              provider.notifyListeners();

                              Navigator.pop(context);
                            }

                          }else if (fieldtype == "Standard Time Min") {
                            if (frmname == "Breakdown") {
                              final provider =
                              Provider.of<Breakdown_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedStd_Time_Min_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedStd_Time_Min =
                                  item["Select_Value"].toString();
                              log(provider.selectedStd_Time_Min);
                              provider.notifyListeners();

                              Navigator.pop(context);
                            }else if (frmname == "Recovery") {
                              final provider =
                              Provider.of<Recovery_Form_Provider>(
                                context,
                                listen: false,
                              );
                              provider.selectedStd_Time_Min_ID =
                                  item["Select_Value_Code"].toString();
                              provider.selectedStd_Time_Min =
                                  item["Select_Value"].toString();
                              log(provider.selectedStd_Time_Min);
                              provider.notifyListeners();

                              Navigator.pop(context);
                            }

                          }else if (fieldtype == "Product Machine Name") {
                            final provider =
                            Provider.of<Breakdown_Form_Provider>(
                              context,
                              listen: false,
                            );
                            provider.selectedMachine_ID_Product =
                                item["Select_Value_Code"].toString();
                            provider.selectedMachine_Product =
                                item["Select_Value"].toString();
                            log(provider.selectedMachine_Product);
                            provider.notifyListeners();

                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
