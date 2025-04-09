use atica;

-- inserción de alumnos, tutores docentes y seguimientos
delimiter $$
drop procedure if exists rellenar$$
create procedure rellenar()
begin
  declare inicio int default 0;
  declare fecha_nacimiento date default '2000-01-01';
  declare fecha_seguimiento date default '2025-01-01';

  while inicio < 20 do
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
('o56789444', 'minas del sur', 'mineria');
select count(*) from empresa;

insert into sede(localizacion, empresa) values 
('madrid', 1), 
('sevilla', 2),
('murcia', 3), 
('malaga', 4), 
('vigo', 5),
('bilbao', 6), 
('valladolid', 7),
('jaen', 8), 
('cuenca', 9),
('logroño', 10), 
('guadalajara', 11), 
('huelva', 12),
('ciudad real', 13), 
('burgos', 14),
('ceuta', 15);
select count(*) from sede;

-- calendario y jornadas
delimiter $$
drop procedure if exists rellenar_calendario$$
create procedure rellenar_calendario()
begin
  declare inicio int default 0;
  while inicio<15 do 
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
  while inicio <20 do 
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
  while inicio <15 do
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
  while inicio <5 do
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
    while i <= 5 do
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
  while inicio<20 do 
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

-- Convenio
insert into convenio (firma, tutor_laboral, tutor_docente, proyecto) values
(true, 1, 1, 1),
(true, 2, 2, 2),
(true, 3, 3, 3),
(true, 4, 4, 4),
(true, 5, 5, 5),
(true, 6, 6, 1),
(true, 7, 7, 2),
(true, 8, 8, 3),
(true, 9, 9, 4),
(true, 10, 10, 5),
(true, 11, 11, 1),
(true, 12, 12, 2),
(true, 13, 13, 3),
(true, 14, 14, 4),
(true, 15, 15, 5),
(true, 1, 16, 1),
(true, 2, 17, 2),
(true, 3, 18, 3),
(true, 4, 19, 4),
(true, 5, 20, 5);

select * from convenio;

-- Practicas 
delimiter $$
drop procedure if exists practicas$$
create procedure practicas()
begin 
declare inicio int default 0;
  while inicio<20 do 
    set inicio = inicio +1;
    insert into practicas (anio_curso,convenio,alumno,calendario) values(
	'2025',
    inicio,
    inicio,
    floor(RAND() * 15) + 1
    );
    end while;
end$$
delimiter ;
call practicas;
select * from practicas;


-- Evaluacion  
-- Evaluaciones de los 20 alumnos en las 4 actividades
-- Alumno 1
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Buen desarrollo de interfaces', 8.5, TRUE, TRUE, 1, 1, 1),  -- Juan Pérez en Desarrollo Frontend
('Excelente API RESTful', 9.0, TRUE, TRUE, 2, 1, 1),         -- Juan Pérez en Desarrollo Backend
('Buena operación de la máquina', 7.5, TRUE, TRUE, 3, 1, 1),  -- Juan Pérez en Mantenimiento de Máquinas
('Buena operación de la máquina', 7.5, TRUE, TRUE, 4, 1, 1),  -- Juan Pérez en Mantenimiento de Máquinas
('Correcta programación del robot', 8.0, TRUE, TRUE, 5, 1, 1); -- Juan Pérez en Programación de Robots

-- Alumno 2
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Buen desarrollo de interfaces', 7.8, TRUE, TRUE, 1, 2, 1),  -- Ana García en Desarrollo Frontend
('Buena API RESTful', 8.0, TRUE, TRUE, 2, 2, 1),             -- Ana García en Desarrollo Backend
('Buena operación de la máquina', 7.0, TRUE, TRUE, 3, 2, 1),  -- Ana García en Mantenimiento de Máquinas
('Programación eficiente del robot', 8.3, TRUE, TRUE, 4, 2, 1); -- Ana García en Programación de Robots

-- Alumno 3
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz simple pero funcional', 7.0, TRUE, TRUE, 1, 3, 1),  -- Mario Ruiz en Desarrollo Frontend
('Buena API RESTful', 8.0, TRUE, TRUE, 2, 3, 1),             -- Mario Ruiz en Desarrollo Backend
('Problemas con la máquina', 6.0, TRUE, TRUE, 3, 3, 1),       -- Mario Ruiz en Mantenimiento de Máquinas
('Correcta programación del robot', 7.5, TRUE, TRUE, 4, 3, 1); -- Mario Ruiz en Programación de Robots

