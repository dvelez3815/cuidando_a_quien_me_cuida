insert into contacto values
    (0, 'Policía', 'Policía Nacional de Ecuador', '111'),
    (1, 'Emergencia', 'Contacto de emergencia de Ecuador', '911');

insert into actividad (id, nombre, descripcion, days, time, active, type, complements)
values
(0, 'Respiración abdominal', 'La respiración abdominal es fácil de realizar y es muy relajante. Intente este ejercicio básico en cualquier momento que necesite relajarse o aliviar el estrés.', 
    '[lunes, miercoles, viernes]', '10:30', 0, 'physical',
'[]'),
(1, 'Respiración 4-7-8', 'Este ejercicio también utiliza la respiración abdominal para ayudarle a relajarse. Puede realizar este ejercicio sentado o recostado.', 
    '[lunes, miercoles, viernes]', '17:30', 0, 'physical',
'[]'),
(2, 'Respiración completa', 'El objetivo de la respiración completa es desarrollar el uso completo de los pulmones y centrarse en el ritmo de su respiración. Puede hacerlo en cualquier posición. Pero, mientras aprende, es mejor recostarse boca arriba con las rodillas flexionadas.', 
    '[lunes, miercoles, viernes]', '20:00', 0, 'physical', 
'[]'),
(3, 'Respiración matinal', 'Intente realizar este ejercicio cuando se levanta por la mañana para aliviar la rigidez de los músculos y liberar las vías respiratorias obstruidas. Luego, utilícelo a lo largo del día para aliviar la tensión en la espalda.', 
    '[lunes, miercoles, viernes]', '08:00', 0, 'physical', 
'[]'),
(4, 'Meditación', 'Elija un momento y un lugar donde pueda meditar sin interrupciones. Procure buscar un lugar tranquilo, pero no se preocupe si hay algunos ruidos, como el del tráfico. Ese tipo de ruido es simplemente parte del momento presente.', 
    '[martes, jueves, sabado]', '21:00', 0, 'physical', 
'[]'),
(5, 'TAICHI', 'La especificidad del taichí de bienestar consiste en una ejecución de secuencias hecha con la sensación de llevar unas bolas de ki.', 
    '[martes, jueves, sabado]', '10:00', 0, 'physical', '[]'),

(6, 'Bailoterapia', 'La música es la libre expresión de las emociones. La expresión corporal en colectividad puede ayudar a elevar el estado de ánimo, liberar tensiones y motivar al anciano a crear empatía con su entorno.', 
    '[martes, jueves, sabado]', '14:00', 0, 'recreación', '[]'),
(7, 'Risoterapia', 'Conocida como terapia de risa. Es ideal para liberar tensiones de forma natural usando herramientas como: juegos de mesa, de azar, bailes o chistes.', 
    '[martes, jueves, sabado]', '7:00', 0, 'recreación', '[]'),
(8, 'Juegos al aire libre', 'Las actividades physical en exteriores fomentan un envejecimiento sano. A través de movimiento en equipo como: pasar la pelota, mejorar el equilibrio, juego con globos.', 
    '[lunes, miercoles, viernes]', '7:00', 0, 'recreación', '[]'),
(9, 'Natación', 'Puede aportar no solo ejercicio físico sino, favorecer la energía y vitalidad del adulto. Además, el contacto con el agua puede relajarlo y subir su estado de ánimo.', 
    '[martes, jueves, sabado]', '8:00', 0, 'care', '[]'),
(10, 'Caminar', 'Ideal para para los que que deseen preservar su masa muscular, mejorar su salud cardiovascular y perder peso como método de prevención a posibles fracturas o lesiones a nivel de vertebras.',
    '[martes, jueves, sabado]', '13:00', 0, 'care', '[]'),
(11, 'Crucigramas', 'Los juegos con palabras también son de gran ayuda, ya que el lenguaje es un elemento clave en el funcionamiento de los "engranajes" cerebrales.',
    '[lunes, miercoles, viernes]', '13:00', 0, 'mental', '[]'),
(12, 'Sudokus', 'Los sudokus se popularizaron hace años y se han convertido en una presencia permanente en muchas publicaciones, algo así como la versión numérica de las palabras cruzadas.',
    '[martes, jueves, sabado]', '17:00', 0, 'mental', '[]');


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
(8, 'Pescado a la Plancha con Verduras', 'assets/imagenes/pescado.jpg', 
    '1.	Cortar el pescado o bien adquirirlo hecho filetes, esparcir con una mezcla de aceite, sal y pimienta.
Adecentar y recortar en rodajas las verduras (suchi, cebolla, pimiento colorado etc.) y recortar unos espárragos. Ponerlo todo en una plancha o bien una sartén a fuego fuerte salpimentando las verduras. Ir pincelando el pescado de cuando en cuando con la mezcla del aceite.
2.	Servir el pescado y las verduras que más le agraden a cada uno de ellos y comer calentito.

',
    '[{"title":"Pescado"},{"title":"Verdura"},{"title":"Sal"}]'
),

