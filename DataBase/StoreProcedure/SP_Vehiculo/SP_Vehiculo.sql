-- Procedimiento para crear un nuevo vehículo (por administrador)
DELIMITER $$
Drop PROCEDURE IF EXISTS  SPCrearVehiculo $$
CREATE PROCEDURE SPCrearVehiculo(
    OUT xidVehiculo INT,
    xTipo VARCHAR(45),
    xMatricula VARCHAR(45),
    xCapacidadMax DOUBLE,
    xEstado TINYINT
)
BEGIN
    INSERT INTO Vehiculo (Tipo, Matricula, CapacidadMaz, Estado)
    VALUES (xTipo, xMatricula, xCapacidadMax, xEstado);
    
    set xidVehiculo = last_insert_id();
END $$
DELIMITER ;

-- Procedimiento para eliminar un vehículo
DELIMITER $$
Drop PROCEDURE IF EXISTS  SPDelVehiculo $$
CREATE PROCEDURE SPDelVehiculo(xidVehiculo INT)
BEGIN
    -- Aca Verificamos si el vehículo tiene pedidos asignados
    DECLARE asignaciones_pedidos INT;
    
    SELECT COUNT(*) INTO asignaciones_pedidos 
    FROM pedido 
    WHERE pedido.Vehiculo_idVehiculo = xidVehiculo;
    
    IF asignaciones_pedidos > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar el vehículo porque tiene pedidos asignados';
    ELSE
        DELETE FROM Vehiculo WHERE `Vehiculo`.`idVehiculo` = xidVehiculo;
    END IF;
END $$
DELIMITER ;

-- Procedimiento para actualizar datos de un vehículo
DELIMITER $$
Drop PROCEDURE IF EXISTS  UpdateVehiculo $$
CREATE PROCEDURE UpdateVehiculo(xidVehiculo INT, xMatricula VARCHAR(45)
)
BEGIN
    UPDATE Vehiculo
    SET Matricula = xMatricula
    WHERE idVehiculo = xidVehiculo;
END $$
DELIMITER $$

DELIMITER $$
Drop PROCEDURE IF EXISTS  SPActualizarEstadoVehiculo $$
CREATE PROCEDURE SPActualizarEstadoVehiculo(xidVehiculo INT, xdisponible BOOLEAN)
BEGIN
	-- Ojo que esto vendria aser un trigger ya qeu al asignarle almenos un pedido/conductor ya se cambia la disponibilidad
    UPDATE Vehiculo
    SET Estado = CASE
        WHEN xdisponible THEN 0
        ELSE 1
    END
    WHERE idVehiculo = xidVehiculo;
END $$

-- --------------------------------------------------------------------------------------------

-- =====================================================================
-- PROCEDIMIENTOS PARA ASIGNACIÓN DE VEHÍCULOS A CONDUCTORES
-- =====================================================================

-- Procedimiento para asignar un vehículo a un conductor
DELIMITER $$
DROP PROCEDURE IF EXISTS AsignarVehiculoAConductor $$
CREATE PROCEDURE AsignarVehiculoAConductor(
    xidConductor INT,
    xidVehiculo INT
)
BEGIN
    DECLARE conductor_disponible TINYINT;
    DECLARE vehiculo_disponible TINYINT;
    
    -- Verificar disponibilidad del conductor
    SELECT Disponibilidad INTO conductor_disponible
    FROM Conductor
    WHERE idConductor = xidConductor;
    
    -- Verificar estado del vehículo
    SELECT Estado INTO vehiculo_disponible
    FROM Vehiculo
    WHERE idVehiculo = xidVehiculo;
    
    IF conductor_disponible != 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El conductor no está disponible para asignaciones';
    ELSEIF vehiculo_disponible != 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El vehículo no está disponible para asignaciones';
    ELSE
        INSERT INTO Conductor_has_Vehiculo (
            Conductor_idConductor,
            Vehiculo_idVehiculo,
            FechaAsignado
        )
        VALUES (xidConductor, xidVehiculo, CURDATE());
        
        UPDATE Conductor
        SET Disponibilidad = 0
        WHERE idConductor = xidConductor;
        
        UPDATE Vehiculo
        SET Estado = 0
        WHERE idVehiculo = xidVehiculo;
    END IF;
END $$
DELIMITER ;

-- Procedimiento para desasignar un vehículo de un conductor
DELIMITER $$
DROP PROCEDURE IF EXISTS SPDesasignarVehiculoAConductor $$
CREATE PROCEDURE SPDesasignarVehiculoAConductor(
    xidConductor INT,
    xidVehiculo INT
)
BEGIN
    DECLARE pedidosEnVehiculo INT;

    SELECT COUNT(*) INTO pedidosEnVehiculo
    FROM Pedido
    WHERE Vehiculo_idVehiculo = xidVehiculo;

    IF pedidosEnVehiculo > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede desasignar el vehículo porque tiene pedidos activos';
    ELSE
        DELETE FROM Conductor_has_Vehiculo
        WHERE Conductor_idConductor = xidConductor
          AND Vehiculo_idVehiculo = xidVehiculo;
        
        UPDATE Conductor
        SET Disponibilidad = 1
        WHERE idConductor = xidConductor;

        UPDATE Vehiculo
        SET Estado = 0
        WHERE idVehiculo = xidVehiculo;
    END IF;
END $$
DELIMITER ;