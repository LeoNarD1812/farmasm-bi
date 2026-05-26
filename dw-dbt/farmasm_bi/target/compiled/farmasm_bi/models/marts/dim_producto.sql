with prod as ( select * from "farmacia_dw"."marts_staging"."stg_productos" ),
     cat as ( select * from "farmacia_dw"."raw"."categorias" ),
     mar as ( select * from "farmacia_dw"."raw"."marcas" ),
     prov as ( select * from "farmacia_dw"."raw"."proveedores" )

select
    row_number() over (order by prod.id_producto) as producto_key,
    prod.id_producto,
    prod.nombre_producto,
    coalesce(cat.nombre_categoria, 'SIN CATEGORIA') as nombre_categoria,
    coalesce(mar.nombre_marca, 'SIN MARCA') as nombre_marca,
    coalesce(prov.nombre_proveedor, 'SIN PROVEEDOR') as nombre_proveedor,
    prod.costo_unitario
from prod
left join cat on prod.id_categoria = cat.id_categoria
left join mar on prod.id_marca = mar.id_marca
left join prov on prod.id_proveedor = prov.id_proveedor