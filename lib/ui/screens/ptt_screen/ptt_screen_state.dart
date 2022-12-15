import 'dart:typed_data';
import 'package:walkie_talkie_app/domain/model/session_user_model.dart';

class PTTState {
  final bool isRecording;
  final List<Uint8List>? audioChunks;
  final Uint8List? audioToPlay;
  final String username;
  final int usersCount;
  final List<SessionUser> usersOnline;


  const PTTState({
    this.isRecording = false,
    this.audioChunks = const [],
    this.audioToPlay,
    required this.username,
    this.usersCount = 0,
    this.usersOnline = const [SessionUser(), SessionUser(), SessionUser()],
  });

  PTTState copyWith({
    bool? isRecording,
    List<Uint8List>? audioChunks,
    Uint8List? audioToPlay,
    String? username,
    int? usersCount,
    List<SessionUser>? usersOnline,
  }) {
    return PTTState(
      isRecording: isRecording ?? this.isRecording,
      audioChunks: audioChunks ?? this.audioChunks,
      audioToPlay: audioToPlay ?? this.audioToPlay,
      username: username ?? this.username,
      usersCount: usersCount ?? this.usersCount,
      usersOnline: usersOnline ?? this.usersOnline,
    );
  }
}