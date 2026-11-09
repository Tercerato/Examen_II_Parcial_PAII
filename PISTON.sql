/*
==========================================================
 P.I.S.T.O.N.
 Plataforma Inteligente de Servicio,
 Taller, Overhaul y de reparacióN

 Programacion Avanzada II
 Sistema Integral de Gestion de Taller Mecanico
==========================================================
*/


--CREATE DATABASE PISTON;


/*
LAS SIGUIENTES SON LAS TABLAS QUE SE DISEÑARON PARA ESTE PROYECTO
*/

/*==========================================================
 1. TABLA CLIENTES
==========================================================*/

CREATE TABLE CLIENTES (
    id_cliente INT IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    dni NVARCHAR(20) NOT NULL,
    telefono NVARCHAR(20) NOT NULL,
    correo NVARCHAR(100),
    direccion NVARCHAR(200),
    estado BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_CLIENTES
    PRIMARY KEY (id_cliente),

    CONSTRAINT UQ_CLIENTES_DNI
    UNIQUE (dni)
);

/*==========================================================
 2. TABLA VEHICULOS
==========================================================*/

CREATE TABLE VEHICULOS (
    id_vehiculo INT IDENTITY(1,1),
    id_cliente INT NOT NULL,
    placa NVARCHAR(15) NOT NULL,
    vin NVARCHAR(30) NOT NULL,
    marca NVARCHAR(50) NOT NULL,
    modelo NVARCHAR(50) NOT NULL,
    anio SMALLINT NOT NULL,
    color NVARCHAR(30),
    kilometraje INT NOT NULL,
    combustible NVARCHAR(30) NOT NULL,
    estado BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_VEHICULOS
    PRIMARY KEY (id_vehiculo),

    CONSTRAINT UQ_VEHICULOS_PLACA
    UNIQUE (placa),

    CONSTRAINT UQ_VEHICULOS_VIN
    UNIQUE (vin),

    CONSTRAINT CK_VEHICULOS_KILOMETRAJE
    CHECK (kilometraje >= 0)
);

/*==========================================================
 3. TABLA MECANICOS
==========================================================*/

CREATE TABLE MECANICOS (
    id_mecanico INT IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    especialidad NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20),
    estado BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_MECANICOS
    PRIMARY KEY (id_mecanico)
);

/*==========================================================
 4. TABLA SERVICIOS
==========================================================*/

CREATE TABLE SERVICIOS (
    id_servicio INT IDENTITY(1,1),
    codigo NVARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(300),
    nivel_complejidad TINYINT NOT NULL,
    costo_mano_obra DECIMAL(10,2) NOT NULL,
    tiempo_estimado INT NOT NULL,
    estado BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_SERVICIOS
    PRIMARY KEY (id_servicio),

    CONSTRAINT UQ_SERVICIOS_CODIGO
    UNIQUE (codigo),

    CONSTRAINT CK_SERVICIOS_NIVEL
    CHECK (nivel_complejidad BETWEEN 1 AND 5),

    CONSTRAINT CK_SERVICIOS_COSTO
    CHECK (costo_mano_obra >= 0),

    CONSTRAINT CK_SERVICIOS_TIEMPO
    CHECK (tiempo_estimado >= 0)
);

/*==========================================================
 5. TABLA ORDENES_TRABAJO
==========================================================*/

CREATE TABLE ORDENES_TRABAJO (
    id_orden INT IDENTITY(1,1),
    id_vehiculo INT NOT NULL,
    fecha_inicio DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    fecha_fin DATETIME2,
    kilometraje INT NOT NULL,
    sintomas NVARCHAR(500) NOT NULL,
    diagnostico_preliminar NVARCHAR(500),
    estado NVARCHAR(30) NOT NULL DEFAULT 'Recibida',

    CONSTRAINT PK_ORDENES_TRABAJO
    PRIMARY KEY (id_orden),

    CONSTRAINT CK_ORDENES_KILOMETRAJE
    CHECK (kilometraje >= 0),

    CONSTRAINT CK_ORDENES_FECHAS
    CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

/*==========================================================
 6. TABLA DETALLE_ORDEN
==========================================================*/

CREATE TABLE DETALLE_ORDEN (
    id_detalle INT IDENTITY(1,1),
    id_orden INT NOT NULL,
    id_servicio INT NOT NULL,
    cantidad INT NOT NULL,
    costo_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_DETALLE_ORDEN
    PRIMARY KEY (id_detalle),

    CONSTRAINT CK_DETALLE_ORDEN_CANTIDAD
    CHECK (cantidad > 0),

    CONSTRAINT CK_DETALLE_ORDEN_COSTO
    CHECK (costo_unitario >= 0),

    CONSTRAINT CK_DETALLE_ORDEN_SUBTOTAL
    CHECK (subtotal >= 0)
);

/*==========================================================
 7. TABLA DIAGNOSTICOS
==========================================================*/

CREATE TABLE DIAGNOSTICOS (
    id_diagnostico INT IDENTITY(1,1),
    id_orden INT NOT NULL,
    descripcion NVARCHAR(500) NOT NULL,
    evidencia NVARCHAR(500),
    fecha DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT PK_DIAGNOSTICOS
    PRIMARY KEY (id_diagnostico)
);

/*==========================================================
 8. TABLA PROVEEDORES
==========================================================*/

CREATE TABLE PROVEEDORES (
    id_proveedor INT IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20) NOT NULL,
    correo NVARCHAR(100),
    direccion NVARCHAR(200),
    estado BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_PROVEEDORES
    PRIMARY KEY (id_proveedor)
);

