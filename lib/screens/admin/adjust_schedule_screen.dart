import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../providers/rumutai_date_provider.dart';

enum DayToAdjust { day1, day2 }

class AdjustScheduleScreen extends ConsumerStatefulWidget {
  static const routeName = "/adjust-schedule-screen";

  const AdjustScheduleScreen({super.key});

  @override
  ConsumerState<AdjustScheduleScreen> createState() => _AdjustScheduleScreenState();
}

class _AdjustScheduleScreenState extends ConsumerState<AdjustScheduleScreen> {
  final _dateFormatter = DateFormat("yyyy M/d");
  bool _isloading = false;

  Widget _adjustDateButton(DayToAdjust dayToAdjust) {
    return ElevatedButton(
      onPressed: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          locale: const Locale("ja"),
          initialDate: dayToAdjust == DayToAdjust.day1 ? ref.read(day1dateProvider) : ref.read(day2dateProvider),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (pickedDate != null) {
          setState(() {
            _isloading = true;
          });
          switch (dayToAdjust) {
            case (DayToAdjust.day1):
              await FirebaseFirestore.instance.collection("rumutaiSchedule").doc("rumutaiScheduleDoc").set(
                {
                  "day1": {
                    "day": pickedDate.day,
                    "month": pickedDate.month,
                    "year": pickedDate.year,
                  }
                },
                SetOptions(merge: true),
              );
              ref.read(day1dateProvider.notifier).state = pickedDate;
              break;
            case (DayToAdjust.day2):
              await FirebaseFirestore.instance.collection("rumutaiSchedule").doc("rumutaiScheduleDoc").set(
                {
                  "day2": {
                    "day": pickedDate.day,
                    "month": pickedDate.month,
                    "year": pickedDate.year,
                  }
                },
                SetOptions(merge: true),
              );
              ref.read(day2dateProvider.notifier).state = pickedDate;
              break;
          }
          setState(() {
            _isloading = false;
          });
        }
      },
      child: Text(dayToAdjust == DayToAdjust.day1 ? "1日目を変更" : "2日目を変更"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("日程")),
      body: SizedBox(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 50),
          Text(
            "1日目：${_dateFormatter.format(ref.watch(day1dateProvider))}",
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 15),
          Text(
            "2日目：${_dateFormatter.format(ref.watch(day2dateProvider))}",
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          const Expanded(child: SizedBox()),
          _isloading
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _adjustDateButton(DayToAdjust.day1),
                    const SizedBox(width: 10),
                    _adjustDateButton(DayToAdjust.day2),
                  ],
                ),
          const SizedBox(height: 50),
        ]),
      ),
    );
  }
}
