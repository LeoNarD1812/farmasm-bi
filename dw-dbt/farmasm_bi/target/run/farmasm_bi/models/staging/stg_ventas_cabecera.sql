
  create view "farmacia_dw"."marts_staging"."stg_ventas_cabecera__dbt_tmp"
    
    
  as (
    with source as (
    select * from "farmacia_dw"."raw"."ventas_cabecera"
)
select
    id_venta,
    comprobante_tipo,
    serie,
    numero,
    cast(fecha_emision as timestamp) as fecha_emision,
    id_vendedor,
    id_cliente,
    metodo_pago,
    cast(total_venta as decimal(10,2)) as total_venta,
    fecha_modificacion
from source
  );