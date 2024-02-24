import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  static const routeName = "/map-screen";

  MapScreen({
    super.key,
  });

  final _viewTransformationController = TransformationController();
  void _setMapToView(String? place) {
    if (place == null) {
      return;
    }
    late double zoomFactor;
    late double xTranslate;
    late double yTranslate;
    if (place.contains("運動場")) {
      zoomFactor = 1.5;
      xTranslate = 150.0;
      yTranslate = 300.0;
    } else if (place.contains("鯱光館")) {
      zoomFactor = 1.3;
      xTranslate = 100.0;
      yTranslate = 0.0;
    } else if (place.contains("外バレ")) {
      zoomFactor = 1.5;
      xTranslate = 0.0;
      yTranslate = 0.0;
    } else if (place.contains("小体育館")) {
      zoomFactor = 1.5;
      xTranslate = 0.0;
      yTranslate = 100.0;
    } else if (place.contains("ハンドボールコート")) {
      zoomFactor = 1.5;
      xTranslate = 0.0;
      yTranslate = 300.0;
    } else {
      return;
    }
    _viewTransformationController.value.setEntry(0, 0, zoomFactor);
    _viewTransformationController.value.setEntry(1, 1, zoomFactor);
    _viewTransformationController.value.setEntry(2, 2, zoomFactor);
    _viewTransformationController.value.setEntry(0, 3, -xTranslate);
    _viewTransformationController.value.setEntry(1, 3, -yTranslate);
  }

  @override
  Widget build(BuildContext context) {
    final String? place = ModalRoute.of(context)!.settings.arguments as String?;
    _setMapToView(place);

    return Scaffold(
      appBar: AppBar(title: const Text("マップ")),
      body: InteractiveViewer(
        transformationController: _viewTransformationController,
        maxScale: 5,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset("assets/images/map.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
