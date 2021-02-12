
import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:utm_vinculacion/modules/music/model.playlist.dart';
import 'package:http/http.dart' as http;

import 'model.music.dart';

class MusicProvider {

  static const String URL = "https://www.googleapis.com/youtube/v3/";
  static const String CHANNEL_ID = "UCRFgeSNI_UmvjtNoj2eLobQ";
  static const String PLAYLIST_REQUIREMENTS = "id,contentDetails,player,contentDetails,id,snippet,status";

  static final String apiKey = DotEnv().env['API_KEY_YT']; // YouTube API key
  final List<String> playElements = new List<String>();

  // Singleton pattern
  static MusicProvider _instance;

  factory MusicProvider(){
    if(_instance == null) {
      _instance = MusicProvider._();
    }
    return _instance;
  }

  MusicProvider._();


  // This will get all playlist in the channel
  final playlistYTUrl = "${MusicProvider.URL}playlists?part=${MusicProvider.PLAYLIST_REQUIREMENTS}&channelId=${MusicProvider.CHANNEL_ID}&key=$apiKey&maxResults=10";
  
  final playlistList = new StreamController<List<PlayList>>.broadcast();

  Stream<List<PlayList>> get playlistStream => playlistList.stream;
  Function(List<PlayList>) get playlistSink => playlistList.sink.add;

  /// This will kill the playlist stream
  dispose(){
    playlistList?.close();
  }

  /// Initialize the playlist stream
  void init(){
    // This is important in order to avoid the app crash
    playlistSink([]);
  }

  /// This will get all playlist in the channel, with its name, 
  /// description, thumbnails, and the playlist ID
  Future<void> queryPlaylist() async{

    final response = await http.get(playlistYTUrl);
    final Map<String, dynamic> decodedData = json.decode(response.body);

    final List<PlayList> playlist = List<PlayList>.from(decodedData["items"].map((playlist){
      return new PlayList(
        playlist["id"], 
        playlist["snippet"]["title"], 
        playlist["snippet"]["description"],
        playlist["snippet"]["thumbnails"]["default"]["url"]
      );
    }));

    playlistSink(playlist);
  }

  /// This will load all music in a playlist that match with [playlistID]
  Future<List<MusicModel>> loadMusicList(String playlistID) async {
    
    final url = "${MusicProvider.URL}playlistItems?part=contentDetails,id,snippet&playlistId=$playlistID&key=$apiKey&maxResults=30";
    
    final res = await http.get(url);
    final Map<String, dynamic> decoded = json.decode(res.body);

    // This will clear the stream every time a request is made, in order to avoid
    // repetitions in the elements or some bugs.
    playElements.clear();
    playElements.addAll(List<String>.from(decoded["items"].map((music)=>music["snippet"]["resourceId"]["videoId"])));

    // 
    return List<MusicModel>.from(decoded["items"].map((music){
      return new MusicModel(
        description: music["snippet"]["description"],
        title: music["snippet"]["title"],
        id: music["snippet"]["resourceId"]["videoId"],
        image: music["snippet"]["thumbnails"]["default"]["url"]
      );
    }));
  }
}