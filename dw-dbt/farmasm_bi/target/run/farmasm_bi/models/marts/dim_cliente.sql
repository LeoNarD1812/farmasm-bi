
  
    

  create  table "farmacia_dw"."marts_marts"."dim_cliente__dbt_tmp"
  
  
    as
  
  (
    with clientes as ( select * from "farmacia_dw"."marts_staging"."stg_clientes" )
select
    row_number() over (order by id_cliente) as cliente_key,
    id_cliente,
    nombre_cliente,
    ruc_dni
from clientes
  );
  