USE BibliotecaDB;
GO

INSERT INTO dbo.Categorias (Nombre) VALUES
    (N'Bases de Datos'),
    (N'Algoritmos'),
    (N'Literatura'),
    (N'Matemáticas');

INSERT INTO dbo.Carreras (Nombre) VALUES
    (N'Ingeniería en Sistemas'),
    (N'Licenciatura en Letras'),
    (N'Ingeniería Industrial');

INSERT INTO dbo.Autores (CodigoAutor, Nombre) VALUES
    ('AUT-001', N'Abraham Silberschatz'),
    ('AUT-002', N'Henry F. Korth'),
    ('AUT-003', N'S. Sudarshan'),
    ('AUT-004', N'Thomas H. Cormen'),
    ('AUT-005', N'Charles E. Leiserson'),
    ('AUT-006', N'Ronald L. Rivest'),
    ('AUT-007', N'Clifford Stein'),
    ('AUT-008', N'Gabriel García Márquez'),
    ('AUT-009', N'James Stewart'),
    ('AUT-010', N'Ramez Elmasri'),
    ('AUT-011', N'Shamkant B. Navathe');

INSERT INTO dbo.Libros (CodigoLibro, Titulo, AnioPublicacion, CategoriaId) VALUES
    ('LIB-001', N'Fundamentos de Bases de Datos', 2019, 1),
    ('LIB-002', N'Introducción a los Algoritmos', 2022, 2),
    ('LIB-003', N'Cien años de soledad', 1967, 3),
    ('LIB-004', N'Cálculo de una variable', 2012, 4),
    ('LIB-005', N'Fundamentos de Sistemas de Bases de Datos', 2016, 1),
    ('LIB-006', N'El amor en los tiempos del cólera', 1985, 3);

INSERT INTO dbo.LibroAutores (CodigoLibro, CodigoAutor) VALUES
    ('LIB-001', 'AUT-001'), ('LIB-001', 'AUT-002'), ('LIB-001', 'AUT-003'),
    ('LIB-002', 'AUT-004'), ('LIB-002', 'AUT-005'), ('LIB-002', 'AUT-006'), ('LIB-002', 'AUT-007'),
    ('LIB-003', 'AUT-008'),
    ('LIB-004', 'AUT-009'),
    ('LIB-005', 'AUT-010'), ('LIB-005', 'AUT-011'),
    ('LIB-006', 'AUT-008');

INSERT INTO dbo.Ejemplares (CodigoEjemplar, CodigoLibro, Estado) VALUES
    ('EJ-001', 'LIB-001', N'Disponible'),
    ('EJ-002', 'LIB-001', N'Prestado'),
    ('EJ-003', 'LIB-001', N'Disponible'),
    ('EJ-004', 'LIB-002', N'Disponible'),
    ('EJ-005', 'LIB-002', N'Dañado'),
    ('EJ-006', 'LIB-003', N'Prestado'),
    ('EJ-007', 'LIB-003', N'Disponible'),
    ('EJ-008', 'LIB-004', N'Disponible'),
    ('EJ-009', 'LIB-005', N'Prestado'),
    ('EJ-010', 'LIB-005', N'Disponible'),
    ('EJ-011', 'LIB-006', N'Disponible');

INSERT INTO dbo.Estudiantes (Carnet, Nombre, Correo, CarreraId) VALUES
    ('2021-0001', N'Ana López', N'ana.lopez@universidad.edu', 1),
    ('2021-0002', N'Carlos Méndez', N'carlos.mendez@universidad.edu', 2),
    ('2022-0003', N'María Pérez', N'maria.perez@universidad.edu', 1),
    ('2023-0004', N'Jorge Ramírez', N'jorge.ramirez@universidad.edu', 3);

INSERT INTO dbo.Prestamos (Carnet, FechaPrestamo) VALUES
    ('2021-0001', '2026-10-01'),
    ('2021-0002', '2026-11-10'),
    ('2021-0001', '2026-11-01'),
    ('2022-0003', '2026-11-18');

INSERT INTO dbo.DetallePrestamos (NoPrestamo, CodigoEjemplar, FechaDevolucionEsperada, FechaDevolucionReal) VALUES
    (1, 'EJ-001', '2026-10-15', '2026-10-14'),
    (1, 'EJ-004', '2026-10-15', '2026-10-20'),
    (2, 'EJ-006', '2026-11-24', NULL),
    (3, 'EJ-002', '2026-11-15', NULL),
    (3, 'EJ-008', '2026-11-15', '2026-11-12'),
    (4, 'EJ-009', '2026-12-02', NULL);
GO
