-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=1;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=1;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pizzaria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pizzaria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzaria` DEFAULT CHARACTER SET utf8 ;
USE `pizzaria` ;

-- -----------------------------------------------------
-- Table `pizzaria`.`provinces`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzaria`.`provinces` (
  `provinces_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`provinces_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzaria`.`localities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzaria`.`localities` (
  `localities_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `provinces_id` INT NOT NULL,
  PRIMARY KEY (`localities_id`),
  INDEX `fk_localities_provinces_idx` (`provinces_id` ASC) VISIBLE,
  CONSTRAINT `fk_localities_provinces`
    FOREIGN KEY (`provinces_id`)
    REFERENCES `pizzaria`.`provinces` (`provinces_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzaria`.`addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzaria`.`addresses` (
  `addresses_id` INT NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(45) NOT NULL,
  `complement` VARCHAR(45) NULL,
  `zip_code` VARCHAR(45) NOT NULL,
  `localities_id` INT NOT NULL,
  PRIMARY KEY (`addresses_id`),
  INDEX `fk_addresses_localities1_idx` (`localities_id` ASC) VISIBLE,
  UNIQUE INDEX `address_UNIQUE` (`address` ASC) VISIBLE,
  CONSTRAINT `fk_addresses_localities1`
    FOREIGN KEY (`localities_id`)
    REFERENCES `pizzaria`.`localities` (`localities_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzaria`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzaria`.`customers` (
  `customers_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `addresses_id` INT NOT NULL,
  PRIMARY KEY (`customers_id`),
  INDEX `fk_customers_addresses1_idx` (`addresses_id` ASC) VISIBLE,
  CONSTRAINT `fk_customers_addresses1`
    FOREIGN KEY (`addresses_id`)
    REFERENCES `pizzaria`.`addresses` (`addresses_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzaria`.`stores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzaria`.`stores` (
  `stores_id` INT NOT NULL,
  `addresses_id` INT NOT NULL,
  PRIMARY KEY (`stores_id`),
  INDEX `fk_stores_addresses1_idx` (`addresses_id` ASC) VISIBLE,
  UNIQUE INDEX `addresses_id_UNIQUE` (`addresses_id` ASC) VISIBLE,
  CONSTRAINT `fk_stores_addresses1`
    FOREIGN KEY (`addresses_id`)
    REFERENCES `pizzaria`.`addresses` (`addresses_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzaria`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzaria`.`employees` (
  `employees_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `addresses_id` INT NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `nif` VARCHAR(20) NOT NULL,
  `job` ENUM('cooker', 'delivery') NOT NULL,
  `hire_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dismiss_date` DATETIME NULL,
  PRIMARY KEY (`employees_id`),
  INDEX `fk_employees_addresses1_idx` (`addresses_id` ASC) VISIBLE,
  CONSTRAINT `fk_employees_addresses1`
    FOREIGN KEY (`addresses_id`)
    REFERENCES `pizzaria`.`addresses` (`addresses_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzaria`.`stores_employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzaria`.`stores_employees` (
  `stores_id` INT NOT NULL,
  `employees_id` INT NOT NULL,
  PRIMARY KEY (`stores_id`, `employees_id`),
  INDEX `fk_stores_has_employees_employees1_idx` (`employees_id` ASC) VISIBLE,
  INDEX `fk_stores_has_employees_stores1_idx` (`stores_id` ASC) VISIBLE,
  UNIQUE INDEX `employees_id_UNIQUE` (`employees_id` ASC) VISIBLE,
  CONSTRAINT `fk_stores_has_employees_stores1`
    FOREIGN KEY (`stores_id`)
    REFERENCES `pizzaria`.`stores` (`stores_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_stores_has_employees_employees1`
    FOREIGN KEY (`employees_id`)
    REFERENCES `pizzaria`.`employees` (`employees_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzaria`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzaria`.`orders` (
  `orders_id` INT NOT NULL AUTO_INCREMENT,
  `time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` ENUM('delivery', 'take away') NOT NULL,
  `stores_id` INT NOT NULL,
  `customers_id` INT NOT NULL,
  `employees_id` INT NULL,
  `delivery_time` DATETIME NULL,
  PRIMARY KEY (`orders_id`),
  INDEX `fk_orders_customers1_idx` (`customers_id` ASC) VISIBLE,
  INDEX `fk_orders_stores_employees1_idx` (`stores_id` ASC, `employees_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_customers1`
    FOREIGN KEY (`customers_id`)
    REFERENCES `pizzaria`.`customers` (`customers_id`),
  CONSTRAINT `fk_orders_stores_employees1`
    FOREIGN KEY (`stores_id` , `employees_id`)
    REFERENCES `pizzaria`.`stores_employees` (`stores_id` , `employees_id`),
	CONSTRAINT `ck_if_delivery`
    CHECK (
		CASE 
			WHEN `type` = 'delivery' AND  `employees_id` IS NOT NULL THEN 1
            WHEN `type` = 'take away' AND  `employees_id` IS NULL THEN 1
			ELSE 0
		END=1
    )
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzaria`.`pizzas_categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzaria`.`pizzas_categories` (
  `pizzas_categories_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`pizzas_categories_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzaria`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzaria`.`products` (
  `products_id` VARCHAR(5) NOT NULL COMMENT 'Letter (category) + 4 numbers (item id)',
  `type` ENUM('burguer', 'pizza', 'drink') NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` TINYTEXT NOT NULL DEFAULT (CONCAT('It is a ', `type`, ' named ', `name`)),
  `price` DECIMAL(10,2) NOT NULL,
  `photo` BLOB NULL,
  `pizzas_categories_id` INT NULL,
  PRIMARY KEY (`products_id`),
  INDEX `fk_pizzas_pizzas_categories1_idx` (`pizzas_categories_id` ASC) VISIBLE,
  CONSTRAINT `fk_pizzas_pizzas_categories1`
    FOREIGN KEY (`pizzas_categories_id`)
    REFERENCES `pizzaria`.`pizzas_categories` (`pizzas_categories_id`),
  CONSTRAINT `ck_if_not_pizza`
    CHECK (
		CASE 
			WHEN (`type` = 'burguer' OR `type` = 'drink') AND  `pizzas_categories_id` IS NULL THEN 1
			WHEN `type` = 'pizza' AND `pizzas_categories_id` IS NOT NULL THEN 1
            ELSE 0
		END=1
    )
    )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzaria`.`orders_products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzaria`.`orders_products` (
  `orders_id` INT NOT NULL,
  `products_id` VARCHAR(5) NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`orders_id`, `products_id`),
  INDEX `fk_orders_has_products_products1_idx` (`products_id` ASC) VISIBLE,
  INDEX `fk_orders_has_products_orders1_idx` (`orders_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_has_products_orders1`
    FOREIGN KEY (`orders_id`)
    REFERENCES `pizzaria`.`orders` (`orders_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_orders_has_products_products1`
    FOREIGN KEY (`products_id`)
    REFERENCES `pizzaria`.`products` (`products_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- -------------------------------------------- --
--             Populate tables data             --
-- -------------------------------------------- --

USE pizzaria;

INSERT INTO pizzas_categories (name) values ('Classic'), ('Special'), ('Premium'), ('Sweet');

INSERT INTO products (products_id, type, name, price, pizzas_categories_id)
	VALUES
		('D0001', 'drink',  'Water', 1.0, NULL),
        ('D0002', 'drink','Coke', 1.5, NULL),
        ('D0003', 'drink','Ice Tea', 1.2, NULL),
        ('B0001', 'burguer', 'Cheeseburger', 4.5, NULL),
        ('B0002', 'burguer', 'Special burguer', 5.1, NULL),
        ('B0003', 'burguer', 'Angus burguer', 6.5, NULL),
        ('P0001', 'pizza', 'Cheese', 4.0, 1),
        ('P0002', 'pizza', 'Iberic Ham', 5.5, 2),
        ('P0003', 'pizza', 'Chocolate', 4.5, 4);
        
INSERT INTO `provinces` (`provinces_id`, `name`)
VALUES
	(2,'Albacete'),
	(3,'Alicante/Alacant'),
	(4,'Almería'),
	(1,'Araba/Álava'),
	(33,'Asturias'),
	(5,'Ávila'),
	(6,'Badajoz'),
	(7,'Balears, Illes'),
	(8,'Barcelona'),
	(48,'Bizkaia'),
	(9,'Burgos'),
	(10,'Cáceres'),
	(11,'Cádiz'),
	(39,'Cantabria'),
	(12,'Castellón/Castelló'),
	(51,'Ceuta'),
	(13,'Ciudad Real'),
	(14,'Córdoba'),
	(15,'Coruña, A'),
	(16,'Cuenca'),
	(20,'Gipuzkoa'),
	(17,'Girona'),
	(18,'Granada'),
	(19,'Guadalajara'),
	(21,'Huelva'),
	(22,'Huesca'),
	(23,'Jaén'),
	(24,'León'),
	(27,'Lugo'),
	(25,'Lleida'),
	(28,'Madrid'),
	(29,'Málaga'),
	(52,'Melilla'),
	(30,'Murcia'),
	(31,'Navarra'),
	(32,'Ourense'),
	(34,'Palencia'),
	(35,'Palmas, Las'),
	(36,'Pontevedra'),
	(26,'Rioja, La'),
	(37,'Salamanca'),
	(38,'Santa Cruz de Tenerife'),
	(40,'Segovia'),
	(41,'Sevilla'),
	(42,'Soria'),
	(43,'Tarragona'),
	(44,'Teruel'),
	(45,'Toledo'),
	(46,'Valencia/València'),
	(47,'Valladolid'),
	(49,'Zamora'),
	(50,'Zaragoza');

INSERT INTO localities (name, provinces_id)
	VALUES
		('Valencia', 46),
        ('Barcelona', 8),
        ('Badalona', 8);
	
INSERT INTO addresses (address, complement, zip_code, localities_id)
	VALUES
		('Av. Diagonal, 211', '1st floor', '08018', 2), -- pizzaria 1
        ('Via Augusta, 9', NULL, '08911', 3), -- pizzaria 2
        ('Plaça Roca i Pi, 5', '3o 1a', '08911', 3), -- employee 1
        ('Plaça de Pep Ventura, 2', 'Bajo 1', '08912', 3), -- employee 2
        ('Carrer de la Industria, 226', NULL, '08026', 2), -- employee 3
        ('Carrer de Rosselló, 515', NULL, '08025', 2), -- customer 1
        ('Carrer de Montcada, 15', '1o2a', '08003', 2), -- customer 2
        ('Carrer de la Marina, 19', NULL, '08005', 2), -- customer 3
        ('Av. dels Vents, 9', '2o3a', '08917', 3); -- customer 4
        
INSERT INTO stores
	VALUES
		(1, 1),
        (2, 2);
        
INSERT INTO employees (first_name, last_name, addresses_id, phone, nif, job)
	VALUES
		('Antonio', 'Cobo Hijo', 3, '938 20 02 51', '446-40-4406', 'cooker'),
		('Raúl', 'Olivas', 4, '938 20 02 51', '870-16-0344', 'cooker'),
		('Asier', 'Ulibarri', 5, '932 80 59 49', '889-59-6862', 'delivery');
        
INSERT INTO stores_employees
	VALUES
		(1, 1),
        (2, 2),
        (2, 3);
        
INSERT INTO customers (first_name, last_name, phone, addresses_id)
	VALUES
		('Mario', 'Alicea Hijo', '936 92 78 84', 6),
        ('Ismael', 'Orta', '932 80 59 49', 7),
        ('Isabel', 'Medrano Segundo', '936 92 78 84', 8),
        ('Teresa', 'Pabón', '936 75 08 03', 9);
	
INSERT INTO orders (type, stores_id, customers_id, employees_id)
	VALUES
		('delivery', 2, 4, 3),
        ('take away', 2, 4, NULL),
        ('take away', 1, 1, NULL),
        ('take away', 1, 2, NULL),
        ('take away', 1, 3, NULL),
        ('delivery', 2, 4, 3);
        
INSERT INTO orders_products
	VALUES
		(1, 'D0001', 2),
        (1, 'P0001', 1),
        (1, 'P0002', 1),
        (2, 'P0003', 1),
        (3, 'D0002', 3),
        (3, 'B0001', 3),
        (4, 'D0003', 4),
        (4, 'P0002', 2),
        (4, 'P0003', 1),
        (5, 'P0001', 1),
        (6, 'D0003', 2),
        (6, 'B0003', 2);
        

-- -------------------------------------------- --
--             Query pizzaria data              --
-- -------------------------------------------- --

SELECT o.stores_id, sum(op.quantity) as Total_Drinks from orders o join orders_products op on o.orders_id = op.orders_id where o.stores_id = 1 and left(products_id, 1) = 'd';
SELECT o.employees_id, count(orders_id) as Total_Deliveries FROM orders o where employees_id = 3;
