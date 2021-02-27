-- IMPORTANT!!!
-- All this process is automatic, so, if you want to
-- update a part of the database, you need to place the 
-- old code writted in this script and put it in the 
-- [database_script.sql], then you need to put here the new
-- code and increase the database version in one unit.


delete from actividad where id = '1';
delete from comida where id = '15';
delete from comida where id = '20';

insert into comida(id, nombre, urlImagen, preparacion, ingredientes)
values
(21, 'Crema de espinaca', 'assets/imagenes/espinaca.jpg', 
    '1.	Se pica la zanahoria y la papa en cuadros pequeños y se pone a hervir en 1 litro de agua con la cebolla y el pimiento por 25 minutos a fuego medio.
2.	Se agrega la espinaca y se deja coser por 25 minutos más.
3.	Después, se deja enfriar para proceder a licuar.
4.	Siguiente, se le agrega el queso y la leche al gusto al gusto y se revuelve.
5.	Por último, precalentar de nuevo todo y se le agrega la sal al gusto.',
    '[{"title":"2 papa medianas."},{"title":"1 zanahoria mediana."},{"title":"1 taza llena de espinaca."},{"title":"½ de cebolla blanca."},{"title":"½ de cebolla paiteña."},{"title":"Sal al gusto."},{"title":"4 onzas de Queso."},{"title":"¼ de leche."}]'
),
(22, 'Crema de zapallo', 'assets/imagenes/zapallo.jpg', 
    '1.	Se pela el zapallo, la papa y se pica en cuadritos.
2.	Siguiente se pone a hervir en 1 litro de agua, el zapallo, la papa, la cebolla blanca, la cebolla paiteña por 25 minutos.
3.	Después de que esté cocido, se procese a dejar refrescar para licuar todo.
4.	Posteriormente, se le añade sal al gusto y leche.
5.	Se sirve en plato, se añade cilantro y queso rallado encima.',
    '[{"title":"Un zapallo mediano."},{"title":"1 papa mediana."},{"title":"½ cebolla blanca."},{"title":"½ cebolla paiteña."},{"title":"¼ de leche."},{"title":"Sal al gusto."},{"title":"Cilantro al gusto."},{"title":"Queso al gusto."},{"title":""},{"title":""},{"title":""}]'
),
(23, 'Crema de zanahoria', 'assets/imagenes/zanahoria.jpg', 
    '1.	Se lava y se pica la zanahoria, el brócoli y la coliflor.
2.	Siguiente se pone a hervir en 1 litro de agua todo lo anterior junto con la cebolla blanca, la cebolla paiteña por 25 minutos.
3.	Después de que esté cocido, se procese a dejar refrescar para licuar todo.
4.	Posteriormente, se le añade sal al gusto y leche.
5.	Se sirve en plato, se añade cilantro y queso rallado encima.',
    '[{"title":"3 zanahorias medianas."},{"title":"1 porción de coliflor."},{"title":"1 porción de brócoli."},{"title":"½ cebolla blanca."},{"title":"½ cebolla paiteña."},{"title":"¼ de leche."},{"title":"Sal al gusto."},{"title":"Cilantro al gusto."},{"title":"Queso al gusto."}]'
),
(24, 'Entomatado', 'assets/imagenes/entomatado.jpg', 
    '1.	se pican los tomates de forma minúscula (casi puré)
2.	se pone a cocinar los tomates picados siempre observando que no se queme
3.	Cuando se comience a secar tirarle agua necesaria para mantener con volumen el tomate
4.	Al pasar entre 40 minutos a 1 hora se procede a tirarle, azúcar al gusto para quitarle lo ácido del tomate
5.	Tirarle queso en cubitos
6.	Tirarle leche al gusto (Al gusto)
7.	Antes de servir tirarle cilandro picado',
    '[{"title":"6 tomates"},{"title":"1 cucharada Azúcar"},{"title":"½ litro de Agua"},{"title":"¼ Queso"},{"title":"10 lamitas Cilandro"},{"title":"1 taza de Leche"}]'
);


insert into actividad (id, nombre, descripcion, days, time, active, type, complements)
values
(13, 'Juego De Números', 'Permite trabajar las parte cognitiva de identificar los números, además de reforzar la estabilidad, movilidad y fuerza de tronco y piernas a nivel físico.',
    '[lunes, miercoles, viernes]', '9:00', 0, 'mental', '[]'),
