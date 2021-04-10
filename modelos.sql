CREATE DATABASE prueba;
\c prueba;

CREATE TABLE cliente(
  id SERIAL PRIMARY KEY, 
  nombre VARCHAR(50) NOT NULL,
  rut INT NOT NULL UNIQUE,
  direccion VARCHAR(100) NOT NULL
);

CREATE TABLE cliente_factura (
    cliente_id INT,
    factura_id INT
);

CREATE TABLE factura(
  numero_factura INT PRIMARY KEY, 
  fecha_factura DATE NOT NULL,
  subtotal INT NOT NULL DEFAULT(0),
  iva INT NOT NULL DEFAULT(0),
  precio_total INT NOT NULL DEFAULT(0)
);

CREATE TABLE factura_detalle(
  factura_id INT,
  detalle_id INT
);

CREATE TABLE detalle(
  id SERIAL PRIMARY KEY,
  sub_total INT NOT NULL,
  cantidad INT NOT NULL,
  total INT NOT NULL,
  id_producto INT
);

CREATE TABLE categoria(
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(150)
);

CREATE TABLE productos(
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(150),
  valor_unitario INT NOT NULL,
  id_categoria INT
);

ALTER TABLE cliente_factura
  ADD FOREIGN KEY (cliente_id)
  REFERENCES cliente(id);

ALTER TABLE cliente_factura
  ADD FOREIGN KEY (factura_id)
  REFERENCES factura(numero_factura);

ALTER TABLE factura_detalle
  ADD FOREIGN KEY (factura_id)
  REFERENCES factura(numero_factura);

ALTER TABLE factura_detalle
  ADD FOREIGN KEY (detalle_id)
  REFERENCES detalle(id);
  
ALTER TABLE productos
  ADD FOREIGN KEY (id_categoria)
  REFERENCES categoria(id);

ALTER TABLE detalle
  ADD FOREIGN KEY (id_producto)
  REFERENCES productos(id);

INSERT INTO cliente (rut, nombre, direccion) 
VALUES (18178256, 'Andoni Serrano', 'Avenida Del Valle, 869'),
(24929290, 'Jose Manuel', 'José Joaquín Prieto 4504'),
(8874179, 'Herminia Roman', 'Calle Los Corteses 5714'),
(19637138, 'Maria Raquel', 'Avenida Rancagua 857'),
(1201245, 'Luis Francisco', 'Avenida Santa Rosa 3660');

INSERT INTO categoria (nombre, descripcion) 
VALUES ('mouses', 'mouses alambricos e inalambricos'),
('audio', 'parlantes y audifonos'),
('TV', 'televisores LED de alta resolucion');

INSERT INTO productos (nombre, descripcion, valor_unitario, id_categoria) 
VALUES ('Parlante', 'parlante sony', 35, 2),
('LED 32 1080p', 'televisor samsung', 75, 3),
('mouse inalambrico', 'mouse kingston', 25, 1),
('mouse', 'mouse marca logitech', 10, 1),
('control remoto', 'control remoto universal', 15, 3),
('audifonos', 'audifonos pastilla sony', 7, 2),
('audifonos bluetooth', 'audifonos inalambricos samsung', 45, 2),
('LED 4k 42', 'oferta tv lg', 150, 3);

INSERT INTO factura (numero_factura, fecha_factura, subtotal, iva, precio_total) 
VALUES (9595, '2020-10-07', 70, 7, 77),
(3530, '2021-02-15', 89, 9, 98),
(8065, '2020-11-25', 21, 2, 23),
(2054, '2021-01-05', 120, 12, 132),
(3045, '2021-02-18', 35, 4, 39),
(4598, '2020-08-15', 150, 15, 165),
(1548, '2021-03-14', 100, 10, 110),
(9580, '2020-11-25', 49, 5, 54),
(5210,'2020-12-15', 70, 7, 77),
(5684,'2021-02-23', 150, 15, 165);

INSERT INTO cliente_factura (cliente_id,factura_id)
VALUES (1,9595),
(1,3530),
(2,8065),
(2,2054),
(2,3045),
(3,4598),
(4,1548),
(4,9580),
(4,5210),
(4,5684);

INSERT INTO detalle (sub_total, cantidad, total, id_producto)
VALUES(35, 2, 70, 1),
(75, 1, 75, 2),
(7, 2, 14, 6),
(7, 3, 21, 6),
(45, 1, 45, 7),
(75, 1, 75, 2),
(10, 2, 20, 4),
(15, 1, 15, 5),
(150, 1, 150, 8),
(75, 1, 75, 2),
(25, 1, 25, 3),
(7, 2, 14, 6),
(35, 1, 35, 1),
(25, 2, 50, 3),
(10, 2, 20, 4),
(150, 1, 150, 8);

INSERT INTO factura_detalle (factura_id, detalle_id)
VALUES (9595, 1),
(3530, 2),
(3530, 3),
(8065, 4),
(2054, 5),
(2054, 6),
(3045, 7),
(3045, 8),
(4598, 9),
(1548, 10),
(1548, 11),
(9580, 12),
(9580, 13),
(5210, 14),
(5210, 15),
(5684, 16);
--consultas

--¿Que cliente realizó la compra más cara?
SELECT
	nombre, precio_total
FROM
    cliente_factura
INNER JOIN cliente 
    ON id = cliente_id
INNER JOIN factura 
    ON numero_factura = factura_id
ORDER BY precio_total DESC LIMIT 1
;

--¿Que cliente pagó sobre 100 de monto?

SELECT
	nombre, precio_total
FROM
    cliente_factura
INNER JOIN cliente 
    ON id = cliente_id
INNER JOIN factura 
    ON numero_factura = factura_id
WHERE precio_total > 100
;

--¿Cuantos clientes han comprado el producto 6

SELECT
    SUM ( 1 * cantidad) AS producto_6
FROM
    detalle
WHERE 
    id_producto = 6
;