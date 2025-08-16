-- STORE PROCEDURE PARA ENTIDAD CONDUCTOR

-- STORE PROCEDURE PARA CREAR ENTIDAD CONDUCTOR
DELIMITER $$

Drop PROCEDURE IF EXISTS SPNewConductor $$

CREATE PROCEDURE SPNewConductor(
    OUT xidConductor INT,
    xName VARCHAR(45),
    xLicencia VARCHAR(45),
    xDisponibilidad TINYINT
)
BEGIN
    INSERT INTO Conductor (Name, Licencia, Disponibilidad)
		VALUES (xName, xLicencia, xDisponibilidad);
    
    SET xidConductor = last_insert_id();
END $$

-- SP para eliminar un conductor
-- SE ELIMINA SI ESTE NO TIENE ASIGNACIONES DE VEHICULOS O ESTA LIBRE
DELIMITER $$

Drop PROCEDURE IF EXISTS SPDelConductor $$

CREATE PROCEDURE SPDelConductor(xidConductor INT)
BEGIN
    -- Se verifica si el conductor tiene asignacion de vehículo
    DECLARE cantPedidos INT;
    
    SELECT COUNT(*) INTO cantPedidos
    FROM Conductor_has_Vehiculo 
    WHERE Conductor_idConductor = xidConductor;
    
    IF cantPedidos > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar el conductor porque tiene vehículos asignados';
    ELSE
        DELETE FROM Conductor WHERE idConductor = xidConductor;
    END IF;
END $$

DELIMITER;

-- Procedimiento para actualizar datos de un conductor
DELIMITER $$

Drop PROCEDURE IF EXISTS UpdateConductor $$

CREATE PROCEDURE UpdateConductor(xidConductor INT,xLicencia VARCHAR(45))
BEGIN
    UPDATE Conductor
    SET Licencia = xLicencia
    WHERE idConductor = xidConductor;
END $$

DELIMITER;