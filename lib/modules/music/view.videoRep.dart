import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/music/model.music.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePage extends StatefulWidget {

  final MusicModel music;
  final List<String> playlist;

  YouTubePage(this.music, {this.playlist}){
    assert (this.music != null || this.playlist != null);
  }

  @override
  _YouTubePageState createState() => _YouTubePageState();
}

class _YouTubePageState extends State<YouTubePage> {

  YoutubePlayerController _controller;

  @override
  void initState() {

    _controller = YoutubePlayerController(
      initialVideoId: widget.music?.id ?? null,      
      params: YoutubePlayerParams(
        playlist: widget.playlist ?? [widget.music.id],
        showControls: true, 
        showFullscreenButton: true,
        autoPlay: true,
        mute: false,
        enableJavaScript: true,
        interfaceLanguage: "es",
        captionLanguage: "es",
        enableCaption: false,        
        showVideoAnnotations: false,        
      ),
    );

    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // appBar: AppBar(title: Text("Video"),),
      body: Column(
        children: [
          getHeader(context, MediaQuery.of(context).size, "Reproductor"),
          Expanded(child: _getElements(_controller)),
        ],
      )
    );
  }

  Widget _getElements(YoutubePlayerController _controller) {
    return SingleChildScrollView(
      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.music_note),
            title: Text(widget.playlist==null? widget.music.title : "Reproduciendo lista"),
          ),
          YoutubePlayerIFrame(
            controller: _controller,
            aspectRatio: 16 / 9,
          ),
          widget.playlist != null? 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous),
                      onPressed: (){
                        setState(() {
                          _controller.previousVideo();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.pause),
                      onPressed: (){
                        setState(() {
                          _controller.pause();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next),
                      onPressed: (){
                        setState(() {
                          _controller.nextVideo();
                        });
                      },
                    ),
                  ],
                ):
                ExpansionTile(
                  title: Text("Descripción"),
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(widget.music.description ?? "No disponible")
                    )
                  ],
                )
        ],
      ),
    );
  }
  
}