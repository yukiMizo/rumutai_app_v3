import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import "dart:io";
import '../providers/local_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocalNotification {
  static final flnp = FlutterLocalNotificationsPlugin();

  static InitializationSettings initializeLocNotification() {
    //現在時刻設定
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));
//権限設定
    const DarwinInitializationSettings initSettingsIOS = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: false);
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('notification_icon');
    if (Platform.isAndroid) {
      flnp.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
    }

// ignore: unused_local_variable
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initSettingsIOS,
    );

    return initializationSettings;
  }

  //通知予約解除
  static Future<void> cancelLocNotification(String gameId) async {
    await flnp.cancel(gameId.hashCode);
    await LocalData.saveLocalData<bool>(gameId, false);
  }

  static String _sport(String sport) {
    if (sport == "futsal") {
      return "フットサル";
    } else if (sport == "volleyball") {
      return "バレーボール";
    } else if (sport == "basketball") {
      return "バスケットボール";
    } else if (sport == "dodgebee") {
      return "ドッチビー";
    } else if (sport == "dodgeball") {
      return "ドッジボール";
    }
    return "";
  }

  //通知の予約
  static Future<void> registerLocNotification({
    required String place,
    required String gameId,
    required String sport,
    required String day,
    required String hour,
    required String minute,
    required String team1,
    required String team2,
  }) async {
    var globalData = await FirebaseFirestore.instance.collection("rumutaiSchedule").doc("2023Early").get();
    //試合日程yyyy/mm/dd
    int year = globalData.get("year");
    int month = globalData.get("month");
    int firstDay = globalData.get("day");
    //日時指定
    var date = tz.TZDateTime(tz.local, year, month, firstDay - 1 + int.parse(day), int.parse(hour), int.parse(minute) - 10);
    String message = "10分前：$place";
    //通知設定
    await flnp.zonedSchedule(
        gameId.hashCode,
        "${team1}vs$team2（${_sport(sport)}）",
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
        androidAllowWhileIdle: true);

    await LocalData.saveLocalData<bool>(gameId, true);
  }
}