/*==========================================================
 9. TABLA REPUESTOS
==========================================================*/

CREATE TABLE REPUESTOS (
    id_repuesto INT IDENTITY(1,1),
    id_proveedor INT NOT NULL,
    codigo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(300),
    stock INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 0,
    costo_unitario DECIMAL(10,2) NOT NULL,
    estado BIT NOT NULL DEFAULT 1,

    CONSTRAINT PK_REPUESTOS
    PRIMARY KEY (id_repuesto),

    CONSTRAINT UQ_REPUESTOS_CODIGO
    UNIQUE (codigo),

    CONSTRAINT CK_REPUESTOS_STOCK
    CHECK (stock >= 0 AND stock_minimo >= 0),

    CONSTRAINT CK_REPUESTOS_COSTO
    CHECK (costo_unitario >= 0)
);

/*==========================================================
 10. TABLA MOVIMIENTOS_INVENTARIO
==========================================================*/

CREATE TABLE MOVIMIENTOS_INVENTARIO (
    id_movimiento INT IDENTITY(1,1),
    id_repuesto INT NOT NULL,
    tipo_movimiento NVARCHAR(20) NOT NULL,
    cantidad INT NOT NULL,
    fecha DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    referencia NVARCHAR(100),
    observacion NVARCHAR(300),

    CONSTRAINT PK_MOVIMIENTOS_INVENTARIO
    PRIMARY KEY (id_movimiento),

    CONSTRAINT CK_MOVIMIENTO_TIPO
    CHECK (tipo_movimiento IN ('Entrada','Salida','Ajuste')),

    CONSTRAINT CK_MOVIMIENTO_CANTIDAD
    CHECK (cantidad > 0)
);

/*==========================================================
 11. TABLA ORDEN_MECANICO
==========================================================*/

CREATE TABLE ORDEN_MECANICO (
    id_orden_mecanico INT IDENTITY(1,1),
    id_orden INT NOT NULL,
    id_mecanico INT NOT NULL,
    rol NVARCHAR(20) NOT NULL,

    CONSTRAINT PK_ORDEN_MECANICO
    PRIMARY KEY (id_orden_mecanico),

    CONSTRAINT UQ_ORDEN_MECANICO
    UNIQUE (id_orden, id_mecanico),

    CONSTRAINT CK_ORDEN_MECANICO_ROL
    CHECK (rol IN ('Responsable','Apoyo'))
);

/*==========================================================
 12. TABLA DETALLE_REPUESTO
==========================================================*/

CREATE TABLE DETALLE_REPUESTO (
    id_detalle_repuesto INT IDENTITY(1,1),
    id_orden INT NOT NULL,
    id_repuesto INT NOT NULL,
    cantidad INT NOT NULL,
    costo_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_DETALLE_REPUESTO
    PRIMARY KEY (id_detalle_repuesto),

    CONSTRAINT CK_DETALLE_REPUESTO_CANTIDAD
    CHECK (cantidad > 0),

    CONSTRAINT CK_DETALLE_REPUESTO_COSTO
    CHECK (costo_unitario >= 0),

    CONSTRAINT CK_DETALLE_REPUESTO_SUBTOTAL
    CHECK (subtotal >= 0)
);

/*==========================================================
 13. TABLA ACTIVIDADES_TRABAJO
==========================================================*/

CREATE TABLE ACTIVIDADES_TRABAJO (
    id_actividad INT IDENTITY(1,1),
    id_orden INT NOT NULL,
    id_mecanico INT NOT NULL,
    descripcion NVARCHAR(300) NOT NULL,
    fecha DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    estado NVARCHAR(20) NOT NULL DEFAULT 'Pendiente',

    CONSTRAINT PK_ACTIVIDADES_TRABAJO
    PRIMARY KEY (id_actividad),

    CONSTRAINT CK_ACTIVIDADES_ESTADO
    CHECK (estado IN ('Pendiente','En proceso','Finalizada'))
);

