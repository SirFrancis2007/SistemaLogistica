-- STORE PROCEDURES PARA ENTIDAD ADMINISTRADOR

-- STORE PROCEDURE PARA CREAR ENTIDAD ADMINISTTADOR
-- TODO AMINISTRADOR DEBERA ESTAR LIGADO A UNA EMPRESA.

DELIMITER $$

DROP PROCEDURE IF EXISTS SPNuevoAdministrador $$

CREATE PROCEDURE SPNuevoAdministrador(out xidAdministrador INT, xName VARCHAR(45), xPassword VARCHAR(45), xEmpresa_idEmpresa INT)
BEGIN
    INSERT INTO Administrador (Name, Passworld, Empresa_idEmpresa)
    VALUES (xName, xPassword, xEmpresa_idEmpresa);
    set xidAdministrador = last_insert_id();
END $$

-- STORE PROCEDURE PARA ELIMINAR PARCIALMENTE UN ADMINISTRADOR.

DELIMITER $$

Drop PROCEDURE IF EXISTS SPDelAdministrador $$

CREATE PROCEDURE SPDelAdministrador(xidAdministrador INT)
BEGIN
    -- Se verifica que el administrador no tenga paquetes asignados todavia
    DECLARE pedidos_count INT;
    
    SELECT COUNT(*) INTO pedidos_count 
    FROM Pedido 
    WHERE Administrador_idAdministrador = xidAdministrador;
    
    IF pedidos_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar el administrador porque tiene pedidos asociados';
    ELSE
        DELETE FROM Administrador 
        WHERE idAdministrador = xidAdministrador;
    END IF;
END $$

-- STORE PROCEDURE PARA ACTUALIZAR TODAS LAS TUPLAS DE LA ENTIDAD ADMINISTRADOR

DELIMITER $$

Drop PROCEDURE IF EXISTS SPActAdmi $$

CREATE PROCEDURE SPActAdmi(
    xidAdministrador INT,
    xName VARCHAR(45),
    xPassword VARCHAR(45)
)
BEGIN
    UPDATE Administrador
    SET Name = xName, Passworld = xPassword
    WHERE idAdministrador = xidAdministrador;
END $$