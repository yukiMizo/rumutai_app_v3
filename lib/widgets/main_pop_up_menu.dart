import 'package:flutter/material.dart';

import '../screens/drawer/map_screen.dart';
import '../screens/home_screen.dart';
import '../screens/drawer/setting_screen.dart';

class MainPopUpMenu extends StatelessWidget {
  final String? place;
  const MainPopUpMenu({super.key, this.place});

  Widget _popUpMenuChild({required String text, required IconData icon}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.brown.shade900,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: Colors.brown.shade900,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: PopupMenuButton(
        color: Colors.brown.shade50,
        onSelected: (selectedValue) {
          switch (selectedValue) {
            case "法的事項":
              Navigator.of(context).pushNamed(SettingScreen.routeName);
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
            value: "法的事項",
            child: _popUpMenuChild(text: "法的事項", icon: Icons.settings_outlined),
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
