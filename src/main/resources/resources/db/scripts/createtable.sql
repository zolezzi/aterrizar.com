CREATE TABLE `aterrizar_schema`.`users` (
										  `iduser` INT NOT NULL AUTO_INCREMENT,
  
										  `nombreUsuario` VARCHAR(45) NOT NULL,

								  		  `Nombre` VARCHAR(45) NOT NULL,
 					   
										  `apellido` VARCHAR(45) NOT NULL,
 
 					  					  `email` VARCHAR(45) NOT NULL,
 
				   					 	  `FechaNacimiento` VARCHAR(45) NULL,
  
					   					  `contrasenia` VARCHAR(45) NOT NULL,
  					 
					   					  `validado` TINYINT(1) NULL,
  
					    				  PRIMARY KEY (`iduser`, `nombreUsuario`));
