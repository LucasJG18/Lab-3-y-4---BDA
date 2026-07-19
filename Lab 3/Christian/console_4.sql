CREATE TABLE REPORTE_VENTAS_DIARIAS (
    numero_factura VARCHAR2(20),
    fecha_venta DATE,
    -- Datos del Cliente embebidos
    codigo_cliente VARCHAR2(20),
    nombre_cliente VARCHAR2(100),
    -- Datos del Empleado embebidos
    nombre_empleado VARCHAR2(100),
    cargo_empleado VARCHAR2(50),
    -- Datos del Producto y Detalle embebidos
    codigo_producto VARCHAR2(20),
    nombre_producto VARCHAR2(100),
    categoria_producto VARCHAR2(50),
    cantidad NUMBER,
    precio_unitario NUMBER(10,2),
    subtotal_item NUMBER(10,2),
    forma_pago VARCHAR2(50),
    valor_total_factura NUMBER(10,2),
    CONSTRAINT pk_rep_ventas PRIMARY KEY (numero_factura, codigo_producto)
    USING INDEX TABLESPACE tbs_gcdistribuidor_indices
) TABLESPACE tbs_gcdistribuidor_datos;


-- Poblado de Reporte de Ventas Diarias
INSERT INTO REPORTE_VENTAS_DIARIAS
SELECT
    v.numero_factura, v.fecha,
    c.codigo_cliente, c.nombres_apellidos,
    e.nombre, e.cargo,
    p.codigo_producto, p.nombre, p.categoria,
    dv.cantidad, dv.precio_unitario,
    (dv.cantidad * dv.precio_unitario) AS subtotal_item,
    v.forma_pago, v.valor_total
FROM VENTAS v
JOIN DETALLE_VENTAS dv ON v.numero_factura = dv.numero_factura
JOIN CLIENTES c ON v.codigo_cliente = c.codigo_cliente
JOIN EMPLEADOS e ON v.codigo_empleado = e.codigo_empleado
JOIN PRODUCTOS p ON dv.codigo_producto = p.codigo_producto;

commit;

CREATE TABLE PRODUCTOS_CATALOGO_STOCK (
    codigo_producto VARCHAR2(20) PRIMARY KEY USING INDEX TABLESPACE tbs_gcdistribuidor_indices,
    nombre_producto VARCHAR2(100),
    categoria VARCHAR2(50),
    marca VARCHAR2(50),
    precio_venta NUMBER(10,2),
    -- Datos de Inventario embebidos directamente
    existencias_actuales NUMBER,
    stock_disponible NUMBER,
    -- Redundancia controlada para analítica
    total_unidades_vendidas NUMBER DEFAULT 0,
    total_ingresos_generados NUMBER(12,2) DEFAULT 0.00
) TABLESPACE tbs_gcdistribuidor_datos;

INSERT INTO PRODUCTOS_CATALOGO_STOCK
SELECT
    p.codigo_producto, p.nombre, p.categoria, p.marca, p.precio_venta,
    i.existencias_actuales, i.stock_disponible,
    NVL((SELECT SUM(cantidad) FROM DETALLE_VENTAS WHERE codigo_producto = p.codigo_producto), 0) AS total_vendido,
    NVL((SELECT SUM(cantidad * precio_unitario) FROM DETALLE_VENTAS WHERE codigo_producto = p.codigo_producto), 0) AS total_ingresos
FROM PRODUCTOS p
JOIN INVENTARIO i ON p.codigo_producto = i.codigo_producto;

CREATE TABLE CATALOGO_PROVEEDORES_PRODUCTOS (
    codigo_proveedor VARCHAR2(20),
    nombre_empresa VARCHAR2(100),
    pais_origen VARCHAR2(50),
    codigo_producto VARCHAR2(20),
    nombre_producto VARCHAR2(100),
    marca_producto VARCHAR2(50),
    precio_compra NUMBER(10,2),
    CONSTRAINT pk_cat_prov_prod PRIMARY KEY (codigo_proveedor, codigo_producto)
    USING INDEX TABLESPACE tbs_gcdistribuidor_indices
) TABLESPACE tbs_gcdistribuidor_datos;

INSERT INTO CATALOGO_PROVEEDORES_PRODUCTOS
SELECT
    pr.codigo_proveedor,
    pr.nombre_empresa,
    pr.pais_origen,
    p.codigo_producto,
    p.nombre AS nombre_producto,
    p.marca,
    p.precio_compra
FROM PROVEEDORES pr
JOIN PROVEEDOR_PRODUCTO pp ON pr.codigo_proveedor = pp.codigo_proveedor
JOIN PRODUCTOS p ON pp.codigo_producto = p.codigo_producto;

CREATE TABLE HISTORICO_PRECIOS_CONGELADOS (
    numero_factura VARCHAR2(20),
    codigo_producto VARCHAR2(20),
    nombre_producto VARCHAR2(100),
    precio_venta_catalogo NUMBER(10,2), -- Precio del maestro actual
    precio_congelado_factura NUMBER(10,2), -- El precio instantáneo cobrado
    diferencia_aplicada NUMBER(10,2), -- Descuentos o variaciones si existieran
    fecha_registro DATE,
    CONSTRAINT pk_hist_precios PRIMARY KEY (numero_factura, codigo_producto)
    USING INDEX TABLESPACE tbs_gcdistribuidor_indices
) TABLESPACE tbs_gcdistribuidor_datos;

-- Captura de la instantánea de precios basada en las ventas cruzadas
INSERT INTO HISTORICO_PRECIOS_CONGELADOS
SELECT
    dv.numero_factura,
    p.codigo_producto,
    p.nombre,
    p.precio_venta AS precio_venta_catalogo,
    dv.precio_unitario AS precio_congelado_factura,
    (p.precio_venta - dv.precio_unitario) AS diferencia_aplicada,
    v.fecha
FROM DETALLE_VENTAS dv
JOIN VENTAS v ON dv.numero_factura = v.numero_factura
JOIN PRODUCTOS p ON dv.codigo_producto = p.codigo_producto;

-- Guardar permanentemente en el contenedor
COMMIT;
drop table HISTORICO_PRECIOS_CONGELADOS;
commit;

DROP TABLE HISTORICO_PRECIOS_CONGELADOS;

CREATE TABLE HISTORICO_PRECIOS_CONGELADOS (
    numero_factura VARCHAR2(20),
    codigo_producto VARCHAR2(20),
    nombre_producto VARCHAR2(100),
    cantidad_vendida NUMBER,
    precio_congelado_factura NUMBER(10,2), -- El precio instantáneo cobrado
    subtotal_congelado NUMBER(10,2),       -- ¡NUEVO CAMPO REDUNDANTE PRECALCULADO!
    fecha_registro DATE,
    CONSTRAINT pk_hist_precios PRIMARY KEY (numero_factura, codigo_producto)
    USING INDEX TABLESPACE tbs_gcdistribuidor_indices
) TABLESPACE tbs_gcdistribuidor_datos;

INSERT INTO HISTORICO_PRECIOS_CONGELADOS
SELECT
    dv.numero_factura,
    p.codigo_producto,
    p.nombre,
    dv.cantidad,
    dv.precio_unitario,
    (dv.cantidad * dv.precio_unitario) AS subtotal_congelado, -- Se calcula aquí al guardar
    v.fecha
FROM DETALLE_VENTAS dv
JOIN VENTAS v ON dv.numero_factura = v.numero_factura
JOIN PRODUCTOS p ON dv.codigo_producto = p.codigo_producto;

-- Guardar permanentemente en el contenedor
COMMIT;