CREATE DATABASE BibliotecaPublicacionesITM

USE BibliotecaPublicacionesITM


-- TABLAS BASE (CATÁLOGOS)

-- PAÍS
CREATE TABLE Pais(
	Id INT IDENTITY NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	CONSTRAINT pk_Pais_Id PRIMARY KEY(Id)
)

CREATE UNIQUE INDEX ix_Pais_Nombre
	ON Pais(Nombre)


-- CIUDAD
CREATE TABLE Ciudad(
	Id INT IDENTITY NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	IdPais INT NOT NULL,
	CONSTRAINT pk_Ciudad_Id PRIMARY KEY(Id),
	CONSTRAINT fk_Ciudad_IdPais FOREIGN KEY(IdPais) REFERENCES Pais(Id)
)

CREATE UNIQUE INDEX ix_Ciudad_Nombre
	ON Ciudad(IdPais, Nombre)


-- EDITORIAL
CREATE TABLE Editorial(
	Id INT IDENTITY NOT NULL,
	Nombre VARCHAR(150) NOT NULL,
	IdCiudad INT NOT NULL,
	CONSTRAINT pk_Editorial_Id PRIMARY KEY(Id),
	CONSTRAINT fk_Editorial_IdCiudad FOREIGN KEY(IdCiudad) REFERENCES Ciudad(Id)
)

CREATE UNIQUE INDEX ix_Editorial_Nombre
	ON Editorial(IdCiudad, Nombre)



-- NÚCLEO DE PUBLICACIONES

-- PUBLICACION (entidad padre)
CREATE TABLE Publicacion(
	Id INT IDENTITY NOT NULL,
	IdEditorial INT NOT NULL,
	FechaCreacion DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
	Activo BIT NOT NULL DEFAULT 1,
	CONSTRAINT pk_Publicacion_Id PRIMARY KEY(Id),
	CONSTRAINT fk_Publicacion_IdEditorial FOREIGN KEY(IdEditorial) REFERENCES Editorial(Id)
)

CREATE INDEX ix_Publicacion_Fecha
	ON Publicacion(FechaCreacion)



-- SUBTIPOS 1-1 (PK=FK)


CREATE TABLE Libro(
	IdPublicacion INT NOT NULL,
	Titulo VARCHAR(200) NOT NULL,
	Edicion VARCHAR(50) NULL,
	Volumen VARCHAR(50) NULL,
	ISBN VARCHAR(20) NULL,
	Paginas INT NULL,
	CONSTRAINT pk_Libro_IdPublicacion PRIMARY KEY(IdPublicacion),
	CONSTRAINT fk_Libro_IdPublicacion FOREIGN KEY(IdPublicacion) REFERENCES Publicacion(Id)
)

CREATE UNIQUE INDEX ix_Libro_ISBN
	ON Libro(ISBN)


CREATE TABLE Revista(
	IdPublicacion INT NOT NULL,
	Nombre VARCHAR(200) NOT NULL,
	Volumen VARCHAR(50) NULL,
	Numero VARCHAR(50) NULL,
	FechaEdicion DATE NULL,
	CONSTRAINT pk_Revista_IdPublicacion PRIMARY KEY(IdPublicacion),
	CONSTRAINT fk_Revista_IdPublicacion FOREIGN KEY(IdPublicacion) REFERENCES Publicacion(Id)
)
CREATE INDEX ix_Revista_FechaEdicion
    ON Revista(FechaEdicion);

CREATE UNIQUE INDEX ix_Revista_Nombre
    ON Revista(Nombre);


CREATE TABLE Periodico(
	IdPublicacion INT NOT NULL,
	Nombre VARCHAR(200) NOT NULL,
	FechaEdicion DATE NULL,
	NumeroEdicion VARCHAR(50) NULL,
	CONSTRAINT pk_Periodico_IdPublicacion PRIMARY KEY(IdPublicacion),
	CONSTRAINT fk_Periodico_IdPublicacion FOREIGN KEY(IdPublicacion) REFERENCES Publicacion(Id)
)
CREATE  INDEX ix_Periodico_FechaEdicion
    ON Periodico(FechaEdicion);

