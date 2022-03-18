-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=1;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `optica` DEFAULT CHARACTER SET utf8 ;
USE `optica` ;

-- -----------------------------------------------------
-- Table `optica`.`adresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`adresses` (
  `adresses_id` INT NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(45) NOT NULL COMMENT 'street name + street number',
  `complement` VARCHAR(45) NULL COMMENT 'floor, office number, others infos',
  `city` VARCHAR(45) NULL,
  `state` VARCHAR(2) NULL,
  `country` VARCHAR(2) NULL,
  `zip_code` VARCHAR(45) NULL,
  PRIMARY KEY (`adresses_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`fiscal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`fiscal` (
  `fiscal_id` INT NOT NULL AUTO_INCREMENT,
  `document` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`fiscal_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`contact`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`contact` (
  `contact_id` INT NOT NULL AUTO_INCREMENT,
  `phone` VARCHAR(40) NULL,
  `fax` VARCHAR(40) NULL,
  `email` VARCHAR(254) NULL,
  PRIMARY KEY (`contact_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`contact_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`contact_info` (
  `contact_info_id` INT NOT NULL AUTO_INCREMENT,
  `adresses_id` INT NOT NULL,
  `fiscal_id` INT UNIQUE NOT NULL,
  `contact_id` INT NOT NULL,
  PRIMARY KEY (`contact_info_id`),
  INDEX `fk_contact_full_adresses1_idx` (`adresses_id` ASC) VISIBLE,
  INDEX `fk_contact_full_fiscal_info1_idx` (`fiscal_id` ASC) VISIBLE,
  INDEX `fk_contact_full_contact_info1_idx` (`contact_id` ASC) VISIBLE,
  CONSTRAINT `fk_contact_full_adresses1`
    FOREIGN KEY (`adresses_id`)
    REFERENCES `optica`.`adresses` (`adresses_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_contact_full_fiscal_info1`
    FOREIGN KEY (`fiscal_id`)
    REFERENCES `optica`.`fiscal` (`fiscal_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_contact_full_contact_info1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `optica`.`contact` (`contact_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`suppliers` (
  `suppliers_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `contact_info_id` INT NOT NULL,
  PRIMARY KEY (`suppliers_id`),
  INDEX `fk_suppliers_contact_info1_idx` (`contact_info_id` ASC) VISIBLE,
  CONSTRAINT `fk_suppliers_contact_info1`
    FOREIGN KEY (`contact_info_id`)
    REFERENCES `optica`.`contact_info` (`contact_info_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`brand`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`brand` (
  `brand_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL UNIQUE,
  `suppliers_id` INT NOT NULL,
  PRIMARY KEY (`brand_id`),
  INDEX `fk_brand_suppliers1_idx` (`suppliers_id` ASC) VISIBLE,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  CONSTRAINT `fk_brand_suppliers1`
    FOREIGN KEY (`suppliers_id`)
    REFERENCES `optica`.`suppliers` (`suppliers_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `optica`.`frame`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`frame` (
  `frame_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `brand_id` INT NOT NULL,
  `frame_type` ENUM('plastic', 'metallic', 'floating') NOT NULL,
  `frame_color` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`frame_id`),
  INDEX `fk_item_brand1_idx` (`brand_id` ASC) VISIBLE,
  CONSTRAINT `fk_item_brand1`
    FOREIGN KEY (`brand_id`)
    REFERENCES `optica`.`brand` (`brand_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`customers` (
  `customers_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `contact_info_id` INT NOT NULL,
  `invited_by` INT NULL DEFAULT NULL,
  `register_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customers_id`),
  INDEX `fk_customers_contact_info1_idx` (`contact_info_id` ASC) VISIBLE,
  INDEX `fk_customers_customers1_idx` (`invited_by` ASC) VISIBLE,
  CONSTRAINT `fk_customers_contact_info1`
    FOREIGN KEY (`contact_info_id`)
    REFERENCES `optica`.`contact_info` (`contact_info_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_customers_customers1`
    FOREIGN KEY (`invited_by`)
    REFERENCES `optica`.`customers` (`customers_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`employees` (
  `employees_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `contact_info_id` INT NOT NULL,
  PRIMARY KEY (`employees_id`),
  INDEX `fk_employees_contact_info1_idx` (`contact_info_id` ASC) VISIBLE,
  CONSTRAINT `fk_employees_contact_info1`
    FOREIGN KEY (`contact_info_id`)
    REFERENCES `optica`.`contact_info` (`contact_info_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`orders` (
  `orders_id` INT NOT NULL AUTO_INCREMENT,
  `customers_id` INT NOT NULL,
  `employees_id` INT NOT NULL,
  PRIMARY KEY (`orders_id`),
  INDEX `fk_order_customers_idx` (`customers_id` ASC) VISIBLE,
  INDEX `fk_orders_employees1_idx` (`employees_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_customers`
    FOREIGN KEY (`customers_id`)
    REFERENCES `optica`.`customers` (`customers_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_orders_employees1`
    FOREIGN KEY (`employees_id`)
    REFERENCES `optica`.`employees` (`employees_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`eye_prescription`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`eye_prescription` (
  `eye_prescription_id` INT NOT NULL AUTO_INCREMENT,
  `sphere` FLOAT NULL,
  `cylinder` FLOAT NULL,
  `axis` INT NULL,
  `add` FLOAT NULL,
  `prism` FLOAT NULL,
  `base` ENUM('BU', 'BD', 'BI', 'BO') NULL,
  PRIMARY KEY (`eye_prescription_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`lenses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`lenses` (
  `lenses_id` INT NOT NULL AUTO_INCREMENT,
  `left_color` VARCHAR(45) NOT NULL DEFAULT 'Transparent',
  `right_color` VARCHAR(45) NOT NULL DEFAULT 'Transparent',
  `left_eye_prescription_id` INT NOT NULL,
  `right_eye_prescription_id` INT NOT NULL,
  PRIMARY KEY (`lenses_id`),
  INDEX `fk_lenses_eye_prescription1_idx` (`left_eye_prescription_id` ASC) VISIBLE,
  INDEX `fk_lenses_eye_prescription2_idx` (`right_eye_prescription_id` ASC) VISIBLE,
  CONSTRAINT `fk_lenses_eye_prescription1`
    FOREIGN KEY (`left_eye_prescription_id`)
    REFERENCES `optica`.`eye_prescription` (`eye_prescription_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_lenses_eye_prescription2`
    FOREIGN KEY (`right_eye_prescription_id`)
    REFERENCES `optica`.`eye_prescription` (`eye_prescription_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`glasses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`glasses` (
  `glasses_id` INT NOT NULL AUTO_INCREMENT,
  `frame_id` INT NOT NULL,
  `lenses_id` INT NOT NULL,
  `price` DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (`glasses_id`),
  INDEX `fk_glasses_frame1_idx` (`frame_id` ASC) VISIBLE,
  INDEX `fk_glasses_lenses1_idx` (`lenses_id` ASC) VISIBLE,
  CONSTRAINT `fk_glasses_frame1`
    FOREIGN KEY (`frame_id`)
    REFERENCES `optica`.`frame` (`frame_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_glasses_lenses1`
    FOREIGN KEY (`lenses_id`)
    REFERENCES `optica`.`lenses` (`lenses_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`glasses_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`glasses_orders` (
  `orders_id` INT NOT NULL,
  `glasses_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`orders_id`, `glasses_id`),
  INDEX `fk_glasses_has_orders_orders1_idx` (`orders_id` ASC) VISIBLE,
  INDEX `fk_glasses_has_orders_glasses1_idx` (`glasses_id` ASC) VISIBLE,
  CONSTRAINT `fk_glasses_has_orders_glasses1`
    FOREIGN KEY (`glasses_id`)
    REFERENCES `optica`.`glasses` (`glasses_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_glasses_has_orders_orders1`
    FOREIGN KEY (`orders_id`)
    REFERENCES `optica`.`orders` (`orders_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;




-- -------------------------------- --
--     Populate Optica Data         --
-- -------------------------------- --

use `optica`;

-- create adresses data
insert into adresses values
	(default, 'Vila Dois Irmãos 1728', NULL, 'Belem', 'PA', 'BR', '66073-170'),
    (default, 'Rua Faradim 1775', '3rd floor', 'Divinópolis', 'MG', 'BR', '35500-212'),
    (default, 'Praça Assembléia de Deus 555', NULL, 'Jacareí', 'SP', 'BR', '12307-470'),
    (default, 'Rua Havana 525', 'Room 123', 'Rua Havana 525', 'CE', 'BR', '60764-770'),
    (default, 'Viela Um 27', NULL, 'Itatiba', 'SP', 'BR', '13256-217'),
    (default, 'Rua Governador José Bezerra 628', NULL, 'Caruaru', 'PE', 'BR', '55004-340'),
    (default, 'Rua Onze 541', 'Bloco B - 123', 'Contagem', 'MG', 'BR', '32071-163'),
    (default, 'Rua Perdiz da Campina 134', NULL, 'Jaboatão Dos Guararapes', 'PE', 'BR', '54230-361'),
    (default, 'Alameda Rouxinol 529', '10th floor - room 1005', 'Itapecerica Da Serra', 'SP', 'BR', '06872-444'),
    (default, 'Rua Palermo 561', NULL, 'Curitiba', 'PR', 'BR', '82020-110');
    
-- create contact data
insert into contact values
	(default, 9121222637, NULL, 'doisirmaos@belem.com.br'),
	(default, 3745994462, 3745994462, NULL),
    (default, 1266537135, 1266537135, 'deus@jacarei.com.br'),
    (default, 8556623212, NULL, 'havana@uhlala.com'),
    (default, 1147103510, NULL, NULL),
    (default, 8137767649, NULL, 'thegovernor@caruaru.com'),
    (default, 3163828526, 3163828526, NULL),
    (default, 8165842481, NULL, NULL),
    (default, 1188154510, NULL, 'rouxinol@bird.com.br'),
    (default, 4148833719, NULL, NULL);
    
-- create fiscal data
insert into fiscal values
	(default, 9121222637),
    (default, 'ABC123'),
    (default, 'Y123456K'),
    (default, '00058720900'),
    (default, 'CB738911'),
    (default, '1873182370'),
    (default, '9000000000'),
    (default, '1283718971'),
    (default, '10983101'),
    (default, '1298319A');
    
-- create contact info data
insert into contact_info values
	(default, 1, 1, 1),
    (default, 2, 2, 2),
    (default, 3, 3, 3),
    (default, 4, 4, 4),
    (default, 5, 5, 5),
    (default, 6, 6, 6),
    (default, 7, 7, 7),
    (default, 8, 8, 8),
    (default, 9, 9, 9),
    (default, 10, 10, 10);
    
-- create customer data
insert into customers values
	(default, 'Kenton Jaffray', 1, NULL, DEFAULT),
	(default, 'Pia Skramstad', 4, 1, DEFAULT),
   	(default, 'Kamila Matulessy', 5, NULL, DEFAULT),
	(default, 'Nicolaas Fang', 6, 2, DEFAULT);
    
    
-- create employees data
insert into employees values
	(default, 'Zion Kobayashi', 8),
	(default, 'Gro Ryland', 9),
   	(default, 'Dita Vítová', 10);
    
-- create suppliers data
insert into suppliers values
	(default, 'Raretaken', 2),
	(default, 'Nocturno', 3),
   	(default, 'Orkly', 7);
    
-- create brands data
insert into brand values
	(default, 'Boss', 1),
    (default, 'Ray-Ban', 1),
    (default, 'Gucci', 2),
    (default, 'Versace', 2),
    (default, 'Dolce & Gabana', 1);
    
-- create frames data
insert into frame values
	(default, 'plastyc', 1, 'plastic', 'black'),
	(default, 'metallyc', 1, 'metallic', 'chromed'),
    (default, 'floatyng', 1, 'floating', 'tiger stamp'),
    (default, 'verPlast', 4, 'plastic', 'blue'),
    (default, 'verMetal', 4, 'metallic', 'silver'),
    (default, 'verFloat', 4, 'floating', 'black'),
    (default, 'plastyc', 5, 'plastic', 'red');
    
    
-- create eye prescriptions data
insert into eye_prescription values
	(default, null, null, null, null, null, null),
	(default, -2.0 , null, null, 2.0, 0.5, 'BD'),
	(default, -1.0, -0.5, 180, 2.0, 0.5, 'BU');
    
-- create lenses data
insert into lenses values
	(default, default, default, 1, 1),
    (default, 'green', 'green', 2, 3),
    (default, default, default, 2, 2),
    (default, 'blue', 'blue', 1, 1);
    
-- create glasses data
insert into glasses values
	(default, 1, 1, 150.25),
    (default, 2, 2, 200),
    (default, 3, 3, 180),
    (default, 4, 4, 190),
    (default, 4, 1, 150.25),
    (default, 1, 3, 87.78);
    
    
-- create orders data
insert into orders values
	(default, 1, 1),
    (default, 3, 1),
    (default, 4, 2),
    (default, 3, 2),
    (default, 1, 3),
    (default, 1, 1);
    
-- create glasses_orders data
insert into glasses_orders values
	(1, 1, 1),
    (1, 2, 2),
    (2, 5, 1),
    (3, 6, 1),
    (4, 3, 1),
    (4, 4, 1),
    (5, 1, 1),
    (6, 1, 1);
    



-- -------------------------------- --
--         Optica Queries           --
-- -------------------------------- --

SELECT o.orders_id from orders o natural join customers c where c.customers_id = 1;
SELECT distinct (f.name) from frame f natural join glasses g natural join glasses_orders go natural join orders o where o.employees_id = 1;
SELECT distinct (s.name) from suppliers s join brand b on s.suppliers_id = b.suppliers_id join frame f on b.brand_id = f.brand_id join glasses g on f.frame_id = g.frame_id join glasses_orders go on g.glasses_id = go.glasses_id;