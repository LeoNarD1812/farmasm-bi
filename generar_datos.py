import csv
import os

print("Generando archivo farmadb.sql completo y limpiando texto...")

# Función para escapar comillas simples y evitar que SQL se rompa
def limpiar_texto(texto):
    return str(texto).replace("'", "''").strip()

try:
    with open('INVENTARIO_COMPRAS.csv', encoding='utf-8-sig') as f: inventario = list(csv.DictReader(f))
    with open('VENTAS_CABECERA.csv', encoding='utf-8-sig') as f: ventas_cab = list(csv.DictReader(f))
    with open('VENTAS_DETALLE.csv', encoding='utf-8-sig') as f: ventas_det = list(csv.DictReader(f))
except Exception as e:
    print(f"Error leyendo CSVs: {e}")
    exit()

cats, marcas, provs, vends, clientes = {}, {}, {}, {}, {}

for row in inventario:
    if row['Categoria'] not in cats: cats[row['Categoria']] = len(cats) + 1
    if row['Marca'] not in marcas: marcas[row['Marca']] = len(marcas) + 1
    if row['Proveedor'] not in provs: provs[row['Proveedor']] = len(provs) + 1

for row in ventas_cab:
    if row['Vendedor'] not in vends: vends[row['Vendedor']] = len(vends) + 1
    cli_key = (row['Cliente'], row['RUC'])
    if cli_key not in clientes: clientes[cli_key] = len(clientes) + 1

os.makedirs('oltp-mysql/mysql/init', exist_ok=True)

# Plantilla de creación de base de datos y tablas
sql_estructura = """CREATE DATABASE IF NOT EXISTS farmadb;
USE farmadb;

CREATE TABLE categorias (id_categoria INT PRIMARY KEY, nombre_categoria VARCHAR(100) NOT NULL);
CREATE TABLE marcas (id_marca INT PRIMARY KEY, nombre_marca VARCHAR(100) NOT NULL);
CREATE TABLE proveedores (id_proveedor INT PRIMARY KEY, nombre_proveedor VARCHAR(100) NOT NULL);
CREATE TABLE vendedores (id_vendedor INT PRIMARY KEY, nombre_vendedor VARCHAR(100) NOT NULL);
CREATE TABLE clientes (id_cliente INT PRIMARY KEY, nombre_cliente VARCHAR(150) NOT NULL, ruc_dni VARCHAR(20) NOT NULL);

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(250) NOT NULL,
    id_categoria INT,
    id_marca INT,
    stock_actual INT NOT NULL,
    fecha_vencimiento DATE,
    id_proveedor INT,
    costo_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    FOREIGN KEY (id_marca) REFERENCES marcas(id_marca),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

CREATE TABLE ventas_cabecera (
    id_venta INT PRIMARY KEY,
    comprobante_tipo VARCHAR(20) NOT NULL,
    serie VARCHAR(10) NOT NULL,
    numero INT NOT NULL,
    fecha_emision DATETIME NOT NULL,
    id_vendedor INT,
    id_cliente INT,
    metodo_pago VARCHAR(50) NOT NULL,
    total_gravada DECIMAL(10, 2) NOT NULL,
    total_igv DECIMAL(10, 2) NOT NULL,
    total_venta DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE ventas_detalle (
    id_detalle INT PRIMARY KEY,
    id_venta INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas_cabecera(id_venta) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- --- POBLADO DE DATOS MASIVO --- --
"""

try:
    with open('oltp-mysql/mysql/init/farmadb.sql', 'w', encoding='utf-8') as f:
        f.write(sql_estructura)

        f.write("INSERT INTO categorias VALUES " + ",\n".join([f"({v}, '{limpiar_texto(k)}')" for k,v in cats.items()]) + ";\n")
        f.write("INSERT INTO marcas VALUES " + ",\n".join([f"({v}, '{limpiar_texto(k)}')" for k,v in marcas.items()]) + ";\n")
        f.write("INSERT INTO proveedores VALUES " + ",\n".join([f"({v}, '{limpiar_texto(k)}')" for k,v in provs.items()]) + ";\n")
        f.write("INSERT INTO vendedores VALUES " + ",\n".join([f"({v}, '{limpiar_texto(k)}')" for k,v in vends.items()]) + ";\n")
        f.write("INSERT INTO clientes VALUES " + ",\n".join([f"({v}, '{limpiar_texto(k[0])}', '{limpiar_texto(k[1])}')" for k,v in clientes.items()]) + ";\n")

        prods = []
        for r in inventario:
            # Por si hay fechas vacías en el CSV
            fecha = r['Fecha_Vencimiento'] if r['Fecha_Vencimiento'].strip() else '2099-12-31'
            prods.append(f"({r['ID_Producto']}, '{limpiar_texto(r['Producto'])}', {cats[r['Categoria']]}, {marcas[r['Marca']]}, {r['Stock_Actual']}, '{fecha}', {provs[r['Proveedor']]}, {r['Costo_Unitario']})")
        f.write("INSERT INTO productos VALUES\n" + ",\n".join(prods) + ";\n")

        cabs = []
        venta_map = {}
        for i, r in enumerate(ventas_cab):
            id_venta = i + 1
            venta_map[f"{r['Comprobante']}-{r['Serie']}-{r['Numero']}"] = id_venta
            cabs.append(f"({id_venta}, '{limpiar_texto(r['Comprobante'])}', '{limpiar_texto(r['Serie'])}', {r['Numero']}, '{r['Fecha_Emision']}', {vends[r['Vendedor']]}, {clientes[(r['Cliente'], r['RUC'])]}, '{limpiar_texto(r['Metodo_Pago'])}', {r['Total_Gravada']}, {r['Total_IGV']}, {r['Total_Venta']})")
        f.write("INSERT INTO ventas_cabecera VALUES\n" + ",\n".join(cabs) + ";\n")

        dets = []
        for i, r in enumerate(ventas_det):
            dets.append(f"({i+1}, {venta_map[r['Comprobante_Ref']]}, {r['ID_Producto']}, {r['Cantidad']}, {r['Precio_Unitario']}, {r['Subtotal']})")
        f.write("INSERT INTO ventas_detalle VALUES\n" + ",\n".join(dets) + ";\n")

    print("¡Archivo SQL generado con éxito y a prueba de errores!")
except Exception as e:
    print(f"Error escribiendo SQL: {e}")