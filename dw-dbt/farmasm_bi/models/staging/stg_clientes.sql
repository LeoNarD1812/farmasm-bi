with source as ( select * from {{ source('raw', 'clientes') }} )
select id_cliente, nombre_cliente from source
