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
insert into convenio (nombre,firma, tutor_laboral, tutor_docente, proyecto) values
('conevnio1',true, 1, 1, 1),
('conevnio2',true, 2, 2, 2),
('conevnio3',true, 3, 3, 3),
('conevnio4',true, 4, 4, 4),
('conevnio5',true, 5, 5, 5),
('conevnio6',true, 6, 6, 1),
('conevnio7',true, 7, 7, 2),
('conevnio8',true, 8, 8, 3),
('conevnio9',true, 9, 9, 4),
('conevnio10',true, 10, 10, 5),
('conevnio11',true, 11, 11, 1),
('conevnio12',true, 12, 12, 2),
('conevnio13',true, 13, 13, 3),
('conevnio14',true, 14, 14, 4),
('conevnio15',true, 15, 15, 5),
('conevnio16',true, 1, 16, 1),
('conevnio17',true, 2, 17, 2),
('conevnio18',true, 3, 18, 3),
('conevnio19',true, 4, 19, 4),
('conevnio20',true, 5, 20, 5);

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
insert into practicas (anio_curso,convenio,alumno,calendario) values(
	'2025', 1, 2, floor(RAND() * 15) + 1);
insert into practicas (anio_curso,convenio,alumno,calendario) values(
	'2025', 1, 3, floor(RAND() * 15) + 1);
-- Evaluacion  
-- Evaluaciones de los 20 alumnos en las 4 actividades
-- Alumno 1
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Buen desarrollo de interfaces', 8.5, TRUE, TRUE, 1, 1, 1),  
('Excelente API RESTful', 9.0, TRUE, TRUE, 2, 1, 1),         
('Buena operación de la máquina', 7.5, TRUE, TRUE, 3, 1, 1),  
('Buena operación de la máquina', 7.5, TRUE, TRUE, 4, 1, 1),  
('Correcta programación del robot', 8.0, TRUE, TRUE, 5, 1, 1); 

-- Alumno 2
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Buen desarrollo de interfaces', 7.8, TRUE, TRUE, 6, 2, 2),  
('Buena API RESTful', 8.0, TRUE, TRUE, 7, 2, 2),             
('Buena operación de la máquina', 7.0, TRUE, TRUE, 8, 2, 2), 
('Buena operación de la máquina', 7.0, TRUE, TRUE, 9, 2, 2),  
('Programación eficiente del robot', 8.3, TRUE, TRUE, 10, 2, 2); 

-- Alumno 3
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz simple pero funcional', 7.0, TRUE, TRUE, 11, 3, 3), 
('Buena API RESTful', 8.0, TRUE, TRUE, 12, 3, 1),            
('Problemas con la máquina', 6.0, TRUE, TRUE, 13, 3, 3), 
('Problemas con la máquina', 6.0, TRUE, TRUE, 14, 3, 3),      
('Correcta programación del robot', 7.5, TRUE, TRUE, 15, 3, 3); 

-- Alumno 4
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Excelente interfaz de usuario', 9.0, TRUE, TRUE, 16, 4, 4),
('Buen manejo de API RESTful', 8.5, TRUE, TRUE, 17, 4, 4),     
('Mantenimiento adecuado de la máquina', 7.8, TRUE, TRUE, 18, 4, 4),
('Mantenimiento adecuado de la máquina', 7.8, TRUE, TRUE, 19, 4, 4), 
('Excelente programación de robots', 9.5, TRUE, TRUE, 20, 4, 4); 

-- Alumno 5
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz muy atractiva', 8.3, TRUE, TRUE, 21, 5, 5), 
('API RESTful bien diseñada', 8.8, TRUE, TRUE, 22, 5, 5), 
('Mantenimiento de la máquina sin problemas', 7.0, TRUE, TRUE, 23, 5, 5),
('Mantenimiento de la máquina sin problemas', 7.0, TRUE, TRUE, 24, 5, 5), 
('Programación del robot eficiente', 8.2, TRUE, TRUE, 25, 5, 5); 

