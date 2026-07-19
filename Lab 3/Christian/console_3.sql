--Casi 1
SELECT
    v.numero_factura, v.fecha,
    c.codigo_cliente, c.nombres_apellidos AS cliente,
    e.nombre AS empleado,
    p.codigo_producto, p.nombre AS producto,
    dv.cantidad, dv.precio_unitario,
    (dv.cantidad * dv.precio_unitario) AS subtotal_item
FROM VENTAS v
JOIN DETALLE_VENTAS dv ON v.numero_factura = dv.numero_factura
JOIN CLIENTES c ON v.codigo_cliente = c.codigo_cliente
JOIN EMPLEADOS e ON v.codigo_empleado = e.codigo_empleado
JOIN PRODUCTOS p ON dv.codigo_producto = p.codigo_producto
WHERE v.fecha BETWEEN TO_DATE('2026-05-01', 'YYYY-MM-DD') AND TO_DATE('2026-05-31', 'YYYY-MM-DD');


SELECT
    numero_factura, fecha_venta,
    codigo_cliente, nombre_cliente,
    nombre_empleado,
    codigo_producto, nombre_producto,
    cantidad, precio_unitario, subtotal_item
FROM REPORTE_VENTAS_DIARIAS
WHERE fecha_venta BETWEEN TO_DATE('2026-05-01', 'YYYY-MM-DD') AND TO_DATE('2026-05-31', 'YYYY-MM-DD');

--Caso 2
SELECT
    p.codigo_producto, p.nombre, p.categoria, p.marca, p.precio_venta,
    i.existencias_actuales,
    NVL(SUM(dv.cantidad), 0) AS total_unidades_vendidas,
    NVL(SUM(dv.cantidad * dv.precio_unitario), 0) AS total_ingresos_generados
FROM PRODUCTOS p
JOIN INVENTARIO i ON p.codigo_producto = i.codigo_producto
LEFT JOIN DETALLE_VENTAS dv ON p.codigo_producto = dv.codigo_producto
WHERE p.categoria = 'Tecnologia'
GROUP BY p.codigo_producto, p.nombre, p.categoria, p.marca, p.precio_venta, i.existencias_actuales;

SELECT
    codigo_producto, nombre_producto, categoria, marca, precio_venta,
    existencias_actuales, total_unidades_vendidas, total_ingresos_generados
FROM PRODUCTOS_CATALOGO_STOCK
WHERE categoria = 'Tecnologia';

--Caso 3

SELECT
    pr.codigo_proveedor, pr.nombre_empresa, pr.pais_origen,
    p.codigo_producto, p.nombre AS nombre_producto, p.marca, p.precio_compra
FROM PROVEEDORES pr
JOIN PROVEEDOR_PRODUCTO pp ON pr.codigo_proveedor = pp.codigo_proveedor
JOIN PRODUCTOS p ON pp.codigo_producto = p.codigo_producto
WHERE pr.codigo_proveedor = 'PROV011';

SELECT
    codigo_proveedor, nombre_empresa, pais_origen,
    codigo_producto, nombre_producto, marca_producto, precio_compra
FROM CATALOGO_PROVEEDORES_PRODUCTOS
WHERE codigo_proveedor = 'PROV011';

--Caso 4

SELECT
    numero_factura,
    codigo_producto,
    cantidad,
    precio_unitario,
    (cantidad * precio_unitario) AS subtotal -- Operación costosa en tiempo de consulta
FROM DETALLE_VENTAS
WHERE numero_factura = 'FAC001';


SELECT
    numero_factura,
    codigo_producto,
    cantidad_vendida,
    precio_congelado_factura,
    subtotal_congelado -- Lectura directa, limpia y barata en recursos
FROM HISTORICO_PRECIOS_CONGELADOS
WHERE numero_factura = 'FAC001';