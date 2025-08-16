-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Aurorabd
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Aurorabd` ;

-- -----------------------------------------------------
-- Schema Aurorabd
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Aurorabd` DEFAULT CHARACTER SET utf8 ;
USE `Aurorabd` ;

-- -----------------------------------------------------
-- Table `Aurorabd`.`Empresa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aurorabd`.`Empresa` ;

CREATE TABLE IF NOT EXISTS `Aurorabd`.`Empresa` (
  `idEmpresa` INT NOT NULL,
  `Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`idEmpresa`),
  UNIQUE INDEX `Nombre_UNIQUE` (`Nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aurorabd`.`Administrador`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aurorabd`.`Administrador` ;

CREATE TABLE IF NOT EXISTS `Aurorabd`.`Administrador` (
  `idAdministrador` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Passworld` VARCHAR(45) NULL,
  `idEmpresa` INT NOT NULL,
  PRIMARY KEY (`idAdministrador`),
  INDEX `fk_Administrador_Empresa_idx` (`idEmpresa` ASC) VISIBLE,
  CONSTRAINT `fk_Administrador_Empresa`
    FOREIGN KEY (`idEmpresa`)
    REFERENCES `Aurorabd`.`Empresa` (`idEmpresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aurorabd`.`Ruta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aurorabd`.`Ruta` ;

CREATE TABLE IF NOT EXISTS `Aurorabd`.`Ruta` (
  `idRuta` INT NOT NULL,
  `Origen` VARCHAR(45) NULL,
  `Destino` VARCHAR(45) NULL,
  PRIMARY KEY (`idRuta`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aurorabd`.`Vehiculo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aurorabd`.`Vehiculo` ;

CREATE TABLE IF NOT EXISTS `Aurorabd`.`Vehiculo` (
  `idVehiculo` INT NOT NULL,
  `Tipo` VARCHAR(45) NULL,
  `Matricula` VARCHAR(45) NULL,
  `CapacidadMaz` DOUBLE NULL,
  `Estado` TINYINT NULL,
  PRIMARY KEY (`idVehiculo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aurorabd`.`Pedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aurorabd`.`Pedido` ;

CREATE TABLE IF NOT EXISTS `Aurorabd`.`Pedido` (
  `idPedido` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Volumen` VARCHAR(45) NULL,
  `Peso` VARCHAR(45) NULL,
  `EstadoPedido` VARCHAR(45) NULL,
  `FechaDespacho` DATE NULL,
  `Administrador_idAdministrador` INT NOT NULL,
  `EmpresaDestino` INT NOT NULL,
  `Ruta_idRuta` INT NOT NULL,
  `Vehiculo_idVehiculo` INT NOT NULL,
  PRIMARY KEY (`idPedido`),
  INDEX `fk_Pedido_Administrador1_idx` (`Administrador_idAdministrador` ASC) VISIBLE,
  INDEX `fk_Pedido_Pedido2_idx` (`EmpresaDestino` ASC) VISIBLE,
  INDEX `fk_Pedido_Ruta1_idx` (`Ruta_idRuta` ASC) VISIBLE,
  INDEX `fk_Pedido_Vehiculo1_idx` (`Vehiculo_idVehiculo` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Administrador1`
    FOREIGN KEY (`Administrador_idAdministrador`)
    REFERENCES `Aurorabd`.`Administrador` (`idAdministrador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Pedido2`
    FOREIGN KEY (`EmpresaDestino`)
    REFERENCES `Aurorabd`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Ruta1`
    FOREIGN KEY (`Ruta_idRuta`)
    REFERENCES `Aurorabd`.`Ruta` (`idRuta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Vehiculo1`
    FOREIGN KEY (`Vehiculo_idVehiculo`)
    REFERENCES `Aurorabd`.`Vehiculo` (`idVehiculo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aurorabd`.`Conductor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aurorabd`.`Conductor` ;

CREATE TABLE IF NOT EXISTS `Aurorabd`.`Conductor` (
  `idConductor` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Licencia` VARCHAR(45) NULL,
  `Disponibilidad` TINYINT NULL,
  PRIMARY KEY (`idConductor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aurorabd`.`Conductor_has_Vehiculo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aurorabd`.`Conductor_has_Vehiculo` ;

CREATE TABLE IF NOT EXISTS `Aurorabd`.`Conductor_has_Vehiculo` (
  `idConductor` INT NOT NULL,
  `idVehiculo` INT NOT NULL,
  `FechaAsignado` DATE NULL,
  PRIMARY KEY (`idConductor`, `idVehiculo`),
  INDEX `fk_Conductor_has_Vehiculo_Vehiculo1_idx` (`idVehiculo` ASC) VISIBLE,
  INDEX `fk_Conductor_has_Vehiculo_Conductor1_idx` (`idConductor` ASC) VISIBLE,
  CONSTRAINT `fk_Conductor_has_Vehiculo_Conductor1`
    FOREIGN KEY (`idConductor`)
    REFERENCES `Aurorabd`.`Conductor` (`idConductor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Conductor_has_Vehiculo_Vehiculo1`
    FOREIGN KEY (`idVehiculo`)
    REFERENCES `Aurorabd`.`Vehiculo` (`idVehiculo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aurorabd`.`HistorialPedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aurorabd`.`HistorialPedido` ;

CREATE TABLE IF NOT EXISTS `Aurorabd`.`HistorialPedido` (
  `idHistorialPedido` INT NOT NULL,
  `EstadoAnterior` VARCHAR(45) NULL,
  `EstadoNuevo` VARCHAR(45) NULL,
  `FechaCambio` DATETIME NULL,
  `Pedido_idPedido` INT NOT NULL,
  PRIMARY KEY (`idHistorialPedido`),
  INDEX `fk_HistorialPedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  CONSTRAINT `fk_HistorialPedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `Aurorabd`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
