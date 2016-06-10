package ar.edu.unq.epers.test.servicios.mongoDB

import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Comentario
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.ComentariosHome
import ar.edu.unq.epers.aterrizar.persistencias.RepositorioUsuarios
import ar.edu.unq.epers.aterrizar.servicios.mongoDB.PerfilService
import ar.edu.unq.epers.aterrizar.servicios.neo4j.AmigosService
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.mongojack.DBQuery
import org.mongojack.DBQuery.Query

class testPerfilService {
	PerfilService perfilService = new PerfilService	
	ComentariosHome<Perfil> homePerfil = perfilService.getHomePerfil
	RepositorioUsuarios BDJDBC = new RepositorioUsuarios()
	
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
		
		BDJDBC.insertUser(charlie,1)
		BDJDBC.insertUser(ricky,1)
		BDJDBC.insertUser(nico,1)
		BDJDBC.insertUser(miami,1)
		BDJDBC.insertUser(ezequiel,1)

					
		repositorioService.agregarAmigo(charlie, ezequiel)		
		repositorioService.agregarAmigo(ezequiel, nico)
		repositorioService.agregarAmigo(ricky, charlie)
		repositorioService.agregarAmigo(nico, miami)
				
	}
	
	@Test
	def testCrearPerfil(){
		perfilService.crearPerfil(charlie,"Titulo")
		var Query query = DBQuery.in("usuarioPerfil", charlie.nombreUsuario)
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPerfil.titulo, "Titulo")
		Assert.assertEquals(resQueryPerfil.usuarioPerfil, charlie.nombreUsuario)
		perfilService.crearPerfil(charlie,"Titulo2")
		resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPerfil.titulo,"Titulo")
	}
	
	@Test
	def agregarDestino(){
		
		perfilService.crearPerfil(charlie,"Titulo")
		var Destino dest = new Destino()
		perfilService.agregarDestino(charlie,dest)
		var Query query = DBQuery.in("usuarioPerfil", charlie.nombreUsuario)
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPerfil.destinos.get(0).id, dest.id)
		
	}
	
	@Test
	def agregarComentarioAlDestinoDelPerfil(){
		
		perfilService.crearPerfil(charlie,"Titulo")
		var Destino dest = new Destino()
		dest.tituloDestino = "viaje a miami"
		perfilService.agregarDestino(charlie,dest)
		var Comentario comentario = new Comentario =>[
			usuarioDelComentario = nico.nombreUsuario
			textoComentario = "genial"
		]
		
		var Query query = DBQuery.in("usuarioPerfil", charlie.nombreUsuario)
		perfilService.agregarComentarioAlPerfilDe(charlie,dest,comentario)
		
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPerfil.destinos.get(0).comentarios.get(0).textoComentario, comentario.textoComentario )
		
	}
	
	@Test
	def agregarMeGustaAlDestino(){
		
		perfilService.crearPerfil(charlie,"Titulo")
		var Destino dest = new Destino()
		dest.tituloDestino = "viaje a miami"
		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarMeGustaAlPerfilDe(charlie,dest,nico)
		
		var Query query = DBQuery.in("usuarioPerfil", charlie.nombreUsuario)
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPerfil.destinos.get(0).cantMeGusta, 1 )
		
	}
	
	@Test
	def agregarNoMeGustaAlDestino(){
		
		perfilService.crearPerfil(charlie,"Titulo")
		var Destino dest = new Destino()
		dest.tituloDestino = "viaje a miami"
		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarNoMeGustaAlPerfilDe(charlie,dest,nico)
		
		var Query query = DBQuery.in("usuarioPerfil", charlie.nombreUsuario)
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPerfil.destinos.get(0).cantNoMeGusta, 1 )
		
	}
	
	@Test
	def void mostrarDestinosPublico(){
		
		var Destino dest = new Destino()
		dest.hacerPrivado
		
		var Destino dest2 = new Destino()
		var Destino dest3 = new Destino()
		var Destino dest4 = new Destino()
				
		perfilService.crearPerfil(charlie,"Perfil Charly")
		perfilService.crearPerfil(ricky,"Perfil Ricky")

		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarDestino(charlie,dest2)
		perfilService.agregarDestino(charlie,dest3)
		perfilService.agregarDestino(ricky,dest4)
		
		var perfil = perfilService.mostrarPerfil(nico,charlie)
		Assert.assertEquals(perfil.destinos.size, 2)
		Assert.assertEquals(perfil.usuarioPerfil, "charlie")
		Assert.assertEquals(perfil.titulo, "Perfil Charly")
		Assert.assertEquals(perfil.destinos.get(0).publico, true)
		Assert.assertEquals(perfil.destinos.get(1).publico, true)
	}
	
	@Test
	def void mostrarDestinosParaAmigos(){
		
		var Destino dest = new Destino()
		dest.hacerPrivado
		
		var Destino dest2 = new Destino()
		dest2.hacerSoloAmigos
		
		var Destino dest3 = new Destino()
		var Destino dest4 = new Destino()
				
		perfilService.crearPerfil(charlie,"Perfil Charly")
		perfilService.crearPerfil(ezequiel,"Perfil Ezequiel")

		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarDestino(charlie,dest2)
		perfilService.agregarDestino(charlie,dest3)
		perfilService.agregarDestino(ezequiel,dest4)
		
		var perfil = perfilService.mostrarPerfil(ezequiel,charlie)
		
		Assert.assertEquals(perfil.destinos.size, 2)
		Assert.assertEquals(perfil.usuarioPerfil, "charlie")
		Assert.assertEquals(perfil.titulo, "Perfil Charly")

	}
	
	@Test
	def void mostarDestinoPrivado(){
		var Destino dest = new Destino()
		dest.hacerPrivado
		
		var Destino dest2 = new Destino()
		dest2.hacerSoloAmigos
		
		var Destino dest3 = new Destino()
		var Destino dest4 = new Destino()
				
		perfilService.crearPerfil(charlie,"Perfil Charly")
		perfilService.crearPerfil(ezequiel,"Perfil Ezequiel")

		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarDestino(charlie,dest2)
		perfilService.agregarDestino(charlie,dest3)
		perfilService.agregarDestino(ezequiel,dest4)
		
		var perfil = perfilService.mostrarPerfil(charlie,charlie)
		
		Assert.assertEquals(perfil.destinos.size, 3)
		Assert.assertEquals(perfil.usuarioPerfil, "charlie")
		Assert.assertEquals(perfil.titulo, "Perfil Charly")
	}
	
	
			
		
	
	@After
	def dropAll(){
		
		BDJDBC.removeUser(charlie)
		BDJDBC.removeUser(ricky)
		BDJDBC.removeUser(nico)
		BDJDBC.removeUser(miami)
		BDJDBC.removeUser(ezequiel)
		
		repositorioService.eliminarUsuario(charlie)
		repositorioService.eliminarUsuario(ezequiel)
	 	repositorioService.eliminarUsuario(nico)
		repositorioService.eliminarUsuario(ricky)
		repositorioService.eliminarUsuario(miami)
		
		homePerfil.mongoCollection.drop
		
		
	}
}
	