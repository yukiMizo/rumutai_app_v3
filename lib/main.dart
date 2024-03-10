import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

import 'notification_manager.dart';

//themes/
import 'themes/app_theme.dart';

//screens/
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/rumutai_staff_screen.dart';
import 'screens/rule_book_screen.dart';
import 'screens/my_game_screen.dart';
//cheer/
import 'screens/cheer/pick_team_to_cheer_screen.dart';
import 'screens/cheer/cheer_screen.dart';
//drawer/
import 'screens/drawer/map_screen.dart';
import 'screens/drawer/sign_in_screen.dart';
import 'screens/drawer/privacy_policy_screen.dart';
import 'screens/drawer/terms_of_service_screen.dart';
import 'screens/drawer/contact_screen.dart';
import 'screens/drawer/info_screen.dart';
import 'screens/drawer/place_schedule_screen.dart';
//game_result/
import 'screens/game_result/pick_category_screen.dart';
import 'screens/game_result/game_results_screen.dart';
//notification/
import 'screens/notification/notifications_screen.dart';
import 'screens/notification/notifications_detail_screen.dart';
//omikuji/
import 'screens/omikuji/pick_omikuji_screen.dart';
import 'screens/omikuji/draw_omikuji_screen.dart';
import 'screens/omikuji/make_omikuji_screen.dart';
//schedule/
import 'screens/schedule/schedule_screen.dart';
import 'screens/schedule/pick_schedule_screen.dart';
//staff/
import 'screens/staff/timeline_screen.dart';
//admin/
import 'screens/admin/adjust_schedule_screen.dart';
import 'screens/admin/send_notification_screen.dart';
import 'screens/admin/admin_edit_screen.dart';
import 'screens/admin/manage_omikuji_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await _init();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //通知関係の設定
  NotificationManager.notificationSetup();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //通知をタップして起動したときの設定＆local_notificationの初期化
    NotificationManager.whenNotificationTapped(navigatorKey);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Rumutai',
      theme: appTheme(),
      themeMode: ThemeMode.system,
      initialRoute: HomeScreen.routeName,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale("ja")],
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        DetailScreen.routeName: (ctx) => const DetailScreen(),
        RumutaiStaffScreen.routeName: (ctx) => const RumutaiStaffScreen(),
        RuleBookScreen.routeName: (ctx) => const RuleBookScreen(),
        MyGameScreen.routeName: (ctx) => const MyGameScreen(),
        //admin
        AdjustScheduleScreen.routeName: (ctx) => const AdjustScheduleScreen(),
        AdminEditScreen.routeName: (ctx) => const AdminEditScreen(),
        ManagaeOmikujiScreen.routeName: (ctx) => const ManagaeOmikujiScreen(),
        SendNotificationScreen.routeName: (ctx) => const SendNotificationScreen(),
        //cheer
        PickTeamToCheerScreen.routeName: (ctx) => const PickTeamToCheerScreen(),
        CheerScreen.routeName: (ctx) => const CheerScreen(),
        //drawer
        InfoScreen.routeName: (ctx) => const InfoScreen(),
        SignInScreen.routeName: (ctx) => const SignInScreen(),
        MapScreen.routeName: (ctx) => const MapScreen(),
        PrivacyPolicyScreen.routeName: (ctx) => const PrivacyPolicyScreen(),
        TermsOfServiceScreen.routeName: (ctx) => const TermsOfServiceScreen(),
        ContactScreen.routeName: (ctx) => const ContactScreen(),
        PlaceScheduleScreen.routeName: (ctx) => const PlaceScheduleScreen(),
        //gameResult
        GameResultsScreen.routeName: (ctx) => const GameResultsScreen(),
        PickCategoryScreen.routeName: (ctx) => const PickCategoryScreen(),
        //notification
        NotificationsScreen.routeName: (ctx) => const NotificationsScreen(),
        NotificationsDetailScreen.routeName: (ctx) => const NotificationsDetailScreen(),
        //omikuji
        PickOmikujiScreen.routeName: (ctx) => const PickOmikujiScreen(),
        DrawOmikujiScreen.routeName: (ctx) => const DrawOmikujiScreen(),
        MakeOmikujiScreen.routeName: (ctx) => const MakeOmikujiScreen(),
        //schedule
        ScheduleScreen.routeName: (ctx) => const ScheduleScreen(),
        PickScheduleScreen.routeName: (ctx) => const PickScheduleScreen(),
        //staff
        TimelineScreen.routeName: (ctx) => const TimelineScreen(),
      },
    );
  }
}
