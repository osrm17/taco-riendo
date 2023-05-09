DROP SCHEMA IF EXISTS public CASCADE;

CREATE SCHEMA public;

CREATE TABLE Sucursal (
	idSucursal SERIAL PRIMARY KEY,
	nombre VARCHAR(64) NOT NULL,
	RFC CHAR(13) NOT NULL UNIQUE CHECK (CHAR_LENGTH(RFC) = 13 AND RFC SIMILAR TO '[A-Z0-9]{13}'),
	codigoPostal  CHAR(5) NOT NULL CHECK (CHAR_LENGTH(codigoPostal) = 5 AND codigoPostal SIMILAR TO '[0-9]{5}'),
	estado VARCHAR(30) NOT NULL,
	calle VARCHAR(30) NOT NULL,
	numeroExt INT NOT NULL CHECK (numeroExt > 0),
	telefono CHAR(10) NOT NULL CHECK (CHAR_LENGTH(telefono) = 10 AND telefono SIMILAR TO '[0-9]{10}'),
	correo VARCHAR(64)
);
COMMENT ON TABLE Sucursal IS 'Tabla donde se guarda la informacion de las sucursales';
COMMENT ON COLUMN Sucursal.idSucursal IS 'El id de la sucursal que sirve de identificador';
COMMENT ON COLUMN Sucursal.nombre IS 'Nombre de la sucursal';
COMMENT ON COLUMN Sucursal.RFC IS 'RFC de la sucursal';
COMMENT ON COLUMN Sucursal.codigoPostal IS 'Código postal de donde está ubicada de la sucursal';
COMMENT ON COLUMN Sucursal.estado IS 'Estado donde está ubicada de la sucursal';
COMMENT ON COLUMN Sucursal.calle IS 'Calle donde está ubicada de la sucursal';
COMMENT ON COLUMN Sucursal.numeroExt IS 'Nuumero exterior de donde está ubicada de la sucursal';
COMMENT ON COLUMN Sucursal.telefono IS 'Telefono de la sucursal';
COMMENT ON COLUMN Sucursal.correo IS 'Correo de la sucursal';

CREATE TABLE Persona (
	CURP CHAR(18) NOT NULL UNIQUE CHECK (CHAR_LENGTH(CURP) = 18 AND CURP SIMILAR TO '[A-Z0-9]{18}') PRIMARY KEY ,
	nombre VARCHAR(30) NOT NULL,
    apellidoPaterno VARCHAR(30) NOT NULL,
    apellidoMaterno VARCHAR(30) NOT NULL,
	fechaNacimiento DATE NOT NULL,
	codigoPostal  CHAR(5) NOT NULL CHECK (CHAR_LENGTH(codigoPostal) = 5 AND codigoPostal SIMILAR TO '[0-9]{5}'),
	estado VARCHAR(30) NOT NULL,
	calle VARCHAR(30) NOT NULL,
	numeroExt INT NOT NULL CHECK (numeroExt > 0),
	telefono CHAR(10) NOT NULL CHECK (CHAR_LENGTH(telefono) = 10 AND telefono SIMILAR TO '[0-9]{10}'),
	correo VARCHAR(64)
);
COMMENT ON TABLE Persona IS 'Tabla donde se guarda la informacion de las personas';
COMMENT ON COLUMN Persona.CURP IS 'CURP identificador de la persona';
COMMENT ON COLUMN Persona.nombre IS 'Nombre de la persona';
COMMENT ON COLUMN Persona.apellidoPaterno IS 'Apellido paterno de la persona';
COMMENT ON COLUMN Persona.apellidoMaterno IS 'Apellido materno de la persona';
COMMENT ON COLUMN Persona.fechaNacimiento IS 'Fecha de nacimiento de la persona';
COMMENT ON COLUMN Persona.codigoPostal IS 'Código postal de la dirección de la persona';
COMMENT ON COLUMN Persona.estado IS 'Estado de la dirección de la persona';
COMMENT ON COLUMN Persona.calle IS 'Calle de la dirección de la persona';
COMMENT ON COLUMN Persona.numeroExt IS 'Numero exterior de la dirección de la persona';
COMMENT ON COLUMN Persona.telefono IS 'Telefono de la persona';
COMMENT ON COLUMN Persona.correo IS 'Correo de la persona';	

