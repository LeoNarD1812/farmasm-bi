
  create view "farmacia_dw"."marts_staging"."stg_ventas_cabecera__dbt_tmp"
    
    
  as (
    with source as ( select * from "farmacia_dw"."raw"."ventas_cabecera" )
select id_venta, fecha_emision, id_cliente from source
  );