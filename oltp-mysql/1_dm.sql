USE farmadb;

-- 1. Dimensiones (Deben existir primero)
CREATE TABLE IF NOT EXISTS dim_cliente (
    cliente_key INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    nombre_cliente VARCHAR(150),
    ruc_dni VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS dim_vendedor (
    vendedor_key INT AUTO_INCREMENT PRIMARY KEY,
    vendedor_id INT NOT NULL,
    nombre_vendedor VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS dim_producto (
    producto_key INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    nombre_producto VARCHAR(250),
    nombre_categoria VARCHAR(100),
    nombre_marca VARCHAR(100),
    nombre_proveedor VARCHAR(100),
    costo_unitario DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS dim_fecha (
    fecha_key INT PRIMARY KEY,
    fecha DATE,
    dia INT,
    dia_semana_desc VARCHAR(20),
    mes INT,
    mes_desc VARCHAR(20),
    trimestre INT,
    anio INT
);

-- 2. Hechos (Ahora sí tienen a quién referenciar)
CREATE TABLE IF NOT EXISTS fact_ventas (
    fact_venta_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT,
    id_detalle INT,
    fecha_key INT,
    cliente_key INT,
    vendedor_key INT,
    producto_key INT,
    comprobante_tipo VARCHAR(20),
    serie VARCHAR(10),
    numero INT,
    metodo_pago VARCHAR(50),
    cantidad_vendida INT,
    precio_unitario_venta DECIMAL(10,2),
    subtotal_venta DECIMAL(10,2),
    costo_unitario DECIMAL(10,2),
    costo_total DECIMAL(10,2),
    margen_bruto DECIMAL(10,2),
    FOREIGN KEY (fecha_key) REFERENCES dim_fecha(fecha_key),
    FOREIGN KEY (cliente_key) REFERENCES dim_cliente(cliente_key),
    FOREIGN KEY (vendedor_key) REFERENCES dim_vendedor(vendedor_key),
    FOREIGN KEY (producto_key) REFERENCES dim_producto(producto_key)
);

CREATE TABLE IF NOT EXISTS fact_inventario (
    fact_inventario_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_inventario INT,
    fecha_key INT,
    producto_key INT,
    stock_actual INT,
    faltantes INT,
    sobrantes INT,
    pct_quiebre DECIMAL(10,4),
    FOREIGN KEY (fecha_key) REFERENCES dim_fecha(fecha_key),
    FOREIGN KEY (producto_key) REFERENCES dim_producto(producto_key)
);