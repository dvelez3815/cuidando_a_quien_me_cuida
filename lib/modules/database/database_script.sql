insert into contacto values
    (0, 'Policía', 'Policía Nacional de Ecuador', '111'),
    (1, 'Emergencia', 'Contacto de emergencia de Ecuador', '911');

insert into actividad (id, nombre, descripcion, days, time, active, type, complements)
values
(0, 'Respiración abdominal', 'La respiración abdominal es fácil de realizar y es muy relajante. Intente este ejercicio básico en cualquier momento que necesite relajarse o aliviar el estrés.', 
    '[lunes, miercoles, viernes]', '10:30', 3, 'physical', 
'[]'),
(1, 'Respiración 4-7-8', 'Este ejercicio también utiliza la respiración abdominal para ayudarle a relajarse. Puede realizar este ejercicio sentado o recostado.', 
    '[lunes, miercoles, viernes]', '17:30', 3, 'physical', 
'[]'),
(2, 'Respiración completa', 'El objetivo de la respiración completa es desarrollar el uso completo de los pulmones y centrarse en el ritmo de su respiración. Puede hacerlo en cualquier posición. Pero, mientras aprende, es mejor recostarse boca arriba con las rodillas flexionadas.', 
    '[lunes, miercoles, viernes]', '20:00', 3, 'physical', 
'[]'),
(3, 'Respiración matinal', 'Intente realizar este ejercicio cuando se levanta por la mañana para aliviar la rigidez de los músculos y liberar las vías respiratorias obstruidas. Luego, utilícelo a lo largo del día para aliviar la tensión en la espalda.', 
    '[lunes, miercoles, viernes]', '08:00', 3, 'physical', 
'[]'),
(4, 'Meditación', 'Elija un momento y un lugar donde pueda meditar sin interrupciones. Procure buscar un lugar tranquilo, pero no se preocupe si hay algunos ruidos, como el del tráfico. Ese tipo de ruido es simplemente parte del momento presente.', 
    '[martes, jueves, sabado]', '21:00', 3, 'physical', 
'[]'),
(5, 'TAICHI', 'La especificidad del taichí de bienestar consiste en una ejecución de secuencias hecha con la sensación de llevar unas bolas de ki.', 
    '[martes, jueves, sabado]', '10:00', 3, 'physical', '[]'),

(6, 'Bailoterapia', 'La música es la libre expresión de las emociones. La expresión corporal en colectividad puede ayudar a elevar el estado de ánimo, liberar tensiones y motivar al anciano a crear empatía con su entorno.', 
    '[martes, jueves, sabado]', '14:00', 1, 'recreación', '[]'),
(7, 'Risoterapia', 'Conocida como terapia de risa. Es ideal para liberar tensiones de forma natural usando herramientas como: juegos de mesa, de azar, bailes o chistes.', 
    '[martes, jueves, sabado]', '7:00', 1, 'recreación', '[]'),
(8, 'Juegos al aire libre', 'Las actividades physical en exteriores fomentan un envejecimiento sano. A través de movimiento en equipo como: pasar la pelota, mejorar el equilibrio, juego con globos.', 
    '[lunes, miercoles, viernes]', '7:00', 1, 'recreación', '[]'),
(9, 'Natación', 'Puede aportar no solo ejercicio físico sino, favorecer la energía y vitalidad del adulto. Además, el contacto con el agua puede relajarlo y subir su estado de ánimo.', 
    '[martes, jueves, sabado]', '8:00', 1, 'care', '[]'),
(10, 'Caminar', 'Ideal para para los que que deseen preservar su masa muscular, mejorar su salud cardiovascular y perder peso como método de prevención a posibles fracturas o lesiones a nivel de vertebras.',
    '[martes, jueves, sabado]', '13:00', 1, 'care', '[]'),
(11, 'Crucigramas', 'Los juegos con palabras también son de gran ayuda, ya que el lenguaje es un elemento clave en el funcionamiento de los "engranajes" cerebrales.',
    '[lunes, miercoles, viernes]', '13:00', 1, 'mental', '[]'),
