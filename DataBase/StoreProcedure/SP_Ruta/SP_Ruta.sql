-- =====================================================================
-- PROCEDIMIENTOS PARA GESTIÓN DE RUTAS
-- =====================================================================

-- Procedimiento para crear una nueva ruta
DELIMITER $$
Drop PROCEDURE IF EXISTS  SPCrearRuta $$

CREATE PROCEDURE SPCrearRuta(
    OUT xidRuta INT,
    IN xOrigen VARCHAR(45),
    IN xDestino VARCHAR(45)
)
BEGIN
    INSERT INTO Ruta (Origen, Destino)
    VALUES (xOrigen, xDestino);
    
    set xidRuta = last_insert_id();
END $$
DELIMITER ;