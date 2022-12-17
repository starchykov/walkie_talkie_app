import 'package:flutter/cupertino.dart';
import 'package:walkie_talkie_app/ui/screens/ptt_screen/ptt_screen.dart';
import 'package:walkie_talkie_app/ui/screens/ptt_settings_screen/ptt_settings_screen.dart';



abstract class AppNavigationRoutes {
  static const pttScreen = '/ptt';
  static const settingScreen = '/setting';
}

class AppNavigation {
  final Map<String, Widget Function(BuildContext)> routes = <String, Widget Function(BuildContext)>{
    AppNavigationRoutes.pttScreen: (context) => PTT.render(),
    AppNavigationRoutes.settingScreen: (context) => PTTSettingsScreen.render(),
  };

  final List<Widget> bottomNavigationScreens = <Widget>[
    PTT.render(),

  ];
}