(14, 'Juego De Pañuelos', 'Permite agilizar la memoria al recordar los colores y trabajar tanto brazos como piernas a nivel físico.',
    '[lunes, miercoles, viernes]', '9:00', 0, 'mental', '[]'),    
(15, 'Juego De La Canasta', 'Se estimula a nivel cognitivo la memoria, como el reconocimiento de colores y se trabaja la parte de piernas a nivel físico.',
    '[lunes, miercoles, viernes]', '14:00', 0, 'mental', '[]'),    
(16, 'Juego De Movimientos', 'Se estimula la memoria del aspecto cognitivo y la amplitud articular en el aspecto físico.',
    '[lunes, miercoles, viernes]', '15:00', 0, 'mental', '[]'),    
(17, 'Juego De La Baraja', 'Con esta actividad se trabaja la atención divida y selectiva.',
    '[martes, jueves, sabado]', '15:00', 0, 'mental', '[]'),    
(18, 'Juego De Encuentra A La Reina', 'Se trabaja y estimula la atención sostenida.',
    '[martes, jueves, sabado]', '16:00', 0, 'mental', '[]'),        
(19, 'Juego De Domina El Dominó', 'Se estimulan las funciones ejecutivas, particularmente las memorias de trabajo.',
    '[martes, jueves, sabado]', '17:00', 0, 'mental', '[]'),
(20, 'Juego Efecto Stroop', 'Se estimulan la inhibición y la atención.',
    '[martes, jueves, sabado]', '18:00', 0, 'mental', '[]'),    
(21, 'Juego De Lectura De Memoria', 'Se estimula la memoria audio verbal y la memoria de trabajo.',
    '[martes, jueves, sabado]', '19:00', 0, 'mental', '[]'),        
(22, 'Juego De Secuencias', 'Se estimulan el control mental, ampliando la retentiva de la persona.',
    '[martes, jueves, sabado]', '20:00', 0, 'mental', '[]'),

(23, 'Estiramiento de cuello', 'Estiramiento de cuello para estimular los músculos y liberar tensión que la persona pueda tener, además de mejorar el tono muscular, la fuerza, la movilidad y la funcionalidad de los músculos y articulaciones en general.', 
    '[lunes, miercoles, viernes]', '7:30', 0, 'physical',
'[{"title":"Una silla"}, {"title":"Ropa cómoda"}]'),
(24, 'Estiramiento de hombros', 'Estiramiento de hombro para estimular los músculos y liberar tensión que la persona pueda tener, además de mejorar el tono muscular, la fuerza, la movilidad y la funcionalidad de los músculos y articulaciones en general.', 
    '[lunes, miercoles, viernes]', '8:30', 0, 'physical',
'[{"title":"Una silla"}, {"title":"Ropa cómoda"}]'),
(25, 'Estiramiento de codo', 'Estiramiento de codo para estimular los músculos y liberar tensión que la persona pueda tener, además de mejorar el tono muscular, la fuerza, la movilidad y la funcionalidad de los músculos y articulaciones en general.', 
    '[lunes, miercoles, viernes]', '9:30', 0, 'physical',
'[{"title":"Una silla"}, {"title":"Ropa cómoda"}]'),
(26, 'Estiramiento de muñeca', 'Estiramiento de muñeca para estimular los músculos y liberar tensión que la persona pueda tener, además de mejorar el tono muscular, la fuerza, la movilidad y la funcionalidad de los músculos y articulaciones en general.', 
    '[lunes, miercoles, viernes]', '10:30', 0, 'physical',
'[{"title":"Una silla"}, {"title":"Ropa cómoda"}]'),
(27, 'Estiramiento de cadera', 'Estiramiento de cadera para estimular los músculos y liberar tensión que la persona pueda tener, además de mejorar el tono muscular, la fuerza, la movilidad y la funcionalidad de los músculos y articulaciones en general.', 
    '[lunes, miercoles, viernes]', '11:30', 0, 'physical',
'[{"title":"Una silla"}, {"title":"Ropa cómoda"}]'),
(28, 'Estiramiento de tobillo', 'Estiramiento de tobillo para estimular los músculos y liberar tensión que la persona pueda tener, además de mejorar el tono muscular, la fuerza, la movilidad y la funcionalidad de los músculos y articulaciones en general.', 
    '[lunes, miercoles, viernes]', '12:30', 0, 'physical',
'[{"title": "Una silla"}, {"title": "Ropa cómoda"}]');