/*==========================================================
 14. TABLA CONTROLES_CALIDAD
==========================================================*/

CREATE TABLE CONTROLES_CALIDAD (
    id_control INT IDENTITY(1,1),
    id_orden INT NOT NULL,
    id_mecanico INT NOT NULL,
    descripcion NVARCHAR(300) NOT NULL,
    resultado NVARCHAR(20) NOT NULL,
    fecha DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    observacion NVARCHAR(300),

    CONSTRAINT PK_CONTROLES_CALIDAD
    PRIMARY KEY (id_control),

    CONSTRAINT CK_CONTROLES_RESULTADO
    CHECK (resultado IN ('Aprobado','Rechazado'))
);

/*==========================================================
 15. TABLA PRESUPUESTOS
==========================================================*/

CREATE TABLE PRESUPUESTOS (
    id_presupuesto INT IDENTITY(1,1),
    id_orden INT NOT NULL,
    horas_mano_obra DECIMAL(8,2) NOT NULL,
    costo_hora DECIMAL(10,2) NOT NULL,
    subtotal_servicios DECIMAL(10,2) NOT NULL,
    subtotal_repuestos DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) NOT NULL DEFAULT 0,
    porcentaje_impuesto DECIMAL(5,2) NOT NULL DEFAULT 0,
    impuesto DECIMAL(10,2) NOT NULL DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    fecha DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT PK_PRESUPUESTOS
    PRIMARY KEY (id_presupuesto),

    CONSTRAINT UQ_PRESUPUESTOS_ORDEN
    UNIQUE (id_orden),

    CONSTRAINT CK_PRESUPUESTOS_HORAS
    CHECK (horas_mano_obra >= 0),

    CONSTRAINT CK_PRESUPUESTOS_COSTOS
    CHECK (
        costo_hora >= 0 AND
        subtotal_servicios >= 0 AND
        subtotal_repuestos >= 0 AND
        descuento >= 0 AND
        impuesto >= 0 AND
        total >= 0
    ),

    CONSTRAINT CK_PRESUPUESTOS_IMPUESTO
    CHECK (porcentaje_impuesto BETWEEN 0 AND 100),

    CONSTRAINT CK_PRESUPUESTOS_ESTADO
    CHECK (estado IN ('Pendiente','Aprobado','Rechazado'))
);

/*==========================================================
 16. TABLA PAGOS
==========================================================*/

CREATE TABLE PAGOS (
    id_pago INT IDENTITY(1,1),
    id_orden INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    tipo_pago NVARCHAR(30) NOT NULL,
    fecha DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT PK_PAGOS
    PRIMARY KEY (id_pago),

    CONSTRAINT CK_PAGOS_MONTO
    CHECK (monto > 0),

    CONSTRAINT CK_PAGOS_TIPO
    CHECK (
        tipo_pago IN (
            'Efectivo',
            'Tarjeta',
            'Transferencia'
        )
    )
);

/*==========================================================
 17. TABLA MOTORES
==========================================================*/

CREATE TABLE MOTORES (
    id_motor INT IDENTITY(1,1),
    numero_serie NVARCHAR(50) NOT NULL,
    marca NVARCHAR(50) NOT NULL,
    modelo NVARCHAR(50) NOT NULL,
    compatibilidad NVARCHAR(200) NOT NULL,
    estado NVARCHAR(20) NOT NULL DEFAULT 'Disponible',

    CONSTRAINT PK_MOTORES
    PRIMARY KEY (id_motor),

    CONSTRAINT UQ_MOTORES_SERIE
    UNIQUE (numero_serie),

    CONSTRAINT CK_MOTORES_ESTADO
    CHECK (
        estado IN (
            'Disponible',
            'Instalado',
            'Retirado'
        )
    )
);

/*==========================================================
 18. TABLA CAMBIOS_MOTOR
==========================================================*/

CREATE TABLE CAMBIOS_MOTOR (
    id_cambio INT IDENTITY(1,1),
    id_orden INT NOT NULL,
    id_vehiculo INT NOT NULL,
    id_motor_anterior INT NOT NULL,
    id_motor_nuevo INT NOT NULL,
    fecha DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    destino_motor_anterior NVARCHAR(100) NOT NULL,
    resultado_pruebas NVARCHAR(500) NOT NULL,
    garantia NVARCHAR(200) NOT NULL,

    CONSTRAINT PK_CAMBIOS_MOTOR
    PRIMARY KEY (id_cambio),

    CONSTRAINT CK_CAMBIOS_MOTOR_DISTINTOS
    CHECK (id_motor_anterior <> id_motor_nuevo)
);



