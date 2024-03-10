import 'package:flutter/material.dart';
import 'package:rumutai_app/screens/drawer/place_schedule_screen.dart';
import 'package:rumutai_app/themes/app_color.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  static const routeName = "/map-screen";

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Widget _placeScheduleButton2(placeName, double x, double y, double width, double hight) {
    return Align(
      alignment: Alignment(x, y),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
          side: const BorderSide(
            color: AppColors.themeColor,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(PlaceScheduleScreen.routeName, arguments: placeName);
          },
          child: SizedBox(
            width: width,
            height: hight,
            child: Center(
              child: Text(
                (placeName),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.themeColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("マップ")),
      body: InteractiveViewer(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 380,
            height: 600,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: Stack(alignment: Alignment.topCenter, children: [
                Center(child: Image.asset("assets/images/map_background.png")),
                Text(
                  "※タップすると各場所のスケジュールが確認できます",
                  style: TextStyle(color: AppColors.themeColor.shade900, fontSize: 12),
                ),
                _placeScheduleButton2("外バレ北", -0.65, -0.93, 130, 60),
                _placeScheduleButton2("外バレ南", -0.65, -0.68, 130, 60),
                _placeScheduleButton2("鯱光館東", 1, -0.37, 140, 80),
                _placeScheduleButton2("鯱光館西", -0.4, -0.37, 140, 80),
                _placeScheduleButton2("小体育館", -0.9, 0.11, 120, 60),
                _placeScheduleButton2("ハンドボールコート", -0.8, 0.5, 150, 80),
                _placeScheduleButton2("運動場A", 1, 0.4, 160, 72),
                _placeScheduleButton2("運動場B", 1, 0.7, 160, 72),
                _placeScheduleButton2("運動場C", 1, 1, 160, 72),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
