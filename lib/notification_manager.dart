import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'local_data.dart';

import 'providers/game_data_provider.dart';
import 'providers/init_data_provider.dart';

import 'screens/detail_screen.dart';

//通知関係は全てここで扱う
class NotificationManager {
  static final flnp = FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging fbm = FirebaseMessaging.instance;

  //通知関連全体の初期化および設定
  static Future<void> notificationSetup() async {
    _fcmSetup();
    //init local notification
    _initializeLocNotification();
    _requestPermissions();
    //handle background message
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  //fcm関連の設定
  static void _fcmSetup() async {
    //for ios
    fbm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //foreground
    //ios
    fbm.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    //android
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      flnp.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: false,
          ),
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      );
      if (notification == null) {
        return;
      }
      if (android == null) {
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
    });
    //topic設定
    fbm.subscribeToTopic("notification-all");
  }

  //許可を要求
  static Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await flnp.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = flnp.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestPermission();
    }
  }

  //ローカルデータ初期化
  static InitializationSettings _initializeLocNotification() {
    //現在時刻設定
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));
    //権限設定
    const DarwinInitializationSettings initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
    );
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('notification_icon');
    if (Platform.isAndroid) {
      flnp.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
    }

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initSettingsIOS,
    );

    return initializationSettings;
  }

  //バックグラウンド通知の処理
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    flnp.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: false,
        ),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

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

  //通知をタップして起動したときの設定＆local_notificationの初期化
  static void whenNotificationTapped(GlobalKey<NavigatorState> navigatorKey) {
    flnp.initialize(
      _initializeLocNotification(),
      onDidReceiveNotificationResponse: (NotificationResponse res) {
        navigatorKey.currentState?.pushNamed(
          DetailScreen.routeName,
          arguments: GameDataToPass(
            gameDataId: res.payload!,
            isMyGame: true,
          ),
        );
      },
    );
  }

  //通知予約解除
  static Future<void> cancelLocNotification(String gameId) async {
    await flnp.cancel(gameId.hashCode);
    await LocalData.saveLocalData<bool>(gameId, false);
  }

  //ローカル通知の予約
  static Future<void> registerLocNotification({
    required WidgetRef ref,
    required String place,
    required String gameId,
    required SportsType sportsType,
    required String day,
    required String hour,
    required String minute,
    required String team1,
    required String team2,
  }) async {
    //試合日程yyyy/mm/dd
    int year = ref.read(day1dateProvider).year;
    int month = ref.read(day1dateProvider).month;
    int dayToUse = int.parse(day) == 1 ? ref.read(day1dateProvider).day : ref.read(day2dateProvider).day;
    //日時指定
    var date = tz.TZDateTime(
      tz.local,
      year,
      month,
      dayToUse,
      int.parse(hour),
      int.parse(minute) - 10,
    );
    String message = "10分前：$place";
    //通知設定
    await flnp.zonedSchedule(
      gameId.hashCode,
      "${team1}vs$team2（${sportsType.asLongJapanse()}）",
      message,
      date,
      payload: gameId,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'HR対抗',
          'HR対抗',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          styleInformation: BigTextStyleInformation(message),
          icon: 'notification_icon',
        ), //iosは設定事項がほぼないためアンドロイドのみの設定
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );

    await LocalData.saveLocalData<bool>(gameId, true);
  }
}
