-- Función para calcular el total de pedidos por estado
DELIMITER $$

DROP FUNCTION if EXISTS TotalPedidosPorEstado $$

CREATE FUNCTION TotalPedidosPorEstado(xEstado VARCHAR(45)) 
RETURNS INT READS SQL Data
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total
    FROM Pedido
    WHERE EstadoPedido = xEstado;
    
    RETURN total;
END $$

DELIMITER;

-- funcion para verificar si la licencia es valida

DELIMITER $$

DROP FUNCTION if EXISTS VerificarLicenciaValidaParaVehiculo $$

CREATE FUNCTION VerificarLicenciaValidaParaVehiculo(p_idConductor INT, p_idVehiculo INT) 
RETURNS BOOLEAN READS SQL Data
BEGIN
    DECLARE licencia_conductor VARCHAR(45);
    DECLARE tipo_vehiculo VARCHAR(45);
    DECLARE es_valida BOOLEAN;
    
    SELECT Licencia INTO licencia_conductor
    FROM Conductor
    WHERE idConductor = p_idConductor;
    
    SELECT Tipo INTO tipo_vehiculo
    FROM Vehiculo
    WHERE idVehiculo = p_idVehiculo;
    
	IF licencia_conductor is not null then
		set es_valida = true;
	else
		set es_valida = false;
    END IF;
    
    RETURN es_valida;
END $$