import 'package:flutter/cupertino.dart';
import 'package:walkie_talkie_app/ui/screens/ptt_screen/ptt_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: PTT.render(),
    );
  }
}
