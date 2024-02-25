import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rumutai_app/screens/drawer/publish_drive.dart';
import 'package:rumutai_app/screens/staff/my_place_game_screen.dart';
import 'package:rumutai_app/themes/app_theme.dart';
import 'package:rumutai_app/utilities/local_notification.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:rumutai_app/screens/staff/dashboard_screen.dart';
import 'package:rumutai_app/screens/staff/timeline_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'screens/home_screen.dart';

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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  flnp.initialize(const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')));

  if (notification == null) {
    return;
  }

  // 通知
  flnp.show(
    notification.hashCode,
    notification.title,
    notification.body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //通知をタップして起動したときの設定＆local_notificationの初期化
    flutterLocalNotificationsPlugin.initialize(LocalNotification.initializeLocNotification(), onDidReceiveNotificationResponse: (NotificationResponse res) {
      navigatorKey.currentState?.pushNamed(DetailScreen.routeName,
          arguments: DataToPass(
            gameDataId: res.payload!,
            isMyGame: true,
          ));
    });
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Rumutai',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      themeMode: ThemeMode.system,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        PickScheduleScreen.routeName: (ctx) => const PickScheduleScreen(),
        SignInScreen.routeName: (ctx) => const SignInScreen(),
        NotificationsScreen.routeName: (ctx) => const NotificationsScreen(),
        DetailScreen.routeName: (ctx) => const DetailScreen(),
        ScheduleScreen.routeName: (ctx) => const ScheduleScreen(),
        PickCategoryScreen.routeName: (ctx) => const PickCategoryScreen(),
        GameResultsScreen.routeName: (ctx) => const GameResultsScreen(),
        MapScreen.routeName: (ctx) => MapScreen(),
        SendNotificationScreen.routeName: (ctx) => const SendNotificationScreen(),
        AdminEditScreen.routeName: (ctx) => const AdminEditScreen(),
        RumutaiStaffScreen.routeName: (ctx) => const RumutaiStaffScreen(),
        NotificationsDetailScreen.routeName: (ctx) => const NotificationsDetailScreen(),
        RuleBookScreen.routeName: (ctx) => const RuleBookScreen(),
        MyGameScreen.routeName: (ctx) => const MyGameScreen(),
        SettingScreen.routeName: (ctx) => const SettingScreen(),
        PrivacyPolicyScreen.routeName: (ctx) => const PrivacyPolicyScreen(),
        TermsOfServiceScreen.routeName: (ctx) => const TermsOfServiceScreen(),
        ContactScreen.routeName: (ctx) => const ContactScreen(),
        PickTeamToCheerScreen.routeName: (ctx) => const PickTeamToCheerScreen(),
        CheerScreen.routeName: (ctx) => const CheerScreen(),
        PickOmikujiScreen.routeName: (ctx) => const PickOmikujiScreen(),
        DrawOmikujiScreen.routeName: (ctx) => const DrawOmikujiScreen(),
        MakeOmikujiScreen.routeName: (ctx) => const MakeOmikujiScreen(),
        TimelineScreen.routeName: (ctx) => const TimelineScreen(),
        DashboardScreen.routeName: (ctx) => const DashboardScreen(),
        MyPlaceGameScreen.routeName: (ctx) => const MyPlaceGameScreen(),
        PublishDriveScreen.routeName: (ctx) => const PublishDriveScreen(),
        PickAwardScreen.routeName: (ctx) => const PickAwardScreen(),
        GameAwardScreen.routeName: (ctx) => const GameAwardScreen(),
        CheerAwardScreen.routeName: (ctz) => const CheerAwardScreen(),
      },
    );
  }
}
