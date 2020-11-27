import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/music/helper.image.dart';
import 'package:utm_vinculacion/modules/music/model.playlist.dart';
import 'package:utm_vinculacion/modules/music/provider.music.dart';

import 'package:utm_vinculacion/widgets/components/header.dart' as component;

import 'model.music.dart';

class MusicPage extends StatelessWidget {

  final _provider = new MusicProvider();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final PlayList playlist = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Column(
        children: [
          component.getHeader(context, size, playlist.title.toUpperCase() ?? "Música"),
          Expanded(child: _getMusicList(context, playlist))
        ],
      )
    );
  }

  Widget _getMusicList(BuildContext context, PlayList playlist) {
    return FutureBuilder(
      future: this._provider.loadMusicList(playlist.id),
      builder: (context, AsyncSnapshot<List<MusicModel>> snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }

        if(snapshot.data.isEmpty) {
          return ListTile(
            title: Text("Sin músicas")
          );
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: snapshot.data.map((MusicModel music){
              return Column(
                children: [
                  ListTile(
                    leading: getImage(music.image),
                    title: Text(
                      music.title ?? "Sin título",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      music.description ?? "Sin descripción",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(Icons.play_arrow),
                  ),
                  Divider()
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}