/* CLIENTES - VEHICULOS */

ALTER TABLE VEHICULOS
ADD CONSTRAINT FK_VEHICULOS_CLIENTES
FOREIGN KEY (id_cliente)
REFERENCES CLIENTES(id_cliente);

/* VEHICULOS - ORDENES */

ALTER TABLE ORDENES_TRABAJO
ADD CONSTRAINT FK_ORDENES_VEHICULOS
FOREIGN KEY (id_vehiculo)
REFERENCES VEHICULOS(id_vehiculo);

/* ORDENES - SERVICIOS */

ALTER TABLE DETALLE_ORDEN
ADD CONSTRAINT FK_DETALLE_ORDEN
FOREIGN KEY (id_orden)
REFERENCES ORDENES_TRABAJO(id_orden);

ALTER TABLE DETALLE_ORDEN
ADD CONSTRAINT FK_DETALLE_SERVICIO
FOREIGN KEY (id_servicio)
REFERENCES SERVICIOS(id_servicio);

/* ORDENES - DIAGNOSTICOS */

ALTER TABLE DIAGNOSTICOS
ADD CONSTRAINT FK_DIAGNOSTICOS_ORDEN
FOREIGN KEY (id_orden)
REFERENCES ORDENES_TRABAJO(id_orden);

/* PROVEEDORES - REPUESTOS */

ALTER TABLE REPUESTOS
ADD CONSTRAINT FK_REPUESTOS_PROVEEDORES
FOREIGN KEY (id_proveedor)
REFERENCES PROVEEDORES(id_proveedor);

/* REPUESTOS - MOVIMIENTOS */

ALTER TABLE MOVIMIENTOS_INVENTARIO
ADD CONSTRAINT FK_MOVIMIENTOS_REPUESTOS
FOREIGN KEY (id_repuesto)
REFERENCES REPUESTOS(id_repuesto);

/* ORDENES - MECANICOS */

ALTER TABLE ORDEN_MECANICO
ADD CONSTRAINT FK_ORDEN_MECANICO_ORDEN
FOREIGN KEY (id_orden)
REFERENCES ORDENES_TRABAJO(id_orden);

ALTER TABLE ORDEN_MECANICO
ADD CONSTRAINT FK_ORDEN_MECANICO_MECANICO
FOREIGN KEY (id_mecanico)
REFERENCES MECANICOS(id_mecanico);

/* ORDENES - REPUESTOS */

ALTER TABLE DETALLE_REPUESTO
ADD CONSTRAINT FK_DETALLE_REPUESTO_ORDEN
FOREIGN KEY (id_orden)
REFERENCES ORDENES_TRABAJO(id_orden);

ALTER TABLE DETALLE_REPUESTO
ADD CONSTRAINT FK_DETALLE_REPUESTO_REPUESTO
FOREIGN KEY (id_repuesto)
REFERENCES REPUESTOS(id_repuesto);

/* ACTIVIDADES */

ALTER TABLE ACTIVIDADES_TRABAJO
ADD CONSTRAINT FK_ACTIVIDADES_ORDEN
FOREIGN KEY (id_orden)
REFERENCES ORDENES_TRABAJO(id_orden);

ALTER TABLE ACTIVIDADES_TRABAJO
ADD CONSTRAINT FK_ACTIVIDADES_MECANICO
FOREIGN KEY (id_mecanico)
REFERENCES MECANICOS(id_mecanico);

/* CONTROLES */

ALTER TABLE CONTROLES_CALIDAD
ADD CONSTRAINT FK_CONTROLES_ORDEN
FOREIGN KEY (id_orden)
REFERENCES ORDENES_TRABAJO(id_orden);

ALTER TABLE CONTROLES_CALIDAD
ADD CONSTRAINT FK_CONTROLES_MECANICO
FOREIGN KEY (id_mecanico)
REFERENCES MECANICOS(id_mecanico);

/* PRESUPUESTOS */

ALTER TABLE PRESUPUESTOS
ADD CONSTRAINT FK_PRESUPUESTOS_ORDEN
FOREIGN KEY (id_orden)
REFERENCES ORDENES_TRABAJO(id_orden);

/* PAGOS */

ALTER TABLE PAGOS
ADD CONSTRAINT FK_PAGOS_ORDEN
FOREIGN KEY (id_orden)
REFERENCES ORDENES_TRABAJO(id_orden);

/* CAMBIOS DE MOTOR */

ALTER TABLE CAMBIOS_MOTOR
ADD CONSTRAINT FK_CAMBIOS_ORDEN
FOREIGN KEY (id_orden)
REFERENCES ORDENES_TRABAJO(id_orden);

