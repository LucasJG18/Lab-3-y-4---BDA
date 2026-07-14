-- TABLAS INDEPENDIENTES
CREATE TABLE CLIENTES (
    codigo_cliente VARCHAR2(20) PRIMARY KEY USING INDEX TABLESPACE tbs_gcdistribuidor_indices,
    nombres_apellidos VARCHAR2(100),
    identificacion VARCHAR2(20),
    telefono VARCHAR2(15),
    correo_electronico VARCHAR2(100),
    direccion VARCHAR2(200)
) TABLESPACE tbs_gcdistribuidor_datos;

CREATE TABLE PROVEEDORES (
    codigo_proveedor VARCHAR2(20) PRIMARY KEY USING INDEX TABLESPACE tbs_gcdistribuidor_indices,
    nombre_empresa VARCHAR2(100),
    pais_origen VARCHAR2(50),
    persona_contacto VARCHAR2(100),
    telefono VARCHAR2(15),
    correo_electronico VARCHAR2(100)
) TABLESPACE tbs_gcdistribuidor_datos;

CREATE TABLE PRODUCTOS (
    codigo_producto VARCHAR2(20) PRIMARY KEY USING INDEX TABLESPACE tbs_gcdistribuidor_indices,
    nombre VARCHAR2(100),
    categoria VARCHAR2(50),
    marca VARCHAR2(50),
    color VARCHAR2(30),
    medidas VARCHAR2(50),
    precio_compra NUMBER(10,2),
    precio_venta NUMBER(10,2)
) TABLESPACE tbs_gcdistribuidor_datos;

CREATE TABLE EMPLEADOS (
    codigo_empleado VARCHAR2(20) PRIMARY KEY USING INDEX TABLESPACE tbs_gcdistribuidor_indices,
    nombre VARCHAR2(100),
    cargo VARCHAR2(50),
    telefono VARCHAR2(15),
    correo_electronico VARCHAR2(100),
    fecha_contratacion DATE
) TABLESPACE tbs_gcdistribuidor_datos;

-- TABLAS DEPENDIENTES
CREATE TABLE INVENTARIO (
    codigo_producto VARCHAR2(20) PRIMARY KEY USING INDEX TABLESPACE tbs_gcdistribuidor_indices,
    existencias_actuales NUMBER,
    entradas_productos NUMBER,
    salidas_productos NUMBER,
    stock_minimo NUMBER,
    stock_disponible NUMBER,
    CONSTRAINT fk_inv_prod FOREIGN KEY (codigo_producto) REFERENCES PRODUCTOS(codigo_producto) ON DELETE CASCADE
) TABLESPACE tbs_gcdistribuidor_datos;

CREATE TABLE COMPRAS (
    numero_compra VARCHAR2(20) PRIMARY KEY USING INDEX TABLESPACE tbs_gcdistribuidor_indices,
    fecha DATE,
    codigo_proveedor VARCHAR2(20),
    costo_total NUMBER(10,2),
    CONSTRAINT fk_comp_prov FOREIGN KEY (codigo_proveedor) REFERENCES PROVEEDORES(codigo_proveedor)
) TABLESPACE tbs_gcdistribuidor_datos;

CREATE TABLE DETALLE_COMPRAS (
    numero_compra VARCHAR2(20),
    codigo_producto VARCHAR2(20),
    cantidad NUMBER,
    costo_unitario NUMBER(10,2),
    CONSTRAINT pk_det_comp PRIMARY KEY (numero_compra, codigo_producto) USING INDEX TABLESPACE tbs_gcdistribuidor_indices,
    CONSTRAINT fk_det_comp_num FOREIGN KEY (numero_compra) REFERENCES COMPRAS(numero_compra) ON DELETE CASCADE,
    CONSTRAINT fk_det_comp_prod FOREIGN KEY (codigo_producto) REFERENCES PRODUCTOS(codigo_producto)
) TABLESPACE tbs_gcdistribuidor_datos;

CREATE TABLE VENTAS (
    numero_factura VARCHAR2(20) PRIMARY KEY USING INDEX TABLESPACE tbs_gcdistribuidor_indices,
    fecha DATE,
    codigo_cliente VARCHAR2(20),
    codigo_empleado VARCHAR2(20),
    forma_pago VARCHAR2(50),
    valor_total NUMBER(10,2),
    CONSTRAINT fk_ven_cli FOREIGN KEY (codigo_cliente) REFERENCES CLIENTES(codigo_cliente),
    CONSTRAINT fk_ven_emp FOREIGN KEY (codigo_empleado) REFERENCES EMPLEADOS(codigo_empleado)
) TABLESPACE tbs_gcdistribuidor_datos;

CREATE TABLE DETALLE_VENTAS (
    numero_factura VARCHAR2(20),
    codigo_producto VARCHAR2(20),
    cantidad NUMBER,
    precio_unitario NUMBER(10,2),
    CONSTRAINT pk_det_ven PRIMARY KEY (numero_factura, codigo_producto) USING INDEX TABLESPACE tbs_gcdistribuidor_indices,
    CONSTRAINT fk_det_ven_num FOREIGN KEY (numero_factura) REFERENCES VENTAS(numero_factura) ON DELETE CASCADE,
    CONSTRAINT fk_det_ven_prod FOREIGN KEY (codigo_producto) REFERENCES PRODUCTOS(codigo_producto)
) TABLESPACE tbs_gcdistribuidor_datos;

CREATE TABLE PROVEEDOR_PRODUCTO (
    codigo_proveedor VARCHAR2(20),
    codigo_producto VARCHAR2(20),
    CONSTRAINT pk_prov_prod PRIMARY KEY (codigo_proveedor, codigo_producto) USING INDEX TABLESPACE tbs_gcdistribuidor_indices,
    CONSTRAINT fk_pp_prov FOREIGN KEY (codigo_proveedor) REFERENCES PROVEEDORES(codigo_proveedor) ON DELETE CASCADE,
    CONSTRAINT fk_pp_prod FOREIGN KEY (codigo_producto) REFERENCES PRODUCTOS(codigo_producto) ON DELETE CASCADE
) TABLESPACE tbs_gcdistribuidor_datos;
