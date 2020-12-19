CREATE TABLE Actividad(
    id INTEGER PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    descripcion VARCHAR NOT NULL,
    days VARCHAR NULL,
    time VARCHAR NULL,
    active INTEGER DEFAULT 1,
    type varchar not null,
    complements text
);

CREATE TABLE Comida(
    id INTEGER PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    urlImagen varchar not null,
    preparacion text,
    ingredientes text
);


CREATE TABLE alarma(
    id INTEGER PRIMARY KEY,
    title VARCHAR NULL DEFAULT "Sin título",
    body VARCHAR NULL DEFAULT "Sin descripción",
    day INTEGER NOT NULL,
    time VARCHAR NOT NULL, --HH:MM
    active INTEGER DEFAULT 1,
    interval INTEGER DEFAULT 7
);

CREATE TABLE actividadesAlarmas(
    alarma_id INTEGER NOT NULL,
    actividad_id INTEGER NOT NULL,
    FOREIGN KEY(actividad_id) REFERENCES actividad(id) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY(alarma_id) REFERENCES alarma(id) ON UPDATE CASCADE ON DELETE NO ACTION
);
