
  create view "farmacia_dw"."marts_staging"."stg_productos__dbt_tmp"
    
    
  as (
    with source as ( select * from "farmacia_dw"."raw"."productos" )
select id_producto, nombre_producto, costo_unitario from source
  );