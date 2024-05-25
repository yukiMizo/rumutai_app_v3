import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../local_data.dart';

enum SportsType {
  futsal(["フットサル", "フットサル"]),
  basketball(["バスケ", "バスケットボール"]),
  volleyball(["バレー", "バレーボール"]),
  dodgeball(["ドッジボール", "ドッジボール"]),
  dodgebee(["ドッヂビー", "ドッヂビー"]);

  final List<String> japaneseList;
  const SportsType(this.japaneseList);

  String asShortJapanse() => japaneseList[0];
  String asLongJapanse() => japaneseList[1];
}

enum TournamentType { four, four2, five, five2, six, seven }

enum Semester { zenki, kouki }

class SportsTypeMapNotifier extends StateNotifier<Map<String, SportsType>> {
  SportsTypeMapNotifier()
      : super({
          "1d": SportsType.futsal,
          "1j": SportsType.basketball,
          "1k": SportsType.volleyball,
          "2d": SportsType.basketball,
          "2j": SportsType.dodgeball,
          "2k": SportsType.volleyball,
          "3d": SportsType.futsal,
          "3j": SportsType.dodgebee,
          "3k": SportsType.volleyball,
        });

  void setAllData(Map<String, SportsType> newData) {
    state = {...newData};
  }
}

class TournamentTypeMapNotifier extends StateNotifier<Map<String, TournamentType>> {
  TournamentTypeMapNotifier()
      : super({
          "1d-f": TournamentType.four,
          "1d-l": TournamentType.five,
          "1j-f": TournamentType.four,
          "1j-l": TournamentType.five,
          "1k-f": TournamentType.four,
          "1k-l": TournamentType.five,
          "2d-f": TournamentType.four,
          "2d-l": TournamentType.five,
          "2j-f": TournamentType.four,
          "2j-l": TournamentType.five,
          "2k-f": TournamentType.four,
          "2k-l": TournamentType.five,
          "3d-f": TournamentType.four,
          "3d-l": TournamentType.five,
          "3j-f": TournamentType.four,
          "3j-l": TournamentType.five,
          "3k-f": TournamentType.four,
          "3k-l": TournamentType.five,
        });

  void setAllData(Map<String, TournamentType> newData) {
    state = {...newData};
  }
}

final sportsTypeMapProvider = StateNotifierProvider<SportsTypeMapNotifier, Map<String, SportsType>>((ref) => SportsTypeMapNotifier());
final tournamentTypeMapProvider = StateNotifierProvider<TournamentTypeMapNotifier, Map<String, TournamentType>>((ref) => TournamentTypeMapNotifier());

final ruleBookUrlProvider = StateProvider<String>((ref) => "");

final semesterProvider = StateProvider<Semester>((ref) => Semester.zenki);

final day1dateProvider = StateProvider<DateTime>((ref) => DateTime(2024, 3, 13));
final day2dateProvider = StateProvider<DateTime>((ref) => DateTime(2024, 3, 14));

//3年生を表示するかチェック（semesterから判断しても良いが一応データを基準にしている）
final show3rdGradeProvider = StateProvider<bool>((ref) {
  bool show3rdGradeProvider = false;
  final Map<String, SportsType> sportsTypeMap = ref.watch(sportsTypeMapProvider);
  sportsTypeMap.forEach((id, _) {
    if (id.contains("3")) {
      show3rdGradeProvider = true;
    }
  });
  return show3rdGradeProvider;
});

class InitDataManager {
  static final formatter = DateFormat('yyyy-M-d');
  static Future<void> setData(WidgetRef ref) async {
    try {
      debugPrint("loadedDateData");
      final gotData = await FirebaseFirestore.instance.collection("dataForInit").doc("dataForInitDoc").get();

      //るるぶ関連
      ref.read(ruleBookUrlProvider.notifier).state = gotData["ruleBookUrl"];

      //sports,tournament 関連
      final String semesterString = gotData["semester"];
      final String sportsKey = semesterString == Semester.zenki.name ? "sportsZenki" : "sportsKouki";
      final String tournamentKey = semesterString == Semester.zenki.name ? "tournamentZenki" : "tournamentKouki";

      final List<String> sportsIdList = [];
      final List<String> sportsList = [];
      final List<String> tournamentIdList = [];
      final List<String> tournamentList = [];
      gotData[sportsKey].forEach((id, sport) {
        sportsIdList.add(id);
        sportsList.add(sport);
      });
      gotData[tournamentKey].forEach((id, tournament) {
        tournamentIdList.add(id);
        tournamentList.add(tournament);
      });
      //localに保存
      await LocalData.saveLocalData<List>("sportsIdList", sportsIdList);
      await LocalData.saveLocalData<List>("sportsList", sportsList);
      await LocalData.saveLocalData<List>("tournamentIdList", tournamentIdList);
      await LocalData.saveLocalData<List>("tournamentList", tournamentList);
      //providerの値を更新
      _setSportsAndTournamentFromLocal(ref);

      //dateData 関連

      final day1data = gotData["day1"];
      final day2data = gotData["day2"];

      final String day1dateString = formatter.format(DateTime(day1data["year"], day1data["month"], day1data["day"]));
      final String day2dateString = formatter.format(DateTime(day2data["year"], day2data["month"], day2data["day"]));
      //localに保存
      await LocalData.saveLocalData<String>("semester", semesterString);
      await LocalData.saveLocalData<String>("day1date", day1dateString);
      await LocalData.saveLocalData<String>("day2date", day2dateString);

      //providerの値を更新
      await _setDateDataFromLocal(ref);
    } catch (_) {
      await _setDateDataFromLocal(ref);
    }
  }

  static Future<void> _setSportsAndTournamentFromLocal(WidgetRef ref) async {
    final List<String>? sportsIdList = await LocalData.readLocalData<List>("sportsIdList");
    final List<String>? sportsList = await LocalData.readLocalData<List>("sportsList");
    final List<String>? tournamentIdList = await LocalData.readLocalData<List>("tournamentIdList");
    final List<String>? tournamentList = await LocalData.readLocalData<List>("tournamentList");
    if (sportsIdList == null || sportsList == null || tournamentIdList == null || tournamentList == null) {
      return;
    }

    Map<String, SportsType> sportsTypeMap = {};
    Map<String, TournamentType> tournamentTypeMap = {};
    for (String id in sportsIdList) {
      final SportsType sportType = SportsType.values.byName(sportsList[sportsIdList.indexOf(id)]);
      sportsTypeMap[id] = sportType;
    }
    for (String id in tournamentIdList) {
      final TournamentType tournamentType = TournamentType.values.byName(tournamentList[tournamentIdList.indexOf(id)]);
      tournamentTypeMap[id] = tournamentType;
    }

    ref.read(sportsTypeMapProvider.notifier).setAllData(sportsTypeMap);
    ref.read(tournamentTypeMapProvider.notifier).setAllData(tournamentTypeMap);
  }

  static Future<void> _setDateDataFromLocal(WidgetRef ref) async {
    final String? semesterString = await LocalData.readLocalData<String>("semester");
    final String? day1dateString = await LocalData.readLocalData<String>("day1date");
    final String? day2dateString = await LocalData.readLocalData<String>("day2date");
    if (day1dateString == null || day2dateString == null || semesterString == null) {
      return;
    }

    ref.read(semesterProvider.notifier).state = Semester.values.byName(semesterString);
    ref.read(day1dateProvider.notifier).state = formatter.parse(day1dateString);
    ref.read(day2dateProvider.notifier).state = formatter.parse(day2dateString);
  }
}
