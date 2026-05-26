
  
    

  create  table "farmacia_dw"."marts_marts"."fact_inventario__dbt_tmp"
  
  
    as
  
  (
    with inv as ( select * from "farmacia_dw"."marts_staging"."stg_inventario" ),
     dp as ( select * from "farmacia_dw"."marts_marts"."dim_producto" )

select
    row_number() over () as fact_inventario_key,
    inv.id_inventario,
    to_char(inv.fecha_corte, 'YYYYMMDD')::integer as fecha_key,
    dp.producto_key,
    inv.stock_actual,
    inv.faltantes,
    inv.sobrantes,
    case 
        when inv.stock_actual = 0 then 0.0
        else cast(inv.faltantes as numeric) / inv.stock_actual
    end as pct_quiebre
from inv
inner join dp on inv.id_producto = dp.id_producto
  );
  