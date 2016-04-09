CREATE TABLE `aterrizar_p2`.`usuarios` (
	`id_usuario` INT NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(45) NOT NULL,
	`apellido` VARCHAR(45) NOT NULL,
	`nombre_usuario` VARCHAR(45) NOT NULL,
	`email` VARCHAR(45) NOT NULL,
	`fechanacimiento` VARCHAR(45) NULL,
	`contrasenha` VARCHAR(45) NOT NULL,
	`codigo_validacion` VARCHAR(45) NOT NULL,
PRIMARY KEY (`id_usuario`));