insert into procedimiento values
('### Instrucciones:
Se colocan los objetos con los números en el piso frente a la persona, esta tendrá que lanzar el dado y dependiendo del número que salga, deberá tocar dicho objeto.
 ### Observación:
 En caso de no poder agacharse a tocar los objetos, este tendrá que estar sentado alrededor de los mismos.',
 6,13),
 ('### Instrucciones:
  Se debe sentar al paciente y colocarle en cada extremidad un pañuelo, luego se debe decir el nombre de un color y el paciente deberá alzar la extremidad que tenga ese color.
 ### Observación:
  Con más colores se posean, más difícil se podrá hacer la actividad.',
 7,14),
 ('### Instrucciones:   
 Se colocan los pañuelos en una superficie (mesa, silla, entre otros), el cuidador tendrá que decir un color y el paciente deberá tomarlo y ponerlo dentro de la canasta, al final se le pregunta que colores se colocaron en la canasta.
 ### Observación:   
 Con más colores se posean, más difícil se podrá hacer la actividad.',
 8,15),
 ('### Instrucciones:   
 Se deberá sentar al paciente y el cuidador/a deberá realizar una serie de movimientos como por ejemplo, alzar un brazo, aplaudir, girar la cabeza, entre otros (queda a creatividad del cuidador), y el paciente deberá repetirlos. Todo esto en un orden empezando con 3 movimientos y aumentado la dificultad poco a poco.
 ### Observación:   
 Realizar movimientos en base a la movilidad del paciente.',
 9,16),
 ('### Instrucciones:   
 Se procede a decirle que recuerde una carta al paciente, después se esconden las cartas en los vasos mostrándole donde va cada una y se comienzan a mover durante 30 segundos, finalmente se le pide que seleccione el vaso en donde está la carta mostrada al principio, o puede ir volteando los vasos en orden descendente o ascendente de las cartas.
 ### Observación:   
 Se puede aumentar la dificultad pidiendo que recuerde las demás cartas.',
 10,17),
 ('### Instrucciones:   
 Se toman 3 naipes y se le muestran al paciente donde uno de ellos será la reina de corazones (el naipe con la letra Q) y luego se comienza a revolver durante 30 segundos o más, al final se le pide que muestre donde se quedó la reina de corazones y sino adivina, se vuelve a repetir el proceso.
 ### Observación:   
 Se trabaja y estimula la atención sostenida.',
 11,18),
 ('### Instrucciones:   
 Se colocan 5 fichas de dominó o más boca abajo en fila, luego se procede a mostrar la primera y se la vuelve a dejar como estaba, después se procede a mostrar la segunda y se le pregunta la ¿Cuántos puntos tenía la ficha anterior?, así sucesivamente hasta terminar de mostrar todas las fichas, en caso de que falle, vuelve a repetir el juego.
 ### Observación:   
 Si quiere aumentar la dificultad, puede mostrar más de una ficha en orden y luego le pregunta el orden.',
 12,19),
 ('### Instrucciones:   
 Se muestran una a una las tarjetas al paciente y se le dice que mencione el color de la palabra, sin leer la palabra.
 ### Observación:   
 Se puede invertir el juego pidiendo que diga lo escrito y no el color.',
 13,20),
 ('### Instrucciones:   
 Se le pedirá que recuerde la última palabra de cada frase dicha y se le procede a leer, una vez terminada la lectura, se le pregunta que palabra fue la última mencionada.  
 ### Observación:   
 Si el ejercicio es muy fácil puede extender la lectura o pedirle al paciente.',
 14,21),
 ('### Instrucciones:   
 Se le dice al paciente que diga una serie de números o palabras, luego que las haya dicho, se le pide que las vuelva a repetir en orden inverso, así sucesivamente aumentando la dificultad.  
 ### Observación:   
 Se recomienda empezar con una serie de 3 números o palabras.',
 15,22),