(9, 'Aguado de pollo', 'assets/imagenes/aguado.jpg', 
    '1.	Remoje el arroz en agua durante unos 30 minutos
2.	En una olla grande, caliente el aceite o la mantequilla para hacer un refrito o sofrito con la cebolla, el ajo, el pimiento, los tomates, el perejil, el orégano, el comino, el achiote, la sal y pimienta. Cocine por 10 minutos, revolviendo frecuentemente.
3.	Agregue el caldo de pollo y haga hervir.
4.	Agregue las presas de pollo y cocine a fuego medio durante 30 minutos.
5.	Agregue el arroz remojado y las papas picadas, cocine por unos 45 minutos a fuego bajo, revolviendo de vez de en cuando.
6.	Agregue las zanahorias y cocine durante 5 minutos
7.	Agregue las arvejas y cocine por 5-7 minutos o hasta que las arvejas y las zanahorias estén tiernas.
8.	Retire del fuego, y agregue el cilantro picado
9.	Sirva el aguado acompañado de tajas de aguacate y ají.
',
    '[{"title":"900g de pollo o gallina"},
    {"title":"1 taza de arroz"},
    {"title":"2 cucharadas de aceite de oliva"},
    {"title":"1 taza de cebolla roja picada en cubitos"},
    {"title":"1 taza de pimiento picado en cubitos"},
    {"title":"2 tomates tipo roma pelados, sin semillas y picados en cubitos"},
    {"title":"4 dientes de ajo machacados"},
    {"title":"2 cucharadas de perejil finamente picado"},
    {"title":"1 cucharadita de orégano seco o 1 cucharada de orégano fresco picado"},
    {"title":"1 cucharadita de comino molido"},
    {"title":"1 cucharadita de achiote molido"},
    {"title":"4 tazas de caldo de pollo o agua"},
    {"title":"2 papas peladas y picadas, alrededor de 3 ½ tazas"},
    {"title":"1 taza de zanahorias picadas en cubitos"},
    {"title":"1 taza de arvejas o guisantes frescas o congeladas"},
    {"title":"2 cucharadas de cilantro finamente picado"},
    {"title":"Sal y pimienta al gusto"}]
    '
),
(10, 'Locro de papa con queso', 'assets/imagenes/locro.jpg', 
    '1.	Prepare un refrito para el locro de papa, caliente el aceite o la mantequilla a fuego medio en una olla, añada la cebolla picada, los ajos picados, el comino y el achiote molido. Cocine hasta que las cebollas estén suaves, aproximadamente 5 minutos.
2.	Añada las papas a la olla y mezclar bien con el refrito, continúe cocinando las papas por unos 5 minutos.
3.	Añada el agua y haga hervir, cocine las papas hasta que se ablanden. Utilice un machacador de papas para aplastar las papas, pero no las aplaste a todas, la consistencia del locro de papa debe ser cremosa pero con trocitos de papa.
4.	Reduzca la temperatura, añada la leche, mezcle bien y deje cocinar por unos 5 minutos adicionales. Puede añadir más leche o agua si la sopa está muy espesa.
5.	Añada sal al gusto, el queso rallado o desmenuzado y el cilantro.
6.	Sirva el locro de papa caliente con los aguacates, las cebollitas verdes, el queso feta desmenuzado y el aji.

',
    '[{"title":"5 papas de tamaño mediano peladas y cortadas en cuadros grandes y pequeños"},
    {"title":"2 cucharadas de aceite de oliva"},
    {"title":"1 cebolla blanca tipo perla picada en cuadritos"},
    {"title":"2 dientes de ajo picados finamente"},
    {"title":"2 cucharaditas de comino"},
    {"title":"1-2 cucharaditas de achiote molido"},
    {"title":"5 tazas de agua"},
    {"title":"1 taza de leche puede ponerle más si gusta"},
    {"title":"1 taza de quesillo o queso fresco desmenuzado también se puede usar mozzarella rallada"},
    {"title":"4 cucharadas de cilantro picado finamente"},
    {"title":"Sal al gusto"}]
    '
),

