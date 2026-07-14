-- 1. Tablespace para los DATOS de la empresa
CREATE TABLESPACE tbs_gcdistribuidor_datos
DATAFILE '/opt/oracle/oradata/gcdistribuidor_datos01.dbf' SIZE 50M
AUTOEXTEND ON NEXT 10M MAXSIZE 1G;

-- 2. Tablespace para los INDICES de la empresa
CREATE TABLESPACE tbs_gcdistribuidor_indices
DATAFILE '/opt/oracle/oradata/gcdistribuidor_indices01.dbf' SIZE 20M
AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

-- 3. Crear el usuario con el nombre de la empresa
CREATE USER gcdistribuidor IDENTIFIED BY "gcPassword"
DEFAULT TABLESPACE tbs_gcdistribuidor_datos;

-- 4. Darle permiso (cuota) para usar el espacio de nuestros tablespaces
ALTER USER gcdistribuidor QUOTA UNLIMITED ON tbs_gcdistribuidor_datos;
ALTER USER gcdistribuidor QUOTA UNLIMITED ON tbs_gcdistribuidor_indices;

-- 5. Otorgarle los roles "tipicos" para conectarse y crear tablas
GRANT CONNECT, RESOURCE TO gcdistribuidor;
