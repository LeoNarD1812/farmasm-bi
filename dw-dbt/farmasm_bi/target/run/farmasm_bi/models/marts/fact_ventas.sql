
  
    

  create  table "farmacia_dw"."marts_marts"."fact_ventas__dbt_tmp"
  
  
    as
  
  (
    with det as ( select * from "farmacia_dw"."marts_staging"."stg_ventas_detalle" ),
     cab as ( select * from "farmacia_dw"."marts_staging"."stg_ventas_cabecera" ),
     dp as ( select * from "farmacia_dw"."marts_marts"."dim_producto" ),
     dc as ( select * from "farmacia_dw"."marts_marts"."dim_cliente" )

select
    row_number() over () as fact_venta_key,
    cab.id_venta,
    det.id_detalle,
    to_char(cab.fecha_emision, 'YYYYMMDD')::integer as fecha_key,
    dc.cliente_key,
    dp.producto_key,
    cab.comprobante_tipo,
    cab.serie,
    cab.numero,
    cab.metodo_pago,
    det.cantidad as cantidad_vendida,
    det.precio_unitario as precio_unitario_venta,
    det.subtotal as venta_neta,
    dp.costo_unitario,
    (det.cantidad * dp.costo_unitario) as costo_total,
    (det.subtotal - (det.cantidad * dp.costo_unitario)) as margen_bruto
from det
inner join cab on det.id_venta_fk = cab.id_venta
inner join dp on det.id_producto = dp.id_producto
inner join dc on cab.id_cliente = dc.id_cliente
  );
  