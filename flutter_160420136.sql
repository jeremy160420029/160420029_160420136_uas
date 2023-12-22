-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema flutter_160420136
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema flutter_160420136
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `flutter_160420136` DEFAULT CHARACTER SET utf8 ;
USE `flutter_160420136` ;

-- -----------------------------------------------------
-- Table `flutter_160420136`.`penggunas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `flutter_160420136`.`penggunas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NULL,
  `nama_lengkap` VARCHAR(100) NULL,
  `password` VARCHAR(45) NULL,
  `gambar` LONGBLOB NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `flutter_160420136`.`dolanans`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `flutter_160420136`.`dolanans` (
  `id` INT NOT NULL,
  `nama_dolan` VARCHAR(45) NULL,
  `minimal_member` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `flutter_160420136`.`jadwals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `flutter_160420136`.`jadwals` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tanggal` DATE NULL,
  `jam` TIME NULL,
  `lokasi` VARCHAR(200) NULL,
  `alamat` VARCHAR(500) NULL,
  `dolanans_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_jadwals_dolanans1_idx` (`dolanans_id` ASC) VISIBLE,
  CONSTRAINT `fk_jadwals_dolanans1`
    FOREIGN KEY (`dolanans_id`)
    REFERENCES `flutter_160420136`.`dolanans` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `flutter_160420136`.`list_jadwals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `flutter_160420136`.`list_jadwals` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pengguna` INT NOT NULL,
  `jadwal` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_users_has_schedules_schedules1_idx` (`jadwal` ASC) VISIBLE,
  INDEX `fk_users_has_schedules_users_idx` (`pengguna` ASC) VISIBLE,
  CONSTRAINT `fk_users_has_schedules_users`
    FOREIGN KEY (`pengguna`)
    REFERENCES `flutter_160420136`.`penggunas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_schedules_schedules1`
    FOREIGN KEY (`jadwal`)
    REFERENCES `flutter_160420136`.`jadwals` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `flutter_160420136`.`ngobrols`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `flutter_160420136`.`ngobrols` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `isi` LONGTEXT NULL,
  `list_jadwal` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_chats_users_has_schedules1_idx` (`list_jadwal` ASC) VISIBLE,
  CONSTRAINT `fk_chats_users_has_schedules1`
    FOREIGN KEY (`list_jadwal`)
    REFERENCES `flutter_160420136`.`list_jadwals` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