('1.	Sentado en una silla, inclina la espalda un poco hacia adelante y mantener los pies alineados con cadera y hombros.
2.	Con la mano derecha intente tocar su oreja izquierda, pasando la mano por encima de la cabeza.
3.	Luego, lleve su cabeza hacia la derecha como si fuera a tocar el hombro, acompañando el movimiento con la mano (repetir 10 veces).
4.	Repita el ejercicio hacia el lado contrario (con su mano izquierda y repita 10 veces).
5.	Después, coloque sus manos en la nuca de su cabeza y gire lentamente la cabeza hacia arriba y hacia abajo, como si estuviera diciendo que sí (repetir 10 veces). 
6.	Ahora bajando sus manos, lleve el mentón hacia adelante y hacia atrás (repita 10 veces).',
 16,23),
('1.	Sentado en una silla, inclina la espalda un poco hacia adelante y mantener los pies alineados con cadera y hombros.
2.	Con las manos en las piernas, levante los brazos por encima de la cabeza y vuelva a la posición de partida (repita 10 veces).
3.	Levante los brazos por encima de la cabeza y mueva cada brazo alternadamente detrás de la misma (repita 10 veces).
4.	Después, levante los brazos y muévalos de derecha a izquierda (repita 10 veces).
5.	Con la posición inicial, coloque sus manos en el hombro e intente hacer pequeños círculos hacia adelante, luego hacia atrás (repita 10 veces).
6.	Por último, estire sus brazos horizontalmente con los puños cerrados y describa círculos con sus brazos hacia adelante, luego hacia atrás (repita 10 veces).',
 17,24),
 ('1.	Sentado en una silla, inclina la espalda un poco hacia adelante y mantener los pies alineados con cadera y hombros.
2.	Levante los brazos frente a usted con las palmas hacia arriba y luego lleve a cada mano hacia su hombro respectivo alternando cada brazo (repita 10 veces).
3.	Ahora levante los brazos frente a usted y con los puños cerrados lleve los hacia su pecho (repita 10 veces).
4.	Después flexionamos los brazos, los llevamos a los lados y tocamos cada hombro alternadamente (repita 10 veces).
5.	Luego, flexionando los brazos hacia adelante, gira las palmas de la mano hacia arriba y hacia abajo (repita 10 veces).
6.	Por último, juntando las manos en frente de la persona, gire hacia afuera y luego hacia adentro (repita 10 veces).',
 18,25),
 ('1.	Sentado en una silla, inclina la espalda un poco hacia adelante y mantener los pies alineados con cadera y hombros.
2.	Estire los brazos hacia adelante y flexione un poco los codos, luego flexione y extienda la muñeca (repita 10 veces).
3.	Con la posición anterior, mueva la muñeca de izquierda a derecha (repita 10 veces).
4.	Con la posición anterior, cierre el puño y realice 10 rotaciones hacia la izquierda y luego 10 rotaciones hacia la derecha.',
 19,26),
 ('1.	Sentado en una silla, inclina la espalda un poco hacia adelante y mantener los pies alineados con cadera y hombros.
2.	Luego levantar el pie izquierdo hacia el pecho lo que más pueda 10 veces, repetir lo mismo con el pie derecho.
3.	Después con la misma posición, eleve la pierna izquierda hasta que quede verticalmente 10 veces, repita lo mismo con la pierna derecha, por último, repita lo mismo con las dos piernas.
4.	Ahora sentado, imagine que está andando en bicicleta y haga círculos con sus piernas (repita 10 veces).
5.	Siguiente, eleve una pierna verticalmente y lleve la punta del pie hacia afuera, realice lo con la otra pierna (repita 10 veces).
6.	Por último, deberá levantar la pierna izquierda verticalmente y moverla hacia fuera lo que más pueda, lo mismo con la pierna derecha (repita 10 veces).',
 20,27), 
 ('1.	Sentado en una silla, inclina la espalda un poco hacia adelante y mantener los pies alineados con cadera y hombros.
2.	Apoye un talón en el piso y luego levante hacia arriba la punta del pie y muévalo de derecha a izquierda, repita 10 veces con cada pie.
3.	Siguiente, con los pies en el suelo, levante el talón hacia afuera y mantenga la punta del pie pegada al piso (repita 10 veces).
4.	Levante la pierna izquierda verticalmente y lleve la punta del pie hacia a dentro y hacia a fuera, luego cambie de pie (repita 10 veces).
5.	Finalmente, con los pies en el piso, muévalos de izquierda a derecha (repita 10 veces).',
 21,28);

 


