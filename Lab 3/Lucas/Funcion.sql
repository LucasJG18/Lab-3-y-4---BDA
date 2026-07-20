CREATE OR REPLACE FUNCTION fn_verificar_stock (
    p_codigo_producto IN VARCHAR2,
    p_cantidad_requerida IN NUMBER
) RETURN NUMBER IS
    v_stock_disponible NUMBER;
BEGIN
    -- Buscamos el stock actual del producto
    SELECT stock_disponible INTO v_stock_disponible
    FROM INVENTARIO
    WHERE codigo_producto = p_codigo_producto;

    -- Comparamos si nos alcanza
    IF v_stock_disponible >= p_cantidad_requerida THEN
        RETURN 1; -- Verdadero: Sí hay stock
    ELSE
        RETURN 0; -- Falso: No alcanza el stock
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- Si el producto no existe, devolvemos 0
END fn_verificar_stock;
/
