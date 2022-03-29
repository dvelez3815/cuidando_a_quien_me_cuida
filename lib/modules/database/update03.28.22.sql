alter table Contacto add column email text null;
alter table Contacto add column location varchar(100) null;
alter table Contacto add column webpage text null;

insert into contacto values
    (-1, 'TASE', 'Trascender con Amor, Servicio y Excelencia', '+593 989559999', 'info@fundaciontase.org', 'Quito, Ecuador','http://www.fundaciontase.org'),
    (-2, 'Alma', 'Alzheimer Rosario', null, 'info@almarosario.org.ar', 'Rosario, Argentina', 'https://almarosario.org.ar/alma/'),
    (-3, 'Grupo de apoyo Puerto Rico', 'Grupo de apoyo a familiares de pacientes con Alzheimer y otras demencias', null, null, 'Puerto Rico', 'https://www.facebook.com/groups/apoyoafamiliaresdepacientesconalzheimerydemencias/about'),
    (-4, 'Funcación Reina Sofía', 'Funcación Reina Sofía', '+34 913 85 23 00', 'secretaria@fundacionreinasofia.es', 'Madrid, España', 'https://www.fundacionreinasofia.es/');
