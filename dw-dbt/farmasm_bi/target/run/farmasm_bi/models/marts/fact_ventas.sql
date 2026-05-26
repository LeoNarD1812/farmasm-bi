
  
    

  create  table "farmacia_dw"."marts_marts"."fact_ventas__dbt_tmp"
  
  
    as
  
  (
    with det as ( select * from "farmacia_dw"."marts_staging"."stg_ventas_detalle" ),
     cab as ( select * from "farmacia_dw"."marts_staging"."stg_ventas_cabecera" ),
     dp as ( select * from "farmacia_dw"."marts_marts"."dim_producto" ),
     dc as ( select * from "farmacia_dw"."marts_marts"."dim_cliente" )
select
    row_number() over () as fact_venta_key,
    cab.fecha_emision,
    dc.cliente_key,
    dp.producto_key,
    det.cantidad as cantidad_vendida,
    det.subtotal as venta_neta
from det
inner join cab on det.id_venta = cab.id_venta
inner join dp on det.id_producto = dp.id_producto
inner join dc on cab.id_cliente = dc.id_cliente
  );
  