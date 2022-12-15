import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:mic_stream/mic_stream.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:walkie_talkie_app/domain/model/session_user_model.dart';
import 'package:walkie_talkie_app/ui/screens/ptt_screen/ptt_screen_state.dart';

/// This PTT functionality only covers the MVP implementation and must be reviewed.
/// FYI: Custom Node.js server uses.
class PTTViewModel extends ChangeNotifier {
  final BuildContext context;
  late IO.Socket _socket;
  final FlutterSound _flutterSound = new FlutterSound();

  PTTState _state = const PTTState(isRecording: false, audioChunks: [], username: 'starchykov');

  PTTState get state => _state;

  late Stream<Uint8List>? _stream;
  late StreamSubscription<Uint8List> _streamSubscription;

  List<int>? currentSamples = [];
  List<int> visibleSamples = [];
  int? localMax;
  int? localMin;
  Random rng = new Random();
  late int bytesPerSample;
  late int samplesPerSecond;

  late bool isActive;
  DateTime? startTime;

  // int page = 0;
  // List state = ["SoundWavePage", "IntensityWavePage", "InformationPage"];

  PTTViewModel({required this.context}) {
    _initialize();
  }

  void _initialize() async {
    // Default option. Set to false to disable request permission dialogue
    MicStream.shouldRequestPermission(true);

    _createSocketConnection();

    _socket.onConnect((data) => print('Connection established'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Socket.IO server disconnected'));

    _socket.on('socketUpdates', (data) async {
     List usersJSON = data['usersOnline'] ?? [];
     List<SessionUser> usersOnline = usersJSON.map((e) => SessionUser(name: e['userName'], userUUID: e['userCode'])).toList();
      if (usersOnline.length <= 3) usersOnline = [...usersOnline, ...[const SessionUser(), const SessionUser()]];
      _state = _state.copyWith(usersCount: data['userCounter'] ?? 0, usersOnline: usersOnline);
      notifyListeners();
    });

    _socket.on('audioMessage', (data) async {
      if (data == null || data['audioData'].toString().isEmpty) return;
      if (data['sender'] == _state.username) return;

      _state = _state.copyWith(audioToPlay: Uint8List.fromList(data['audioData'][0]));

      await _flutterSound.thePlayer.closePlayer();
      await _flutterSound.thePlayer.openPlayer();
      _flutterSound.thePlayer.startPlayer(
          fromDataBuffer: _state.audioToPlay,
          codec: Codec.pcm16,
          whenFinished: () => _flutterSound.thePlayer.closePlayer());
    });
  }

  void _createSocketConnection() {
    String userCode = UniqueKey().toString();
    String userName = UniqueKey().toString();
    _state= _state.copyWith(username: userName);

    _socket = IO.io(
      // 'http://10.0.2.2:3001/',
      'https://spa-server.onrender.com/',
      IO.OptionBuilder().setTransports(['websocket']).setQuery({'userName': userName, 'userCode': userCode}).build(),
    );
  }

  void closeConnection() {
    _socket.close();
    Navigator.of(context).pop();
  }

  void startListening() async {
    print('START LISTENING');
    if (_state.isRecording) return;
    // if this is the first time invoking the microphone()
    // method to get the stream, we don't yet have access
    // to the sampleRate and bitDepth properties

    // Default option. Set to false to disable request permission dialogue
    MicStream.shouldRequestPermission(true);

    _stream = await MicStream.microphone(
      audioSource: AudioSource.MIC,
      // sampleRate: 44100,
      channelConfig: ChannelConfig.CHANNEL_IN_MONO,
      audioFormat: AudioFormat.ENCODING_PCM_16BIT,
    );

    // after invoking the method for the first time, though, these will be available;
    // It is not necessary to setup a listener first, the stream only needs to be returned first

    // bytesPerSample = (await MicStream.bitDepth)! ~/ 8;
    // samplesPerSecond = (await MicStream.sampleRate)!.toInt();
    // localMax = null;
    // localMin = null;
    // startTime = DateTime.now();

    // visibleSamples = [];
    // await flutterSound.thePlayer.closePlayer();
    // await flutterSound.thePlayer.openPlayer();

    _streamSubscription = _stream!.listen((samples) {
      _state = _state.copyWith(audioChunks: [...?_state.audioChunks, samples], isRecording: true);
      notifyListeners();
    });
  }

  void stopListening() {
    if (_state.isRecording == false) return;
    print("Stop Listening to the microphone");

    // BytesBuilder _audioChunks = BytesBuilder();
    //_state.audioChunks?.forEach((element) => _audioChunks.add(element));

    List _audioChunks = Uint8List.fromList(_state.audioChunks!.expand((x) => x).toList());
    _socket.emit('audioMessage', {
      'audioData': [_audioChunks],
      'sender': _state.username,
      'userCode': _state.username.hashCode,
    });

    _state = _state.copyWith(isRecording: false, audioChunks: []);
    notifyListeners();

    _streamSubscription.cancel();

    // currentSamples = null;
    // startTime = null;
  }

// void _calculateSamples(samples) {
//   _socket.emit('audioMessage', {'message': samples, 'sender': 'starchykov'});
//   if (page == 0) _calculateWaveSamples(samples);
//   else if (page == 1) _calculateIntensitySamples(samples);
// }
//
// void _calculateWaveSamples(samples) {
//   bool first = true;
//   visibleSamples = [];
//   int tmp = 0;
//   for (int sample in samples) {
//     if (sample > 128) sample -= 255;
//     if (first) {
//       tmp = sample * 128;
//     } else {
//       tmp += sample;
//       visibleSamples.add(tmp);
//
//       localMax ??= visibleSamples.last;
//       localMin ??= visibleSamples.last;
//       localMax = max(localMax!, visibleSamples.last);
//       localMin = min(localMin!, visibleSamples.last);
//
//       tmp = 0;
//     }
//     first = !first;
//   }
//   print(visibleSamples);
// }
//
// Iterable<T> eachWithIndex<E, T>(Iterable<T> items, E Function(int index, T item) f) {
//   var index = 0;
//
//   for (final item in items) {
//     f(index, item);
//     index = index + 1;
//   }
//
//   return items;
// }
//
// void _calculateIntensitySamples(samples) {
//   currentSamples ??= [];
//   int currentSample = 0;
//   eachWithIndex(samples, (i, int sample) {
//     currentSample += sample;
//     if ((i % bytesPerSample) == bytesPerSample - 1) {
//       currentSamples!.add(currentSample);
//       currentSample = 0;
//     }
//   });
//
//   if (currentSamples!.length >= samplesPerSecond / 10) {
//     visibleSamples.add(currentSamples!.map((i) => i).toList().reduce((a, b) => a + b));
//     localMax ??= visibleSamples.last;
//     localMin ??= visibleSamples.last;
//     localMax = max(localMax!, visibleSamples.last);
//     localMin = min(localMin!, visibleSamples.last);
//     currentSamples = [];
//   }
// }


}