CREATE TABLE TipoEmpleado(
    idTipoEmpleado INT PRIMARY KEY,
    rol VARCHAR(32) NOT NULL
);

COMMENT ON TABLE TipoEmpleado IS 'Tabla donde se guarda los tipos de empleados que trabajan.';
COMMENT ON COLUMN TipoEmpleado.idTipoEmpleado IS 'Identificador del tipo de empleado';
COMMENT ON COlUMN TipoEmpleado.rol IS 'Lo que hace ese tipo de empleado.';


CREATE TABLE Empleado (
	CURP CHAR(18) NOT NULL REFERENCES Persona (CURP) ON DELETE CASCADE ON UPDATE CASCADE PRIMARY KEY,
	idTipoEmpleado INT NOT NULL CHECK (IdTipoEmpleado  > 0) REFERENCES TipoEmpleado(idTipoEmpleado) ON DELETE CASCADE ON UPDATE CASCADE,
	idSucursal INT NOT NULL CHECK (idSucursal   > 0) REFERENCES Sucursal(idSucursal) ON DELETE CASCADE ON UPDATE CASCADE,
    salario REAL NOT NULL CHECK (salario > 0),
    fechaInicio DATE NOT NULL,
    nss CHAR(11) NOT NULL UNIQUE CHECK (CHAR_LENGTH(nss) = 11 AND nss SIMILAR TO '[A-Z0-9]{11}'),
    fechaUltAumento DATE NOT NULL,
    RFC CHAR(13) NOT NULL UNIQUE CHECK (CHAR_LENGTH(RFC) = 13 AND RFC SIMILAR TO '[A-Z0-9]{13}')
	);
COMMENT ON TABLE Empleado IS 'Tabla donde se guarda la informacion de los empleados';
COMMENT ON COLUMN Empleado.CURP IS 'CURP identificador del empleado';
COMMENT ON COlUMN Empleado.idTipoEmpleado IS 'Dependiendo del numero es el tipo de empleado';
COMMENT ON COLUMN Empleado.idSucursal IS 'El id de la sucursal en la que el empleado trabaja';
COMMENT ON COLUMN Empleado.salario IS 'Salario del empleado.';
COMMENT ON COlUMN Empleado.fechaInicio IS 'Fecha cuando empezo a trabajar.';
COMMENT ON COLUMN Empleado.nss IS 'Numero de seguridad social del empleado';
COMMENT ON COLUMN Empleado.fechaUltAumento IS 'Fecha del ultimo aumento para poder generar el abono cada dos años.';
COMMENT ON COLUMN Empleado.rfc IS 'RFC del empleado';



CREATE TABLE Repartidor (
	CURP CHAR(18) NOT NULL UNIQUE REFERENCES Persona (CURP) ON DELETE CASCADE ON UPDATE CASCADE,
	tieneTransporte BIT NOT NULL,
	noLicencia CHAR(10) NOT NULL UNIQUE
);
COMMENT ON TABLE Repartidor IS 'Tabla donde se guarda la informacion de los repartidores';
COMMENT ON COLUMN Repartidor.CURP IS 'CURP identificador del repartidor';
COMMENT ON COLUMN Repartidor.tieneTransporte IS 'Nos permite saber si un repartidor cuenta con transporte propio';
COMMENT ON COLUMN Repartidor.noLicencia IS 'El numero de la licencia del repartidor';

CREATE TABLE TipoVehiculo (
    idTipoVehiculo SERIAL PRIMARY KEY,
    descripcion VARCHAR(30) NOT NULL
);

COMMENT ON TABLE TipoVehiculo IS 'Tabla donde se guarda la información de los diferentes tipos de vehiculos.';
COMMENT ON COLUMN TipoVehiculo.idTipoVehiculo IS 'Identificador para el tipo del vehiculo.';
COMMENT ON COLUMN TipoVehiculo.descripcion IS 'Descripcion del tipo de vehiculo.';

