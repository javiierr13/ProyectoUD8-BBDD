use atica;

-- Meter alumnos, tutores_docentes y seguimientos
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

-- Meter empresas
insert into empresa(nif, nombre, ocupacion) values ('a12345678', 'tecnologias iberia', 'informatica');
insert into empresa(nif, nombre, ocupacion) values ('b23456789', 'construcciones lopez', 'construccion');
insert into empresa(nif, nombre, ocupacion) values ('c34567890', 'mercados garcía', 'comercio');
insert into empresa(nif, nombre, ocupacion) values ('d45678901', 'hosteleria sur', 'hosteleria');
insert into empresa(nif, nombre, ocupacion) values ('e56789012', 'formacion activa', 'educacion');
insert into empresa(nif, nombre, ocupacion) values ('f67890123', 'centro medico saludplus', 'sanidad');
insert into empresa(nif, nombre, ocupacion) values ('g78901234', 'banco del centro', 'banca');
insert into empresa(nif, nombre, ocupacion) values ('h89012345', 'seguros unidos', 'seguros');
insert into empresa(nif, nombre, ocupacion) values ('i90123456', 'logistica norte', 'logistica');
insert into empresa(nif, nombre, ocupacion) values ('j01234567', 'campo y vida', 'agricultura');
insert into empresa(nif, nombre, ocupacion) values ('k12345000', 'ganados herrera', 'ganaderia');
insert into empresa(nif, nombre, ocupacion) values ('l23456111', 'industrias manzano', 'industria');
insert into empresa(nif, nombre, ocupacion) values ('m34567222', 'moda urbana', 'moda');
insert into empresa(nif, nombre, ocupacion) values ('n45678333', 'viajes horizonte', 'turismo');
insert into empresa(nif, nombre, ocupacion) values ('o56789444', 'minas del sur', 'mineria');
insert into empresa(nif, nombre, ocupacion) values ('p67890555', 'quimicos rivadavia', 'quimica');
insert into empresa(nif, nombre, ocupacion) values ('q78901666', 'energia solar iberica', 'energia');
insert into empresa(nif, nombre, ocupacion) values ('r89012777', 'motor iberia', 'automocion');
insert into empresa(nif, nombre, ocupacion) values ('s90123888', 'servilim limpieza', 'limpieza');
insert into empresa(nif, nombre, ocupacion) values ('t01234999', 'transporte rápido s.l.', 'transporte');
insert into empresa(nif, nombre, ocupacion) values ('u12345111', 'telecomunicaciones nova', 'comunicaciones');
insert into empresa(nif, nombre, ocupacion) values ('v23456222', 'asesores del sur', 'asesoria');
insert into empresa(nif, nombre, ocupacion) values ('w34567333', 'consultores globales', 'consultoria');
insert into empresa(nif, nombre, ocupacion) values ('x45678444', 'estudio creativo luna', 'diseño');
insert into empresa(nif, nombre, ocupacion) values ('y56789555', 'marketing digital plus', 'marketing');

select * from empresa;

-- Meter sedes
insert into sede(localizacion, empresa) values ('madrid', 1);
insert into sede(localizacion, empresa) values ('barcelona', 1);

insert into sede(localizacion, empresa) values ('sevilla', 2);
insert into sede(localizacion, empresa) values ('valencia', 2);

insert into sede(localizacion, empresa) values ('zaragoza', 3);
insert into sede(localizacion, empresa) values ('murcia', 3);

insert into sede(localizacion, empresa) values ('malaga', 4);
insert into sede(localizacion, empresa) values ('alicante', 4);

insert into sede(localizacion, empresa) values ('vigo', 5);
insert into sede(localizacion, empresa) values ('oviedo', 5);

insert into sede(localizacion, empresa) values ('bilbao', 6);
insert into sede(localizacion, empresa) values ('santander', 6);

insert into sede(localizacion, empresa) values ('valladolid', 7);
insert into sede(localizacion, empresa) values ('leon', 7);