(12, 'Sudokus', 'Los sudokus se popularizaron hace años y se han convertido en una presencia permanente en muchas publicaciones, algo así como la versión numérica de las palabras cruzadas.',
    '[martes, jueves, sabado]', '17:00', 1, 'mental', '[]');


insert into alarma (id, title, body, day, time, active, interval)
values
(0, 'Juegos al aire libre', 'Las actividades físicas en exteriores fomentan un envejecimiento sano.', 1, "07:00", 1, 7),
(1, 'Respiración matinal', 'Intente realizar este ejercicio cuando se levanta por la mañana para aliviar la rigidez de los músculos y liberar las vías respiratorias obstruidas. Luego, utilícelo a lo largo del día para aliviar la tensión en la espalda.', 1, "08:30", 1, 7),
(2, 'Crucigramas', 'Divierte un poco y fortalece tu memoria jugando con crucigramas', 1, "13:00", 1, 7),
(3, 'Respiración 4-7-8', 'Respiración abdominal para ayudar a relajarse', 1, "17:30", 1, 7),
(4, 'Respiración completa', 'El objetivo de la respiración completa es desarrollar el uso completo de los pulmones y centrarse en el ritmo de su respiración.', 1, "20:00", 1, 7),
(5, 'Risoterapia', 'ideal para liberar tensiones de forma natural usando herramientas como: juegos de mesa, de azar, bailes o chistes.', 2, "7:00", 1, 7),
(6, 'Natación', 'Puede aportar no solo ejercicio físico sino, favorecer la energía y vitalidad del adulto.', 2, "8:00", 1, 7),
(7, 'TAICHI', 'La especificidad del taichí de bienestar consiste en una ejecución de secuencias hecha con la sensación de llevar unas bolas de ki.', 2, "10:00", 1, 7),
(8, 'Caminar', 'Ideal para para los que que deseen preservar su masa muscular, mejorar su salud cardiovascular y perder peso como método de prevención a posibles fracturas o lesiones a nivel de vertebras.', 2, "13:00", 1, 7),
(9, 'Bailoterapia', 'Nada mejor como realiza bailoterapia!', 2, "14:00", 1, 7),
(10, 'Sudokus', 'Mejora la habilitad mental jugando sodoku', 2, "17:00", 1, 7),
(11, 'Meditación', 'Procure buscar un lugar tranquilo, pero no se preocupe si hay algunos ruidos, como el del tráfico.', 2, "21:00", 1, 7),
(12, 'Juegos al aire libre', 'Las actividades físicas en exteriores fomentan un envejecimiento sano.', 3, "07:00", 1, 7),
(13, 'Respiración matinal', 'Intente realizar este ejercicio cuando se levanta por la mañana para aliviar la rigidez de los músculos y liberar las vías respiratorias obstruidas. Luego, utilícelo a lo largo del día para aliviar la tensión en la espalda.', 3, "08:30", 1, 7),
(14, 'Crucigramas', 'Divierte un poco y fortalece tu memoria jugando con crucigramas', 3, "13:00", 1, 7),
(15, 'Respiración 4-7-8', 'Respiración abdominal para ayudar a relajarse', 3, "17:30", 1, 7),
(16, 'Respiración completa', 'El objetivo de la respiración completa es desarrollar el uso completo de los pulmones y centrarse en el ritmo de su respiración.', 3, "20:00", 1, 7),
(17, 'Risoterapia', 'ideal para liberar tensiones de forma natural usando herramientas como: juegos de mesa, de azar, bailes o chistes.', 4, "7:00", 1, 7),
(18, 'Natación', 'Puede aportar no solo ejercicio físico sino, favorecer la energía y vitalidad del adulto.', 4, "8:00", 1, 7),
(19, 'TAICHI', 'La especificidad del taichí de bienestar consiste en una ejecución de secuencias hecha con la sensación de llevar unas bolas de ki.', 4, "10:00", 1, 7),
(20, 'Caminar', 'Ideal para para los que que deseen preservar su masa muscular, mejorar su salud cardiovascular y perder peso como método de prevención a posibles fracturas o lesiones a nivel de vertebras.', 4, "13:00", 1, 7),
(21, 'Bailoterapia', 'Nada mejor como realiza bailoterapia!', 4, "14:00", 1, 7),
(22, 'Sudokus', 'Mejora la habilitad mental jugando sodoku', 4, "17:00", 1, 7),
(23, 'Meditación', 'Procure buscar un lugar tranquilo, pero no se preocupe si hay algunos ruidos, como el del tráfico.', 4, "21:00", 1, 7),
(24, 'Juegos al aire libre', 'Las actividades físicas en exteriores fomentan un envejecimiento sano.', 5, "07:00", 1, 7),
(25, 'Respiración matinal', 'Intente realizar este ejercicio cuando se levanta por la mañana para aliviar la rigidez de los músculos y liberar las vías respiratorias obstruidas. Luego, utilícelo a lo largo del día para aliviar la tensión en la espalda.', 5, "08:30", 1, 7),
(26, 'Crucigramas', 'Divierte un poco y fortalece tu memoria jugando con crucigramas', 5, "13:00", 1, 7),
(27, 'Respiración 4-7-8', 'Respiración abdominal para ayudar a relajarse', 5, "17:30", 1, 7),
(28, 'Respiración completa', 'El objetivo de la respiración completa es desarrollar el uso completo de los pulmones y centrarse en el ritmo de su respiración.', 5, "20:00", 1, 7),
(29, 'Risoterapia', 'ideal para liberar tensiones de forma natural usando herramientas como: juegos de mesa, de azar, bailes o chistes.', 6, "7:00", 1, 7),
(30, 'Natación', 'Puede aportar no solo ejercicio físico sino, favorecer la energía y vitalidad del adulto.', 6, "8:00", 1, 7),
(31, 'TAICHI', 'La especificidad del taichí de bienestar consiste en una ejecución de secuencias hecha con la sensación de llevar unas bolas de ki.', 6, "10:00", 1, 7),
(32, 'Caminar', 'Ideal para para los que que deseen preservar su masa muscular, mejorar su salud cardiovascular y perder peso como método de prevención a posibles fracturas o lesiones a nivel de vertebras.',6, "13:00", 1, 7),
(33, 'Bailoterapia', 'Nada mejor como realiza bailoterapia!', 6, "14:00", 1, 7),
(34, 'Sudokus', 'Mejora la habilitad mental jugando sodoku', 6, "17:00", 1, 7),
(35, 'Meditación', 'Procure buscar un lugar tranquilo, pero no se preocupe si hay algunos ruidos, como el del tráfico.', 6, "21:00", 1, 7);


