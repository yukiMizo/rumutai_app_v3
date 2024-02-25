import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumutai_app/providers/local_data_provider.dart';

import 'package:rumutai_app/screens/drawer/publish_drive.dart';
import 'package:rumutai_app/screens/staff/my_place_game_screen.dart';
import 'package:rumutai_app/themes/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:rumutai_app/screens/staff/dashboard_screen.dart';
import 'package:rumutai_app/screens/staff/timeline_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'screens/home_screen.dart';

import 'notification_manager.dart';

import 'providers/local_data.dart';
import 'providers/game_data_provider.dart';
import "providers/dashboard_data.dart";

import 'screens/schedule/pick_schedule_screen.dart';
import 'screens/notification/notifications_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/schedule/schedule_screen.dart';
import 'screens/game_result/pick_category_screen.dart';
import 'screens/game_result/game_results_screen.dart';
import 'screens/drawer/map_screen.dart';
import 'screens/notification/send_notification_screen.dart';
import 'screens/drawer/sign_in_screen.dart';
import 'screens/admin_edit_screen.dart';
import 'screens/rumutai_staff_screen.dart';
import 'screens/notification/notifications_detail_screen.dart';
import 'screens/rule_book_screen.dart';
import 'screens/my_game_screen.dart';
import 'screens/drawer/setting_screen.dart';
import 'screens/drawer/privacy_policy_screen.dart';
import 'screens/drawer/terms_of_service_screen.dart';
import 'screens/drawer/contact_screen.dart';
import 'screens/cheer/pick_team_to_cheer_screen.dart';
import 'screens/cheer/cheer_screen.dart';
import 'screens/omikuji/pick_omikuji_screen.dart';
import 'screens/omikuji/draw_omikuji_screen.dart';
import 'screens/omikuji/make_omikuji_screen.dart';
import 'screens/award/pick_award_screen.dart';
import 'screens/award/game_award_screen.dart';
import 'screens/award/cheer_award_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await _init();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      themeMode: ThemeMode.system,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        DetailScreen.routeName: (ctx) => const DetailScreen(),
        AdminEditScreen.routeName: (ctx) => const AdminEditScreen(),
        RumutaiStaffScreen.routeName: (ctx) => const RumutaiStaffScreen(),
        RuleBookScreen.routeName: (ctx) => const RuleBookScreen(),
        MyGameScreen.routeName: (ctx) => const MyGameScreen(),
        //drawer
        SettingScreen.routeName: (ctx) => const SettingScreen(),
        SignInScreen.routeName: (ctx) => const SignInScreen(),
        MapScreen.routeName: (ctx) => MapScreen(),
        PrivacyPolicyScreen.routeName: (ctx) => const PrivacyPolicyScreen(),
        TermsOfServiceScreen.routeName: (ctx) => const TermsOfServiceScreen(),
        ContactScreen.routeName: (ctx) => const ContactScreen(),
        //gameResult
        GameResultsScreen.routeName: (ctx) => const GameResultsScreen(),
        PickCategoryScreen.routeName: (ctx) => const PickCategoryScreen(),
        //schedule
        ScheduleScreen.routeName: (ctx) => const ScheduleScreen(),
        PickScheduleScreen.routeName: (ctx) => const PickScheduleScreen(),
        //notification
        NotificationsScreen.routeName: (ctx) => const NotificationsScreen(),
        SendNotificationScreen.routeName: (ctx) => const SendNotificationScreen(),
        NotificationsDetailScreen.routeName: (ctx) => const NotificationsDetailScreen(),
        //cheer
        PickTeamToCheerScreen.routeName: (ctx) => const PickTeamToCheerScreen(),
        CheerScreen.routeName: (ctx) => const CheerScreen(),
        //omikuji
        PickOmikujiScreen.routeName: (ctx) => const PickOmikujiScreen(),
        DrawOmikujiScreen.routeName: (ctx) => const DrawOmikujiScreen(),
        MakeOmikujiScreen.routeName: (ctx) => const MakeOmikujiScreen(),
        //award
        PickAwardScreen.routeName: (ctx) => const PickAwardScreen(),
        GameAwardScreen.routeName: (ctx) => const GameAwardScreen(),
        CheerAwardScreen.routeName: (ctz) => const CheerAwardScreen(),

        TimelineScreen.routeName: (ctx) => const TimelineScreen(),
        DashboardScreen.routeName: (ctx) => const DashboardScreen(),
        MyPlaceGameScreen.routeName: (ctx) => const MyPlaceGameScreen(),
        PublishDriveScreen.routeName: (ctx) => const PublishDriveScreen(),
      },
    );
  }
}
