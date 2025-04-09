use atica;

-- inserción de alumnos, tutores docentes y seguimientos
delimiter $$
drop procedure if exists rellenar$$
create procedure rellenar()
begin
  declare inicio int default 0;
  declare fecha_nacimiento date default '2000-01-01';
  declare fecha_seguimiento date default '2025-01-01';

  while inicio < 30 do
    set inicio = inicio +1;
    set fecha_nacimiento = date_add(fecha_nacimiento, interval 1 day);
    set fecha_seguimiento = date_add(fecha_seguimiento, interval 1 month);

    insert into alumno(nombre,dni,apellidos,fecha_nac) values(
      concat('alumno',inicio),
      concat(lpad(inicio,8,'0'),'A'),
      concat('apellido',inicio),
      fecha_nacimiento
    );
    
    insert into tutor_docente(nombre,apellidos,dni,correo_electronico) values(
      concat('tutor_docente',inicio),
      concat('apellido',inicio),
      concat(lpad(inicio,8,'0'),'B'),
      concat('tutor_docente',inicio,'@gmail.com')
    );

    insert into seguimiento(fecha,anotaciones,alumno,tutor_docente) values(
      fecha_seguimiento,
      concat('Anotacion',inicio),
      inicio,
      inicio
    );
  end while;
end$$
delimiter ;
call rellenar();
select * from alumno;
select * from tutor_docente;
select * from seguimiento;

-- empresas y sedes
insert into empresa(nif, nombre, ocupacion) values 
('a12345678', 'tecnologias iberia', 'informatica'),
('b23456789', 'construcciones lopez', 'construccion'),
('c34567890', 'mercados garcía', 'comercio'),
('d45678901', 'hosteleria sur', 'hosteleria'),
('e56789012', 'formacion activa', 'educacion'),
('f67890123', 'centro medico saludplus', 'sanidad'),
('g78901234', 'banco del centro', 'banca'),
('h89012345', 'seguros unidos', 'seguros'),
('i90123456', 'logistica norte', 'logistica'),
('j01234567', 'campo y vida', 'agricultura'),
('k12345000', 'ganados herrera', 'ganaderia'),
('l23456111', 'industrias manzano', 'industria'),
('m34567222', 'moda urbana', 'moda'),
('n45678333', 'viajes horizonte', 'turismo'),
('o56789444', 'minas del sur', 'mineria'),
('p67890555', 'quimicos rivadavia', 'quimica'),
('q78901666', 'energia solar iberica', 'energia'),
('r89012777', 'motor iberia', 'automocion'),
('s90123888', 'servilim limpieza', 'limpieza'),
('t01234999', 'transporte rápido s.l.', 'transporte'),
('u12345111', 'telecomunicaciones nova', 'comunicaciones'),
('v23456222', 'asesores del sur', 'asesoria'),
('w34567333', 'consultores globales', 'consultoria'),
('x45678444', 'estudio creativo luna', 'diseño'),
('y56789555', 'marketing digital plus', 'marketing');
select * from empresa;

insert into sede(localizacion, empresa) values 
('madrid', 1), ('barcelona', 1), ('sevilla', 2), ('valencia', 2), ('zaragoza', 3),
('murcia', 3), ('malaga', 4), ('alicante', 4), ('vigo', 5), ('oviedo', 5),
('bilbao', 6), ('santander', 6), ('valladolid', 7), ('leon', 7), ('granada', 8),
('jaen', 8), ('albacete', 9), ('cuenca', 9), ('logroño', 10), ('pamplona', 10),
('guadalajara', 11), ('toledo', 11), ('huelva', 12), ('cadiz', 12),
('ciudad real', 13), ('teruel', 13), ('burgos', 14), ('soria', 14),
('ceuta', 15), ('melilla', 15), ('gijon', 16), ('aviles', 16),
('san sebastian', 17), ('vitoria', 17), ('lleida', 18), ('tarragona', 18),
('palma', 19), ('ibiza', 19), ('reus', 20), ('sabadell', 20),
('elche', 21), ('castellon', 21), ('ourense', 22), ('lugo', 22),
('caceres', 23), ('badajoz', 23), ('arrecife', 24), ('santa cruz de tenerife', 24),
('cordoba', 25), ('almeria', 25);
select * from sede;

-- calendario y jornadas
delimiter $$
drop procedure if exists rellenar_calendario$$
create procedure rellenar_calendario()
begin
  declare inicio int default 0;
  while inicio<50 do 
    set inicio = inicio +1;
    insert into calendario(fecha_inicio,fecha_fin,sede) values(
      '2025-04-21','2025-05-30',inicio
    );
  end while;
