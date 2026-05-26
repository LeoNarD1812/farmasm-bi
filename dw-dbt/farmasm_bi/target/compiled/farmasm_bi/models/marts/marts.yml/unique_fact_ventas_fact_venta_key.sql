
    
    

select
    fact_venta_key as unique_field,
    count(*) as n_records

from "farmacia_dw"."marts_marts"."fact_ventas"
where fact_venta_key is not null
group by fact_venta_key
having count(*) > 1


