import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumutai_app/providers/init_data_provider.dart';

import 'package:webview_flutter/webview_flutter.dart';

class RuleBookScreen extends ConsumerStatefulWidget {
  static const routeName = "/rule-book-screen";
  const RuleBookScreen({super.key});

  @override
  ConsumerState<RuleBookScreen> createState() => _RuleBookScreenState();
}

class _RuleBookScreenState extends ConsumerState<RuleBookScreen> {
  bool _pageIsLoading = true;

  @override
  Widget build(BuildContext context) {
    final String ruleBookUrl = ref.watch(ruleBookUrlProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("るるぶ")),
      body: Stack(
        children: [
          WebView(
            initialUrl: ruleBookUrl,
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
