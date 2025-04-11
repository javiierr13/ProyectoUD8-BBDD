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

select convenio.nombre, alumno.nombre, tutor_docente.nombre, tutor_laboral.nombre, calendario.fecha_inicio, calendario.fecha_fin, if(convenio.firma=1,'si','no') as esta_firmado 
from convenio 
	join  tutor_laboral on tutor_laboral.id_laboral=convenio.tutor_laboral
    join tutor_docente on tutor_docente.id_docente=convenio.tutor_docente
    join practicas on practicas.convenio=convenio.id_convenio
    join alumno on alumno.id_alumno=practicas.alumno
    join calendario on calendario.id_calendario=practicas.calendario;

-- Muestra para cada alumno su nombre y sus observaciones de seguimiento
select alumno.nombre, evaluacion.observaciones_tutor_laboral from alumno 
	join evaluacion on alumno.id_alumno=evaluacion.alumno;

-- Muestra la nota media de cada actividad formativa de los alumnos del curso 24/25 que han realizado sus prácticas en Sedes de Sevilla.
select af.nombre as actividad_formativa, avg(e.nota) as nota_media
from evaluacion e
    join actividades_formativas af on e.actividad = af.id_actividades
    join alumno a on e.alumno = a.id_alumno
    join practicas p on p.alumno = a.id_alumno
    join calendario c on p.calendario = c.id_calendario
    join sede s on s.id_sede = c.sede
where p.anio_curso = '24/25'
  and s.localizacion like '%sevilla%'
group by af.nombre;
-- revisar

-- Cuenta el número de concreciones por cada actividad formativa que existe en el sistema
select af.nombre as actividad_formativa, count(c.id_concreciones) as num_concreciones
from actividades_formativas af
	left join concreciones c on af.id_actividades = c.actividad
group by af.nombre;

-- Muestra el listado de alumnos que no tienen convenio de colaboración.
select a.id_alumno, a.nombre, a.apellidos
from alumno a
	left join practicas p on a.id_alumno = p.alumno
where p.id_practicas is null;
-- revisar

-- Muestra para los convenios firmados el número de alumnos que tienen asociados.
select c.id_convenio, c.nombre, count(p.alumno) as num_alumnos
from convenio c
	join practicas p on c.id_convenio = p.convenio
where c.firma = true
group by c.id_convenio, c.nombre;

-- Muestra la información de los calendarios del convenio 1.
select cal.*
from practicas p
	join calendario cal on p.calendario = cal.id_calendario
where p.convenio = 1;
