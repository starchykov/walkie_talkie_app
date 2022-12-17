import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_app/domain/utils/avatar_builder.dart';
import 'package:walkie_talkie_app/ui/screens/ptt_screen/ptt_screen_state.dart';
import 'package:walkie_talkie_app/ui/screens/ptt_screen/ptt_screen_view_model.dart';

class PTT extends StatelessWidget {
  const PTT({Key? key}) : super(key: key);

  static Widget render() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => PTTViewModel(context: context),
      child: const PTT(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PTTViewModel viewModel = context.read<PTTViewModel>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        automaticallyImplyLeading: false,
        middle: const Text('PTT'),
        trailing: CupertinoButton(
          minSize: double.minPositive,
          padding: EdgeInsets.zero,
          onPressed: () => viewModel.navigateToSettings(),
          child: const Icon(CupertinoIcons.settings),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              _OnlineUsersCount(),
              _OnlineUsersList(),
              Spacer(),
              _PTTButton(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PTTButton extends StatelessWidget {
  const _PTTButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PTTViewModel viewModel = context.read<PTTViewModel>();
    final PTTState state = context.select((PTTViewModel viewModel) => viewModel.state);
    return GestureDetector(
      onLongPress: () => viewModel.startListening(),
      onLongPressEnd: (details) => viewModel.stopListening(),
      onForcePressEnd: (details) => viewModel.stopListening(),
      child: Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: state.isRecording ? CupertinoColors.destructiveRed : CupertinoColors.link,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        child: Icon(
          state.isRecording ? CupertinoIcons.mic_fill : CupertinoIcons.mic,
          color: CupertinoColors.white,
        ),
      ),
    );
  }
}

class _OnlineUsersList extends StatelessWidget {
  const _OnlineUsersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PTTState state = context.select((PTTViewModel viewModel) => viewModel.state);

    return SizedBox(
      height: 400,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: state.usersOnline.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: CupertinoColors.secondarySystemFill,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Text(AvatarBuilder.instance.makeInitials(e.name)),
                ),
                const SizedBox(width: 8),
                Text(e.name),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Presentation of top screen widget with online users count
class _OnlineUsersCount extends StatelessWidget {
  const _OnlineUsersCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PTTState state = context.select((PTTViewModel viewModel) => viewModel.state);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.lightGreen,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Stack(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white.withOpacity(.5),
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Text(
                    AvatarBuilder.instance.makeInitials(''),
                    style: const TextStyle(color: CupertinoColors.black),
                  ),
                ),
                Positioned(
                  left: 10,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CupertinoColors.white.withOpacity(.7),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Text(
                      AvatarBuilder.instance.makeInitials(''),
                      style: const TextStyle(color: CupertinoColors.black),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Text(
                      AvatarBuilder.instance.makeInitials(state.usersOnline[0].name),
                      style: const TextStyle(color: CupertinoColors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Icon(CupertinoIcons.person_3_fill),
          const SizedBox(width: 4),
          Text('Users online: ${state.usersCount}'),
        ],
      ),
    );
  }
}
