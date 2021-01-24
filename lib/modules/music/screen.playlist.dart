import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utm_vinculacion/routes/route.names.dart';

import 'package:utm_vinculacion/widgets/components/header.dart' as component;

import 'helper.image.dart';
import 'model.playlist.dart';
import 'provider.music.dart';

class PlaylistScreen extends StatelessWidget {

  final _musicProvider = new MusicProvider();

  @override
  Widget build(BuildContext context) {

    _musicProvider.queryPlaylist();

    return Scaffold(
      body: Column(
        children: [
          component.getHeader(context, "MÚSICA"),
          SizedBox(height: 30,),
          FutureBuilder(
            future: canLaunch("https://www.google.com/"),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator());
              }

              if(!snapshot.data) {
                return ListTile(
                  leading: Icon(Icons.wifi_off),
                  title: Text("Vaya... No tienes conexión a internet"),
                );
              }
              return _getPlaylist(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _getPlaylist(BuildContext context) {

    return StreamBuilder(
      stream: this._musicProvider.playlistStream,
      builder: (BuildContext context, AsyncSnapshot<List<PlayList>> snapshot){
        
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(snapshot.data.isEmpty) {
          return ListTile(
            leading: Icon(Icons.sentiment_dissatisfied),
            title: Text("Sin contenido")
          );
        }

        final playlistElements = new List<Widget>.from(snapshot.data.map((PlayList playlist){
          return _getPlayListTile(context, playlist);
        }));

        playlistElements.addAll([
          SizedBox(height: 30,),
          RaisedButton.icon(
            onPressed: ()=>launch("https://www.youtube.com/channel/UCRFgeSNI_UmvjtNoj2eLobQ?view_as=subscriber"), 
            icon: Icon(Icons.play_arrow_rounded), 
            label: Text("Abrir en YouTube"),
            color: Colors.red,
            textColor: Colors.white,
          )
        ]);

        return new Column(children: playlistElements,);

      },
    );

  }

  Widget _getPlayListTile(BuildContext context, PlayList playlist) {
    return Column(
      children: [
        ListTile(
          leading: getImage(playlist.image),
          title: Text(playlist.title ?? "Sin título"),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: ()=>Navigator.of(context).pushNamed(MUSIC_DETAIL, arguments: playlist),
        ),
        Divider()
      ],
    );
  }
}