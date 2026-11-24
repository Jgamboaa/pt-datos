USE BibliotecaDB;
GO

CREATE OR ALTER VIEW dbo.VW_LIBROS_CON_AUTORES
AS
SELECT
    l.CodigoLibro,
    l.Titulo,
    l.AnioPublicacion,
    c.Nombre                                               AS Categoria,
    COUNT(a.CodigoAutor)                                   AS CantidadAutores,
    STRING_AGG(a.Nombre, N', ') WITHIN GROUP (ORDER BY a.Nombre) AS Autores
FROM dbo.Libros l
INNER JOIN dbo.Categorias c ON c.Id = l.CategoriaId
LEFT JOIN dbo.LibroAutores la ON la.CodigoLibro = l.CodigoLibro
LEFT JOIN dbo.Autores a ON a.CodigoAutor = la.CodigoAutor
GROUP BY l.CodigoLibro, l.Titulo, l.AnioPublicacion, c.Nombre;
GO

CREATE OR ALTER VIEW dbo.VW_PRESTAMOS_POR_ESTUDIANTE
AS
SELECT
    e.Carnet,
    e.Nombre                    AS NombreEstudiante,
    ca.Nombre                   AS Carrera,
    p.NoPrestamo,
    p.FechaPrestamo,
    dp.CodigoEjemplar,
    l.CodigoLibro,
    l.Titulo,
    dp.FechaDevolucionEsperada,
    dp.FechaDevolucionReal,
    CASE
        WHEN dp.FechaDevolucionReal > dp.FechaDevolucionEsperada            THEN N'Devuelto con atraso'
        WHEN dp.FechaDevolucionReal IS NOT NULL                             THEN N'Devuelto'
        WHEN CAST(SYSDATETIME() AS DATE) > dp.FechaDevolucionEsperada       THEN N'Vencido'
        ELSE N'En curso'
    END                         AS EstadoPrestamo
FROM dbo.Estudiantes e
INNER JOIN dbo.Carreras ca ON ca.Id = e.CarreraId
INNER JOIN dbo.Prestamos p ON p.Carnet = e.Carnet
INNER JOIN dbo.DetallePrestamos dp ON dp.NoPrestamo = p.NoPrestamo
INNER JOIN dbo.Ejemplares ej ON ej.CodigoEjemplar = dp.CodigoEjemplar
INNER JOIN dbo.Libros l ON l.CodigoLibro = ej.CodigoLibro;
GO

CREATE OR ALTER FUNCTION dbo.FN_PRESTAMOS_ESTUDIANTE (@Carnet VARCHAR(15))
RETURNS TABLE
AS
RETURN (
    SELECT *
    FROM dbo.VW_PRESTAMOS_POR_ESTUDIANTE
    WHERE Carnet = @Carnet
);
GO

CREATE OR ALTER VIEW dbo.VW_LIBROS_PRESTADOS
AS
SELECT
    l.CodigoLibro,
    l.Titulo,
    dp.CodigoEjemplar,
    p.NoPrestamo,
    e.Carnet,
    e.Nombre                    AS NombreEstudiante,
    p.FechaPrestamo,
    dp.FechaDevolucionEsperada,
    CASE
        WHEN CAST(SYSDATETIME() AS DATE) > dp.FechaDevolucionEsperada
            THEN DATEDIFF(DAY, dp.FechaDevolucionEsperada, CAST(SYSDATETIME() AS DATE))
        ELSE 0
    END                         AS DiasAtraso
FROM dbo.DetallePrestamos dp
INNER JOIN dbo.Prestamos p ON p.NoPrestamo = dp.NoPrestamo
INNER JOIN dbo.Estudiantes e ON e.Carnet = p.Carnet
INNER JOIN dbo.Ejemplares ej ON ej.CodigoEjemplar = dp.CodigoEjemplar
INNER JOIN dbo.Libros l ON l.CodigoLibro = ej.CodigoLibro
WHERE dp.FechaDevolucionReal IS NULL;
GO

CREATE OR ALTER VIEW dbo.VW_CANTIDAD_PRESTAMOS_POR_ESTUDIANTE
AS
SELECT
    e.Carnet,
    e.Nombre                     AS NombreEstudiante,
    ca.Nombre                    AS Carrera,
    COUNT(DISTINCT p.NoPrestamo) AS CantidadPrestamos,
    COUNT(dp.CodigoEjemplar)     AS CantidadEjemplares
FROM dbo.Estudiantes e
INNER JOIN dbo.Carreras ca ON ca.Id = e.CarreraId
LEFT JOIN dbo.Prestamos p ON p.Carnet = e.Carnet
LEFT JOIN dbo.DetallePrestamos dp ON dp.NoPrestamo = p.NoPrestamo
GROUP BY e.Carnet, e.Nombre, ca.Nombre;
GO
