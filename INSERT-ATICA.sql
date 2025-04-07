use atica;

delimiter $$
drop procedure if exists rellenar_alumno$$
create procedure rellenar_alumno()
begin
declare inicio int default 0;
declare fecha_nacimiento date default '2000-01-01';
while inicio < 100 do
set fecha_nacimiento = date_add(fecha_nacimiento, interval 1 day);
	insert into alumno(nombre,dni,apellidos,fecha_nac) values(
    concat('alumno',inicio),
    concat(lpad(inicio,8,'0'),'A'),
    concat('apellido',inicio),
    fecha_nacimiento
    );
    set inicio = inicio +1;
    end while;
end$$

delimiter ;
call rellenar_alumno();

select * from alumno;