import 'package:heavy_metal/screens/Dashboard/Provider/Dashboard_Provider.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../screens/Login_Screens/Provider/Login_Page_Provider.dart';
import '../screens/Maintanance/BreakDown/BreakDown_Listing/Provider/BreakDown_List_Provider.dart';
import '../screens/Maintanance/BreakDown/Provider/Breakdown_Form_Provider.dart';
import '../screens/Maintanance/Maintanance_Menu/Provider/Maintanance_Menu_Provider.dart';
import '../screens/Maintanance/Recovery/Recovery_Form/Provider/Recovery_Form_Provider.dart';
import '../screens/Maintanance/Recovery/Recovery_Listing/Provider/Recovery_List_Provider.dart';
import '../screens/Production/Production_Form/Provider/Production_Form_Provider.dart';
import '../screens/Scanner/Provider/Scanner_Provider.dart';
import '../screens/Transfer_Memo/Transfer_Memo_Form/Provider/Transfer_Memo_Form_Provider.dart';
import '../screens/Transfer_Memo/Transfer_Memo_List/Provider/Transfer_Memo_List_Provider.dart';

MultiProvider multiProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginPageProvider()),
      ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ChangeNotifierProvider(create: (_) => Production_Form_Provider()),
      ChangeNotifierProvider(create: (_) => Maintanance_Menu_Provider()),
      ChangeNotifierProvider(create: (_) => Transfer_Memo_List_Provider()),
      ChangeNotifierProvider(create: (_) => ScannerProvider()),
      ChangeNotifierProvider(create: (_) => Breakdown_Form_Provider()),
      ChangeNotifierProvider(create: (_) => Transfer_Memo_Form_Provider()),
      ChangeNotifierProvider(create: (_) => BreakDown_List_Provider()),
      ChangeNotifierProvider(create: (_) => Recovery_List_Provider()),
      ChangeNotifierProvider(create: (_) => Recovery_Form_Provider()),
    ],
    child: MyApp(),
  );
}
