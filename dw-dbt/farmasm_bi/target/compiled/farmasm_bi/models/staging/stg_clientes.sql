with source as ( select * from "farmacia_dw"."raw"."clientes" )
select id_cliente, nombre_cliente from source