ALTER TABLE CAMBIOS_MOTOR
ADD CONSTRAINT FK_CAMBIOS_VEHICULO
FOREIGN KEY (id_vehiculo)
REFERENCES VEHICULOS(id_vehiculo);

ALTER TABLE CAMBIOS_MOTOR
ADD CONSTRAINT FK_CAMBIOS_MOTOR_ANTERIOR
FOREIGN KEY (id_motor_anterior)
REFERENCES MOTORES(id_motor);

ALTER TABLE CAMBIOS_MOTOR
ADD CONSTRAINT FK_CAMBIOS_MOTOR_NUEVO
FOREIGN KEY (id_motor_nuevo)
REFERENCES MOTORES(id_motor);

SELECT * FROM CLIENTES;
SELECT * FROM VEHICULOS;
SELECT * FROM MECANICOS;
SELECT * FROM SERVICIOS;
SELECT * FROM ORDENES_TRABAJO;

SELECT
    OBJECT_NAME(parent_object_id) AS Tabla,
    name AS Restriccion,
    OBJECT_NAME(referenced_object_id) AS TablaReferenciada
FROM sys.foreign_keys
ORDER BY Tabla;

/*==========================================================
 INSERTAR CLIENTES
==========================================================*/

INSERT INTO CLIENTES
(nombre, dni, telefono, correo, direccion)
VALUES
('alexander Lavaire', '0318199500587', '97165740',
 'alexanderlavaire@gmail.com', 'Siguatepeque'),

('Mario Beteta', '0301200000123', '33164062',
 'mariobeteta@gmail.com', 'Comayagua');

/*==========================================================
 INSERTAR VEHICULOS
==========================================================*/

INSERT INTO VEHICULOS
(id_cliente, placa, vin, marca, modelo, anio,
 color, kilometraje, combustible)
VALUES
(1, 'HAA1234', 'JT123456789000001', 'Toyota',
 'Hilux', 2015, 'Blanco', 150000, 'Diesel'),

(1, 'HBB5678', 'JT123456789000002', 'Toyota',
 'Corolla', 2020, 'Gris', 80000, 'Gasolina'),

(2, 'HCC9012', 'HN123456789000003', 'Honda',
 'Civic', 2018, 'Negro', 95000, 'Gasolina');

/*==========================================================
 VERIFICAR REGISTROS
==========================================================*/

SELECT * FROM CLIENTES;

SELECT * FROM VEHICULOS;


/*==========================================================
 INSERTAR MECANICOS
==========================================================*/

INSERT INTO MECANICOS
(nombre, especialidad, telefono)
VALUES
('Armando Esteban Quito', 'Mecanica general', '92131542'),
('Mario Neta', 'Motores', '36128915'),
('Elvis tek', 'Electricidad automotriz', '96142233');

/*==========================================================
 INSERTAR SERVICIOS
==========================================================*/

INSERT INTO SERVICIOS
(codigo, nombre, descripcion, nivel_complejidad,
 costo_mano_obra, tiempo_estimado)
VALUES
('SRV001', 'Cambio de aceite',
 'Cambio de aceite y filtro', 1, 350.00, 60),

('SRV002', 'Cambio de bujias',
 'Sustitucion de bujias', 1, 250.00, 45),

('SRV003', 'Mantenimiento de frenos',
 'Revision y mantenimiento de frenos', 2, 800.00, 120),

('SRV004', 'Reparacion de alternador',
 'Diagnostico y reparacion de alternador', 3, 1500.00, 240),

('SRV005', 'Reparacion de motor',
 'Reparacion mayor de motor', 5, 5000.00, 1440);

/*==========================================================
 VERIFICAR
==========================================================*/

SELECT * FROM MECANICOS;

SELECT * FROM SERVICIOS;

/*==========================================================
 INSERTAR PROVEEDORES
==========================================================*/

INSERT INTO PROVEEDORES
(nombre, telefono, correo, direccion)
VALUES
('Repuestos Centroamericanos', '22334455',
 'ventas@repuestosca.com', 'San Pedro Sula'),

('Distribuidora Automotriz', '99887766',
 'contacto@distribuidora.com', 'Tegucigalpa');

/*==========================================================
 INSERTAR REPUESTOS
==========================================================*/

INSERT INTO REPUESTOS
(id_proveedor, codigo, nombre, descripcion,
 stock, stock_minimo, costo_unitario)
VALUES
(1, 'REP001', 'Aceite 10W30', 'Aceite para motor',
 50, 10, 180.00),

(1, 'REP002', 'Filtro de aceite', 'Filtro de aceite universal',
 30, 5, 90.00),

(2, 'REP003', 'Bujias', 'Juego de bujias',
 20, 5, 120.00),

(2, 'REP004', 'Motor Toyota Hilux 2015',
 'Motor compatible con Toyota Hilux 2015',
  1, 0, 35000.00);

