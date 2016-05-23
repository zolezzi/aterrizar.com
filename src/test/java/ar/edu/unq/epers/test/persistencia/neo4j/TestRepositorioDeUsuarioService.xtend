package ar.edu.unq.epers.test.persistencia.neo4j


import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.servicios.neo4j.AmigosService

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
			nombre = "carlos"
			apellido = "albar"		  
			email = "c_alabar@hotmail.com"
			fechaNacimiento = "12/3/1990"
			contrasenia = "albar" 
			codValidacion = "cod2Tst"
		]
		
		charlie = new Usuario => [
			nombreUsuario = "charlie"
			nombre = "carlos"
			apellido = "albar"		  
			email = "c_alabar@hotmail.com"
			fechaNacimiento = "12/3/1990"
			contrasenia = "albar" 
			codValidacion = "cod2Tst"
		]
		
		 nico = new Usuario => [
			nombreUsuario = "nico"
			nombre = "carlos"
			apellido = "albar"		  
			email = "c_alabar@hotmail.com"
			fechaNacimiento = "12/3/1990"
			contrasenia = "albar" 
			codValidacion = "cod2Tst"
		]
		
		ezequiel = new Usuario => [
			nombreUsuario = "ezequiel"
			nombre = "carlos"
			apellido = "albar"		  
			email = "c_alabar@hotmail.com"
			fechaNacimiento = "12/3/1990"
			contrasenia = "albar" 
			codValidacion = "cod2Tst"
		]
		
		  miami = new Usuario => [
			nombreUsuario = "miami"
			nombre = "carlos"
			apellido = "albar"		  
			email = "c_alabar@hotmail.com"
			fechaNacimiento = "12/3/1990"
			contrasenia = "albar" 
			codValidacion = "cod2Tst"
					]
		repositorioService.agregarAmigo(ricky, charlie)
		repositorioService.agregarAmigo(charlie, ezequiel)
		repositorioService.agregarAmigo(nico, miami)
		repositorioService.agregarAmigo(ezequiel, nico)
		
		repositorioService.getbase.insertUser(charlie , 0)
		repositorioService.getbase.insertUser(nico , 1)
		repositorioService.getbase.insertUser(ricky , 2)
		repositorioService.getbase.insertUser(miami , 3)
		repositorioService.getbase.insertUser(ezequiel , 4)
		
		
		}
		
		
	@Test
	def void testConsultarCantidadAmigos(){
		var cantidadDeAmigos = repositorioService.cuantosConozco(charlie)	
		Assert.assertEquals(1, cantidadDeAmigos)
		
	}
	@After
	def void after(){}
}