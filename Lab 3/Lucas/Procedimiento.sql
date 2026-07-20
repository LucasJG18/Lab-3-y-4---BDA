CREATE OR REPLACE PROCEDURE sp_registrar_detalle_venta (
    p_numero_factura IN VARCHAR2,
    p_codigo_producto IN VARCHAR2,
    p_cantidad IN NUMBER,
    p_precio_unitario IN NUMBER
) IS
    v_hay_stock NUMBER;
BEGIN
    -- 1. Usar la función para validar stock antes de vender
    v_hay_stock := fn_verificar_stock(p_codigo_producto, p_cantidad);

    IF v_hay_stock = 1 THEN
        -- 2. Si hay stock, insertamos en el detalle de la venta
        INSERT INTO DETALLE_VENTAS (numero_factura, codigo_producto, cantidad, precio_unitario)
        VALUES (p_numero_factura, p_codigo_producto, p_cantidad, p_precio_unitario);

        DBMS_OUTPUT.PUT_LINE('Venta registrada con éxito.');
    ELSE
        -- 3. Si no hay stock, abortamos la misión y lanzamos un error
        RAISE_APPLICATION_ERROR(-20001, 'Error: Stock insuficiente para el producto ' || p_codigo_producto);
    END IF;
END sp_registrar_detalle_venta;
/
