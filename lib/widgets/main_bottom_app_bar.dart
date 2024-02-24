/*import 'package:flutter/material.dart';

import '../screens/drawer/sign_in_screen.dart';
import '../screens/home_screen.dart';
import '../screens/drawer/map_screen.dart';

class MainBottomAppBar extends StatelessWidget {
  const MainBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      color: Colors.brown.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(SignInScreen.routeName),
            icon: Icon(
              Icons.settings_outlined,
              size: 30,
              color: Colors.brown.shade900,
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () => Navigator.popUntil(
                context, ModalRoute.withName(HomeScreen.routeName)),
            icon: Icon(
              Icons.home_outlined,
              size: 30,
              color: Colors.brown.shade900,
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(MapScreen.routeName),
            icon: Icon(
              Icons.map_outlined,
              size: 30,
              color: Colors.brown.shade900,
            ),
          ),
        ],
      ),
    );
  }
}*/
