import 'dart:async';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../home_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/local_data.dart';

class TimelineDataToPass {
  final Map data;
  final int index;

  TimelineDataToPass({
    required this.data,
    required this.index,
  });
}

class TimelineScreen extends StatefulWidget {
  static const routeName = "/timeline-screen";

  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  bool _isLoading = false;
  bool _isInit = true;
  final List<Map> _timelines = [];

  Future _loadData() async {
    setState(() {
      _isLoading = true;
    });
    var gotData = await FirebaseFirestore.instance.collection("Timeline").get();
    for (var data in gotData.docs) {
      final d = data.data();
      final String id = data.id;
      _timelines.add({
        "id": id,
        "timeStamp": d["timeStamp"].toDate(),
        "title": d["title"],
      });
    }
    _timelines.sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));
    setState(() {
      _isLoading = false;
    });
  }

  Widget _dialog({required timelineData}) {
    bool dialogIsLoading = false;
    return StatefulBuilder(
      builder: (context, setStateInDialog) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: const Text("確認"),
          content: SizedBox(
            height: 200,
            width: 200,
            child: dialogIsLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(timelineData["title"]),
                      ),
                      const Divider(),
                      const Text(
                        "を消去します。",
                      )
                    ],
                  ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            if (!dialogIsLoading)
              SizedBox(
                width: 140,
                height: 40,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("キャンセル"),
                ),
              ),
            if (!dialogIsLoading)
              SizedBox(
                width: 140,
                height: 40,
                child: FilledButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: const Text("消去"),
                  onPressed: () async {
                    setStateInDialog(() {
                      dialogIsLoading = true;
                    });
                    await FirebaseFirestore.instance.collection("Timeline").doc(timelineData["id"]).delete();
                    dialogIsLoading = false;
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('タイムラインを消去しました。'),
                      ),
                    );
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(HomeScreen.routeName),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _timelineWidget({
    required timelineData,
    required int index,
    bool? isLoggedInAdmin,
  }) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        child: Hero(
          tag: "timeline-tag$index",
          child: Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 250,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            timelineData["title"],
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('yyyy/MM/dd HH:mm').format(timelineData["timeStamp"]),
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  if (isLoggedInAdmin == true) const Expanded(child: SizedBox()),
                  if (isLoggedInAdmin == true)
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) {
                          return _dialog(timelineData: timelineData);
                        },
                      ),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool? isLoggedInAdmin = Provider.of<LocalData>(context, listen: false).isLoggedInAdmin;

    if (_isInit) {
      _loadData();
      _isInit = false;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("タイムライン")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Scrollbar(
              child: ListView.builder(
                itemCount: (_timelines.isEmpty) ? 0 : _timelines.length + 1,
                itemBuilder: ((context, index) {
                  index -= 1;
                  if (index == -1) {
                    return Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5));
                  }
                  return _timelineWidget(
                    timelineData: _timelines[index],
                    index: index,
                    isLoggedInAdmin: isLoggedInAdmin,
                  );
                }),
              ),
            ),
    );
  }
}
