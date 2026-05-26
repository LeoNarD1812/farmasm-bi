with source as (
    select * from "farmacia_dw"."raw"."productos"
)
select
    id_producto,
    nombre_producto,
    id_categoria,
    id_marca,
    id_proveedor,
    cast(stock_actual as integer) as stock_actual,
    cast(fecha_vencimiento as date) as fecha_vencimiento,
    cast(costo_unitario as decimal(10,2)) as costo_unitario,
    fecha_modificacion
from source