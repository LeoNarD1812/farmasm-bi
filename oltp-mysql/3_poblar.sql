USE farmadb;
SET lc_time_names = 'es_ES';

-- P2: ETL MANUAL PARA DIMENSIONES Y HECHOS (VISTA G)

-- Limpieza previa para evitar duplicados si corres el script varias veces
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM fact_ventas;
DELETE FROM fact_inventario;
DELETE FROM dim_fecha;
DELETE FROM dim_producto;
DELETE FROM dim_vendedor;
DELETE FROM dim_cliente;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Poblar Dimensiones
INSERT INTO dim_cliente (cliente_id, nombre_cliente, ruc_dni)
SELECT id_cliente, nombre_cliente, ruc_dni FROM clientes;

INSERT INTO dim_vendedor (vendedor_id, nombre_vendedor)
SELECT id_vendedor, nombre_vendedor FROM vendedores;

INSERT INTO dim_producto (producto_id, nombre_producto, nombre_categoria, nombre_marca, nombre_proveedor, costo_unitario)
SELECT 
    p.id_producto, p.nombre_producto, 
    COALESCE(c.nombre_categoria, 'SIN CATEGORIA'), 
    COALESCE(m.nombre_marca, 'SIN MARCA'), 
    COALESCE(pr.nombre_proveedor, 'SIN PROVEEDOR'), 
    p.costo_unitario
FROM productos p
LEFT JOIN categorias c ON p.id_categoria = c.id_categoria
LEFT JOIN marcas m ON p.id_marca = m.id_marca
LEFT JOIN proveedores pr ON p.id_proveedor = pr.id_proveedor;

-- UNION para que dim_fecha contenga las fechas de ventas Y de inventario
INSERT IGNORE INTO dim_fecha (fecha_key, fecha, dia, dia_semana_desc, mes, mes_desc, trimestre, anio)
SELECT DISTINCT
    CAST(DATE_FORMAT(fecha, '%Y%m%d') AS UNSIGNED),
    DATE(fecha), DAY(fecha), DAYNAME(fecha),
    MONTH(fecha), MONTHNAME(fecha), QUARTER(fecha), YEAR(fecha)
FROM (
    SELECT fecha_emision AS fecha FROM ventas_cabecera
    UNION
    SELECT fecha_corte AS fecha FROM inventario
) fechas_combinadas;

-- 2. Construcción de Vistas G (Recrear por si acaso)
CREATE OR REPLACE VIEW vw_g_ventas AS
SELECT 
    vc.id_venta, vd.id_detalle, CAST(DATE_FORMAT(vc.fecha_emision, '%Y%m%d') AS UNSIGNED) AS fecha_key,
    dc.cliente_key, dv.vendedor_key, dp.producto_key,
    vc.comprobante_tipo, vc.serie, vc.numero, vc.metodo_pago,
    vd.cantidad AS cantidad_vendida, vd.precio_unitario AS precio_unitario_venta, vd.subtotal AS subtotal_venta,
    dp.costo_unitario, (vd.cantidad * dp.costo_unitario) AS costo_total, (vd.subtotal - (vd.cantidad * dp.costo_unitario)) AS margen_bruto
FROM ventas_detalle vd
INNER JOIN ventas_cabecera vc ON vd.id_venta = vc.id_venta
INNER JOIN dim_cliente dc ON vc.id_cliente = dc.cliente_id
INNER JOIN dim_vendedor dv ON vc.id_vendedor = dv.vendedor_id
INNER JOIN dim_producto dp ON vd.id_producto = dp.producto_id;

CREATE OR REPLACE VIEW vw_g_inventario AS
SELECT 
    i.id_inventario, CAST(DATE_FORMAT(i.fecha_corte, '%Y%m%d') AS UNSIGNED) AS fecha_key,
    dp.producto_key, i.stock_actual, i.faltantes, i.sobrantes,
    CASE WHEN i.stock_actual = 0 THEN 0 ELSE (i.faltantes / i.stock_actual) END AS pct_quiebre
FROM inventario i
INNER JOIN dim_producto dp ON i.id_producto = dp.producto_id;

-- 3. Cargar las Tablas de Hechos
INSERT INTO fact_ventas (
    id_venta, id_detalle, fecha_key, cliente_key, vendedor_key, producto_key,
    comprobante_tipo, serie, numero, metodo_pago,
    cantidad_vendida, precio_unitario_venta, subtotal_venta, costo_unitario, costo_total, margen_bruto
)
SELECT * FROM vw_g_ventas;

INSERT INTO fact_inventario (
    id_inventario, fecha_key, producto_key, stock_actual, faltantes, sobrantes, pct_quiebre
)
SELECT * FROM vw_g_inventario;