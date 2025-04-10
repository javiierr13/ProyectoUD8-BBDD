drop database if exists atica;
create database atica;
use atica;

create table alumno (
    id_alumno int primary key auto_increment,
    nombre varchar(100),
    dni varchar(20),
    apellidos varchar(100),
    fecha_nac date
);

create table tutor_docente (
    id_docente int primary key auto_increment,
    nombre varchar(100),
    apellidos varchar(100),
    dni char(9),
    correo_electronico varchar(100)
);

create table seguimiento (
    id_seguimiento int primary key auto_increment,
    fecha date,
    anotaciones text,
    alumno int not null,
    tutor_docente int not null,
    constraint fk_seguimiento_alumno foreign key (alumno) references alumno(id_alumno),
    constraint fk_seguimiento_tutor foreign key (tutor_docente) references tutor_docente(id_docente)
);

create table empresa (
    id_empresa int primary key auto_increment,
    nif char(9),
    nombre varchar(100),
    ocupacion varchar(100)
);

create table sede (
    id_sede int primary key auto_increment,
    localizacion varchar(150),
    empresa int not null,
    constraint fk_sede_empresa foreign key (empresa) references empresa(id_empresa)
);

create table calendario (
    id_calendario int primary key auto_increment,
    fecha_inicio date,
    fecha_fin date,
    sede int not null unique,
    constraint fk_calendario_sede foreign key (sede) references sede(id_sede)
);

create table jornada (
    id_jornada int primary key auto_increment,
    dia_semana varchar(20),
    fecha date,
    hora_inicio time,
    hora_fin time,
    es_festivo boolean,
    calendario int not null,
    constraint fk_jornada_calendario foreign key (calendario) references calendario(id_calendario)
);

create table diario_alumno (
    id_diario int primary key auto_increment,
    descripcion text,
    alumno int not null,
    jornada int,
    constraint fk_diario_alumno foreign key (alumno) references alumno(id_alumno),
    constraint fk_diario_jornada foreign key (jornada) references jornada(id_jornada)
);

create table tutor_laboral (
    id_laboral int primary key auto_increment,
    nombre varchar(100),
    apellidos varchar(100),
    empresa int not null,
    constraint fk_tutor_laboral_empresa foreign key (empresa) references empresa(id_empresa)
);

create table proyecto (
    id_proyecto int primary key auto_increment,
    cod varchar(20),
    nombre varchar(100)
);

create table actividades_formativas (
    id_actividades int primary key auto_increment,
    nombre varchar(100),
    obligatoriedad boolean,
    proyecto int not null,
    constraint fk_actividad_proyecto foreign key (proyecto) references proyecto(id_proyecto)
);

create table concreciones (
    id_concreciones int primary key auto_increment,
    descripcion_actividad text,
    dificultad varchar(100),
    actividad int not null unique,
    constraint fk_concrecion_actividad foreign key (actividad) references actividades_formativas(id_actividades)
);


create table convenio (
    id_convenio int primary key auto_increment,
    nombre varchar(100),
    firma boolean,
    tutor_laboral int not null,
    tutor_docente int not null,
    proyecto int not null,
    constraint fk_convenio_tutor_laboral foreign key (tutor_laboral) references tutor_laboral(id_laboral),
    constraint fk_convenio_tutor_docente foreign key (tutor_docente) references tutor_docente(id_docente),
    constraint fk_convenio_proyecto foreign key (proyecto) references proyecto(id_proyecto)
);

create table practicas (
    id_practicas int primary key auto_increment,
    anio_curso int,
    convenio int not null,
    alumno int not null,
    calendario int not null,
    constraint fk_practicas_convenio foreign key (convenio) references convenio(id_convenio),
    constraint fk_practicas_alumno foreign key (alumno) references alumno(id_alumno),
    constraint fk_practicas_calendario foreign key (calendario) references calendario(id_calendario)
);

create table evaluacion (
    id_evaluacion int primary key auto_increment,
    observaciones_tutor_laboral text,
    nota double,
    firma_tutor boolean,
    firma_alumno boolean,
    actividad int not null,
    alumno int not null,
    tutor_laboral int not null,
    constraint fk_evaluacion_actividad foreign key (actividad) references actividades_formativas(id_actividades),
    constraint fk_evaluacion_alumno foreign key (alumno) references alumno(id_alumno),
    constraint fk_evaluacion_tutor_laboral foreign key (tutor_laboral) references tutor_laboral(id_laboral)
);