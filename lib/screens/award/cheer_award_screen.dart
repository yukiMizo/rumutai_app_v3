import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CheerAwardScreen extends StatefulWidget {
  static const routeName = "/cheer-award-screen";
  const CheerAwardScreen({super.key});

  @override
  State<CheerAwardScreen> createState() => _CheerAwardScreenState();
}

class _CheerAwardScreenState extends State<CheerAwardScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  final Map<String, List<Map<String, String>>> _cheerRankMap = {};

  Future _loadData() async {
    setState(() {
      _isLoading = true;
    });
    debugPrint("loadedCheerData");
    FirebaseDatabase.instance.ref("cheer").get().then((data) {
      final dataMap = data.value as Map;
      List<Map<String, String>> cheerRankList1 = [];
      List<Map<String, String>> cheerRankList2 = [];
      List<Map<String, String>> cheerRankList3 = [];
      List<Map<String, String>> all = [];
      dataMap.forEach(
        (className, cheerNumber) {
          if (className[0] == "1") {
            cheerRankList1.add({"className": className, "cheerNumber": cheerNumber.toString()});
          } else if (className[0] == "2") {
            cheerRankList2.add({"className": className, "cheerNumber": cheerNumber.toString()});
          } else if (className[0] == "3") {
            cheerRankList3.add({"className": className, "cheerNumber": cheerNumber.toString()});
          }
          all.add({"className": className, "cheerNumber": cheerNumber.toString()});
        },
      );

      cheerRankList1.sort((a, b) => int.parse(b["cheerNumber"]!).compareTo(int.parse(a["cheerNumber"]!)));
      cheerRankList2.sort((a, b) => int.parse(b["cheerNumber"]!).compareTo(int.parse(a["cheerNumber"]!)));
      cheerRankList3.sort((a, b) => int.parse(b["cheerNumber"]!).compareTo(int.parse(a["cheerNumber"]!)));
      all.sort((a, b) => int.parse(b["cheerNumber"]!).compareTo(int.parse(a["cheerNumber"]!)));
      _cheerRankMap["1年"] = cheerRankList1;
      _cheerRankMap["2年"] = cheerRankList2;
      _cheerRankMap["3年"] = cheerRankList3;
      _cheerRankMap["総合"] = all;
      setState(() {
        _isLoading = false;
      });
    });
  }

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

  Widget _rankPartWidget(int place, Map rankInfoMap) {
    return SizedBox(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 40),
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
            "${rankInfoMap["cheerNumber"]!}",
            style: TextStyle(fontSize: 25, color: Colors.brown.shade900, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _rankWidget({required String title, required List rankData, required bool canShow}) {
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
                  return _rankPartWidget(index + 1, rankData[index]);
                },
              )
            : Text(
                "順位決定時に更新されます",
                style: TextStyle(color: Colors.brown.shade900),
              ),
      ],
    );
  }

  String _mapKey(int index) {
    if (index == 0) {
      return "1年";
    } else if (index == 1) {
      return "2年";
    } else if (index == 2) {
      return "3年";
    } else if (index == 3) {
      return "総合";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    if (_isInit) {
      _loadData();
      _isInit = false;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("表彰　応援数")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              width: double.infinity,
              child: Scrollbar(
                child: ListView.builder(
                    itemCount: _cheerRankMap.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: _rankWidget(
                          canShow: true,
                          title: _mapKey(index),
                          rankData: _cheerRankMap[_mapKey(index)]!,
                        ),
                      );
                    }),
              ),
            ),
    );
  }
}
