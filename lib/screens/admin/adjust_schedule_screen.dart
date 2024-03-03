import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../providers/init_data_provider.dart';

enum DayToAdjust { day1, day2 }

class AdjustScheduleScreen extends ConsumerStatefulWidget {
  static const routeName = "/adjust-schedule-screen";

  const AdjustScheduleScreen({super.key});

  @override
  ConsumerState<AdjustScheduleScreen> createState() => _AdjustScheduleScreenState();
}

class _AdjustScheduleScreenState extends ConsumerState<AdjustScheduleScreen> {
  final _dateFormatter = DateFormat("yyyy M/d");
  bool _isLoading = false;

  Widget _adjustDateButton(DayToAdjust dayToAdjust) {
    return SizedBox(
      width: 130,
      child: ElevatedButton(
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
              _isLoading = true;
            });
            switch (dayToAdjust) {
              case (DayToAdjust.day1):
                await FirebaseFirestore.instance.collection("dataForInit").doc("dataForInitDoc").set(
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
                await FirebaseFirestore.instance.collection("dataForInit").doc("dataForInitDoc").set(
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
              _isLoading = false;
            });
          }
        },
        child: Text(dayToAdjust == DayToAdjust.day1 ? "1日目を変更" : "2日目を変更"),
      ),
    );
  }

  Widget _adjustSemesterButton() {
    return SizedBox(
      width: 130,
      child: ElevatedButton(
        onPressed: () => showDialog(
            context: context,
            builder: (_) {
              final String newSemesterString = ref.read(semesterProvider) == Semester.zenki ? "後期" : "前期";
              final Semester newSemester = ref.read(semesterProvider) == Semester.zenki ? Semester.kouki : Semester.zenki;
              return StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  insetPadding: const EdgeInsets.all(10),
                  title: const Text("確認"),
                  content: SizedBox(
                      height: 100,
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Center(
                              child: Text(
                                "$newSemesterStringに変更します",
                                style: const TextStyle(fontSize: 18),
                              ),
                            )),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: <Widget>[
                    if (!_isLoading)
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("キャンセル"),
                        ),
                      ),
                    if (!_isLoading)
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: FilledButton(
                          child: const Text("変更"),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await FirebaseFirestore.instance.collection("dataForInit").doc("dataForInitDoc").set({"semester": newSemester.name}, SetOptions(merge: true));
                            setState(() {
                              _isLoading = false;
                            });
                            ref.read(semesterProvider.notifier).state = newSemester;
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("変更しました")),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                  ],
                ),
              );
            }),
        child: const Text("学期を変更"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("日程")),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Text(
                  "学期：${ref.watch(semesterProvider) == Semester.zenki ? "前期" : "後期"}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const Expanded(child: SizedBox()),
                _isLoading ? const CircularProgressIndicator() : _adjustSemesterButton(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "1日目：${_dateFormatter.format(ref.watch(day1dateProvider))}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const Expanded(child: SizedBox()),
                _isLoading ? const CircularProgressIndicator() : _adjustDateButton(DayToAdjust.day1),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "2日目：${_dateFormatter.format(ref.watch(day2dateProvider))}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const Expanded(child: SizedBox()),
                _isLoading ? const CircularProgressIndicator() : _adjustDateButton(DayToAdjust.day2),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