end$$
delimiter ;
call rellenar_calendario;
select * from calendario;

DELIMITER $$
drop procedure if exists rellenar_jornada$$
create procedure rellenar_jornada()
begin 
  declare c_fecha_inicio date;
  declare c_fecha_fin date;
  declare c_id int;
  declare fin int default 0;
  declare calendarios cursor for select fecha_inicio, fecha_fin, id_calendario from calendario;
  declare continue handler for not found set fin = 1;

  open calendarios;
  bucle_cal: loop
    fetch calendarios into c_fecha_inicio, c_fecha_fin, c_id;
    while c_fecha_inicio <= c_fecha_fin do
      if dayofweek(c_fecha_inicio) IN (2,3,4,5,6) then
        insert into jornada (dia_semana, fecha, hora_inicio, hora_fin,es_festivo, calendario)
        values ( dia_semana(dayofweek(c_fecha_inicio)), c_fecha_inicio, '08:00', '22:00',false, c_id);
      end if;
      set c_fecha_inicio = date_add(c_fecha_inicio, interval 1 day);
    end while;
    if fin = 1 then
      leave bucle_cal;
    end if;
  end loop;
  close calendarios;
end$$

drop function if exists dia_semana$$
create function dia_semana(num_dia int) returns varchar(25) deterministic
begin
  declare result varchar(25);
  set result = case(num_dia)
    when 1 then 'Domingo'
    when 2 then 'Lunes'
    when 3 then 'Martes'
    when 4 then 'Miercoles'
    when 5 then 'Jueves'
    when 6 then 'Viernes'
    when 7 then 'Sabado'
  end;
  return result;
end$$
delimiter ;
call rellenar_jornada;
select * from jornada;

-- diario alumno
delimiter $$
drop procedure if exists diario_alumno$$
create procedure diario_alumno()
begin
  declare inicio int default 0;
  while inicio <25 do 
    set inicio = inicio +1;
    insert into diario_alumno(descripcion, alumno, jornada) values(
      concat('descripcion',inicio),
      inicio,
      400
    );
  end while;
end$$
delimiter ;
call diario_alumno;
select * from diario_alumno;

-- tutor laboral
delimiter $$
drop procedure if exists tutor_laboral$$
create procedure tutor_laboral()
begin
  declare inicio int default 0;
  while inicio <25 do
    set inicio = inicio +1;
    insert into tutor_laboral(nombre, apellidos, empresa) values(
      concat('tutor_laboral',inicio),
      concat('apellido',inicio),
      inicio
    );
  end while;
end$$
delimiter ;
call tutor_laboral;
select * from tutor_laboral;

-- proyectos y actividades
delimiter $$
drop procedure if exists proyectos$$
create procedure proyectos()
begin
  declare inicio int default 0;
  while inicio <25 do
    set inicio = inicio +1;
    insert into proyecto(cod, nombre) values (
      concat(lpad(inicio,6,'0'),'P'),
      concat('proyecto',inicio)
    );
  end while;
end$$
delimiter ;
call proyectos;
select * from proyecto;

delimiter $$
drop procedure if exists rellenar_actividades$$
create procedure rellenar_actividades()
begin
  declare c_id int;
  declare fin int default 0;
  declare i int;
  declare cur_proyectos cursor for select id_proyecto from proyecto;
  declare continue handler for not found set fin = 1;

  open cur_proyectos;
  bucle_proyectos: loop
    fetch cur_proyectos into c_id;
    if fin = 1 then leave bucle_proyectos; end if;
    set i = 1;
    while i <= 10 do
      insert into actividades_formativas (nombre, obligatoriedad, proyecto)
      values (
        concat('actividad ', i, ' del proyecto ', c_id),
        true,
        c_id
      );
      set i = i + 1;
    end while;
  end loop;
  close cur_proyectos;
end$$
delimiter ;
call rellenar_actividades;
select * from actividades_formativas;

-- concreciones
delimiter $$
drop procedure if exists concreciones$$
create procedure concreciones()
begin
  declare inicio int default 0;
  while inicio<50 do 
    set inicio = inicio +1;
    insert into concreciones(descripcion_actividad,dificultad,actividad) values(
      concat('desscripcion',inicio),
      'media',
      inicio
    );
  end while;
end$$
delimiter ;
call concreciones;
select * from concreciones;
