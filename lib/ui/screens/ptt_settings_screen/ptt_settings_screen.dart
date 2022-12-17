import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PTTSettingsScreen extends StatelessWidget {
  const PTTSettingsScreen({Key? key}) : super(key: key);

  static Widget render() {
    return ChangeNotifierProvider(
      create: (context) {},
      child: const PTTSettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
        automaticallyImplyLeading: true,
        previousPageTitle: 'PTT',
      ),
      child: Placeholder(),
    );
  }
}
