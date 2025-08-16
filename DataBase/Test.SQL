use aurorabd;

-- Datos de prueba
Delimiter $$
Call PSCrearEmpresa (@Idempresa1,'Empresa Norte src') $$
Call PSCrearEmpresa (@Idempresa2,'Empresa Sur SA') $$
Call PSCrearEmpresa (@Idempresa3,'Sancor Seguro') $$
CALL PSCrearEmpresa (@Idempresa4, 'Empresa Para Eliminar') $$
Call PSCrearEmpresa (@Idempresa5,'Arcor Chocolateria') $$


/*se borrara ya que no tiene nada asignado*/
Delimiter $$
Call SPDelEmpresa(3) $$

/*Se testea que tenga todo parcialmente insertado, eliminacion parcial*/
Delimiter $$
CALL SPDelEmpresa(@Idempresa4) $$


Delimiter $$
Call SPNuevoAdministrador(@id1,'Victor', 'victor1234', @Idempresa1) $$
Call SPNuevoAdministrador(@id2,'Victoria', 'vic1234', @Idempresa1) $$
Call SPNuevoAdministrador(@id3,'pepe', 'pepe1234', @Idempresa2) $$
Call SPNuevoAdministrador(@id4,'messi', 'messi1234', @Idempresa2) $$
CALL SPNuevoAdministrador(@idAdm4, 'Laura', 'laura1234', @Idempresa4) $$


Delimiter $$
Call SPDelAdministrador(4) $$

/*Conductores*/
Delimiter $$
Call SPNewConductor(@id1c,'Samuel', '123456789', TRUE) $$
Call SPNewConductor(@id2c,'juan', 'juan1234', TRUE) $$
Call SPNewConductor(@id3c,'julian', 'julian1234', TRUE) $$
Call SPNewConductor(@id4c,'pepe', 'pepe1234', TRUE) $$

Delimiter $$
call SPDelConductor(4) $$

Delimiter $$
call UpdateConductor(1, 'samuel1234') $$

/*Nuevos Vehiculos*/

Delimiter $$
call SPCrearVehiculo(@Veh1,'camioncito', 'm34c123', 1000, TRUE) $$ 
call SPCrearVehiculo(@Veh2,'Furgoneta', 'MAT002', 500, TRUE) $$
call SPCrearVehiculo(@Veh3,'Camión Grande', 'MAT003', 2000, TRUE) $$
call SPCrearVehiculo(@Veh4,'Furgoneta Pequeña', 'MAT004', 300, TRUE) $$
CALL SPCrearVehiculo(@idVeh4, 'Test Truck', 'ZXC123', 1500, TRUE) $$


Delimiter $$
call SPDelVehiculo(2) $$

Delimiter $$
call UpdateVehiculo(1, 'ABC021HC') $$

/*Rutas*/
Delimiter $$
CALL SPCrearRuta(@r1,'Cordoba', 'BSAS') $$
CALL SPCrearRuta(@r2,'BSAS', 'Cordoba') $$
CALL SPCrearRuta(@r3,'Posadas', 'Resistencia') $$
CALL SPCrearRuta(@r4,'Montevideo', 'BSAS') $$
CALL SPCrearRuta(@r5,'Santa Rosa', 'Chivilcoy') $$
CALL SPCrearRuta(@r6,'Chacomus', 'La Plata') $$
CALL SPCrearRuta(@r7,'Viedma', 'Bariloche') $$

/*Asignar condcutor a un vehiculo*/
Delimiter $$
CALL AsignarVehiculoAConductor(2, 3) $$
CALL AsignarVehiculoAConductor(3, 4) $$

/*Desagsignar vehiculo a conductor*/
Delimiter $$
call SPDesasignarVehiculoAConductor (3,4) $$

/*Registrar pedido*/
/*Asignar pedido a vehiculo*/
-- ID + NAME + VOL + PESO + ESTADO + FECHA + IDADMIN + IDDESTINO + IDRUTA + IDVEHICULO
DELIMITER $$
CALL SPCrearPedido(@p2,'Troncos', 1500, 600, 'Creado', curdate(), 1, 2,2,3) $$
CALL SPCrearPedido(@p3,'aceite 1lt', 200, 100, 'Creado', curdate(), 1, 2,6,1) $$
CALL SPCrearPedido(@p4,'aceitunas 1lt', 200, 100, 'Creado', curdate(), 1, 2,6,1) $$
CALL SPCrearPedido(@p5,'leche La Serenicima', 200, 100, 'Creado', curdate(), 1, 2,6,1) $$
CALL SPCrearPedido(@p6,'Cafe molido', 123, 80, 'Creado', curdate(), 1, 2,6,1) $$

CALL SPCrearPedido(@idPed4, 'Pedido Test', 200, 80, 'Creado', CURDATE(), 4, @Idempresa4, 1, @idVeh4) $$


/*Simular que el paquete ya fue recibido y confirmado su entrega por parte del receptor*/

Delimiter $$
call SPUpdateEstadoPedido(@p2, 'Recibido') $$
