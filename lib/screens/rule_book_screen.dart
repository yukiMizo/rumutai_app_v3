import 'package:flutter/material.dart';
import 'package:rumutai_app/themes/app_color.dart';

import 'package:webview_flutter/webview_flutter.dart';

//import 'package:pdfx/pdfx.dart';

class RuleBookScreen extends StatefulWidget {
  static const routeName = "/rule-book-screen";
  const RuleBookScreen({super.key});

  @override
  State<RuleBookScreen> createState() => _RuleBookScreenState();
}

class _RuleBookScreenState extends State<RuleBookScreen> {
  /*final pdfController = PdfControllerPinch(
    document: PdfDocument.openAsset('assets/documents/rule_book.pdf'),
  );*/
  bool _pageIsLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("るるぶ")),
      body: Stack(
        children: [
          WebView(
            initialUrl: "https://drive.google.com/drive/folders/1P7izGwdZvwUPkB68R9_ucYPluzhLqETZ",
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
              color: AppColors.scaffoldBackgroundColor,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      /*PdfViewPinch(
        controller: pdfController,
        builders: const PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: DefaultBuilderOptions(
            loaderSwitchDuration: Duration(milliseconds: 300),
          ),
        ),
      ),*/
    );
  }
}
