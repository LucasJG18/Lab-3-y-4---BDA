-- Trigger que automatiza las salidas del inventario cada vez que se inserta una venta

CREATE OR REPLACE TRIGGER trg_actualizar_inventario
AFTER INSERT ON DETALLE_VENTAS
FOR EACH ROW
BEGIN
    UPDATE INVENTARIO
    SET existencias_actuales = existencias_actuales - :NEW.cantidad,
        stock_disponible = stock_disponible - :NEW.cantidad,
        salidas_productos = NVL(salidas_productos, 0) + :NEW.cantidad
    WHERE codigo_producto = :NEW.codigo_producto;
END;
/
