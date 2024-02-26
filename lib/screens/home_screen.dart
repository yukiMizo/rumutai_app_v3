import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../themes/app_color.dart';

import '../providers/rumutai_date_provider.dart';
import '../providers/picked_person_data_provider.dart';
import '../providers/sign_in_data_provider.dart';

import 'my_game_screen.dart';
import 'rule_book_screen.dart';
import 'admin/adjust_schedule_screen.dart';
import 'admin/send_notification_screen.dart';
import 'award/pick_award_screen.dart';
import 'cheer/pick_team_to_cheer_screen.dart';
import 'game_result/pick_category_screen.dart';
import 'staff/dashboard_screen.dart';
import "staff/timeline_screen.dart";
import 'notification/notifications_screen.dart';
import 'omikuji/pick_omikuji_screen.dart';
import 'schedule/pick_schedule_screen.dart';

import '../widgets/main_drawer.dart';

class HomeScreen extends ConsumerWidget {
  static const routeName = "/home-screen";
  const HomeScreen({super.key});

  Future<void> _initWithRef(WidgetRef ref, BuildContext context) async {
    //ローカルデータ初期化
    PickedPersonDataManager.setPickedPersonDataFromLocal(ref);
    SignInDataManager.setSignInDataFromLocal(ref);

    //パスワードの変更をチェック
    var scaffoldMessengerOfContext = ScaffoldMessenger.of(context);
    final String message = await SignInDataManager.checkIfPasswordChanged(ref);
    if (message != "") {
      scaffoldMessengerOfContext.removeCurrentSnackBar();
      scaffoldMessengerOfContext.showSnackBar(SnackBar(content: Text(message)));
    }
    //日付の情報を設定
    RumutaiDateManager.setDateData(ref);
  }