insert into actividadesAlarmas(alarma_id, actividad_id)
values (0, 8), (1, 3), (2, 11), (3, 1),(4, 2),(5, 7),(6, 9),(7, 5),(8, 10),(9, 6),(10, 12),(11, 4),(12, 8),(13,3),(14, 11),(15,1),(16, 2),(17, 7),
(18, 9),(19, 5),(20, 10),(21, 6),(22, 12),(23, 4),(24, 8),(25, 3),(26, 11),(27,1),(28, 2),(29, 7),(30, 9),(31, 5),(32, 10),(33, 6),(34, 12),(35, 4);


insert into comida(id, nombre, urlImagen, preparacion, ingredientes)
values
(0, 'Colada de avena con naranjilla', 'assets/imagenes/colacao.jpg', 
    '1.	Remoje la avena cruda con una taza de agua
2.	Si está usando naranjillas enteras, córtelas por la mitad y sáqueles la pulpa, luego licue la pulpa con un poco de agua hasta que se haga puré. Cernir or colar esta mezcla.
3.	En una olla, combine las 6 tazas de agua, la mitad del puré o la pulpa de naranjilla, los palitos de canela y la panela. Haga hervir, reduzca la temperatura, y cocine a fuego lento durante unos 15 minutos.
4.	Retire del fuego, y retire los palitos de canela.
5.	Licue~ 2 tazas del líquido caliente con la avena remojada y con el resto del puré o la pulpa de naranjilla.
6.	Si lo desea sin grumos, puede cernir la mezcla licuada de avena. Luego se combine con el resto del concentrado de naranjilla.
7.	Haga hervir a fuego medio, revolviendo de vez en cuando. Deje hervir hasta que espese y pierde el sabor de avena cruda, aproximadamente unos 5 minutos. Según su preferencia puede agregar mas agua, o panela/azúcar.
8.	Sirva la colada de avena caliente para el desayuno o en los días fríos, y sírvala fría con hielo en los días cálidos o en el verano.',
    '[{"title":"¾ taza avena cruda + 1 taza de agua para remojar"}, {"title":"6 tazas de agua ajuste de acuerdo a que tan espeso le guste la colada"}, {"title":"4 palitos de canela"}, {"title":"6 naranjillas enteras – frescas o congeladas o 14 onzas de pulpa congelada de naranjilla (lulo)"}, {"title":"½ – ¾ lb panela o piloncillo rallada o en trozos, o puede usar azúcar – ajuste al gusto"}]'
),

