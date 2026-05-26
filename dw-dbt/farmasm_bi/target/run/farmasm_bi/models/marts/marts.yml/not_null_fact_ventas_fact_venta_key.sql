
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select fact_venta_key
from "farmacia_dw"."marts_marts"."fact_ventas"
where fact_venta_key is null



  
  
      
    ) dbt_internal_test