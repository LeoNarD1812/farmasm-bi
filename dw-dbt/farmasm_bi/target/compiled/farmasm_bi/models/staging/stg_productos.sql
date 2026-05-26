with source as ( select * from "farmacia_dw"."raw"."productos" )
select id_producto, nombre_producto, costo_unitario from source