(11, 'Macarrones con atún', 'assets/imagenes/macarron.jpg', 
    '1.	Echar un poco de aceite de las latas del pescado para dorar el ajo.
2.	Poner el atún y el resto de aceite en un colador o separar con un tenedor.
3.	Freír el ajo con aceite hasta que esté dorado y descartarlo, añadir la mezcla de pescado, el tomate y, si se desea, la menta o la albahaca y cocinar a fuego lento durante unos 15 minutos. Esta salsa se puede poner en la nevera y recalentar justo antes de servir. O empezar a hacer la salsa unos minutos antes de poner los macarrones a hervir, como siempre, en abundante agua con sal.
4.	Cuando los macarrones estén al dente, escurrir, echar la salsa caliente por encima y decorar con el perejil en el momento de servir.

',
    '[{"title":"75 gr de atún en aceite de oliva"},
    {"title":"1 diente de ajo"},
    {"title":"1 lata de pasta de tomate"},
    {"title":"1 ramita de albaca o menta (opcional)"},
    {"title":"400g de macarrones"},
    {"title":"2 cucharadas de perejil picado"}]
    '
),

(12, 'Filete de pollo a la plancha', 'assets/imagenes/fplancha.jpg', 
    '1.	Prepara el marinado para el pollo, utiliza: limón o vinagre de manzana, el ajo (finamente picado) y las especies.
2.	Mezcla muy bien todos los ingredientes, hasta lograr homogeneidad, y reserva. El marinado proporciona sabor a la carne, jugosidad y suavidad.
3.	Acto seguido, impregna las pechugas fileteadas dentro de la mezcla, deja reposar entre 10 y 15 minutos.
4.	Pasado el tiempo, solo necesitas cocinarlo a la plancha (no agregues aceite).
',
    '[{"title":"2 filetes de pechuga de pollo"},
    {"title":"1 Limón"},
    {"title":"1 pizca de pimienta"},
    {"title":"1 diente de ajo"},
    {"title":"1 pizca de orégano"},
    {"title":"1 pizca de hierbas provenzales"}]
    '
),
(13, 'Sopa de zapallo', 'assets/imagenes/szapallo.jpg', 
    '1.	Caliente el aceite en una cacerola de buen tamaño.
2.	Añada la cebolla, el ajo, el comino y los tomates, cocine hasta que las cebollas estén suaves, por unos 5 minutos.
3.	Añada el caldo de pollo o verduras y haga hervir.
4.	Añada los trozos de zapallo o calabaza y haga hervir nuevamente, reduzca la temperatura y cocine a fuego lento hasta que los pedazos de zapallo estén suaves, aproximadamente unos 30 minutos.
5.	Dejar que la sopa se enfríe lo suficiente para poder licuarlo, licuar hasta obtener un puré.
6.	Añada sal y pimienta al gusto, re-calentar si la sopa lo requiere
7.	Sirva la sopa caliente con queso feta o queso de cabra y cebolletas picadas
',
    '[{"title":"1 zapallo o calabaza de buen tamaño pelado, sin semillas y cortado en trozos pequeños"},
    {"title":"3 cucharadas de aceite de oliva"},
    {"title":"1 cebolla blanca picada finamente"},
    {"title":"3 dientes de ajo machacados"},
    {"title":"1 cucharadita de comino molido"},
    {"title":"4 tomates pelados y picados"},
    {"title":"6 tazas de caldo de pollo o verduras"},
    {"title":"Sal y pimienta al gusto"}]
    '
),
(14, 'Sopa de fideo con queso', 'assets/imagenes/sopaqueso.jpg', 
    '1.	Preparar un refrito o sofrito con el aceite de color, la cebolla picada, y los aliños.
2.	Pelar y picar las papas en cuadritos pequeños.
3.	Agregar el agua y las papas. Llevar a la ebullición.
4.	Agregar el fideo y cocinar durante unos diez minutos o hasta que las papas y los fi-deos estén cocidos.
5.	Añadir la crema y el queso desmenuzado. Mezclar bien.
6.	Rectificar la sal y servir con culantro o perejil picadito.
',
    '[{"title":"2 cucharadas de aceite de color achiote"},
    {"title":"½ cebollita blanca picadita"},
    {"title":"Aliños al gusto: comino, ajo, orégano, etc"},
    {"title":"2 ½ litros de agua"},
    {"title":"1 libra de papas"},
    {"title":"7 onzas de fideos"},
    {"title":"½ taza de crema de leche"},
    {"title":"6 onzas de queso picadito en cubos o desmenuzado"},
    {"title":"Culantro o perejil picadito"}]
    '
),
(15, 'Wok de tallarines, camarón y verduras con salsa teriyaki', 'assets/imagenes/wok.jpg', 
    '1.	Empezamos lavando las verduras y cortándolas en juliana.
2.	Luego, en un wok con aceite caliente salteamos las verduras moviéndolas constantemente con un movimiento de muñeca. La idea es no hacerlas demasiado para que queden ligeramente crujientes
3.	Por otro lado, calentamos agua con sal en una olla y hacemos los tallarines, luego los escurrimos con agua fría y los añadimos al wok junto con la salsa teriyaki (unas dos o tres cucharadas).
4.	Rehogamos un par de minutos y servimos en cuencos.
',
    '[{"title":"160 g de tallarines (pueden ser noodles al huevo como los usado, fideos udon o incluso de arroz)"},
    {"title":"10 Camarones pelados"},
    {"title":"Verduras variadas (berenjena, pimiento, zanahoria, cebolla, champiñones...)"},
    {"title":"Aceite de oliva virgen extra"},
    {"title":"Sal"},
    {"title":"Salsa teriyaki"}]
    '
),

