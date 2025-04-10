use atica;
-- Muestra el nombre del tutor laboral con mayor número de observaciones puestas.
-- Debe aparecer también el número de observaciones
select * from evaluacion;
select t.nombre, count(e.observaciones_tutor_laboral)as observaciones 
from tutor_laboral t
join evaluacion e on t.id_laboral=e.tutor_laboral
group by t.nombre
order by t.nombre asc limit 1;

-- Cuenta el número de convenios que tienen más de dos alumnos asociados
select convenio, count(*) as alumnos_asociados
from practicas
group by convenio
having count(alumno) > 2;

-- Muestra el número de alumnos asociados a cada empresa
select empresa.nombre, count(id_practicas)as numero_alumnos from practicas
join convenio on convenio.id_convenio=practicas.convenio
join tutor_laboral on tutor_laboral.id_laboral=convenio.tutor_laboral
join empresa on empresa.id_empresa=tutor_laboral.empresa
group by empresa.nombre;

-- Muestra la información completa de los convenios: Nombre del convenio, nombre 
-- del alumno, nombre de los tutores laborales y docentes, fecha de inicio y fin y si está 
-- o no firmado.
