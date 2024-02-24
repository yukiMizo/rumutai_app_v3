import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SendNotificationScreen extends StatefulWidget {
  static const routeName = "/send-notification-screen";

  const SendNotificationScreen({super.key});

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("通知の送信")),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),
                SizedBox(
                  width: 300,
                  child: Text(
                    "タイトルと内容を入力して送信",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.brown.shade900,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _titleController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      label: const Text("タイトル"),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) => setState(() {}),
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      label: const Text("内容"),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: 300,
                  child: FilledButton(
                    onPressed: (_controller.text == "" || _titleController.text == "")
                        ? null
                        : () => showDialog(
                            context: context,
                            builder: (_) {
                              return StatefulBuilder(
                                builder: (context, setState) => AlertDialog(
                                  title: const Text("確認"),
                                  content: SizedBox(
                                    height: 200,
                                    child: _isLoading
                                        ? const Center(child: CircularProgressIndicator())
                                        : SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                const Text('以下の内容で通知を送信します。'),
                                                const Divider(),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    _titleController.text,
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    _controller.text,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: <Widget>[
                                    if (!_isLoading)
                                      SizedBox(
                                        width: 120,
                                        height: 40,
                                        child: OutlinedButton(
                                          style: ButtonStyle(
                                            foregroundColor: MaterialStateProperty.all(Colors.black),
                                          ),
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("キャンセル"),
                                        ),
                                      ),
                                    if (!_isLoading)
                                      SizedBox(
                                        width: 120,
                                        height: 40,
                                        child: FilledButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                          child: const Text("送信"),
                                          onPressed: () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            await FirebaseFirestore.instance
                                                .collection("notification")
                                                .add({"timeStamp": Timestamp.fromDate(DateTime.now()), "content": _controller.text, "title": _titleController.text});
                                            _controller.text = "";
                                            _titleController.text = "";
                                            _isLoading = false;
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text("通知を送信しました"),
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                    child: const Text("送信"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