(17, 'Tostada de aguacate', 'assets/imagenes/ta.jpg', 
    '1.	Prepara la mayonesa mezclándola con sal de ajo, paprika, y Puré de Tomate, reserva.
2.	Para los panes y huevos Tuesta ligeramente los panes en un sartén, coloca un poco de mantequilla sobre el sartén y cocina los huevos como huevos fritos. Otra opción es en una olla a fuego medio, coloca agua y deja hervir. Agrega 2 cucharadas de vinagre blanco y con cuidado agregas los huevos. Revuelves el agua con mucho cuidado formando un remolino en el agua y deja cocinar los huevos 4 minutos en el remolino de agua hirviendo.
3.	Mientras tanto coloca un poco de la mayonesa preparada sobre las rodajas de pan tostado, sobre esta las rodajas de aguacate y sobre el aguacate los huevos.
',
    '[{"title":"3 Cucharadas de Mayonesa"},
    {"title":"1 Unidad Aguacate maduro, pelado y picado en rodajas"},
    {"title":"2 Unidades Pan artesanal de masa madre"},
    {"title":"2 Unidades Huevo"},
    {"title":"1 Cucharadita Sal de Ajo"},
    {"title":"1 Cucharadita Paprika"},
    {"title":"1 Cucharadita de Puré de Tomate"}]
    '
),
(20, 'Ensaladilla de patata con mayonesa de limón y mostaza', 'assets/imagenes/ensaladilla.jpg', 
    '1.	Cocemos las patatas enteras y con piel en una cacerola con abundante agua. El tiempo dependerá del tipo de patata. Las nuestras tardaron 30 minutos, pero lo mejor es comprobar el punto pinchando con una brocheta en la parte más gruesa. Si entra con facilidad, están listas y las podemos retirar del agua. Si no es el caso las dejamos cocer unos minutos más.
2.	Al tiempo que se hacen las patatas ponemos a hervir agua con un puñado de sal en un cacito. Introducimos cuatro huevos y contamos 11 minutos justos. Retiramos los huevos y los refrescamos en un recipiente con agua helada para cortar la cocción. Pelamos y reservamos.
3.	También preparamos la salsa mezclando la mayonesa con la yema de huevo, la ralladura de un limón, la mostaza y la leche. Salpimentamos al gusto y removemos bien hasta homogeneizar. Reservamos en la nevera hasta el momento de usar.
4.	Pelamos las patatas (en frío) y semi machacamos con un tenedor, dejando trozos irregulares para dar textura. Salpimentamos ligeramente, añadimos los huevos duros troceados (nos reservamos una yema para decorar) junto con la salsa. En el momento de servir la ensalada rallamos la yema de huevo duro que tenemos reservada y decoramos con cebollino fresco picado.
',
    '[{"title":"Patata nueva 4"},
    {"title":"Mayonesa 200 g"},
    {"title":"Ralladura de limón 1"},
    {"title":"Leche 30 ml"},
    {"title":"Yema de huevo 1"},
    {"title":"Huevo 4"},
    {"title":"Sal"},
    {"title":"Pimienta negra molida"},
    {"title":"Cebollino para decorar"}]
    '
);


insert into imagenesactividades values
(0,0,'assets/imagenes/abdominal.jpg'),
(1,1,'assets/imagenes/478.jpg'),
(2,2,'assets/imagenes/completa.jpg'),

(4,4,'assets/imagenes/meditacion.jpg'),
(5, 5, "assets/imagenes/taichi.jpg"),
(6, 5, "assets/imagenes/taichi1.jpg"),
(7, 5, "assets/imagenes/taichi2.jpg"),
(8, 5, "assets/imagenes/taichi3.jpg"),
(9, 5, "assets/imagenes/taichi4.jpg");

