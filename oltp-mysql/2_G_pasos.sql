USE farmadb;

-- P2: INTEGRACIÓN Y PASOS INTERMEDIOS (VISTAS G)
-- Este script es el puente que el ingeniero requiere para validar la lógica analítica

CREATE OR REPLACE VIEW vw_g_ventas AS
SELECT 
    vc.id_venta,
    vd.id_detalle,
    CAST(DATE_FORMAT(vc.fecha_emision, '%Y%m%d') AS UNSIGNED) AS fecha_key,
    dc.cliente_key,
    dv.vendedor_key,
    dp.producto_key,
    vc.comprobante_tipo,
    vc.serie,
    vc.numero,
    vc.metodo_pago,
    vd.cantidad AS cantidad_vendida,
    vd.precio_unitario AS precio_unitario_venta,
    vd.subtotal AS subtotal_venta,
    dp.costo_unitario,
    (vd.cantidad * dp.costo_unitario) AS costo_total,
    (vd.subtotal - (vd.cantidad * dp.costo_unitario)) AS margen_bruto
FROM ventas_detalle vd
INNER JOIN ventas_cabecera vc ON vd.id_venta = vc.id_venta
INNER JOIN dim_cliente dc ON vc.id_cliente = dc.cliente_id
INNER JOIN dim_vendedor dv ON vc.id_vendedor = dv.vendedor_id
INNER JOIN dim_producto dp ON vd.id_producto = dp.producto_id;