CREATE TABLE Vehiculo (
	idVehiculo SERIAL NOT NULL CHECK (idVehiculo  > 0),
	CURPRepartidor CHAR(18) NOT NULL REFERENCES Repartidor (CURP) ON DELETE CASCADE ON UPDATE CASCADE,
	tipo INT NOT NULL CHECK (tipo  > 0) REFERENCES TipoVehiculo (idTipoVehiculo) ON DELETE CASCADE ON UPDATE CASCADE,
	marca VARCHAR(30) NOT NULL,
	modelo VARCHAR(30) NOT NULL
);
COMMENT ON TABLE Vehiculo IS 'Tabla donde se guarda la informacion de los vehiculos de los repartidores';
COMMENT ON COLUMN Vehiculo.idVehiculo IS 'Id del vehiculo';
COMMENT ON COLUMN Vehiculo.CURPRepartidor IS 'CURP del repartidor';
COMMENT ON COLUMN Vehiculo.tipo IS 'Tipo del vehiculo';
COMMENT ON COLUMN Vehiculo.marca IS 'Marca del vehiculo';
COMMENT ON COLUMN Vehiculo.modelo IS 'Modelo del vehiculo';

CREATE TABLE Cliente (
	CURP CHAR(18) NOT NULL UNIQUE REFERENCES Persona (CURP) ON DELETE CASCADE ON UPDATE CASCADE,
	puntos INT NOT NULL
);
COMMENT ON TABLE Cliente IS 'Tabla donde se guarda la informacion de los clientes';
COMMENT ON COLUMN Cliente.CURP IS 'CURP identificador del cliente';
COMMENT ON COLUMN Cliente.puntos IS 'Puntos que el cliente tiene acumulados';

CREATE TABLE TipoMetodoPago (
	idTipoMP SERIAL PRIMARY KEY,
    descripcion VARCHAR(30) NOT NULL
);

COMMENT ON TABLE TipoMetodoPago IS 'Tabla donde se guarda la información de los diferentes formas de pagar.';
COMMENT ON COLUMN TipoMetodoPago.idTipoMP IS 'Identificador para la forma de pago.';
COMMENT ON COLUMN TipoMetodoPago.descripcion IS 'Descripcion de la forma de pago.';

CREATE TABLE MetodoPago (
	idMetodoPago SERIAL PRIMARY KEY,
 	idTipo INT NOT NULL CHECK (idTipo  > 0),
	CURPCliente CHAR(18) NOT NULL REFERENCES Cliente (CURP) ON DELETE CASCADE ON UPDATE CASCADE
);
COMMENT ON TABLE MetodoPago IS 'Tabla donde se guarda la informacion de los metodos de pago';
COMMENT ON COLUMN MetodoPago.idMetodoPago IS 'Identificador de los metodos de pago';
COMMENT ON COLUMN MetodoPago.idTipo IS 'Tipo de metodo de pago';
COMMENT ON COLUMN MetodoPago.CURPCliente IS 'CURP del cliente que va a pagar';


CREATE TABLE Tarjeta (
    idMetodoPago INT NOT NULL REFERENCES MetodoPago (idMetodoPago) ON DELETE CASCADE ON UPDATE CASCADE,
    numTarjeta CHAR(13) NOT NULL UNIQUE CHECK (CHAR_LENGTH(numTarjeta) = 13 AND numTarjeta SIMILAR TO '[0-9]{13}'),
    fechaVencimiento DATE NOT NULL 
);
COMMENT ON TABLE Tarjeta IS 'Tabla para guardar la informacion de las tarjetas.';
COMMENT ON COLUMN Tarjeta.idMetodoPago IS 'Identificador para la tarjeta.';
COMMENT ON COLUMN Tarjeta.numTarjeta IS 'Numero de tarjeta.';
COMMENT ON COLUMN Tarjeta.fechaVencimiento IS 'Fecha en la que vence la tarjeta.';