-- Alumno 6
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Buen desarrollo de interfaces', 8.5, TRUE, TRUE, 1, 6, 6),  
('Excelente API RESTful', 9.0, TRUE, TRUE, 2, 6, 6),         
('Buena operación de la máquina', 7.5, TRUE, TRUE, 3, 6, 6),  
('Buena operación de la máquina', 7.5, TRUE, TRUE, 4, 6, 6),  
('Correcta programación del robot', 8.0, TRUE, TRUE, 5, 6, 6); 

-- Alumno 7
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Buen desarrollo de interfaces', 7.8, TRUE, TRUE, 6, 7, 7),  
('Buena API RESTful', 8.0, TRUE, TRUE, 7, 7, 7),             
('Buena operación de la máquina', 7.0, TRUE, TRUE, 8, 7, 7), 
('Buena operación de la máquina', 7.0, TRUE, TRUE, 9, 7, 7),  
('Programación eficiente del robot', 8.3, TRUE, TRUE, 10, 7, 7); 

-- Alumno 8
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz simple pero funcional', 7.0, TRUE, TRUE, 11, 8, 8), 
('Buena API RESTful', 8.0, TRUE, TRUE, 12, 8,8),            
('Problemas con la máquina', 6.0, TRUE, TRUE, 13, 8, 8), 
('Problemas con la máquina', 6.0, TRUE, TRUE, 14, 8, 8),      
('Correcta programación del robot', 7.5, TRUE, TRUE, 15, 8, 8); 

-- Alumno 9
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Excelente interfaz de usuario', 9.0, TRUE, TRUE, 16, 9, 9),
('Buen manejo de API RESTful', 8.5, TRUE, TRUE, 17, 9, 1),     
('Mantenimiento adecuado de la máquina', 7.8, TRUE, TRUE, 18, 9, 9),
('Mantenimiento adecuado de la máquina', 7.8, TRUE, TRUE, 19, 9, 9), 
('Excelente programación de robots', 9.5, TRUE, TRUE, 20, 9, 9); 

-- Alumno 10
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz muy atractiva', 8.3, TRUE, TRUE, 21, 10, 10), 
('API RESTful bien diseñada', 8.8, TRUE, TRUE, 22, 10, 1), 
('Mantenimiento de la máquina sin problemas', 7.0, TRUE, TRUE, 23, 10, 10),
('Mantenimiento de la máquina sin problemas', 7.0, TRUE, TRUE, 24, 10, 10), 
('Programación del robot eficiente', 8.2, TRUE, TRUE, 25, 10, 10); 

-- Alumno 11
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Buen desarrollo de interfaces', 8.5, TRUE, TRUE, 1, 11, 11),  
('Excelente API RESTful', 9.0, TRUE, TRUE, 2, 11, 11),         
('Buena operación de la máquina', 7.5, TRUE, TRUE, 3, 11, 11),  
('Buena operación de la máquina', 7.5, TRUE, TRUE, 4, 11, 11),  
('Correcta programación del robot', 8.0, TRUE, TRUE, 5, 11, 11); 

-- Alumno 12
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Buen desarrollo de interfaces', 7.8, TRUE, TRUE, 6, 12, 12),  
('Buena API RESTful', 8.0, TRUE, TRUE, 7, 12, 12),             
('Buena operación de la máquina', 7.0, TRUE, TRUE, 8, 12, 12), 
('Buena operación de la máquina', 7.0, TRUE, TRUE, 9, 12, 12),  
('Programación eficiente del robot', 8.3, TRUE, TRUE, 10, 12, 12); 

-- Alumno 13
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz simple pero funcional', 7.0, TRUE, TRUE, 11, 13, 13), 
('Buena API RESTful', 8.0, TRUE, TRUE, 12, 13, 13),            
('Problemas con la máquina', 6.0, TRUE, TRUE, 13, 13, 13), 
('Problemas con la máquina', 6.0, TRUE, TRUE, 14, 13, 13),      
('Correcta programación del robot', 7.5, TRUE, TRUE, 15, 13, 13); 

