
  
    

  create  table "farmacia_dw"."marts_marts"."dim_producto__dbt_tmp"
  
  
    as
  
  (
    with stg as ( select * from "farmacia_dw"."marts_staging"."stg_productos" )
select row_number() over (order by id_producto) as producto_key, id_producto, nombre_producto from stg
  );
  