CREATE TABLE Pedido(
    idPedido SERIAL PRIMARY KEY,
    CURPCliente CHAR(18) NOT NULL REFERENCES Cliente (CURP),
    CURPEmpleado CHAR(18) NOT NULL REFERENCES Empleado (CURP),
    tipo INT NOT NULL CHECK (tipo BETWEEN 0 AND 1)
);
COMMENT ON TABLE Pedido IS 'Tabla para guardar la informacion de los pedidos.';
COMMENT ON COLUMN Pedido.idPedido IS 'Identificador para el pedido.';
COMMENT ON COLUMN Pedido.CURPCLiente IS 'CURP del cliente que pidio el pedido.';
COMMENT ON COLUMN Pedido.CURPEmpleado IS 'CURP del empleado que tomo la orden.';
COMMENT ON COLUMN Pedido.tipo IS 'Tipo del pedido(Llevar/comer aquí).';

CREATE TABLE TipoProductoAlimenticio(
       idTipo SERIAL PRIMARY KEY,
       descripcion VARCHAR(32) NOT NULL
);
COMMENT ON TABLE TipoProductoAlimenticio IS 'Tabla para guardar la informacion de los diferentes tipos de alimentos que ofrece.';
COMMENT ON COLUMN TipoProductoAlimenticio.idTipo IS 'Identificador para el tipo de producto.';
COMMENT ON COLUMN TipoProductoAlimenticio.descripcion IS 'Descripcion del tipo de producto.';

CREATE TABLE ProductoAlimenticio(
       idProductoAlimenticio SERIAL PRIMARY KEY,
       idTipo INT NOT NULL REFERENCES TipoProductoAlimenticio(idTipo) ON DELETE CASCADE ON UPDATE CASCADE,
       nombre VARCHAR(32) NOT NULL,
       precioVenta REAL NOT NULL CHECK(precioVenta > 0),
       descripcion VARCHAR(32) 
);
COMMENT ON TABLE ProductoAlimenticio IS 'Tabla para guardar de los todos los productos alimenticios que ofrece la taqueria.';
COMMENT ON COLUMN ProductoAlimenticio.idProductoAlimenticio IS 'Identificador para el alimento.';
COMMENT ON COLUMN ProductoAlimenticio.idTipo IS 'Tipo del alimento.';
COMMENT ON COLUMN ProductoAlimenticio.nombre IS 'Descripcion del alimento.';
COMMENT ON COLUMN ProductoAlimenticio.precioVenta IS 'Precio al que se oferta el alimento.';

CREATE TABLE Salsa(
       idSalsa SERIAL PRIMARY KEY,
       nivelPicante VARCHAR(32) NOT NULL,
       descripcion VARCHAR(45) NOT NULL
);
COMMENT ON TABLE Salsa IS 'Tabla para guardar la informacion de las salsas que ofrece la taqueria.';
COMMENT ON COLUMN Salsa.idSalsa IS 'Identificador para la salsa.';
COMMENT ON COLUMN Salsa.nivelPicante IS 'Nivel de picante de la salsa (Dulce/Bajo/Medio/Alto/Extremo).';
COMMENT ON COLUMN Salsa.descripcion IS 'Descripcion de la salsa';

CREATE TABLE TamañoSalsa (
	idProductoAlimenticio INT NOT NULL REFERENCES ProductoAlimenticio(idProductoAlimenticio) ON DELETE CASCADE ON UPDATE CASCADE,
	idSalsa INT NOT NULL REFERENCES Salsa(idSalsa) ON DELETE CASCADE ON UPDATE CASCADE,
	tamaño INT NOT NULL
);
COMMENT ON TABLE TamañoSalsa IS 'Tabla para guardar la información del precio de las salsas con respecto a su tamaño';
COMMENT ON COLUMN TamañoSalsa.idProductoAlimenticio IS 'Identificador del producto';
COMMENT ON COLUMN TamañoSalsa.idSalsa IS 'Identificador para la salsa.';
COMMENT ON COLUMN TamañoSalsa.tamaño IS 'El tamaño del envase(250/500/1000)';