-- Alumno 14
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Excelente interfaz de usuario', 9.0, TRUE, TRUE, 16, 14, 14),
('Buen manejo de API RESTful', 8.5, TRUE, TRUE, 17, 14, 14),     
('Mantenimiento adecuado de la máquina', 7.8, TRUE, TRUE, 18, 14, 14),
('Mantenimiento adecuado de la máquina', 7.8, TRUE, TRUE, 19, 14, 14), 
('Excelente programación de robots', 9.5, TRUE, TRUE, 20, 14, 14); 

-- Alumno 15
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz muy atractiva', 8.3, TRUE, TRUE, 21, 15, 15), 
('API RESTful bien diseñada', 8.8, TRUE, TRUE, 22, 15, 1), 
('Mantenimiento de la máquina sin problemas', 7.0, TRUE, TRUE, 23, 15, 15),
('Mantenimiento de la máquina sin problemas', 7.0, TRUE, TRUE, 24, 15, 15), 
('Programación del robot eficiente', 8.2, TRUE, TRUE, 25, 15, 15); 

-- Alumno 16
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Buen desarrollo de interfaces', 8.5, TRUE, TRUE, 1, 16, 1),  
('Excelente API RESTful', 9.0, TRUE, TRUE, 2, 16, 1),         
('Buena operación de la máquina', 7.5, TRUE, TRUE, 3, 16, 1),  
('Buena operación de la máquina', 7.5, TRUE, TRUE, 4, 16, 1),  
('Correcta programación del robot', 8.0, TRUE, TRUE, 5, 16, 1); 

-- Alumno 17
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Buen desarrollo de interfaces', 7.8, TRUE, TRUE, 6, 17, 2),  
('Buena API RESTful', 8.0, TRUE, TRUE, 7, 17, 2),             
('Buena operación de la máquina', 7.0, TRUE, TRUE, 8, 17, 2), 
('Buena operación de la máquina', 7.0, TRUE, TRUE, 9, 17, 2),  
('Programación eficiente del robot', 8.3, TRUE, TRUE, 10, 17, 2); 

-- Alumno 18
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz simple pero funcional', 7.0, TRUE, TRUE, 11, 18, 3), 
('Buena API RESTful', 8.0, TRUE, TRUE, 12, 18, 3),            
('Problemas con la máquina', 6.0, TRUE, TRUE, 13, 18, 3), 
('Problemas con la máquina', 6.0, TRUE, TRUE, 14, 18, 3),      
('Correcta programación del robot', 7.5, TRUE, TRUE, 15, 18, 3); 

-- Alumno 19
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Excelente interfaz de usuario', 9.0, TRUE, TRUE, 16, 19, 4),
('Buen manejo de API RESTful', 8.5, TRUE, TRUE, 17, 19, 4),     
('Mantenimiento adecuado de la máquina', 7.8, TRUE, TRUE, 18, 19, 4),
('Mantenimiento adecuado de la máquina', 7.8, TRUE, TRUE, 19, 19, 4), 
('Excelente programación de robots', 9.5, TRUE, TRUE, 20, 19, 4); 

-- Alumno 20
INSERT INTO evaluacion (observaciones_tutor_laboral, nota, firma_tutor, firma_alumno, actividad, alumno, tutor_laboral) 
VALUES 
('Interfaz muy atractiva', 8.3, TRUE, TRUE, 21, 20, 5), 
('API RESTful bien diseñada', 8.8, TRUE, TRUE, 22, 20, 5), 
('Mantenimiento de la máquina sin problemas', 7.0, TRUE, TRUE, 23, 20, 5),
('Mantenimiento de la máquina sin problemas', 7.0, TRUE, TRUE, 24, 20, 5), 
('Programación del robot eficiente', 8.2, TRUE, TRUE, 25, 20, 5); 

select * from evaluacion;


