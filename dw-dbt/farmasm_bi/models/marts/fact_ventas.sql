with det as ( select * from {{ ref('stg_ventas_detalle') }} ),
     cab as ( select * from {{ ref('stg_ventas_cabecera') }} ),
     dp as ( select * from {{ ref('dim_producto') }} ),
     dc as ( select * from {{ ref('dim_cliente') }} )
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
