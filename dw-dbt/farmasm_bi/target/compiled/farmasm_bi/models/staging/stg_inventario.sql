with source as (
    select * from "farmacia_dw"."raw"."inventario"
)
select
    id_inventario,
    id_producto,
    cast(fecha_corte as date) as fecha_corte,
    cast(stock_actual as integer) as stock_actual,
    cast(faltantes as integer) as faltantes,
    cast(sobrantes as integer) as sobrantes,
    fecha_modificacion
from source