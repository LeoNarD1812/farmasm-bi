
  create view "farmacia_dw"."marts_staging"."stg_ventas_detalle__dbt_tmp"
    
    
  as (
    with source as ( select * from "farmacia_dw"."raw"."ventas_detalle" )
select id_detalle, id_venta, id_producto, cantidad, precio_unitario, subtotal from source
  );