import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagaeOmikujiScreen extends StatefulWidget {
  static const routeName = "/manage-omikuji-screen";

  const ManagaeOmikujiScreen({super.key});

  @override
  State<ManagaeOmikujiScreen> createState() => _ManagaeOmikujiScreenState();
}

class _ManagaeOmikujiScreenState extends State<ManagaeOmikujiScreen> {
  bool _isLoading = false;
  bool _isInit = true;
  bool _dialogIsLoading = false;

  final List _reportedOmikujiDataList = [];

  Future _loadData() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      debugPrint("loadedOmikujiData");
      final List<String> reportedOmikujiIdList = [];
      await FirebaseFirestore.instance.collection("reportedOmikujiIds").doc("reportedOmikujiIdsDoc").get().then((DocumentSnapshot doc) {
        final Map gotMap = doc.data() as Map;
        gotMap.forEach((id, _) {
          reportedOmikujiIdList.add(id);
        });
      });
      await FirebaseFirestore.instance.collection("omikujiDataToRead").doc("omikujiDataToReadDoc").get().then((DocumentSnapshot doc) {
        final Map gotMap = doc.data() as Map;
        gotMap.forEach((id, map) {
          if (reportedOmikujiIdList.contains(id)) {
            _reportedOmikujiDataList.add({"map": map, "id": id});
          }
        });
      });

      setState(() {
        _isLoading = false;
      });
      _isInit = false;
    }
  }

  Widget _textForOmikuji({
    required String title,
    required String content,
  }) {
    if (title == "" || content == "") {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "YujiSyuku",
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  content,
                  style: const TextStyle(
                    fontFamily: "YujiSyuku",
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOmikujiCard(Map omikujiData) {
    return Column(
      children: [
        Expanded(
          child: FittedBox(
            child: Card(
              elevation: 1,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 36, right: 24, left: 24),
                child: SizedBox(
                  height: 460,
                  width: 250,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Text(
                        omikujiData["map"]["fortune"],
                        style: const TextStyle(
                          fontFamily: "YujiSyuku",
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              omikujiData["map"]["oneWord"],
                              style: const TextStyle(
                                fontFamily: "YujiSyuku",
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.brown),
                      ListView.builder(
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: omikujiData["map"]["content"].length,
                        itemBuilder: (context, index) {
                          return _textForOmikuji(
                            title: omikujiData["map"]["content"][index]["title"],
                            content: omikujiData["map"]["content"][index]["content"],
                          );
                        },
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: Colors.grey),
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) {
                    return _buildDeleteDialog(omikujiData);
                  }),
              icon: const Icon(Icons.delete_outline),
            ),
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: Colors.green.shade300),
              onPressed: () => showDialog(
                  context: context,
                  builder: (_) {
                    return _buildUnreportDialog(omikujiData);
                  }),
              icon: const Icon(Icons.thumb_up_outlined),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildContentOfDialog(Map omikujiData, String message) {
    return SizedBox(
      height: 350,
      child: _dialogIsLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 280,
                      child: Card(
                        elevation: 1,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                        color: Colors.orange.shade50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                omikujiData["map"]["fortune"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: "YujiSyuku",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    omikujiData["map"]["oneWord"],
                                    style: const TextStyle(
                                      fontFamily: "YujiSyuku",
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Divider(color: Colors.brown),
                            ListView.builder(
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: omikujiData["map"]["content"].length,
                              itemBuilder: (context, index) {
                                return _textForOmikuji(
                                  title: omikujiData["map"]["content"][index]["title"],
                                  content: omikujiData["map"]["content"][index]["content"],
                                );
                              },
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.brown.shade900,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildUnreportDialog(Map omikujiData) {
    return StatefulBuilder(
      builder: (context, setStateInDialog) => AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        title: const Text("確認"),
        content: _buildContentOfDialog(omikujiData, "このおみくじの報告を取り消します"),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          if (!_dialogIsLoading)
            SizedBox(
              width: 120,
              height: 40,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("キャンセル"),
              ),
            ),
          if (!_dialogIsLoading)
            SizedBox(
              width: 120,
              height: 40,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.green.shade400),
                child: const Text("取り消し"),
                onPressed: () async {
                  setStateInDialog(() {
                    _dialogIsLoading = true;
                  });
                  await FirebaseFirestore.instance.collection("reportedOmikujiIds").doc("reportedOmikujiIdsDoc").set(
                    {omikujiData["id"]: FieldValue.delete()},
                    SetOptions(merge: true),
                  );
                  setState(() {
                    _reportedOmikujiDataList.remove(omikujiData);
                  });
                  _dialogIsLoading = false;
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('おみくじの報告を取り消しました'),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeleteDialog(Map omikujiData) {
    return StatefulBuilder(
      builder: (context, setStateInDialog) => AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        title: const Text("確認"),
        content: _buildContentOfDialog(omikujiData, "このおみくじを削除します"),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          if (!_dialogIsLoading)
            SizedBox(
              width: 120,
              height: 40,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("キャンセル"),
              ),
            ),
          if (!_dialogIsLoading)
            SizedBox(
              width: 120,
              height: 40,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text("削除"),
                onPressed: () async {
                  setStateInDialog(() {
                    _dialogIsLoading = true;
                  });
                  await FirebaseFirestore.instance.collection("omikujiData").doc(omikujiData["id"]).delete();
                  await FirebaseFirestore.instance.collection("omikujiDataToRead").doc("omikujiDataToReadDoc").set(
                    {omikujiData["id"]: FieldValue.delete()},
                    SetOptions(merge: true),
                  );
                  await FirebaseFirestore.instance.collection("reportedOmikujiIds").doc("reportedOmikujiIdsDoc").set(
                    {omikujiData["id"]: FieldValue.delete()},
                    SetOptions(merge: true),
                  );
                  setState(() {
                    _reportedOmikujiDataList.remove(omikujiData);
                  });
                  _dialogIsLoading = false;
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('おみくじを削除しました'),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
      appBar: AppBar(title: const Text("管理")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Column(children: [
                const Text("報告があったおみくじです", style: TextStyle(fontWeight: FontWeight.w500)),
                _reportedOmikujiDataList.isEmpty
                    ? const SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Center(child: Text("報告されたおみくじはありません")),
                        ))
                    : Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 30),
                          scrollDirection: Axis.horizontal,
                          itemCount: _reportedOmikujiDataList.length,
                          itemBuilder: ((context, index) {
                            return _buildOmikujiCard(_reportedOmikujiDataList[index]);
                          }),
                        ),
                      ),
              ]),
            ),
    );
  }
}
