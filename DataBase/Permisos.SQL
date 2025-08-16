-- Drop de usuarios
DROP USER IF EXISTS 'Empresa'@'localhost';
DROP USER IF EXISTS 'Administradores'@'%';

-- Creacion de usuarios
CREATE USER if NOT EXISTS 'Empresa'@'localhost' IDENTIFIED BY 'Empresa159!';
CREATE USER if NOT EXISTS 'Administradores'@'%' IDENTIFIED BY 'Admin753!';

/* La empresa (el jefecito) podra hacer cualquier accion exceptuando la asignasion de pedidos a vehiculos*/
GRANT ALL on `Aurorabd`.`Administrador` to 'Empresa'@'localhost';
GRANT ALL on `Aurorabd`.`Conductor` to 'Empresa'@'localhost';
GRANT ALL on `Aurorabd`.`Vehiculo` to 'Empresa'@'localhost';
GRANT ALL on `Aurorabd`.`Conductor_has_Vehiculo` to 'Empresa'@'localhost';
GRANT SELECT on `Aurorabd`.`Pedido` to 'Empresa'@'localhost';

/*Los administradores solo podran administrar los pedidos, rutas, como seleccionar a vehiculos y conductores.*/
GRANT SELECT on `Aurorabd`.`Vehiculo` to 'Administradores'@'%';
GRANT SELECT on `Aurorabd`.`Conductor` to 'Administradores'@'%';
GRANT SELECT, CREATE on `Aurorabd`.`Ruta` to 'Administradores'@'%';
GRANT SELECT, CREATE on `Aurorabd`.`Pedido` to 'Administradores'@'%';