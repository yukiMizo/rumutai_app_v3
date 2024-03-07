import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumutai_app/providers/init_data_provider.dart';

import '../../themes/app_color.dart';

import 'schedule_screen.dart';
import '../../widgets/main_pop_up_menu.dart';

class PickScheduleScreen extends ConsumerWidget {
  static const routeName = "/schedule-screen";

  const PickScheduleScreen({super.key});

  Widget _buildScheduleButton({required context, required String classNumber}) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.black),
        onPressed: () => Navigator.of(context).pushNamed(ScheduleScreen.routeName, arguments: classNumber),
        child: Row(
          children: [
            Expanded(
              child: Text(
                classNumber,
                style: TextStyle(fontSize: 20, color: AppColors.themeColor.shade900),
                textAlign: TextAlign.center,
              ),
            ),
            Icon(Icons.navigate_next, size: 25, color: AppColors.themeColor.shade900),
          ],
        ),
      ),
    );
  }

  Widget _gradeLabel(String text) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.themeColor.shade900,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, String grade) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(children: [
              _gradeLabel("$grade年"),
              _buildScheduleButton(context: context, classNumber: "${grade}01"),
              const Divider(height: 1),
              _buildScheduleButton(context: context, classNumber: "${grade}02"),
              const Divider(height: 1),
              _buildScheduleButton(context: context, classNumber: "${grade}03"),
              const Divider(height: 1),
              _buildScheduleButton(context: context, classNumber: "${grade}04"),
              const Divider(height: 1),
              _buildScheduleButton(context: context, classNumber: "${grade}05"),
              const Divider(height: 1),
              _buildScheduleButton(context: context, classNumber: "${grade}06"),
              const Divider(height: 1),
              _buildScheduleButton(context: context, classNumber: "${grade}07"),
              const Divider(height: 1),
              _buildScheduleButton(context: context, classNumber: "${grade}08"),
              const Divider(height: 1),
              _buildScheduleButton(context: context, classNumber: "${grade}09"),
              const Divider(height: 1),
              _buildScheduleButton(context: context, classNumber: "${grade}10"),
              const Divider(height: 1),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("スケジュール"),
        actions: const [MainPopUpMenu()],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(children: [
            _buildScheduleCard(context, "1"),
            _buildScheduleCard(context, "2"),
            if (ref.watch(show3rdGradeProvider)) _buildScheduleCard(context, "3"),
            const SizedBox(height: 50),
          ]),
        ),
      ),
    );
  }
}