(1, 'Humitas', 'assets/imagenes/pillo.jpg', 
    '1.	Pele los choclos, saque las hojas y trate de mantener cada hoja intacta, las hojas mas grandes se usan para envolver las humitas y las más pequeñas se rompen en tiritas para amarrarlas.
2.	Ponga las hojas en agua hirviendo durante un par de minutos, luego cierne y guarde las hojas hasta el momento de envolver las humitas.
3.	Limpie bien los choclos pelados, quitándoles las pelusitas, y use un chuchillo para desgranar los choclos, si no tiene una vaporera para cocinar las humitas guarde las tusas para hacer una vaporera.
4.	En el procesador de alimentos ponga los granos de choclos, 1 taza de queso o quesillo, las cebollas picadas, los ajos machacados, las semillas de cilantro molidas, la harina de maíz, la crema, los huevos, y la sal, muela todos los ingredientes hasta obtener un puré.
5.	En una olla de tipo tamalera ponga aproximadamente 2 ½ tazas de agua y la vaporera, el nivel de agua debe estar justo debajo de la parte superior de la vaporera. Si no tiene una vaporera ponga las tusas y algunas de las hojas de choclo en el fondo de la olla, así mismo el nivel de agua debe llegar justo a la parte superior de las tusas pero sin cubrirlas completamente.
6.	Para rellenar y envolver las hojas con la mezcla de las humitas, use 2 hojas de buen tamaño para cada humita, ponga las hojas una encima de otra, doble el costado, luego doble la punta creando un pequeño bolsillo, rellene las hojas con una buena cucharadade la mezcla de choclo, ponga un poquito de queso rallado o desmenuzado en el centro, luego doble el otro costado de las hojas y use las tiras de las hojas pequeñas para amarrar la humita. Observe las fotos para ver con más detalles el proceso de rellenar y envolver las humitas.
7.	Ponga las hojas rellenas y envueltas en la olla con la vaporera, recomiendo colocar cada humita de forma un poco inclinada y si tienen alguna apertura póngalas con esa parte hacia arriba. Cubra las humitas con las hojas que sobren y tape bien la olla.
8.	Cocine a fuego alto hasta que el agua empiece a hervir, baje la temperatura y cocine a vapor durante 35 a 40 minutos.
9.	Sirva las humitas calientes acompañadas de aji de tomate de árbol.
',
    '[{"title":"6-7 mazorcas de choclos o maíz tierno con las hojas"}, {"title":"3 tazas de queso o quesillo rallado o desmenuzado puede usar queso mozzarella si no encuentra quesillo"}, {"title":"1 taza de cebolla blanca o perla picada finamente"}, {"title":"1 cucharadita de semillas de cilantro en polvo"}, {"title":"2 dientes de ajo machacados"}, {"title":"Aproximadamente una taza de harina de maíz solamente si está preparando las humitas con choclos cultivados en EEUU, Europa, u otro lugar donde no se encuentre la variedad de choclo fresco sudamericano"}, {"title":"¼ taza de crema liquida o nata liquida"}, {"title":"2 huevos"}, {"title":"1 cucharadita de sal"}]'
),
(2, 'Mote pillo', 'assets/imagenes/humitas.jpg', 
    '1.	Calentar la mantequilla o manteca en una sartén de buen tamaño, agregar la cebolla blanca o los puerros, el ajo machacado, el achiote molido, y la sal para preparar un refrito, cocinar hasta que la cebolla este suave, aproximadamente unos 5 minutos.
2.	Añadir el mote, mezclar bien y cocinar por 2 minutos.
3.	Agregar la leche y cocinar hasta que la leche este casi completamente absorbida por el mote.
4.	Batir los huevos ligeramente y añadirlos al mote, mezclar bien y cocinar aproximadamente unos 5 minutos.
5.	Agregar las cebolletas y el cilantro.
6.	Servir acompañado de las rodajas de queso y con cafecito caliente.
',
    '[{"title":"1 lb de mote cocido"}, {"title":"2 cucharadas de mantequilla o manteca"}, {"title":"1 taza de cebolla blanca o puerros la parte blanca, picada finamente"}, {"title":"2 dientes de ajo machacados"}, {"title":"¼ cucharadita de achiote molido"}, {"title":"4 huevos"}, {"title":"¼ taza de leche"}, {"title":"2 cucharadas de cebolletas picadas finamente"}, {"title":"1 cucharada de cilantro o perejil picado finamente"}, {"title": "Sal al gusto"}]'
),

