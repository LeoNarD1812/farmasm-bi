
  create view "farmacia_dw"."marts_staging"."stg_clientes__dbt_tmp"
    
    
  as (
    with source as ( select * from "farmacia_dw"."raw"."clientes" )
select id_cliente, nombre_cliente from source
  );