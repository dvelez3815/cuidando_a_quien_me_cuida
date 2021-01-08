insert into contacto values
    (0, 'Policía', 'Policía Nacional de Ecuador', '111'),
    (1, 'Emergencia', 'Contacto de emergencia de Ecuador', '911');


insert into actividad (id, nombre, descripcion, days, time, active, type, complements)
values
(0, 'Respiración abdominal', 'La respiración abdominal es fácil de realizar y es muy relajante. Intente este ejercicio básico en cualquier momento que necesite relajarse o aliviar el estrés.', 
    '[lunes, miercoles, viernes]', '10:30', 3, 'física', 
'[{}]'),
(1, 'Respiración 4-7-8', 'Este ejercicio también utiliza la respiración abdominal para ayudarle a relajarse. Puede realizar este ejercicio sentado o recostado.', 
    '[lunes, miercoles, viernes]', '17:30', 3, 'física', 
'[{}]'),
(2, 'Respiración completa', 'El objetivo de la respiración completa es desarrollar el uso completo de los pulmones y centrarse en el ritmo de su respiración. Puede hacerlo en cualquier posición. Pero, mientras aprende, es mejor recostarse boca arriba con las rodillas flexionadas.', 
    '[lunes, miercoles, viernes]', '20:00', 3, 'física', 
'[{}]'),
(3, 'Respiración matinal', 'Intente realizar este ejercicio cuando se levanta por la mañana para aliviar la rigidez de los músculos y liberar las vías respiratorias obstruidas. Luego, utilícelo a lo largo del día para aliviar la tensión en la espalda.', 
    '[lunes, miercoles, viernes]', '08:00', 3, 'física', 
'[{}]'),
(4, 'Meditación', 'Elija un momento y un lugar donde pueda meditar sin interrupciones. Procure buscar un lugar tranquilo, pero no se preocupe si hay algunos ruidos, como el del tráfico. Ese tipo de ruido es simplemente parte del momento presente.', 
    '[martes, jueves, sabado]', '21:00', 3, 'física', 
'[{}]'),
(5, 'TAICHI', 'La especificidad del taichí de bienestar consiste en una ejecución de secuencias hecha con la sensación de llevar unas bolas de ki.', 
    '[martes, jueves, sabado]', '10:00', 3, 'física', '[{}]'),

(6, 'Bailoterapia', 'La música es la libre expresión de las emociones. La expresión corporal en colectividad puede ayudar a elevar el estado de ánimo, liberar tensiones y motivar al anciano a crear empatía con su entorno.', 
    '[martes, jueves, sabado]', '14:00', 1, 'recreación', '[{}]'),
(7, 'Risoterapia', 'Conocida como terapia de risa. Es ideal para liberar tensiones de forma natural usando herramientas como: juegos de mesa, de azar, bailes o chistes.', 
    '[martes, jueves, sabado]', '7:00', 1, 'recreación', '[{}]'),
(8, 'Juegos al aire libre', 'Las actividades físicas en exteriores fomentan un envejecimiento sano. A través de movimiento en equipo como: pasar la pelota, mejorar el equilibrio, juego con globos.', 
    '[lunes, miercoles, viernes]', '7:00', 1, 'recreación', '[{}]'),
(9, 'Natación', 'Puede aportar no solo ejercicio físico sino, favorecer la energía y vitalidad del adulto. Además, el contacto con el agua puede relajarlo y subir su estado de ánimo.', 
    '[martes, jueves, sabado]', '8:00', 1, 'bienestar', '[{}]'),
(10, 'Caminar', 'Ideal para para los que que deseen preservar su masa muscular, mejorar su salud cardiovascular y perder peso como método de prevención a posibles fracturas o lesiones a nivel de vertebras.',
    '[martes, jueves, sabado]', '13:00', 1, 'bienestar', '[{}]'),
(11, 'Crucigramas', 'Los juegos con palabras también son de gran ayuda, ya que el lenguaje es un elemento clave en el funcionamiento de los "engranajes" cerebrales.',
    '[lunes, miercoles, viernes]', '13:00', 1, 'mental', '[{}]'),
(12, 'Sudokus', 'Los sudokus se popularizaron hace años y se han convertido en una presencia permanente en muchas publicaciones, algo así como la versión numérica de las palabras cruzadas.',
    '[martes, jueves, sabado]', '17:00', 1, 'mental', '[{}]');


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

