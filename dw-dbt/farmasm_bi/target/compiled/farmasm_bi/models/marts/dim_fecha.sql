with fechas as (
    select fecha_emision::date as fecha from "farmacia_dw"."marts_staging"."stg_ventas_cabecera"
    union
    select fecha_corte as fecha from "farmacia_dw"."marts_staging"."stg_inventario"
)
select
    to_char(fecha, 'YYYYMMDD')::integer as fecha_key,
    fecha,
    extract(day from fecha)::integer as dia,
    extract(month from fecha)::integer as mes,
    to_char(fecha, 'TMMonth') as mes_desc,
    extract(quarter from fecha)::integer as trimestre,
    extract(year from fecha)::integer as anio
from fechas