import 'package:flutter/material.dart';
import 'package:utm_vinculacion/modules/database/provider.database.dart';
import 'package:utm_vinculacion/routes/route.names.dart';
import 'package:utm_vinculacion/widgets/components/header.dart';
import 'package:utm_vinculacion/widgets/components/tres_puntos.dart';

import 'model.activity.dart';
class Actividades extends StatefulWidget {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Actividades({Key key}) : super(key: key);

  @override
  _ActividadesState createState() => _ActividadesState();
}

class _ActividadesState extends State<Actividades>{

  final DBProvider dbProvider = DBProvider.db;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    dbProvider.getActivities();
    return Scaffold(
      key: widget._scaffoldKey,
      body: Column(
        children: [
          getHeader(context, size, "MIS ACTIVIDADES"),
          _headListTile(),
          listaContenido(setState, widget._scaffoldKey),
        ],
      )
    );
  }

  Widget listaContenido(Function setState, GlobalKey<ScaffoldState> scaffoldKey){

    final List<Widget> physicalData = new List<Widget>();
    final List<Widget> mentalData = new List<Widget>();
    final List<Widget> recreationData = new List<Widget>();
    final List<Widget> careData = new List<Widget>();

    return StreamBuilder(
      stream: dbProvider.actividadStream,
      builder: (BuildContext context, AsyncSnapshot<List<Actividad>> snapshot){

        if(!snapshot.hasData) return Center(child: CircularProgressIndicator());                
        if(snapshot.data.isEmpty) return sinDatos();

        // Adding header for each physical activity type
        physicalData.clear();
        physicalData.add(Center(child: Text("Físicas", style: TextStyle(fontSize: 18.0))));
        physicalData.add(Divider());

        mentalData.clear();
        mentalData.add(Center(child: Text("Mental", style: TextStyle(fontSize: 18.0))));
        mentalData.add(Divider());

        recreationData.clear();
        recreationData.add(Center(child: Text("Recreación", style: TextStyle(fontSize: 18.0))));
        recreationData.add(Divider());

        careData.clear();
        careData.add(Center(child: Text("Cuidado", style: TextStyle(fontSize: 18.0))));
        careData.add(Divider());

        // Mapping all entries
        snapshot.data.forEach((Actividad element) { 

          final widget = new Column(
            children: [
              alarmTileHead(element, setState),
              alarmTileBody(context, element, scaffoldKey),
              Divider()
            ],
          );

          switch(element.type){                      
            case ActivityType.recreation: recreationData.add(widget); break;
            case ActivityType.physical: physicalData.add(widget); break;
            case ActivityType.mental: mentalData.add(widget); break;
            case ActivityType.care: careData.add(widget); break;
          }

        });

        final List<Widget> completeData = new List<Widget>();

        if(physicalData.length > 2) completeData.add(_getElementList(physicalData));
        if(careData.length > 2) completeData.add(_getElementList(careData));
        if(recreationData.length > 2) completeData.add(_getElementList(recreationData));
        if(mentalData.length > 2) completeData.add(_getElementList(mentalData));

        return Expanded(
          child: PageView(
            controller: PageController(
              viewportFraction: 0.85,              
            ),
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            children: completeData
          ),
        );
      },
    );
  }

  Widget _getElementList(List<Widget> physicalData) {
    return Card(      
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: physicalData
          )
        )
      )
    );
  }

  Widget _headListTile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Actividades",
            style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: (){
              Navigator.pushNamed(context, ADDACTIVIDADES);
            },
          )
        ],
      ),
    );
  }

  Widget alarmTileBody(BuildContext context, Actividad item, GlobalKey<ScaffoldState> scaffoldKey) {
    return ListTile(
      title: _daysListView(item, context),
      trailing: IconButton(
        icon: Icon(Icons.settings),
        onPressed: ()=>showEditDeleteOptions(context, item, scaffoldKey),
      )
    );
  }

  Widget _daysListView(Actividad item, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: item.daysToNotify.map((day){
          return Container(
            margin: EdgeInsets.only(right: 5.0),
            child: CircleAvatar(
              radius: 12.0,            
              child: Text(
                day != "miercoles"? day[0].toUpperCase(): "X", 
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 10.0
                ),
              )
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget alarmTileHead(Actividad item, Function setState) {
  
    return SwitchListTile(
      value: item.estado,
      onChanged: (status){
        item.estado = status;
        setState(() {});
      },
      subtitle: Text(item.descripcion),
      title: Text("${item.nombre ?? "Sin nombre"}"),
      secondary: _showTimeCareInfo(item),
    );
  }

  Widget _showTimeCareInfo(Actividad item) {
    return Column(
      children: [            
        Icon(Icons.alarm),
        Text("${item.time.hour}:${item.time.minute}"), 
      ],
    );
  }

  void showEditDeleteOptions(BuildContext context, Actividad item, GlobalKey<ScaffoldState> scaffoldKey) {
    showModalBottomSheet(
      context: context, 
      isDismissible: true,
      builder: (context){
        return SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTile(
                    title: Text("Actividad"),
                    subtitle: Text(item.nombre,),
                  ),
                  ListTile(
                    title: Text("Descripción"),
                    subtitle: Text(item.descripcion,),
                  ),
                  ExpansionTile(
                    title: Text("Materiales"),
                    children: item.complements.map((item){
                      return ListTile(
                        leading: Icon(Icons.sports_baseball),
                        title: Text(item["title"])
                      );
                    }).toList(),
                  ),
                  ListTile(
                    title: Text("Días para notificar"),
                    subtitle: _daysListView(item, context)
                  ),
                  ListTile(
                    title: Text("Hora para notificar"),
                    subtitle: Text("${item.time.hour}:${item.time.minute}")
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlatButton.icon(
                        icon: Icon(Icons.edit),
                        label: Text("Editar"),
                        onPressed: (){
                          Navigator.of(context).pushNamed(
                            ADDACTIVIDADES, 
                            arguments: {
                            "title": item.nombre,
                            "description": item.descripcion,
                            "model_data": item
                          });
                        },
                      ),
                      FlatButton.icon(
                        icon: Icon(Icons.delete, color: Colors.red),
                        label: Text("Eliminar", style: TextStyle(color: Colors.red)),
                        onPressed: (){
                          _onDeleteCare(context, item, scaffoldKey);
                        },
                      )
                    ],
                  )
                ],
              ),
          ),
        );
      }
    );
  }

  Future<bool> deleteEvent(Actividad item) async {
    return await item.delete();
  }

  void _onDeleteCare(BuildContext context, Actividad item, GlobalKey<ScaffoldState> scaffoldKey){

    bool deleting = false;

    showDialog(
      context: context,
      builder: (contextInternal){
        return AlertDialog(
          title: Text("¡Atención!"),
          content: Text("Está a punto de eliminar esta actividad, ¿desea continuar?"),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.cancel),
              label: Text("Cancelar"),
              onPressed: ()=>Navigator.of(contextInternal).pop(),
            ),
            FlatButton.icon(
              icon: Icon(Icons.check_circle, color: Colors.red),
              label: Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: ()async{
                if(!deleting){
                  final ok = await deleteEvent(item);

                  scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: Text("El cuidado ${ok? "fue eliminado":"no pudo ser eliminado"}"),
                    duration: Duration(seconds: 2),
                  ));

                  Navigator.of(contextInternal).pop();
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      }, 
    );    
  }

}