-- Alumno 4
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Excelente interfaz de usuario', 9.0, TRUE, TRUE, 1, 4, 1),  -- Laura Gómez en Desarrollo Frontend
('Buen manejo de API RESTful', 8.5, TRUE, TRUE, 2, 4, 1),     -- Laura Gómez en Desarrollo Backend
('Mantenimiento adecuado de la máquina', 7.8, TRUE, TRUE, 3, 4, 1), -- Laura Gómez en Mantenimiento de Máquinas
('Excelente programación de robots', 9.5, TRUE, TRUE, 4, 4, 1); -- Laura Gómez en Programación de Robots

-- Alumno 5
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz muy atractiva', 8.3, TRUE, TRUE, 1, 5, 1),  -- Sergio Pérez en Desarrollo Frontend
('API RESTful bien diseñada', 8.8, TRUE, TRUE, 2, 5, 1), -- Sergio Pérez en Desarrollo Backend
('Mantenimiento de la máquina sin problemas', 7.0, TRUE, TRUE, 3, 5, 1), -- Sergio Pérez en Mantenimiento de Máquinas
('Programación del robot eficiente', 8.2, TRUE, TRUE, 4, 5, 1); -- Sergio Pérez en Programación de Robots

-- Alumno 6
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz funcional pero simple', 7.5, TRUE, TRUE, 1, 6, 1),  -- Marta López en Desarrollo Frontend
('API RESTful funcional', 7.9, TRUE, TRUE, 2, 6, 1),           -- Marta López en Desarrollo Backend
('Buen mantenimiento de la máquina', 8.0, TRUE, TRUE, 3, 6, 1),  -- Marta López en Mantenimiento de Máquinas
('Buen manejo en programación de robots', 8.3, TRUE, TRUE, 4, 6, 1); -- Marta López en Programación de Robots

-- Alumno 7
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz básica pero útil', 6.8, TRUE, TRUE, 1, 7, 1),  -- Javier Martínez en Desarrollo Frontend
('API RESTful buena pero mejorable', 7.5, TRUE, TRUE, 2, 7, 1), -- Javier Martínez en Desarrollo Backend
('Mantenimiento de la máquina adecuado', 7.2, TRUE, TRUE, 3, 7, 1), -- Javier Martínez en Mantenimiento de Máquinas
('Programación del robot correcta', 7.5, TRUE, TRUE, 4, 7, 1); -- Javier Martínez en Programación de Robots

-- Alumno 8
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Buen diseño de la interfaz', 8.1, TRUE, TRUE, 1, 8, 1),  -- Claudia Rodríguez en Desarrollo Frontend
('API RESTful eficiente', 8.4, TRUE, TRUE, 2, 8, 1),      -- Claudia Rodríguez en Desarrollo Backend
('Mantenimiento de la máquina sin inconvenientes', 7.5, TRUE, TRUE, 3, 8, 1), -- Claudia Rodríguez en Mantenimiento de Máquinas
('Robots programados correctamente', 8.0, TRUE, TRUE, 4, 8, 1); -- Claudia Rodríguez en Programación de Robots

-- Alumno 9
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz de usuario funcional', 7.5, TRUE, TRUE, 1, 9, 1),  -- Luis Torres en Desarrollo Frontend
('API RESTful bien implementada', 8.3, TRUE, TRUE, 2, 9, 1),  -- Luis Torres en Desarrollo Backend
('Mantenimiento de la máquina bien ejecutado', 7.2, TRUE, TRUE, 3, 9, 1), -- Luis Torres en Mantenimiento de Máquinas
('Excelente programación de robots', 8.7, TRUE, TRUE, 4, 9, 1); -- Luis Torres en Programación de Robots

-- Alumno 10
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz atractiva pero mejorable', 7.9, TRUE, TRUE, 1, 10, 1), -- Pedro Ruiz en Desarrollo Frontend
('API RESTful excelente', 9.2, TRUE, TRUE, 2, 10, 1),           -- Pedro Ruiz en Desarrollo Backend
('Mantenimiento de la máquina bien realizado', 7.6, TRUE, TRUE, 3, 10, 1), -- Pedro Ruiz en Mantenimiento de Máquinas
('Robots programados eficientemente', 8.5, TRUE, TRUE, 4, 10, 1); -- Pedro Ruiz en Programación de Robots

-- Continúa para los demás alumnos...


select * from evaluaciones;



