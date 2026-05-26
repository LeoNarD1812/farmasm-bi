with source as ( select * from {{ source('raw', 'productos') }} )
select id_producto, nombre_producto, costo_unitario from source
