--Consultas

--Vemos la carta
SELECT nombre, precioVenta FROM ProductoALimenticio;

--Nos aseguramos que el burrito vegetariano, de verdad sea vegetariano
SELECT Preparar.idIngrediente, nombre 
FROM Preparar INNER JOIN Ingrediente 
ON Preparar.idIngrediente = Ingrediente.idIngrediente 
WHERE idProductoALimenticio = 6;

--Recomendaciones de platillos para pico de gallo
SELECT ProductoAlimenticio.idProductoAlimenticio, ProductoALimenticio.nombre
FROM RecomendarConSalsa INNER JOIN ProductoAlimenticio
ON RecomendarConSalsa.idProductoALimenticio = ProductoAlimenticio.idProductoAlimenticio 
WHERE idSalsa= 5;

--Compramos mesas grandes de otra marca a diferente provedor
UPDATE ProductoNoPerecedero
SET idprovedor = 2, cantidad = 20, marca = 'MESAS JIMENEZ', fechaAdquisicion='2022-12-12', precioCompra=2500.26
where idProductoNoPerecedero = 1;

--Compramos tomates de distinta marca 
UPDATE Ingrediente
SET cantidad = 26, marca = 'Tomates DEL SUR', fechaAdquisicion='2022-06-14', precioCompra=30.8, fechaCaducidad='2022-07-17'
where idIngrediente = 1;

-- Dinero que se le ha pagado al provedor 2 por productos no perecederos.
UPDATE ProductoNoPerecedero
SET idprovedor = 2, cantidad = 20, marca = 'MESAS JIMENEZ', fechaAdquisicion='2023-01-2', precioCompra=506.26
where idProductoNoPerecedero = 1;

UPDATE ProductoNoPerecedero
SET idprovedor = 2, cantidad = 20, marca = 'MESAS SANCHEZ', fechaAdquisicion='2023-02-12', precioCompra=6000.26
where idProductoNoPerecedero = 1;

UPDATE ProductoNoPerecedero
SET idprovedor = 2, cantidad = 20, marca = 'MESAS SANCHEZ', fechaAdquisicion='2022-03-12', precioCompra=700.26
where idProductoNoPerecedero = 1;

SELECT sum(precioCompra) FROM RegistroProductoNoPerecedero
where idprovedor = 2;

-- Obtener RFC, salario, Nombre, ApellidoPaterno, ApellidoMaterno, FechaNacimiento, FechaInicio, fechaultaumento, telefono y correo de los empleados de la sucursal con id 3
SELECT RFC,salario,Nombre,ApellidoPaterno,ApellidoMaterno,FechaNacimiento,FechaInicio,fechaultaumento,telefono,correo 
FROM Empleado INNER JOIN Persona 
ON Empleado.CURP = Persona.Curp 
WHERE Empleado.IdSucursal = 3;

-- Obtener el total de los ingresos de la franquicia en la fecha 2021-12-21
SELECT SUM(total) AS TotalIngresos FROM Recibo WHERE fecha = '2021-12-21';

-- Obtener todos los datos de los ingredientes con fecha de caducidad menor al proximo mes
SELECT * FROM Ingrediente WHERE Ingrediente.fechaCaducidad < CURRENT_DATE + INTERVAL '1 month';

--Obtener el menú de la sucursal con id 1
SELECT IdTipo,Nombre,PrecioVenta,Descripcion 
FROM OfertarAlimento INNER JOIN ProductoAlimenticio 
ON OfertarAlimento.idproductoalimenticio = ProductoAlimenticio.idproductoalimenticio 
WHERE IdSucursal = 1;

--Obtener los CURP y Puntos de los clientes con una cantidad de puntos mayor a 500 y menor a 1500
SELECT * FROM Cliente WHERE Puntos BETWEEN 500 AND 1500;

-- Numero de los empleados que trabajan en la sucursal 1
select count(sucursal.idsucursal) from sucursal join empleado on sucursal.idsucursal= empleado.idsucursal -- natural join persona
where sucursal.idsucursal = 1;

-- Obtener el total que se pagó a cada provedor por los ingredientes actuales
select idprovedor, sum(preciocompra) from ingrediente
group by idprovedor;

--Numero de pedidos a domicilio y para comer en la sucursal
select tipo, count(tipo) from pedido
group by tipo;

-- Productos mas pedidos
select idproductoalimenticio, count(idproductoalimenticio) as veces into aux1 from pedir  
group by idproductoalimenticio;

select idproductoalimenticio, veces, nombre from aux1 natural join productoalimenticio
order by veces desc;


