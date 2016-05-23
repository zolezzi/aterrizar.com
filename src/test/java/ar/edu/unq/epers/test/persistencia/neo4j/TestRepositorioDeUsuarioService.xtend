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
	RepositorioUsuarios BD_SQL
	
	@Before
	def void setUp(){

		repositorioService = new AmigosService() 
		BD_SQL = new RepositorioUsuarios()

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
								
		repositorioService.getbase.insertUser(charlie , 1)
		repositorioService.getbase.insertUser(nico , 1)
		repositorioService.getbase.insertUser(ricky , 1)
		repositorioService.getbase.insertUser(miami , 1)
		repositorioService.getbase.insertUser(ezequiel , 1)
		
		repositorioService.agregarAmigo(ricky, charlie)
		repositorioService.agregarAmigo(charlie, ezequiel)
		repositorioService.agregarAmigo(nico, miami)
		repositorioService.agregarAmigo(ezequiel, nico)
		
		
		
		}
		
		
	@Test
	def void testConsultarCantidadAmigos(){
		var cantidadDeAmigos = repositorioService.cuantosConozco(charlie)	
		Assert.assertEquals(1, cantidadDeAmigos)
		
	}

}