/*==========================================================
 VERIFICAR
==========================================================*/

SELECT * FROM PROVEEDORES;

SELECT * FROM REPUESTOS;


/*==========================================================
 INSERTAR ORDENES DE TRABAJO
==========================================================*/

INSERT INTO ORDENES_TRABAJO
(id_vehiculo, kilometraje, sintomas, diagnostico_preliminar, estado)
VALUES
(1, 150000, 'Sobrecalentamiento y perdida de potencia',
 'Posible daño interno del motor', 'Recibida'),

(2, 80000, 'Mantenimiento preventivo',
 'Requiere cambio de aceite', 'Recibida');

/*==========================================================
 ASIGNAR MECANICOS
==========================================================*/

INSERT INTO ORDEN_MECANICO
(id_orden, id_mecanico, rol)
VALUES
(1, 2, 'Responsable'),
(1, 1, 'Apoyo'),
(2, 1, 'Responsable');

/*==========================================================
 ASIGNAR SERVICIOS
==========================================================*/

INSERT INTO DETALLE_ORDEN
(id_orden, id_servicio, cantidad, costo_unitario, subtotal)
VALUES
(1, 5, 1, 5000.00, 5000.00),
(2, 1, 1, 350.00, 350.00);

/*==========================================================
 VERIFICAR
==========================================================*/

SELECT * FROM ORDENES_TRABAJO;

SELECT * FROM ORDEN_MECANICO;

SELECT * FROM DETALLE_ORDEN;


/* DIAGNOSTICOS */

INSERT INTO DIAGNOSTICOS
(id_orden, descripcion, evidencia)
VALUES
(1, 'Daños internos por sobrecalentamiento',
 'Perdida de potencia y sobrecalentamiento'),

(2, 'Aceite degradado',
 'Aceite requiere sustitucion');

/* ACTIVIDADES DE TRABAJO */

INSERT INTO ACTIVIDADES_TRABAJO
(id_orden, id_mecanico, descripcion, estado)
VALUES
(1, 2, 'Desmontaje y evaluacion del motor', 'Pendiente'),

(1, 1, 'Inspeccion del sistema de refrigeracion', 'Pendiente'),

(2, 1, 'Cambio de aceite y filtro', 'Pendiente');

/* VERIFICAR */

SELECT * FROM DIAGNOSTICOS;

SELECT * FROM ACTIVIDADES_TRABAJO;


/*==========================================================
 INSERTAR PRESUPUESTOS
==========================================================*/

INSERT INTO PRESUPUESTOS
(id_orden, horas_mano_obra, costo_hora,
 subtotal_servicios, subtotal_repuestos,
 descuento, porcentaje_impuesto, impuesto,
 total, estado)
VALUES
(1, 20, 250, 5000, 0, 0, 15, 750,
 5750, 'Pendiente'),

(2, 1, 250, 350, 270, 0, 15, 93,
  713, 'Pendiente');

/*==========================================================
 INSERTAR PAGOS
==========================================================*/

INSERT INTO PAGOS
(id_orden, monto, tipo_pago)
VALUES
(1, 2000, 'Efectivo'),

(2, 713, 'Transferencia');

/*==========================================================
 VERIFICAR
==========================================================*/

SELECT * FROM PRESUPUESTOS;

SELECT * FROM PAGOS;

/*==========================================================
 MOVIMIENTOS INICIALES DE INVENTARIO
==========================================================*/

INSERT INTO MOVIMIENTOS_INVENTARIO
(id_repuesto, tipo_movimiento, cantidad, referencia, observacion)
VALUES
(1, 'Entrada', 50, 'COMPRA-001', 'Inventario inicial'),
(2, 'Entrada', 30, 'COMPRA-002', 'Inventario inicial'),
(3, 'Entrada', 20, 'COMPRA-003', 'Inventario inicial'),
(4, 'Entrada', 1, 'COMPRA-004', 'Motor Toyota Hilux');

/*==========================================================
 VERIFICAR MOVIMIENTOS
==========================================================*/

SELECT * FROM MOVIMIENTOS_INVENTARIO;

SELECT
    R.id_repuesto,
    R.codigo,
    R.nombre,
    R.stock,
    R.stock_minimo,
    P.nombre AS proveedor
FROM REPUESTOS R
INNER JOIN PROVEEDORES P
ON R.id_proveedor = P.id_proveedor;

/*==========================================================
 REGISTRAR MOTORES
==========================================================*/

INSERT INTO MOTORES
(numero_serie, marca, modelo, compatibilidad, estado)
VALUES
('MOTOR-HILUX-001', 'Toyota', '2.5 D-4D',
 'Toyota Hilux 2015', 'Instalado'),

