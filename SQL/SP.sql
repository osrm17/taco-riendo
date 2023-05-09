CREATE OR REPLACE FUNCTION CuantoDesdeUltBono (curpEmpleado char(18))
	RETURNS int 
	AS $$
	DECLARE 
		UltBono DATE;
		anioBono int;
		anioActual int;
	BEGIN 
		SELECT Empleado.fechaUltAumento INTO UltBono 
		FROM public.Empleado
		WHERE Empleado.curp = curpEmpleado;
		
		SELECT EXTRACT (year FROM UltBono) INTO anioBono;
		SELECT EXTRACT (year FROM current_date) INTO anioActual;
		return anioActual-anioBono;
	END ;
	$$
	Language plpgsql;
	
CREATE OR REPLACE PROCEDURE bono(curpEmpleado CHAR(18))
	AS $$
	DECLARE
	salarioViejo REAL;
	BEGIN
	SELECT salario INTO salarioViejo
	FROM Empleado
	WHERE Empleado.CURP= curpEmpleado;
	IF CuantoDesdeUltBono(curpEmpleado) >= 2
	THEN UPDATE Empleado
  		 SET salario=salarioViejo+1500, fechaUltAumento = current_date 
  		 WHERE curp=curpEmpleado;
		 
	ELSE 
	end IF;
	END;
	$$
	LANGUAGE plpgsql;

SELECT salario FROM Empleado WHERE CURP='MGQL948231GJJFUMP7';
CALL bono('MGQL948231GJJFUMP7');
SELECT salario FROM Empleado WHERE CURP='MGQL948231GJJFUMP7';