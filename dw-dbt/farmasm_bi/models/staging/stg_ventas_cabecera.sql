with source as ( select * from {{ source('raw', 'ventas_cabecera') }} )
select id_venta, fecha_emision, id_cliente from source
