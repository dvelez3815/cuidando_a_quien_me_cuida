-- Esta es la única vía por la cuál se pueden agregar números de 
-- menos de 10 dígitos y que no comiencen con 09 o +593, después
-- se puede modificar.
insert into contacto values
    (0, 'Policía', 'Policía Nacional de Ecuador', '111'),
    (1, 'Emergencia', 'Contacto de emergencia de Ecuador', '911');

-- El ID debes ponerlo manualmente, es un entero. Los días vienen dados como un
-- vector con los nombres en español; la hora está en formato 24h. El parámetro
-- 'active' es un booleano, pero como sqlite no lo soporta se pone 1 para true y 0
-- para false, pero ponle siempre 1. El 'type' es el tipo de actividad, en este caso
-- solo acepta 4 posibles valores: mental, recreation, physical, care.
-- Por íltimo están los complementos, que vienen en formato de un array json.
insert into actividad (id, nombre, descripcion, days, time, active, type, complements)
values
(0, 'Título ejemplo', 'Descripción ejemplo', 
    '[lunes, martes, viernes]', '10:30', 1, 'mental', 
    '[{"title":"nombre material1"},{"title":"nombre material2"}]'
);

-- Las alarmas deberás crear una por cada día, y en el parámetro 'day' deberás
-- colocar el número del día, siendo el lunes el día 1. El campo 'interval' hace
-- referencia a cada cuánto tiempo sonará la alarma, por defecto sonará cada semana.
-- 
-- El título y el cuerpo de la alarma será lo que se muestre en la notificación, en
-- la app siempre es el mismo nombre de la actividad a la que pertenece. Se pudo normalizar
-- esto para que esos campos los obtuviese de la tabla actividad mediante joins, pero
-- sqlite es un desastre y daba error, por eso los repetí acá, aunque más adelante se
-- puede normalizar, cuando ya esté todo acabado y haya paciencia para ver por qué dan
-- error los joins.
-- 
-- Lo más probable es que esto se termine normalizando, pero ya después haré un script
-- para que transforme estas sentencias al nuevo modelo de datos.
insert into alarma (id, title, body, day, time, active, interval)
values
(0, 'Título ejemplo', 'descripción ejemplo', 1, "10:30", 1, 7),
(1, 'Título ejemplo', 'descripción ejemplo', 2, "10:30", 1, 7),
(2, 'Título ejemplo', 'descripción ejemplo', 5, "10:30", 1, 7);

-- Finalmente, para acabar con las actividades, hay que agregar la relación, esto en 
-- principio era N a N, pero ya después quedó 1 a N, por lo que esta tabla no es
-- necesaria, y la fk iría en la tabla anterior pero de nuevo, ya después se corrige 
-- esto con algún proceso automatizado.
insert into actividadesAlarmas(alarma_id, actividad_id)
values (0, 0), (1, 0), (2, 0);

-- La imágen debe estar en la misma ruta siempre, por lo que la parte de
-- 'assets/imagenes/' es constante. Hay que procurar que las imágenes sean 
-- cuadradas en la medida de lo posible, pero si no se puede no importa
insert into comida(id, nombre, urlImagen, preparacion, ingredientes)
values
(0, 'encebollado', 'assets/imagenes/recetas.jpg', 
    'Poner pescado en agua hervida con ají peruano, cebolla, y yuca',
    '[{"title":"3 Yucas"}, {"title":"5 lbs de Pescado"}, {"title":"5 Cebollas"}, {"title":"5 lts de agua"}]'
);