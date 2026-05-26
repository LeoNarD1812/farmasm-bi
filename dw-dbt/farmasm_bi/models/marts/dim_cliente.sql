with clientes as ( select * from {{ ref('stg_clientes') }} )
select
    row_number() over (order by id_cliente) as cliente_key,
    id_cliente,
    nombre_cliente,
    ruc_dni
from clientes