CREATE TABLE OfertarAlimento (
	IdSucursal INT NOT NULL REFERENCES Sucursal(IdSucursal) ON DELETE CASCADE ON UPDATE CASCADE,
	IdProductoAlimenticio INT NOT NULL REFERENCES ProductoAlimenticio (idProductoAlimenticio) ON DELETE CASCADE ON UPDATE CASCADE
);
COMMENT ON TABLE OfertarAlimento IS 'Tabla de la relación ofertar alimento';
COMMENT ON COLUMN OfertarAlimento.idSucursal IS 'El id de la sucursal en donde se va a ofertar tal alimento';
COMMENT ON COLUMN OfertarAlimento.idProductoAlimenticio IS 'El id del alimento que se va a ofertar en la sucursal';

CREATE TABLE RecomendarConSalsa(
	IdSalsa INT NOT NULL REFERENCES Salsa (idSalsa) ON DELETE CASCADE ON UPDATE CASCADE,
	IdProductoAlimenticio INT NOT NULL REFERENCES ProductoAlimenticio (idProductoAlimenticio) ON DELETE CASCADE ON UPDATE CASCADE
);
COMMENT ON TABLE RecomendarConSalsa IS 'Tabla donde se guarda qué salsa se recomienda con qué platillo';
COMMENT ON COLUMN RecomendarConSalsa.idSalsa IS 'El id de la salsa que se va a recomendar';
COMMENT ON COLUMN RecomendarConSalsa.idProductoAlimenticio IS 'El id del producto con el que se recomienda la salsa';


CREATE TABLE Recibo(
    idRecibo SERIAL PRIMARY KEY,
    idPedido INT NOT NULL REFERENCES Pedido (idPedido) ON DELETE CASCADE ON UPDATE CASCADE,
    idMetodoPago INT NOT NULL REFERENCES MetodoPago (idMetodoPago) ON DELETE CASCADE ON UPDATE CASCADE,
    total REAL NOT NULL,
    fecha DATE NOT NULL
);
COMMENT ON TABLE Recibo IS 'Tabla para guardar la informacion de los recibos.';
COMMENT ON COLUMN Recibo.idRecibo IS 'Identificador para el recibo.';
COMMENT ON COLUMN Recibo.idPedido IS 'El identificador del pedido sobre el cual se esta haciendo el recibo.';
COMMENT ON COLUMN Recibo.idMetodoPago IS 'El metodo de pago utilizado para pagar el recibo.';
COMMENT ON COLUMN Recibo.fecha IS 'Fecha en la que se emite el recibo.';

CREATE TABLE Provedor (
	idProvedor SERIAL PRIMARY KEY,
	nombre VARCHAR(64) NOT NULL,
	telefono CHAR(10) NOT NULL CHECK (CHAR_LENGTH(telefono) = 10 AND telefono SIMILAR TO '[0-9]{10}')	       
);

COMMENT ON TABLE Provedor IS 'Tabla donde se guarda la información de los provedores.';
COMMENT ON COLUMN Provedor.idProvedor IS 'El id del provedor que sirve de identificador.';
COMMENT ON COLUMN Provedor.nombre IS 'Nombre de la provedor.';
COMMENT ON COLUMN Provedor.telefono IS 'Telefono del provedor.';

CREATE TABLE RegistroProductoNoPerecedero (
	idRegistroProductoNoPerecedero SERIAL PRIMARY KEY,
	idProvedor INT NOT NULL REFERENCES Provedor (idProvedor) ON DELETE CASCADE ON UPDATE CASCADE,
	nombre VARCHAR(64) NOT NULL,
	cantidad INT NOT NULL CHECK (cantidad > 0),
	marca VARCHAR(30) NOT NULL,
	fechaAdquisicion DATE NOT NULL,
	precioCompra REAL NOT NULL CHECK (PrecioCompra > 0)
);

