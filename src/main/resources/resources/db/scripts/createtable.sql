CREATE TABLE `aterrizar_schema`.`users` (
										  `iduser` INT NOT NULL AUTO_INCREMENT,
  
										  `nombreUsuario` VARCHAR(45) NOT NULL,

								  		  `nombre` VARCHAR(45) NOT NULL,
 					   
										  `apellido` VARCHAR(45) NOT NULL,
 
 					  					  `email` VARCHAR(45) NOT NULL,
 
				   					 	  `fechaNacimiento` VARCHAR(45) NULL,
  
					   					  `contrasenia` VARCHAR(45) NOT NULL,
  					 
					   					  `validado` TINYINT(1) NULL,
					   					  
  										  `codvalidacion` VARCHAR(45) NOT NULL,
  										  
					    				   PRIMARY KEY (`iduser`, `nombreUsuario`));
