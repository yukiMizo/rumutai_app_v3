import 'package:flutter/material.dart';
import 'package:rumutai_app/screens/drawer/info_screen.dart';

import '../themes/app_color.dart';
import '../screens/drawer/map_screen.dart';
import '../screens/home_screen.dart';

class MainPopUpMenu extends StatelessWidget {
  final String? place;
  const MainPopUpMenu({super.key, this.place});

  Widget _popUpMenuChild({required String text, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.themeColor.shade900),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(color: AppColors.themeColor.shade900),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: PopupMenuButton(
        color: AppColors.themeColor.shade50,
        onSelected: (selectedValue) {
          switch (selectedValue) {
            case "情報":
              Navigator.of(context).pushNamed(InfoScreen.routeName);
              return;
            case "マップ":
              Navigator.of(context).pushNamed(MapScreen.routeName, arguments: place);
              return;
            case "ホーム":
              Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
              return;
          }
        },
        position: PopupMenuPosition.under,
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            value: "情報",
            child: _popUpMenuChild(text: "情報", icon: Icons.article_outlined),
          ),
          PopupMenuItem(
            value: "マップ",
            child: _popUpMenuChild(text: "マップ", icon: Icons.map_outlined),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: "ホーム",
            child: _popUpMenuChild(text: "ホーム", icon: Icons.home_outlined),
          ),
        ],
        child: const Icon(Icons.more_vert),
      ),
    );
  }
}
