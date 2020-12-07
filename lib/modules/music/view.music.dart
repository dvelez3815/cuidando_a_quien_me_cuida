import 'package:flutter/material.dart';

import 'package:utm_vinculacion/modules/music/helper.image.dart';
import 'package:utm_vinculacion/modules/music/model.playlist.dart';
import 'package:utm_vinculacion/modules/music/provider.music.dart';

import 'package:utm_vinculacion/widgets/components/header.dart' as component;

import 'model.music.dart';
import 'view.videoRep.dart';

class MusicPage extends StatelessWidget {

  final _provider = new MusicProvider();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final PlayList playlist = ModalRoute.of(context).settings.arguments;
    final color = Theme.of(context).brightness == Brightness.dark? Colors.white:Colors.indigo[900];

    return Scaffold(
      body: Column(
        children: [
          component.getHeader(context, size, playlist.title.toUpperCase() ?? "Música"),
          SizedBox(height: 15.0,),
          Expanded(child: _getMusicList(context, playlist, color))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow, color: Colors.white),
        backgroundColor: Colors.red,
        onPressed: (){
          return Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>YouTubePage(null, playlist: _provider.playElements)
          ));
        },
      ),
    );
  }

  Widget _getMusicList(BuildContext context, PlayList playlist, Color color) {
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

        return ListView.builder(
          itemCount: snapshot.data.length,
           physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          itemBuilder: (context, index) {

            final music = snapshot.data[index];

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
                  onTap: (){
                    return Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=>YouTubePage(music)
                    ));
                  },
                ),
                Divider()
              ],
            );
          }
        );
      },
    );
  }
}