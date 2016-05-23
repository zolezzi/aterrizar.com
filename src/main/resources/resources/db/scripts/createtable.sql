CREATE TABLE `aterrizar_schema`.`users` (
										  `ID_USUARIO` INT NOT NULL AUTO_INCREMENT,  
										  `NOMBREUSUARIO` VARCHAR(45) NOT NULL,
								  		  `NOMBRE` VARCHAR(45) NOT NULL, 					   
										  `APELLIDO` VARCHAR(45) NOT NULL, 
 					  					  `EMAIL` VARCHAR(45) NOT NULL, 
				   					 	  `FECHANACIMIENTO` VARCHAR(45) NULL,  
					   					  `CONTRASENHA` VARCHAR(45) NOT NULL,  					 
					   					  `VALIDADO` TINYINT(1) NULL,					   					  
  										  `CODVALIDACION` VARCHAR(45) NOT NULL,  										  
					    				   PRIMARY KEY (`ID_USUARIO`, `NOMBREUSUARIO`));
