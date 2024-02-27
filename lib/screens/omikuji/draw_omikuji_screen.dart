import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DrawOmikujiScreen extends StatefulWidget {
  static const routeName = "/draw-omikuji-screen";
  const DrawOmikujiScreen({super.key});

  @override
  State<DrawOmikujiScreen> createState() => _DrawOmikujiScreenState();
}

class _DrawOmikujiScreenState extends State<DrawOmikujiScreen> {
  final List _rotateList = [0, 10, -10, 0];
  bool _isLoading = false;
  bool _isInit = true;
  final List _omikujiDataList = [];

  int _rotateCount = 0;

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

  Map get _randomOmikujiData {
    return _omikujiDataList[Random().nextInt(_omikujiDataList.length)];
  }

  Widget _omikuji() {
    final omikujiData = _randomOmikujiData;
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      backgroundColor: Colors.orange.shade50,
      content: SizedBox(
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
      /* actionsAlignment: MainAxisAlignment.start,
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 15),
          child: IconButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.favorite_outline),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: StatefulBuilder(builder: (BuildContext context, StateSetter setStateInDialog) {
            return Text(omikujiData["id"]);
          }),
        ),
      ],*/
    );
  }

  Future _loadData() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance.collection("omikujiDataToRead").doc("omikujiDataToReadDoc").get().then((DocumentSnapshot doc) {
        final Map gotMap = doc.data() as Map;
        gotMap.forEach((id, map) {
          _omikujiDataList.add({"map": map, "id": id});
        });
      });

      setState(() {
        _isLoading = false;
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
      appBar: AppBar(title: const Text("おみくじを引く")),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              "タップでおみくじを引く",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.brown.shade900,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 50),
            Hero(
              tag: "omikuji-image",
              child: GestureDetector(
                onTap: _isLoading
                    ? null
                    : () {
                        _rotateCount++;
                        if (_rotateCount == 3) {
                          _rotateCount = 0;
                          showDialog(
                            context: context,
                            builder: (_) => _omikuji(),
                          );
                        }
                        setState(() {});
                      },
                child: Transform.rotate(
                  angle: _rotateList[_rotateCount] * pi / 180,
                  child: SizedBox(
                    width: 130,
                    child: Image.asset("assets/images/omikuji.png"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            if (_isLoading) const CircularProgressIndicator(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
