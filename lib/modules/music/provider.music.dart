
import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:utm_vinculacion/modules/music/model.playlist.dart';
import 'package:http/http.dart' as http;

import 'model.music.dart';

class MusicProvider {

  final String apiKey = DotEnv().env['API_KEY_YT'];
  final String url = "https://www.googleapis.com/youtube/v3/";
  final List<String> playElements = new List<String>();

  // Singleton
  static MusicProvider _instance;

  factory MusicProvider(){
    if(_instance == null) {
      _instance = MusicProvider._();
    }
    return _instance;
  }

  MusicProvider._();


  final playlistYTUrl = "https://www.googleapis.com/youtube/v3/playlists?part=id,contentDetails,player,contentDetails,id,snippet,status&channelId=UCRFgeSNI_UmvjtNoj2eLobQ&key=AIzaSyAl1kiIpX-nJzwttFqxRt9QVZSSsRKqzss&maxResults=10";
  
  final playlistList = new StreamController<List<PlayList>>.broadcast();

  Stream<List<PlayList>> get playlistStream => playlistList.stream;
  Function(List<PlayList>) get playlistSink => playlistList.sink.add;

  dispose(){
    playlistList?.close();
  }

  Future<void> init()async{
    playlistSink([]);
  }

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

  Future<List<MusicModel>> loadMusicList(String playlistID) async {
    
    final url = "${this.url}playlistItems?part=contentDetails,id,snippet&playlistId=$playlistID&key=$apiKey&maxResults=30";
    
    final res = await http.get(url);
    final Map<String, dynamic> decoded = json.decode(res.body);

    playElements.clear();
    playElements.addAll(List<String>.from(decoded["items"].map((music)=>music["snippet"]["resourceId"]["videoId"])));

    return List<MusicModel>.from(decoded["items"].map((music){
      return new MusicModel(
        description: music["snippet"]["description"],
        title: music["snippet"]["title"],
        id: music["snippet"]["resourceId"]["videoId"],
        image: music["snippet"]["thumbnails"]["default"]["url"]
      );
    })).toList();
  }
}