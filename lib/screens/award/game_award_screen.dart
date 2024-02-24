import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameAwardScreen extends StatefulWidget {
  static const routeName = "/game-award-screen";
  const GameAwardScreen({super.key});

  @override
  State<GameAwardScreen> createState() => _GameAwardScreenState();
}

class _GameAwardScreenState extends State<GameAwardScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  List _rankDataList = [];

  Widget _dividerWithText(String text) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              child: Divider(
                thickness: 3,
                color: Colors.brown.shade800,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.brown.shade900,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 3,
              color: Colors.brown.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rankPartWidget(int place, Map rankInfoMap, String unit) {
    return SizedBox(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              "${place.toString()}位",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 25, color: Colors.brown.shade900, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 30),
          Text(
            rankInfoMap["className"]!,
            style: TextStyle(fontSize: 25, color: Colors.brown.shade900, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 30),
          Text(
            "${rankInfoMap["point"]!}$unit",
            style: TextStyle(fontSize: 25, color: Colors.brown.shade900, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _rankWidget({required String title, required List rankData, required String unit, required bool canShow}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _dividerWithText(title),
        const SizedBox(height: 10),
        canShow
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rankData.length,
                itemBuilder: (BuildContext context, int index) {
                  return _rankPartWidget(index + 1, rankData[index], unit);
                },
              )
            : Text(
                "順位決定時に更新されます",
                style: TextStyle(color: Colors.brown.shade900),
              ),
      ],
    );
  }

  Future _loadData(String grade) async {
    setState(() {
      _isLoading = true;
    });
    await FirebaseFirestore.instance.collection("award").doc("gameResult").get().then((DocumentSnapshot doc) {
      dynamic d = doc.data();
      _rankDataList = d[grade];
    });
/*
    await FirebaseFirestore.instance.collection("award").doc("gameResult").set({
      "1年": [
        {
          "title": "総合順位",
          "canShow": false,
          "rankData": [
            {"className": "106", "point": "30"},
            {"className": "101", "point": "20"},
            {"className": "102", "point": "19"},
            {"className": "103", "point": "18"},
            {"className": "104", "point": "17"},
            {"className": "105", "point": "16"},
            {"className": "107", "point": "15"},
            {"className": "108", "point": "14"},
            {"className": "109", "point": "13"},
            {"className": "110", "point": "12"},
          ],
          "unit": "pt",
        },
        {
          "title": "フットサル",
          "canShow": true,
          "rankData": [
            {"className": "105", "point": ""},
            {"className": "103", "point": ""},
            {"className": "101", "point": ""},
            {"className": "102", "point": ""},
          ],
          "unit": "",
        },
        {
          "title": "バレーボール",
          "canShow": true,
          "rankData": [
            {"className": "103", "point": ""},
            {"className": "101", "point": ""},
          ],
          "unit": "",
        },
        {
          "title": "ドッジボール",
          "canShow": true,
          "rankData": [
            {"className": "106", "point": ""},
            {"className": "107", "point": ""},
          ],
          "unit": "",
        },
      ],
      "2年": [
        {
          "title": "総合順位",
          "canShow": false,
          "rankData": [
            {"className": "206", "point": "30"},
            {"className": "201", "point": "20"},
            {"className": "202", "point": "19"},
            {"className": "203", "point": "18"},
            {"className": "204", "point": "17"},
            {"className": "205", "point": "16"},
            {"className": "207", "point": "15"},
            {"className": "208", "point": "14"},
            {"className": "209", "point": "13"},
            {"className": "210", "point": "12"},
          ],
          "unit": "pt",
        },
        {
          "title": "フットサル",
          "canShow": true,
          "rankData": [
            {"className": "203", "point": ""},
            {"className": "205", "point": ""},
            {"className": "208", "point": ""},
            {"className": "204", "point": ""},
          ],
          "unit": "",
        },
        {
          "title": "バスケットボール",
          "canShow": true,
          "rankData": [
            {"className": "202", "point": ""},
            {"className": "210a", "point": ""},
            {"className": "204", "point": ""},
            {"className": "208", "point": ""},
          ],
          "unit": "",
        },
        {
          "title": "バレーボール",
          "canShow": true,
          "rankData": [
            {"className": "201", "point": ""},
            {"className": "202", "point": ""},
          ],
          "unit": "",
        },
      ],
      "3年": [
        {
          "title": "総合順位",
          "canShow": false,
          "rankData": [
            {"className": "206", "point": "30"},
            {"className": "201", "point": "20"},
            {"className": "202", "point": "19"},
            {"className": "203", "point": "18"},
            {"className": "204", "point": "17"},
            {"className": "205", "point": "16"},
            {"className": "207", "point": "15"},
            {"className": "208", "point": "14"},
            {"className": "209", "point": "13"},
            {"className": "210", "point": "12"},
          ],
          "unit": "pt",
        },
        {
          "title": "フットサル",
          "canShow": true,
          "rankData": [
            {"className": "308", "point": ""},
            {"className": "303", "point": ""},
            {"className": "305", "point": ""},
            {"className": "301", "point": ""},
          ],
          "unit": "",
        },
        {
          "title": "ドッヂビー",
          "canShow": true,
          "rankData": [
            {"className": "305", "point": ""},
            {"className": "306", "point": ""},
            {"className": "301", "point": ""},
            {"className": "308", "point": ""},
          ],
          "unit": "",
        },
        {
          "title": "バレーボール",
          "canShow": true,
          "rankData": [
            {"className": "307", "point": ""},
            {"className": "306", "point": ""},
            {"className": "304", "point": ""},
            {"className": "302", "point": ""},
          ],
          "unit": "",
        },
      ]
    });
*/
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String grade = ModalRoute.of(context)!.settings.arguments as String;
    if (_isInit) {
      _loadData(grade);
      _isInit = false;
    }
    return Scaffold(
      appBar: AppBar(title: Text("表彰　$grade")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              width: double.infinity,
              child: Scrollbar(
                child: ListView.builder(
                    itemCount: _rankDataList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: _rankWidget(
                          canShow: _rankDataList[index]["canShow"],
                          title: _rankDataList[index]["title"],
                          rankData: _rankDataList[index]["rankData"],
                          unit: _rankDataList[index]["unit"],
                        ),
                      );
                    }), /*Column(children: [
              const SizedBox(height: 20),
              _rankWidget(
                title: "総合順位",
                rankList: [
                  {"className": "206", "point": "30"},
                  {"className": "201", "point": "20"},
                  {"className": "202", "point": "19"},
                  {"className": "203", "point": "18"},
                  {"className": "204", "point": "17"},
                  {"className": "205", "point": "16"},
                  {"className": "207", "point": "15"},
                  {"className": "208", "point": "14"},
                  {"className": "209", "point": "13"},
                  {"className": "210", "point": "12"},
                ],
                unit: "pt",
              ),
              const SizedBox(height: 30),
              _rankWidget(
                title: "フットサル",
                rankList: [
                  {"className": "206", "point": "30"},
                  {"className": "201", "point": "20"},
                  {"className": "202", "point": "19"},
                  {"className": "203", "point": "18"},
                  {"className": "204", "point": "17"},
                  {"className": "205", "point": "16"},
                  {"className": "207", "point": "15"},
                  {"className": "208", "point": "14"},
                  {"className": "209", "point": "13"},
                  {"className": "210", "point": "12"},
                ],
                unit: "点",
              ),
              const SizedBox(height: 30),
              _rankWidget(
                title: "バスケットボール",
                rankList: [
                  {"className": "206", "point": "30"},
                  {"className": "201", "point": "20"},
                  {"className": "202", "point": "19"},
                  {"className": "203", "point": "18"},
                  {"className": "204", "point": "17"},
                  {"className": "205", "point": "16"},
                  {"className": "207", "point": "15"},
                  {"className": "208", "point": "14"},
                  {"className": "209", "point": "13"},
                  {"className": "210", "point": "12"},
                ],
                unit: "点",
              ),
              const SizedBox(height: 30),
              _rankWidget(
                title: "バレーボール",
                rankList: [
                  {"className": "206", "point": "30"},
                  {"className": "201", "point": "20"},
                  {"className": "202", "point": "19"},
                  {"className": "203", "point": "18"},
                  {"className": "204", "point": "17"},
                  {"className": "205", "point": "16"},
                  {"className": "207", "point": "15"},
                  {"className": "208", "point": "14"},
                  {"className": "209", "point": "13"},
                  {"className": "210", "point": "12"},
                ],
                unit: "点",
              ),
              const SizedBox(height: 30),
            ]),*/
              ),
            ),
    );
  }
}