(3, 'Sándwich de aguacate y huevos revueltos', 'assets/imagenes/cate.jpg', 
    '1.	Cubre una de las rebanadas de pan con aguacate, agrega una poca de sal y pimienta para dar más sabor.
2.	En un sartén prepara los dos huevos revueltos.
3.	Coloca los huevos sobre el aguacate y coloca la otra rebanada de pan.
',
    '[{"title":"2 rebanadas de pan de grano entero ligeramente tostado."}, {"title":"½ aguacate aplastado."}, {"title":"Sal y pimienta al gusto."}, {"title":"Dos huevos."},{"title":"Aceite en aerosol para cocinar."}]'
),

(4, 'Papas asadas rellenas', 'assets/imagenes/papas.jpg', 
    '1.	Precalentar el horno a 400°F / 200°C.
2.	Lavar muy bien las papas, quitar cualquier ladito feo que tenga, pero dejar la piel. Secar con una servilleta o paño limpio, pinchar con un tenedor por todos los lados y cubrir toda la superficie con aceite de oliva, agregar sal y pimienta a gusto.
3.	Colocar las papas directamente sobre la rejilla del horno y cocinar por unos 30 a 40 minutos, dependiendo del tamaño de las papas (no hace faltas rotarlas durante la cocción). Para saber si están listas, pincharlas con un palillo o cuchillo. La piel debe estar un poco arrugada o crujiente y suave en el interior.
4.	Retirar las papas del horno, cortarlas a la mitad de forma que las dos partes se mantengan unidas.
5.	Rellenar con los ingredientes que tengas disponible. Servir y disfrutar.
',
    '[{"title":"6 papas"}, {"title":"Aceite de oliva u otro que uses para cocinar"},{"title":"Sal y pimienta a gusto"},{"title":"Para el relleno: Jamón, queso, pollo picado, tomate, cebollines, brócoli y otros vegetales, crema agria, u otras adiciones disponibles"}]'
),
(5, 'Rollitos De Jamón Con Queso', 'assets/imagenes/rollo.jpg', 
    '1.	Cortar todas las orillas de los panes.
2.	Aplanar las rebanadas con un rodillo.
3.	Untarles los frijoles, luego agregar la rebanada de jamón y queso.
4.	Enrolla.
',
    '[{"title":"4 rebanadas de pan blanco"}, {"title":"4 cucharadas de frijol refrito"},{"title":"4 rebanadas de queso amarillo"}, {"title":"2 rebanadas de jamón"}]'
);