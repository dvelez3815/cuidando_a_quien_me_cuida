# utm_vinculacion

### Proyecto de vinculación

## Integrantes
- Franco Cantos Jandry Hernaldo
- Garcia Arteaga Joel Junior
- Mendoza Macias Yahir
- Loor Zambrano Bernis Alfredo
- Santillan ganchozo
- Palacios Balderramo Emerson Javier
- Velez Cedeño Maria José
- Velez Zambrano Darwin Xavier


### Tutor: Ing. SANTANA CAMPOVERDE FABRICIO JAVIER
### Coordinadora: Ing. ZAMBRANO SOLORZANO ELBA TATIANA

## Cuidando a quien me cuida

Cuidado a quien me cuida es una aplicativo que tiene como objetivo el de reducir el estres de los cuidadores, mediante la realiación de un control sobre su dieta y control sobre los ejercicios que realiza

# Procesos  
## Agregar una nueva actividad  
Para agregar una nueva actividad primero se debe crear un objeto del modelo actividad, el cual se llama Actividad, una vez hecho eso se llama el método nuevaActividad del proveedor de la base de datos y se le pasa como parámetro el objeto de la actividad que se acaba de crear.  
## Obtener la lista completa de actividades  
En el DBProvider hay un atributo llamado 'actividades', el cual es una lista de actividades y siempre estará disponible y actualizado debido a que usa el patrón BLOC con Streams. Para usarlo solo basta con llamárlo, pero no se actualizará hasta que se vuelva a llamar. Si se quiere que siémpre se actualice en tiempo real se deberá usar el widget StreamBuilder. 
En el constructor de la vista donde se vayan a usar estos datos de deberá llamar al método getToDos() del DBProvider para cargar la data inicial.  
No es necesario que cada que se agregue una nueva actividad se llame el método getToDos para actualizar la lista de actividades, esto se hace solo por los Streams. 
## Insertar una comida  
Hay que pasarle un objeto tipo Comida (modelo ubicado en la carpeta models) al método nuevaComida del DBProvider.  
## Obtener lista de comidas  
El proceso es el mismo que en las actividades, ya hay un atributo en el DBProvider llamado 'comidas', el cual es una lista del modelo Comida, también funciona con Streams por lo que si see usa el StreamBuilder no es necesario llamarlo a cada rato, ya que se actualizará solo en tiempo real. 

