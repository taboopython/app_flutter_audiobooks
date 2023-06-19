import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

AudioPlayer audioPlayer = AudioPlayer();
SharedPreferences prefs;
SongInfo songInfo; // オーディオファイルの情報を保持するオブジェクト

void getSongInfo(String filePath) async {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  songInfo = await audioQuery.getSongsFromFilePath(filePath: filePath);
}

void saveBookmark() async {
  int position = await audioPlayer.getCurrentPosition();
  prefs = await SharedPreferences.getInstance();
  await prefs.setInt('bookmark', position);
}

void loadBookmark() async {
  prefs = await SharedPreferences.getInstance();
  int bookmarkPosition = prefs.getInt('bookmark') ?? 0;
  audioPlayer.seek(Duration(milliseconds: bookmarkPosition));
  audioPlayer.resume();
}

void displayAudioInfo() {
  print('Title: ${songInfo.title}');
  audioPlayer.onAudioPositionChanged.listen((Duration p) {
    print('Current position: $p');
  });
  audioPlayer.onDurationChanged.listen((Duration d) {
    print('Duration: $d');
    print('Remaining time: ${d - audioPlayer.getCurrentPosition()}');
  });
}
