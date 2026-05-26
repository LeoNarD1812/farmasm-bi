
    
    

select
    producto_key as unique_field,
    count(*) as n_records

from "farmacia_dw"."marts_marts"."dim_producto"
where producto_key is not null
group by producto_key
having count(*) > 1


