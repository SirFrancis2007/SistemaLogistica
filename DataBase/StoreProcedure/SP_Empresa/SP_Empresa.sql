/*Store Procedures para EMPRESA*/

-- STORE PROCEDURE PARA CREAR ENTIDAD EMPRESA.
DELIMITER $$
Drop PROCEDURE IF EXISTS  PSCrearEmpresa $$
CREATE PROCEDURE PSCrearEmpresa(OUT xidEmpresa INT, xNombre VARCHAR(45))
BEGIN
    INSERT INTO Empresa (Nombre)
    VALUES (xNombre);
    set xidEmpresa = last_insert_id();
END $$


-- STORE PROCEDURE PARA ELIMINAR PARCIALMENTE UNA EMPRESA.
-- PRIMERO SE ELIMINA EL HISTORIAL DE PEDIDOS LIGADOS A LA EMPRESA.
-- SEGUNDO SE ELIMINA TODO PEDIDO QUE ENVIA LA EMPRESA.
-- TERCERO SE ELIMINA TODO ADMINISTRADOR LIGADO A LA EMPRESA.
-- CUARTO  SE ELIMINA LA EMPRESA.

DELIMITER $$
DROP PROCEDURE IF EXISTS SPDelEmpresa $$
CREATE PROCEDURE SPDelEmpresa (IN xidEmpresa INT)
BEGIN
    START TRANSACTION;
    
    DELETE FROM HistorialPedido
    WHERE Pedido_idPedido IN (
        SELECT idPedido
        FROM Pedido
        WHERE EmpresaDestino = xidEmpresa
           OR Administrador_idAdministrador IN (
                SELECT idAdministrador
                FROM Administrador
                WHERE Empresa_idEmpresa = xidEmpresa
           )
    );
    
    DELETE FROM Pedido 
    WHERE EmpresaDestino = xidEmpresa
       OR Administrador_idAdministrador IN (
                                            SELECT idAdministrador
                                            FROM Administrador
                                            WHERE Empresa_idEmpresa = xidEmpresa
                                        );
    
    DELETE FROM Administrador 
    WHERE Empresa_idEmpresa = xidEmpresa;
    
    DELETE FROM Empresa 
    WHERE idEmpresa = xidEmpresa;
    
    COMMIT;
END $$