insert into sede(localizacion, empresa) values ('granada', 8);
insert into sede(localizacion, empresa) values ('jaen', 8);

insert into sede(localizacion, empresa) values ('albacete', 9);
insert into sede(localizacion, empresa) values ('cuenca', 9);

insert into sede(localizacion, empresa) values ('logroño', 10);
insert into sede(localizacion, empresa) values ('pamplona', 10);

insert into sede(localizacion, empresa) values ('guadalajara', 11);
insert into sede(localizacion, empresa) values ('toledo', 11);

insert into sede(localizacion, empresa) values ('huelva', 12);
insert into sede(localizacion, empresa) values ('cadiz', 12);

insert into sede(localizacion, empresa) values ('ciudad real', 13);
insert into sede(localizacion, empresa) values ('teruel', 13);

insert into sede(localizacion, empresa) values ('burgos', 14);
insert into sede(localizacion, empresa) values ('soria', 14);

insert into sede(localizacion, empresa) values ('ceuta', 15);
insert into sede(localizacion, empresa) values ('melilla', 15);

insert into sede(localizacion, empresa) values ('gijon', 16);
insert into sede(localizacion, empresa) values ('aviles', 16);

insert into sede(localizacion, empresa) values ('san sebastian', 17);
insert into sede(localizacion, empresa) values ('vitoria', 17);

insert into sede(localizacion, empresa) values ('lleida', 18);
insert into sede(localizacion, empresa) values ('tarragona', 18);

insert into sede(localizacion, empresa) values ('palma', 19);
insert into sede(localizacion, empresa) values ('ibiza', 19);

insert into sede(localizacion, empresa) values ('reus', 20);
insert into sede(localizacion, empresa) values ('sabadell', 20);

insert into sede(localizacion, empresa) values ('elche', 21);
insert into sede(localizacion, empresa) values ('castellon', 21);

insert into sede(localizacion, empresa) values ('ourense', 22);
insert into sede(localizacion, empresa) values ('lugo', 22);

insert into sede(localizacion, empresa) values ('caceres', 23);
insert into sede(localizacion, empresa) values ('badajoz', 23);

insert into sede(localizacion, empresa) values ('arrecife', 24);
insert into sede(localizacion, empresa) values ('santa cruz de tenerife', 24);

insert into sede(localizacion, empresa) values ('cordoba', 25);
insert into sede(localizacion, empresa) values ('almeria', 25);

select * from sede;

-- Meter calendarios
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

-- Meter jornada 
DELIMITER $$

DROP PROCEDURE IF EXISTS rellenar_jornada$$
CREATE PROCEDURE rellenar_jornada()
BEGIN 

	-- Declaramos el cursor para recorrer tabla calendarios
	declare c_fecha_inicio date;
    declare c_fecha_fin date;
    declare c_id int;
    declare fin int default 0;
    declare calendarios cursor for select fecha_inicio, fecha_fin, id_calendario from calendario;
    declare continue handler for not found set fin = 1;
    
    open calendarios;
    
    bucle_cal: LOOP
    
		fetch calendarios into c_fecha_inicio, c_fecha_fin, c_id;
        
        while c_fecha_inicio <= c_fecha_fin DO
			if dayofweek(c_fecha_inicio) IN (2,3,4,5,6) then
				insert into jornada 
					(dia_semana, fecha, hora_inicio, hora_fin,es_festivo, calendario)
				values ( dia_semana(dayofweek(c_fecha_inicio)), c_fecha_inicio, '08:00', '22:00',false, c_id);
			end if;
            SET c_fecha_inicio = DATE_ADD(c_fecha_inicio, INTERVAL 1 DAY);
		end while;
    
		if fin = 1 then
			leave bucle_cal;
		end if;
    END LOOP;
	
    close calendarios;
    
END$$

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

-- Meter diario alumno 
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

-- Meter tutor laboral
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

-- Meter proyecto
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

-- Meter actividades formativas
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

        if fin = 1 then 
            leave bucle_proyectos;
        end if;
        
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

-- 