COMMENT ON TABLE RegistroProductoNoPerecedero IS 'Tabla donde se guarda la información de los registros de los productos no perecedero.';
COMMENT ON COLUMN RegistroProductoNoPerecedero.idRegistroProductoNoPerecedero IS 'El id del registro que sirve de identificador.';
COMMENT ON COLUMN RegistroProductoNoPerecedero.idProvedor IS 'El id del provedor del producto.';
COMMENT ON COLUMN RegistroProductoNoPerecedero.nombre IS 'Nombre del producto.';
COMMENT ON COLUMN RegistroProductoNoPerecedero.cantidad IS 'Cantidad comprada.';
COMMENT ON COLUMN RegistroProductoNoPerecedero.marca IS 'Marca del producto';
COMMENT ON COLUMN RegistroProductoNoPerecedero.fechaAdquisicion IS 'Fecha de adquisicion del producto.';
COMMENT ON COLUMN RegistroProductoNoPerecedero.precioCompra IS 'Precio de compra del producto';

CREATE TABLE RegistroIngrediente (
	idRegistroIngrediente SERIAL PRIMARY KEY,
	idProvedor INT NOT NULL REFERENCES Provedor (idProvedor) ON DELETE CASCADE ON UPDATE CASCADE,
	nombre VARCHAR(64) NOT NULL,
	cantidad INT NOT NULL CHECK (cantidad > 0),
	marca VARCHAR(30) NOT NULL,
	fechaAdquisicion DATE NOT NULL,
	precioCompra REAL NOT NULL CHECK (PrecioCompra > 0),
	fechaCaducidad DATE NOT NULL
);

COMMENT ON TABLE RegistroIngrediente IS 'Tabla donde se guarda la información de los registros de los productos no perecedero.';
COMMENT ON COLUMN RegistroIngrediente.idRegistroIngrediente IS 'El id del registro que sirve de identificador.';
COMMENT ON COLUMN RegistroIngrediente.idProvedor IS 'El id del provedor del producto.';
COMMENT ON COLUMN RegistroIngrediente.nombre IS 'Nombre del producto.';
COMMENT ON COLUMN RegistroIngrediente.cantidad IS 'Cantidad comprada.';
COMMENT ON COLUMN RegistroIngrediente.marca IS 'Marca del producto';
COMMENT ON COLUMN RegistroIngrediente.fechaAdquisicion IS 'Fecha de adquisicion del producto.';
COMMENT ON COLUMN RegistroIngrediente.precioCompra IS 'Precio de compra del producto';
COMMENT ON COLUMN RegistroIngrediente.fechaCaducidad IS 'Fecha de caducidad del producto';

CREATE TABLE RegistroProductoAlimenticio (
 	idRegistroProductoAlimenticio SERIAL PRIMARY KEY,
 	idTipo INT NOT NULL REFERENCES TipoProductoAlimenticio (idTipo) ON DELETE CASCADE ON UPDATE CASCADE,
 	nombre VARCHAR(64) NOT NULL,
 	precioVenta REAL NOT NULL CHECK (PrecioVenta > 0),
 	fechaPrecio DATE NOT NULL
 );

 COMMENT ON TABLE RegistroProductoAlimenticio IS 'Tabla donde se guarda la información de los registros de los productos alimenticios ofertados.';
 COMMENT ON COLUMN RegistroProductoAlimenticio.idRegistroProductoAlimenticio IS 'El id del registro que sirve de identificador.';
 COMMENT ON COLUMN RegistroProductoAlimenticio.idTipo IS 'El id del tipo de producto.';
 COMMENT ON COLUMN RegistroProductoAlimenticio.nombre IS 'Nombre del producto.';
 COMMENT ON COLUMN RegistroProductoAlimenticio.precioVenta IS 'Precio a lo que se vende el producto';
 COMMENT ON COLUMN RegistroProductoAlimenticio.fechaPrecio IS 'Fecha a partir donde el precio del producto es  vigente.';

CREATE TABLE Pedir(
	idPedido INT NOT NULL REFERENCES Pedido (idPedido) ON DELETE CASCADE ON UPDATE CASCADE,
	idProductoAlimenticio INT NOT NULL REFERENCES ProductoAlimenticio (idProductoAlimenticio) ON DELETE CASCADE ON UPDATE CASCADE
);

