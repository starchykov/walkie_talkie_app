import 'package:flutter/cupertino.dart';
import 'package:walkie_talkie_app/ui/app_navigation/app_navigation.dart';
import 'package:walkie_talkie_app/ui/screens/ptt_screen/ptt_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppNavigation appNavigation = AppNavigation();
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: PTT.render(),
      routes: appNavigation.routes,
      initialRoute: AppNavigationRoutes.pttScreen,
    );
  }
}
