package ar.edu.unq.epers.test.persistencia.neo4j


import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.servicios.neo4j.AmigosService
import ar.edu.unq.epers.aterrizar.persistencias.RepositorioUsuarios
import ar.edu.unq.epers.aterrizar.modelo.Mensaje

class TestRepositorioUsuariosService {
	Usuario ricky
	Usuario charlie
	Usuario nico
	Usuario ezequiel
	Usuario miami
	Usuario usuarioConUnSoloAmigo
	Usuario usuarioAmigo
	
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
		
		usuarioConUnSoloAmigo = new Usuario => [
			nombreUsuario = "usuario"
			nombre = "root"
			apellido = "root"		  
			email = "root@hotmail.com"
			fechaNacimiento = "12/3/1990"
			contrasenia = "root" 
			codValidacion = "cd2po"
		]
		
		usuarioAmigo = new Usuario => [
			nombreUsuario = "usuarioAmigo"
			nombre = "amigos"
			apellido = "amigo"		  
			email = "amigo@hotmail.com"
			fechaNacimiento = "12/3/1990"
			contrasenia = "amigo" 
			codValidacion = "cod2T222"
		]
		
		repositorioService.getbase.insertUser(charlie , 1)
		repositorioService.getbase.insertUser(nico , 1)
		repositorioService.getbase.insertUser(ricky , 1)
		repositorioService.getbase.insertUser(miami , 1)
		repositorioService.getbase.insertUser(ezequiel , 1)
		repositorioService.getbase.insertUser(usuarioConUnSoloAmigo,1)
		repositorioService.getbase.insertUser(usuarioAmigo,1)
					
		repositorioService.agregarAmigo(charlie, ezequiel)		
		repositorioService.agregarAmigo(ricky, charlie)
		repositorioService.agregarAmigo(nico, miami)
		repositorioService.agregarAmigo(ezequiel, nico)
		repositorioService.agregarAmigo(usuarioConUnSoloAmigo, usuarioAmigo)
				
		}
		
	@Test
	def void testConsultarCantidadAmigos(){
		var cantidadDeConocidos = repositorioService.cuantosConozco(charlie)	
		Assert.assertEquals(4, cantidadDeConocidos)
		
	}
	
	@Test
	def void testUsuarioConUnSoloAmigo(){
		var cantidadDeConocidos = repositorioService.cuantosConozco(usuarioConUnSoloAmigo)
		Assert.assertEquals(cantidadDeConocidos,1)
	}
	
	@Test
	def void testEnviarMensajeAunAmigo(){
		var hola = new Mensaje()=> [
			emisor = charlie.nombreUsuario
			receptor = ezequiel.nombreUsuario
			texto = "texto"
			idMensaje = 0
		]
		repositorioService.enviarMensajeAUnUsuario(charlie, ezequiel, hola)
		var cantMsj = repositorioService.buscarMensajesEnviados(charlie).length
		Assert.assertEquals(cantMsj, 1)
	}
	
	@Test
	def void testEsAmigoDe(){
		Assert.assertTrue(repositorioService.esAmigo(charlie,ezequiel))
	}

	
	@After
	def void after(){
		
		repositorioService.eliminarUsuario(charlie)
		repositorioService.eliminarUsuario(ezequiel)
	 	repositorioService.eliminarUsuario(nico)
		repositorioService.eliminarUsuario(ricky)
		repositorioService.eliminarUsuario(miami)
		repositorioService.eliminarUsuario(usuarioConUnSoloAmigo)
		repositorioService.eliminarUsuario(usuarioAmigo)
		
		repositorioService.getbase.removeUser(charlie)
		repositorioService.getbase.removeUser(nico)
		repositorioService.getbase.removeUser(ricky)
		repositorioService.getbase.removeUser(miami)
		repositorioService.getbase.removeUser(ezequiel)
		repositorioService.getbase.removeUser(usuarioConUnSoloAmigo)
		repositorioService.getbase.removeUser(usuarioAmigo)
	}
}