COMMENT ON TABLE Pedir IS 'Tabla donde se guarda la referencia de un pedido y el producto alimenticio que se ordenó.';
COMMENT ON COLUMN Pedir.idPedido IS 'Id del pedido que se realizó.';
COMMENT ON COLUMN Pedir.idProductoAlimenticio IS 'Id del producto alimenticio que se ordenó.';

CREATE TABLE Ingrediente(
	idIngrediente SERIAL PRIMARY KEY,
	idProvedor INT NOT NULL REFERENCES Provedor (idProvedor) ON DELETE CASCADE ON UPDATE CASCADE,
	nombre VARCHAR(60) NOT NULL,
	cantidad INT NOT NULL CHECK (Cantidad > 0),
	marca VARCHAR(60) NOT NULL,
	fechaAdquisicion DATE NOT NULL,
	precioCompra REAL NOT NULL,
	fechaCaducidad DATE NOT NULL
);

COMMENT ON TABLE Ingrediente IS 'Tabla donde se guarda la información de los productos no perecedero.';
COMMENT ON COLUMN Ingrediente.idIngrediente IS 'Id del ingrediente que sirve de identificador.';
COMMENT ON COLUMN Ingrediente.idProvedor IS 'Id del provedor del producto.';
COMMENT ON COLUMN Ingrediente.nombre IS 'Nombre del producto.';
COMMENT ON COLUMN Ingrediente.cantidad IS 'Cantidad comprada.';
COMMENT ON COLUMN Ingrediente.marca IS 'Marca del producto.';
COMMENT ON COLUMN Ingrediente.fechaAdquisicion IS 'Fecha de adquisicion del producto.';
COMMENT ON COLUMN Ingrediente.precioCompra IS 'Precio de compra del producto.';
COMMENT ON COLUMN Ingrediente.fechaCaducidad IS 'Fecha de caducidad del producto.';

CREATE TABLE Preparar(
	idProductoAlimenticio INT NOT NULL REFERENCES ProductoAlimenticio (idProductoAlimenticio) ON DELETE CASCADE ON UPDATE CASCADE,
	idIngrediente INT NOT NULL REFERENCES Ingrediente (idIngrediente) ON DELETE CASCADE ON UPDATE CASCADE,
	porcion INT NOT NULL CHECK (porcion > 0)
);

COMMENT ON TABLE Preparar IS 'Tabla donde se guarda la información para preparar un producto alimenticio.';
COMMENT ON COLUMN Preparar.idProductoAlimenticio IS 'Id del producto alimenticio que se prepará.';
COMMENT ON COLUMN Preparar.idIngrediente IS 'Id del ingrediente usado en la preparación.';
COMMENT ON COLUMN Preparar.porcion IS 'Porción usada del ingrediente.';


CREATE TABLE ProductoNoPerecedero(
	idProductoNoPerecedero SERIAL PRIMARY KEY,
	idProvedor INT NOT NULL REFERENCES Provedor (idProvedor) ON DELETE CASCADE ON UPDATE CASCADE,
	nombre VARCHAR(64) NOT NULL,
	cantidad INT NOT NULL CHECK (cantidad > 0),
	marca VARCHAR(30) NOT NULL,
	fechaAdquisicion DATE NOT NULL,
	precioCompra REAL NOT NULL CHECK (PrecioCompra > 0)
);

COMMENT ON TABLE ProductoNoPerecedero IS 'Tabla donde se guarda la información de los productos no perecedero.';
COMMENT ON COLUMN ProductoNoPerecedero.idProductoNoPerecedero IS 'Id del producto que sirve de identificador.';
COMMENT ON COLUMN ProductoNoPerecedero.idProvedor IS 'Id del provedor del producto.';
COMMENT ON COLUMN ProductoNoPerecedero.nombre IS 'Nombre del producto.';
COMMENT ON COLUMN ProductoNoPerecedero.cantidad IS 'Cantidad comprada.';
COMMENT ON COLUMN ProductoNoPerecedero.marca IS 'Marca del producto.';
COMMENT ON COLUMN ProductoNoPerecedero.fechaAdquisicion IS 'Fecha de adquisicion del producto.';
COMMENT ON COLUMN ProductoNoPerecedero.precioCompra IS 'Precio de compra del producto.';