  Widget _buildMainButton({
    required String text,
    required IconData icon,
    required double width,
    required void Function() onPressed,
    double? iconSize,
  }) {
    return SizedBox(
      width: width,
      height: 50,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(backgroundColor: AppColors.themeColor),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            height: 1.0,
          ),
        ),
        icon: Icon(
          icon,
          size: iconSize ?? 25,
        ),
      ),
    );
  }

  Widget _buildSubButton({
    required String text,
    required IconData icon,
    required double width,
    required void Function() onPressed,
    double? iconSize,
  }) {
    return SizedBox(
      width: width,
      height: 50,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          side: const BorderSide(color: AppColors.themeColor, width: 2),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.themeColor.shade800,
        ),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            height: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(
          icon,
          size: iconSize ?? 25,
        ),
      ),
    );
  }

  Widget _buildSubButtonWithChild({
    required String text,
    required Widget child,
    required double width,
    required void Function() onPressed,
  }) {
    return SizedBox(
      width: width,
      height: 50,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          side: const BorderSide(color: AppColors.themeColor, width: 2),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.themeColor.shade800,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
            const SizedBox(width: 3),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                height: 1.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTonalButton({
    required String text,
    required IconData icon,
    required double width,
    required void Function() onPressed,
    double? iconSize,
  }) {
    return SizedBox(
      width: width,
      height: 50,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.themeColor.shade200,
          foregroundColor: AppColors.themeColor.shade900,
        ),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            height: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(
          icon,
          size: iconSize ?? 25,
        ),
      ),
    );
  }

  Widget _buildDividerWithText(String text) {
    return Container(
      width: 340,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          SizedBox(
              width: 40,
              child: Divider(
                thickness: 1,
                color: AppColors.themeColor.shade800,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.themeColor.shade800,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: AppColors.themeColor.shade800,
            ),
          ),
        ],
      ),
    );
  }

  String _rumutaiDateString(WidgetRef ref) {
    final String year = ref.watch(day1dateProvider).year.toString();
    final String month = ref.watch(day1dateProvider).month.toString();
    final String day1 = ref.watch(day1dateProvider).day.toString();
    final String day2 = ref.watch(day2dateProvider).day.toString();
    return "$year  $month/$day1-$day2";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //refを使う初期化(refを必要としないものはmain.dartで初期化している)
    _initWithRef(ref, context);

    final double buttonWidth = MediaQuery.of(context).size.width * 4 / 5;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(NotificationsScreen.routeName),
            icon: const Icon(Icons.notifications),
          ),
        ],
        title: const Text("ホーム"),
      ),
      drawer: const MainDrawer(),
      body: SizedBox(
        width: double.infinity,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                children: [
                  Text(
                    "HR対抗 ",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: AppColors.themeColor.shade800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _rumutaiDateString(ref),
                    style: TextStyle(color: AppColors.themeColor.shade800),
                  ),
                  const SizedBox(height: 40),
                  _buildMainButton(
                    text: "試合結果",
                    icon: Icons.scoreboard_outlined,
                    width: buttonWidth,
                    onPressed: () => Navigator.of(context).pushNamed(PickCategoryScreen.routeName),
                  ),
                  const SizedBox(height: 15),
                  _buildMainButton(
                    text: "スケジュール",
                    icon: Icons.event_note_outlined,
                    width: buttonWidth,
                    onPressed: () => Navigator.of(context).pushNamed(PickScheduleScreen.routeName),
                  ),
                  const SizedBox(height: 30),
                  _buildSubButton(
                    text: "るるぶ",
                    icon: Icons.description_outlined,
                    width: buttonWidth,
                    onPressed: () => Navigator.of(context).pushNamed(RuleBookScreen.routeName),
                  ),
                  const SizedBox(height: 15),
                  _buildTonalButton(text: "担当の試合", icon: Icons.sports_score, width: buttonWidth, onPressed: () => Navigator.of(context).pushNamed(MyGameScreen.routeName)),
                  const SizedBox(height: 25),
                  _buildDividerWithText("その他機能"),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSubButton(
                        text: "おみくじ",
                        icon: FontAwesomeIcons.wandMagic,
                        iconSize: 18,
                        width: buttonWidth / 2 - 5,
                        onPressed: () => Navigator.of(context).pushNamed(PickOmikujiScreen.routeName),
                      ),
                      const SizedBox(width: 10),
                      _buildSubButtonWithChild(
                        text: "応援",
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: Image.asset(
                            "assets/images/cheer.png",
                            color: Colors.brown.shade700,
                          ),
                        ),
                        width: buttonWidth / 2 - 5,
                        onPressed: () => Navigator.of(context).pushNamed(PickTeamToCheerScreen.routeName),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildSubButton(
                    text: "表彰",
                    icon: FontAwesomeIcons.medal,
                    iconSize: 18,
                    width: buttonWidth,
                    onPressed: () => Navigator.of(context).pushNamed(PickAwardScreen.routeName),
                  ),
                  if (ref.watch(isLoggedInRumutaiStaffProvider) || ref.watch(isLoggedInAdminProvider))
                    Column(
                      children: [
                        const SizedBox(height: 25),
                        _buildDividerWithText("スタッフ機能"),
                        const SizedBox(height: 15),
                        _buildTonalButton(
                          text: "タイムライン",
                          icon: Icons.view_timeline_outlined,
                          width: buttonWidth,
                          onPressed: () => Navigator.of(context).pushNamed(TimelineScreen.routeName),
                        ),
                        const SizedBox(height: 15),
                        _buildTonalButton(
                          text: "人手確認",
                          icon: Icons.map,
                          width: buttonWidth,
                          onPressed: () => Navigator.of(context).pushNamed(DashboardScreen.routeName),
                        )
                      ],
                    ),
                  if (ref.watch(isLoggedInAdminProvider))
                    Column(
                      children: [
                        const SizedBox(height: 25),
                        _buildDividerWithText("管理者機能"),
                        const SizedBox(height: 15),
                        _buildTonalButton(
                          text: "通知を送る",
                          icon: Icons.send_outlined,
                          width: buttonWidth,
                          onPressed: () => Navigator.of(context).pushNamed(SendNotificationScreen.routeName),
                        ),
                        const SizedBox(height: 15),
                        _buildTonalButton(
                          text: "日程",
                          icon: Icons.date_range,
                          width: buttonWidth,
                          onPressed: () => Navigator.of(context).pushNamed(AdjustScheduleScreen.routeName),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
