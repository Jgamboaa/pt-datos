IF DB_ID(N'BibliotecaDB') IS NULL CREATE DATABASE BibliotecaDB;
GO

USE BibliotecaDB;
GO

DROP TABLE IF EXISTS dbo.DetallePrestamos;
DROP TABLE IF EXISTS dbo.Prestamos;
DROP TABLE IF EXISTS dbo.Estudiantes;
DROP TABLE IF EXISTS dbo.Ejemplares;
DROP TABLE IF EXISTS dbo.LibroAutores;
DROP TABLE IF EXISTS dbo.Libros;
DROP TABLE IF EXISTS dbo.Autores;
DROP TABLE IF EXISTS dbo.Carreras;
DROP TABLE IF EXISTS dbo.Categorias;
GO

CREATE TABLE dbo.Categorias (
    Id     INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Categorias PRIMARY KEY,
    Nombre NVARCHAR(100)     NOT NULL CONSTRAINT UQ_Categorias_Nombre UNIQUE,
    CONSTRAINT CK_Categorias_Nombre CHECK (LEN(TRIM(Nombre)) > 0)
);

CREATE TABLE dbo.Carreras (
    Id     INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Carreras PRIMARY KEY,
    Nombre NVARCHAR(150)     NOT NULL CONSTRAINT UQ_Carreras_Nombre UNIQUE,
    CONSTRAINT CK_Carreras_Nombre CHECK (LEN(TRIM(Nombre)) > 0)
);

CREATE TABLE dbo.Autores (
    CodigoAutor VARCHAR(10)   NOT NULL CONSTRAINT PK_Autores PRIMARY KEY,
    Nombre      NVARCHAR(150) NOT NULL,
    CONSTRAINT CK_Autores_Nombre CHECK (LEN(TRIM(Nombre)) > 0)
);

CREATE TABLE dbo.Libros (
    CodigoLibro     VARCHAR(20)   NOT NULL CONSTRAINT PK_Libros PRIMARY KEY,
    Titulo          NVARCHAR(250) NOT NULL,
    AnioPublicacion SMALLINT      NOT NULL,
    CategoriaId     INT           NOT NULL CONSTRAINT FK_Libros_Categorias REFERENCES dbo.Categorias(Id),
    CONSTRAINT CK_Libros_Titulo CHECK (LEN(TRIM(Titulo)) > 0),
    CONSTRAINT CK_Libros_AnioPublicacion CHECK (AnioPublicacion BETWEEN 1000 AND 9999)
);

CREATE INDEX IX_Libros_CategoriaId ON dbo.Libros(CategoriaId);

CREATE TABLE dbo.LibroAutores (
    CodigoLibro VARCHAR(20) NOT NULL CONSTRAINT FK_LibroAutores_Libros REFERENCES dbo.Libros(CodigoLibro),
    CodigoAutor VARCHAR(10) NOT NULL CONSTRAINT FK_LibroAutores_Autores REFERENCES dbo.Autores(CodigoAutor),
    CONSTRAINT PK_LibroAutores PRIMARY KEY (CodigoLibro, CodigoAutor)
);

CREATE INDEX IX_LibroAutores_CodigoAutor ON dbo.LibroAutores(CodigoAutor);

CREATE TABLE dbo.Ejemplares (
    CodigoEjemplar VARCHAR(20)  NOT NULL CONSTRAINT PK_Ejemplares PRIMARY KEY,
    CodigoLibro    VARCHAR(20)  NOT NULL CONSTRAINT FK_Ejemplares_Libros REFERENCES dbo.Libros(CodigoLibro),
    Estado         NVARCHAR(15) NOT NULL CONSTRAINT DF_Ejemplares_Estado DEFAULT N'Disponible',
    CONSTRAINT CK_Ejemplares_Estado CHECK (Estado IN (N'Disponible', N'Prestado', N'Dañado'))
);

CREATE INDEX IX_Ejemplares_CodigoLibro ON dbo.Ejemplares(CodigoLibro);

CREATE TABLE dbo.Estudiantes (
    Carnet    VARCHAR(15)   NOT NULL CONSTRAINT PK_Estudiantes PRIMARY KEY,
    Nombre    NVARCHAR(150) NOT NULL,
    Correo    NVARCHAR(150) NOT NULL CONSTRAINT UQ_Estudiantes_Correo UNIQUE,
    CarreraId INT           NOT NULL CONSTRAINT FK_Estudiantes_Carreras REFERENCES dbo.Carreras(Id),
    CONSTRAINT CK_Estudiantes_Nombre CHECK (LEN(TRIM(Nombre)) > 0),
    CONSTRAINT CK_Estudiantes_Correo CHECK (Correo LIKE '_%@_%._%')
);

CREATE INDEX IX_Estudiantes_CarreraId ON dbo.Estudiantes(CarreraId);

CREATE TABLE dbo.Prestamos (
    NoPrestamo    INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Prestamos PRIMARY KEY,
    Carnet        VARCHAR(15)       NOT NULL CONSTRAINT FK_Prestamos_Estudiantes REFERENCES dbo.Estudiantes(Carnet),
    FechaPrestamo DATE              NOT NULL CONSTRAINT DF_Prestamos_FechaPrestamo DEFAULT CAST(SYSDATETIME() AS DATE)
);

CREATE INDEX IX_Prestamos_Carnet ON dbo.Prestamos(Carnet);

CREATE TABLE dbo.DetallePrestamos (
    NoPrestamo              INT         NOT NULL CONSTRAINT FK_DetallePrestamos_Prestamos REFERENCES dbo.Prestamos(NoPrestamo),
    CodigoEjemplar          VARCHAR(20) NOT NULL CONSTRAINT FK_DetallePrestamos_Ejemplares REFERENCES dbo.Ejemplares(CodigoEjemplar),
    FechaDevolucionEsperada DATE        NOT NULL,
    FechaDevolucionReal     DATE        NULL,
    CONSTRAINT PK_DetallePrestamos PRIMARY KEY (NoPrestamo, CodigoEjemplar)
);

CREATE UNIQUE INDEX UX_DetallePrestamos_EjemplarAbierto ON dbo.DetallePrestamos(CodigoEjemplar) WHERE FechaDevolucionReal IS NULL;
GO
