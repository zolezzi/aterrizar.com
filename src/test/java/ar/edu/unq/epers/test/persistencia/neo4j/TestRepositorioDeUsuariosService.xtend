package ar.edu.unq.epers.test.persistencia.neo4j


import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.servicios.neo4j.AmigosService
import ar.edu.unq.epers.aterrizar.persistencias.RepositorioUsuarios

class TestRepositorioUsuariosService {
	Usuario ricky
	Usuario charlie
	Usuario nico
	Usuario ezequiel
	Usuario miami
	
	AmigosService repositorioService
	
	@Before
	def void setUp(){

		repositorioService = new AmigosService() 

		ricky = new Usuario => [
			nombreUsuario = "ricky"
			nombre = "ricardo"
			apellido = "fort"		  
			email = "ricky@hotmail.com"
			fechaNacimiento = "12/3/1978"
			contrasenia = "123456" 
			codValidacion = "cod1"
		]
		
		charlie = new Usuario => [
			nombreUsuario = "charlie"
			nombre = "carlos"
			apellido = "z"		  
			email = "c_z@hotmail.com"
			fechaNacimiento = "12/3/1991"
			contrasenia = "holaMundo" 
			codValidacion = "cod2Tst"
		]
		
		 nico = new Usuario => [
			nombreUsuario = "nico"
			nombre = "nico"
			apellido = "apu"		  
			email = "apu@hotmail.com"
			fechaNacimiento = "12/3/1990"
			contrasenia = "1234" 
			codValidacion = "cod2Tst"
		]
		
		ezequiel = new Usuario => [
			nombreUsuario = "ezequiel"
			nombre = "eze"
			apellido = "luna"		  
			email = "hola@hotmail.com"
			fechaNacimiento = "12/3/1986"
			contrasenia = "hola" 
			codValidacion = "cod2Tst"
		]
		
		  miami = new Usuario => [
			nombreUsuario = "miami"
			nombre = "MiamiBeach"
			apellido = "miamiii"		  
			email = "miami@hotmail.com"
			fechaNacimiento = "12/3/1990"
			contrasenia = "hola" 
			codValidacion = "cod2Tst"
		]
		
		repositorioService.getbase.insertUser(charlie , 1)
		repositorioService.getbase.insertUser(nico , 1)
		repositorioService.getbase.insertUser(ricky , 1)
		repositorioService.getbase.insertUser(miami , 1)
		repositorioService.getbase.insertUser(ezequiel , 1)
					
		repositorioService.agregarAmigo(charlie, ezequiel)/*		
		repositorioService.agregarAmigo(ricky, charlie)
		repositorioService.agregarAmigo(nico, miami)
		repositorioService.agregarAmigo(ezequiel, nico)*/
				
		}
		
	@Test
	def void testConsultarCantidadAmigos(){
		var cantidadDeAmigos = repositorioService.cuantosConozco(charlie)	
		Assert.assertEquals(1, cantidadDeAmigos)
		
	}
	@After
	def void after(){
		
		repositorioService.eliminarUsuario(charlie)
		repositorioService.eliminarUsuario(ezequiel)
	/* 	repositorioService.eliminarUsuario(nico)
		repositorioService.eliminarUsuario(ricky)
		repositorioService.eliminarUsuario(miami)*/
	}
}