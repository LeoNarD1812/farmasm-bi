
  create view "farmacia_dw"."marts_staging"."stg_ventas_detalle__dbt_tmp"
    
    
  as (
    with source as (
    select * from "farmacia_dw"."raw"."ventas_detalle"
)
select
    id_detalle,
    id_venta as id_venta_fk,
    id_producto,
    cast(cantidad as integer) as cantidad,
    cast(precio_unitario as decimal(10,2)) as precio_unitario,
    cast(subtotal as decimal(10,2)) as subtotal
from source
  );