('MOTOR-HILUX-002', 'Toyota', '2.5 D-4D',
 'Toyota Hilux 2015', 'Disponible');

/*==========================================================
 VERIFICAR
==========================================================*/

SELECT * FROM MOTORES;


/*==========================================================
 CAMBIO DE MOTOR - ORDEN 1
==========================================================*/

INSERT INTO CAMBIOS_MOTOR
(id_orden, id_vehiculo, id_motor_anterior,
 id_motor_nuevo, destino_motor_anterior,
 resultado_pruebas, garantia)
VALUES
(1, 1, 1, 2,
 'Motor enviado a reconstruccion',
 'Pruebas de funcionamiento aprobadas',
 'Garantia de 6 meses');

/*==========================================================
 ACTUALIZAR ESTADO DE LOS MOTORES
==========================================================*/

UPDATE MOTORES
SET estado = 'Retirado'
WHERE id_motor = 1;

UPDATE MOTORES
SET estado = 'Instalado'
WHERE id_motor = 2;

/*==========================================================
 VERIFICAR
==========================================================*/

SELECT * FROM CAMBIOS_MOTOR;

SELECT * FROM MOTORES;



/*==========================================================
 PROCEDIMEINTOS ALMACINADOS
==========================================================*/

CREATE PROCEDURE SP_REGISTRAR_CONSUMO_REPUESTO
    @id_orden INT,
    @id_repuesto INT,
    @cantidad INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @cantidad <= 0
        BEGIN
            THROW 50001, 'La cantidad debe ser mayor que cero.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM ORDENES_TRABAJO
            WHERE id_orden = @id_orden
        )
        BEGIN
            THROW 50002, 'La orden no existe.', 1;
        END;

        UPDATE REPUESTOS
        SET stock = stock - @cantidad
        WHERE id_repuesto = @id_repuesto
          AND stock >= @cantidad;

        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50003, 'Repuesto inexistente o stock insuficiente.', 1;
        END;

        INSERT INTO DETALLE_REPUESTO
        (
            id_orden,
            id_repuesto,
            cantidad,
            costo_unitario,
            subtotal
        )
        SELECT
            @id_orden,
            id_repuesto,
            @cantidad,
            costo_unitario,
            costo_unitario * @cantidad
        FROM REPUESTOS
        WHERE id_repuesto = @id_repuesto;

        INSERT INTO MOVIMIENTOS_INVENTARIO
        (
            id_repuesto,
            tipo_movimiento,
            cantidad,
            referencia,
            observacion
        )
        VALUES
        (
            @id_repuesto,
            'Salida',
            @cantidad,
            CONCAT('ORDEN-', @id_orden),
            'Consumo en orden de trabajo'
        );

        COMMIT TRANSACTION;

        PRINT 'Consumo registrado correctamente.';
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;

EXEC SP_REGISTRAR_CONSUMO_REPUESTO
    @id_orden = 2,
    @id_repuesto = 1,
    @cantidad = 2;

    SELECT * FROM REPUESTOS
WHERE id_repuesto = 1;

SELECT * FROM DETALLE_REPUESTO
WHERE id_orden = 2;

SELECT * FROM MOVIMIENTOS_INVENTARIO
WHERE tipo_movimiento = 'Salida';


/*  PROCEDIMEINTOS ALMACENADOS n°2 */


CREATE PROCEDURE SP_REGISTRAR_PAGO
    @id_orden INT,
    @monto DECIMAL(10,2),
    @tipo_pago NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @monto <= 0
        BEGIN
            THROW 50010, 'El monto debe ser mayor que cero.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM PRESUPUESTOS
            WHERE id_orden = @id_orden
              AND estado = 'Aprobado'
        )
        BEGIN
            THROW 50011, 'No existe presupuesto aprobado.', 1;
        END;

        DECLARE @total DECIMAL(10,2);
        DECLARE @pagado DECIMAL(10,2);
        DECLARE @saldo DECIMAL(10,2);

        SELECT @total = total
        FROM PRESUPUESTOS
        WHERE id_orden = @id_orden;

        SELECT @pagado = ISNULL(SUM(monto), 0)
        FROM PAGOS
        WHERE id_orden = @id_orden;

        SET @saldo = @total - @pagado;

        IF @monto > @saldo
        BEGIN
            THROW 50012, 'El pago excede el saldo pendiente.', 1;
        END;

        INSERT INTO PAGOS
        (id_orden, monto, tipo_pago)
        VALUES
        (@id_orden, @monto, @tipo_pago);

        COMMIT TRANSACTION;

        PRINT 'Pago registrado correctamente.';
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;

