import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PublishDriveScreen extends StatefulWidget {
  static const routeName = "/publish-drive-screen";

  const PublishDriveScreen({super.key});

  @override
  State<PublishDriveScreen> createState() => _PublishDriveScreenState();
}

class _PublishDriveScreenState extends State<PublishDriveScreen> {
  bool _pageIsLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("情報公開")),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'https://drive.google.com/drive/folders/1MYYOBIsuRONhF1pvj7c7_XN2aqyBqztT?usp=drive_link',
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (String utl) {
              setState(() {
                _pageIsLoading = false;
              });
            },
          ),
          if (_pageIsLoading)
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
