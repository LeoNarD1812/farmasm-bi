with source as ( select * from "farmacia_dw"."raw"."ventas_cabecera" )
select id_venta, fecha_emision, id_cliente from source