insert into procedimiento values
('1. Siéntese o acuéstese en una posición cómoda. 
2.	Coloque una mano sobre el abdomen justo debajo de las costillas y la otra mano sobre el pecho.
3.	Respire hondo por la nariz y deje que el abdomen le empuje la mano. El pecho no debería moverse.
4.	Exhale a través de los labios fruncidos como si estuviese silbando. Sienta cómo se hunde la mano sobre su abdomen y utilícela para expulsar todo el aire hacia afuera.
5.	Realice este ejercicio de respiración entre 3 y 10 veces. Tómese su tiempo con cada respiración.
6.	Note cómo se siente al final del ejercicio.',0,0), 
('1. Para comenzar, coloque una mano sobre el abdomen y la otra sobre el pecho, al igual que en el ejercicio de respiración abdominal.
2.	Respire profunda y lentamente desde el abdomen y cuente en silencio hasta 4 a medida que inhala.
3.	Contenga la respiración y cuente en silencio del 1 al 7.
4.	Exhale por completo a medida que cuenta en silencio del 1 al 8. Intente sacar todo el aire de los pulmones para cuando llegue a 8.
5.	Repítalo entre 3 y 7 veces o hasta que se sienta tranquilo.
6.	Note cómo se siente al final del ejercicio. ',1,1),

('1. Para comenzar, coloque una mano sobre el abdomen y la otra sobre el pecho, al igual que en el ejercicio de respiración abdominal.
2.	Respire profunda y lentamente desde el abdomen y cuente en silencio hasta 4 a medida que inhala.
3.	Contenga la respiración y cuente en silencio del 1 al 7.
4.	Exhale por completo a medida que cuenta en silencio del 1 al 8. Intente sacar todo el aire de los pulmones para cuando llegue a 8.
5.	Repítalo entre 3 y 7 veces o hasta que se sienta tranquilo.
6.	Note cómo se siente al final del ejercicio. ',2,2),

('1. Coloque la mano izquierda sobre el abdomen y la mano derecha sobre el pecho. Observe cómo se mueven las manos al inhalar y exhalar.
2.	Practique llenar la parte inferior de los pulmones respirando, de modo que la mano "del abdomen" (izquierda) suba cuando inhala y la mano "del pecho" permanezca quieta. Siempre inhale por la nariz y exhale por la boca. Haga esto 8 a 10 veces.
3.	Cuando haya llenado y vaciado la parte inferior de los pulmones entre 8 y 10 veces, agregue el segundo paso a su respiración: primero, inhale aire hacia la parte inferior de los pulmones como antes y, después, siga inhalando aire hacia la parte superior del pecho. Respire lenta y regularmente. Mientras lo hace, la mano derecha se levantará y la mano izquierda bajará un poco a medida que el abdomen baja.
4.	A medida que exhala lentamente por la boca, haga un sonido leve y sibilante a medida que baja la mano izquierda, primero, y la mano derecha, después. Mientras exhala, sienta cómo la tensión deja el cuerpo a medida que se relaja cada vez más.
5.	Practique inhalar y exhalar de esta forma entre 3 y 5 minutos. Note que el movimiento del abdomen y del pecho sube y baja como el balanceo de las olas.
6.	Note cómo se siente al final del ejercicio.',3,3),

('1. En posición de pie, inclínese hacia adelante desde la cintura con las rodillas levemente flexionadas y permita que los brazos cuelguen cerca del suelo.
2.	Mientras inhala lenta y profundamente, regrese a la posición de pie enderezándose lentamente y levantando, por último, la cabeza.
3.	Contenga la respiración solo por unos pocos segundos en esta posición de pie.
4.	Exhale lentamente a medida que regresa a la posición original, flexionándose hacia adelante desde la cintura.
5.	Note cómo se siente al final del ejercicio.',4,4),
('1.Siéntese o acuéstese en una posición cómoda. 
2.	Coloque una mano sobre el abdomen justo debajo de las costillas y la otra mano sobre el pecho.
3.	Respire hondo por la nariz y deje que el abdomen le empuje la mano. El pecho no debería moverse.
4.	Exhale a través de los labios fruncidos como si estuviese silbando. Sienta cómo se hunde la mano sobre su abdomen y utilícela para expulsar todo el aire hacia afuera.
5.	Realice este ejercicio de respiración entre 3 y 10 veces. Tómese su tiempo con cada respiración.
6.	Note cómo se siente al final del ejercicio.',5, 5);