EXEC SP_REGISTRAR_PAGO
    @id_orden = 2,
    @monto = 100,
    @tipo_pago = 'Efectivo';

    SELECT * FROM PAGOS
WHERE id_orden = 2;

/*  PROCEDIMEINTOS ALMACENADOS n°3 */
CREATE PROCEDURE SP_FINALIZAR_ORDEN_TRABAJO
    @id_orden INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM ORDENES_TRABAJO
            WHERE id_orden = @id_orden
        )
        BEGIN
            THROW 50020, 'La orden no existe.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM ACTIVIDADES_TRABAJO
            WHERE id_orden = @id_orden
              AND estado <> 'Finalizada'
        )
        BEGIN
            THROW 50021, 'Existen actividades pendientes.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM CONTROLES_CALIDAD
            WHERE id_orden = @id_orden
              AND resultado = 'Aprobado'
        )
        BEGIN
            THROW 50022, 'La orden no tiene controles aprobados.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM CONTROLES_CALIDAD
            WHERE id_orden = @id_orden
              AND resultado = 'Rechazado'
        )
        BEGIN
            THROW 50023, 'Existen controles rechazados.', 1;
        END;

        UPDATE ORDENES_TRABAJO
        SET estado = 'Finalizada',
            fecha_fin = SYSDATETIME()
        WHERE id_orden = @id_orden;

        COMMIT TRANSACTION;

        PRINT 'Orden finalizada correctamente.';
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;

INSERT INTO CONTROLES_CALIDAD
(id_orden, id_mecanico, descripcion, resultado, observacion)
VALUES
(2, 1, 'Verificacion de mantenimiento',
 'Aprobado', 'Vehiculo en condiciones correctas');

 EXEC SP_FINALIZAR_ORDEN_TRABAJO
    @id_orden = 2;

    SELECT * FROM ORDENES_TRABAJO
WHERE id_orden = 2;

CREATE VIEW VW_ORDENES_TRABAJO
AS
SELECT
    O.id_orden,
    C.nombre AS cliente,
    V.placa,
    V.marca,
    V.modelo,
    O.fecha_inicio,
    O.fecha_fin,
    O.kilometraje,
    O.estado,
    M.nombre AS mecanico_responsable
FROM ORDENES_TRABAJO O
INNER JOIN VEHICULOS V
    ON O.id_vehiculo = V.id_vehiculo
INNER JOIN CLIENTES C
    ON V.id_cliente = C.id_cliente
LEFT JOIN ORDEN_MECANICO OM
    ON O.id_orden = OM.id_orden
    AND OM.rol = 'Responsable'
LEFT JOIN MECANICOS M
    ON OM.id_mecanico = M.id_mecanico;

    SELECT * FROM VW_ORDENES_TRABAJO;

CREATE VIEW VW_RESUMEN_FINANCIERO
AS
SELECT
    O.id_orden,
    C.nombre AS cliente,
    V.placa,
    P.total AS total_presupuesto,
    ISNULL(PG.total_pagado, 0) AS total_pagado,
    P.total - ISNULL(PG.total_pagado, 0)
        AS saldo_pendiente,
    P.estado AS estado_presupuesto
FROM ORDENES_TRABAJO O
INNER JOIN VEHICULOS V
    ON O.id_vehiculo = V.id_vehiculo
INNER JOIN CLIENTES C
    ON V.id_cliente = C.id_cliente
INNER JOIN PRESUPUESTOS P
    ON O.id_orden = P.id_orden
LEFT JOIN (
    SELECT
        id_orden,
        SUM(monto) AS total_pagado
    FROM PAGOS
    GROUP BY id_orden
) PG
    ON O.id_orden = PG.id_orden;

SELECT * FROM VW_RESUMEN_FINANCIERO;

CREATE TABLE AUDITORIA_ORDENES (
    id_auditoria INT IDENTITY(1,1),
    id_orden INT NOT NULL,
    estado_anterior NVARCHAR(30),
    estado_nuevo NVARCHAR(30),
    fecha_cambio DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT PK_AUDITORIA_ORDENES
    PRIMARY KEY (id_auditoria)
);

CREATE TRIGGER TR_AUDITORIA_ESTADO_ORDEN
ON ORDENES_TRABAJO
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AUDITORIA_ORDENES
    (id_orden, estado_anterior, estado_nuevo)
    SELECT
        I.id_orden,
        D.estado,
        I.estado
    FROM inserted I
    INNER JOIN deleted D
        ON I.id_orden = D.id_orden
    WHERE I.estado <> D.estado;
END;

UPDATE ORDENES_TRABAJO
SET estado = 'En proceso'
WHERE id_orden = 1;

SELECT * FROM AUDITORIA_ORDENES;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CLIENTES'
ORDER BY ORDINAL_POSITION;