CREATE OR REPLACE FUNCTION agrega_cliente() RETURNS TRIGGER
    AS $$
    DECLARE 
        curp_sucursal VARCHAR(18);
    BEGIN 
        curp_sucursal = CONCAT(NEW.RFC, '00000');
        INSERT INTO Persona(curp,nombre,apellidoPaterno,apellidoMaterno,fechanacimiento,codigopostal,estado,calle,numeroExt,telefono,correo) 
        VALUES (curp_sucursal, NEW.nombre,NEW.nombre,NEW.nombre,'2000-08-17',NEW.codigoPostal,NEW.estado,NEW.calle,NEW.numeroExt,NEW.telefono,NEW.correo);
        INSERT INTO Cliente(curp, puntos) 
        VALUES (curp_sucursal, 0);
        RETURN NEW;
       --
    END;
    $$
    LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS cliente_default_trigger ON sucursal;

CREATE TRIGGER cliente_default_trigger
    AFTER INSERT ON sucursal
    FOR EACH ROW
    EXECUTE PROCEDURE agrega_cliente();
    
    
CREATE OR REPLACE FUNCTION verifica_tipo_repartidor() RETURNS TRIGGER
    AS $$
    DECLARE 
        tipoE INT;
    BEGIN 
        SELECT idTipoEmpleado INTO tipoE FROM empleado WHERE empleado.curp = NEW.curp;
        IF tipoE <> 1 THEN
            RAISE EXCEPTION 'Para poder ser repartidor tiene que tener idTipoRepartidor = 1';
        END IF;
        RETURN NEW;
       --
    END;
    $$
    LANGUAGE plpgsql;
    
DROP TRIGGER IF EXISTS repartidor_coincidente ON repartidor;
    
CREATE TRIGGER repartidor_coincidente
    BEFORE INSERT ON repartidor
    FOR EACH ROW
    EXECUTE PROCEDURE verifica_tipo_repartidor();    
    
    
    
CREATE OR REPLACE FUNCTION agrega_hist_prdalim() RETURNS TRIGGER
	AS $$
	BEGIN
		INSERT INTO RegistroProductoAlimenticio(idTipo,nombre,precioVenta,fechaPrecio)
		VALUES (OLD.idTipo,OLD.nombre,OLD.precioVenta,OLD.fechaPrecio);
		RETURN OLD;
		--
	END;
	$$
	LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS registro_hist_prdalim_trigger ON ProductoAlimenticio;

CREATE TRIGGER registro_hist_prdalim_trigger
	BEFORE UPDATE OR DELETE ON ProductoAlimenticio
	FOR EACH ROW
	EXECUTE PROCEDURE agrega_hist_prdalim();
    
CREATE OR REPLACE FUNCTION agrega_hist_pnoperecedero() RETURNS TRIGGER
	AS $$
	BEGIN
		INSERT INTO  RegistroProductoNoPerecedero(idProvedor,nombre,cantidad, marca, fechaAdquisicion, precioCompra)
		VALUES (OLD.idProvedor,OLD.nombre, OLD.cantidad, OLD.marca, OLD.fechaAdquisicion, OLD.precioCompra);
		RETURN OLD;
		--
	END;
	$$
	LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS registro_hist_pnoperecedero_trigger ON ProductoNoPerecedero;

CREATE TRIGGER registro_hist_pnoperecedero_trigger
	AFTER UPDATE OR DELETE ON ProductoNoPerecedero
	FOR EACH ROW
	EXECUTE PROCEDURE agrega_hist_pnoperecedero();


CREATE OR REPLACE FUNCTION agrega_hist_ingrediente() RETURNS TRIGGER
	AS $$
	BEGIN
		INSERT INTO  RegistroIngrediente(idProvedor,nombre,cantidad, marca, fechaAdquisicion, precioCompra, fechaCaducidad)
		VALUES (OLD.idProvedor,OLD.nombre, OLD.cantidad, OLD.marca, OLD.fechaAdquisicion, OLD.precioCompra, OlD.fechaCaducidad);
		RETURN OLD;
		--
	END;
	$$
	LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS registro_hist_ingrediente_trigger ON ingrediente;

CREATE TRIGGER registro_hist_ingrediente_trigger
	AFTER UPDATE OR DELETE ON ingrediente
	FOR EACH ROW
	EXECUTE PROCEDURE agrega_hist_ingrediente();