CREATE  INDEX ix_Periodico_Nombre
    ON Periodico(Nombre);


CREATE TABLE Tesis(
	IdPublicacion INT NOT NULL,
	Titulo VARCHAR(200) NOT NULL,
	Grado VARCHAR(100) NULL,
	Universidad VARCHAR(200) NULL,
	FechaDefensa DATE NULL,
	CONSTRAINT pk_Tesis_IdPublicacion PRIMARY KEY(IdPublicacion),
	CONSTRAINT fk_Tesis_IdPublicacion FOREIGN KEY(IdPublicacion) REFERENCES Publicacion(Id)
)
CREATE  INDEX ix_Tesis_FechaDefensa
    ON Tesis(FechaDefensa);

CREATE INDEX ix_Tesis_Universidad
    ON Tesis(Universidad);



-- AUTORES Y RELACIÓN M:N


CREATE TABLE Autor(
	Id INT IDENTITY NOT NULL,
	Nombre VARCHAR(150) NOT NULL,
	Apellido VARCHAR(150) NULL,
	Email VARCHAR(100) NULL,
	Biografia VARCHAR(MAX) NULL,
	Activo BIT NOT NULL DEFAULT 1,
	CONSTRAINT pk_Autor_Id PRIMARY KEY(Id)
)

CREATE UNIQUE INDEX ix_Autor_Email
	ON Autor(Email)


CREATE TABLE AutorPublicacion(
	IdAutor INT NOT NULL,
	IdPublicacion INT NOT NULL,
	OrdenAutor TINYINT NOT NULL DEFAULT 1,
	Rol VARCHAR(50) NOT NULL DEFAULT 'Autor',
	FechaAsignacion DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
	CONSTRAINT pk_AutorPublicacion PRIMARY KEY(IdAutor, IdPublicacion),
	CONSTRAINT fk_AutorPublicacion_IdAutor FOREIGN KEY(IdAutor) REFERENCES Autor(Id),
	CONSTRAINT fk_AutorPublicacion_IdPublicacion FOREIGN KEY(IdPublicacion) REFERENCES Publicacion(Id)
)

CREATE INDEX ix_AutorPublicacion_Orden
	ON AutorPublicacion(IdPublicacion, OrdenAutor)


-- DESCRIPTORES Y RELACIÓN M:N

CREATE TABLE Descriptor(
	Id INT IDENTITY NOT NULL,
	Descripcion VARCHAR(200) NOT NULL,
	Categoria VARCHAR(100) NULL,
	Activo BIT NOT NULL DEFAULT 1,
	CONSTRAINT pk_Descriptor_Id PRIMARY KEY(Id)
)

CREATE UNIQUE INDEX ix_Descriptor_Descripcion
	ON Descriptor(Descripcion)


CREATE TABLE PublicacionDescriptor(
	IdPublicacion INT NOT NULL,
	IdDescriptor INT NOT NULL,
	Relevancia TINYINT NOT NULL DEFAULT 5 CHECK(Relevancia BETWEEN 1 AND 10),
	FechaAsignacion DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
	CONSTRAINT pk_PublicacionDescriptor PRIMARY KEY(IdPublicacion, IdDescriptor),
	CONSTRAINT fk_PublicacionDescriptor_IdPublicacion FOREIGN KEY(IdPublicacion) REFERENCES Publicacion(Id),
	CONSTRAINT fk_PublicacionDescriptor_IdDescriptor FOREIGN KEY(IdDescriptor) REFERENCES Descriptor(Id)
)

CREATE INDEX ix_PublicacionDescriptor_Relevancia
	ON PublicacionDescriptor(IdDescriptor, Relevancia)

