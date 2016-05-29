package ar.edu.unq.epers.test.servicios.mongoDB

import ar.edu.unq.epers.aterrizar.servicios.mongoDB.ComentariosService
import org.junit.After
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.servicios.neo4j.AmigosService
import org.junit.Before
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.ComentariosHome
import org.junit.Test
import org.mongojack.DBQuery
import org.mongojack.DBQuery.Query
import org.junit.After
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.persistencias.RepositorioUsuarios
import ar.edu.unq.epers.aterrizar.persistencia.home.UsuarioHome
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Comentario

class testServicioComentarios {
	ComentariosService comentarioService = new ComentariosService	
	ComentariosHome<Perfil> homePerfil = comentarioService.getHomePerfil
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

					
//		repositorioService.agregarAmigo(charlie, ezequiel)		
//		repositorioService.agregarAmigo(ezequiel, nico)
//		repositorioService.agregarAmigo(ricky, charlie)
//		repositorioService.agregarAmigo(nico, miami)
		
		
		
	}
	
	@Test
	def testCrearPerfil(){
		comentarioService.crearPerfil(charlie,"Titulo")
		var Query query = DBQuery.in("usuarioPerfil", charlie)
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPerfil.titulo, "Titulo")
		Assert.assertEquals(resQueryPerfil.usuarioPerfil.nombreUsuario, charlie.nombreUsuario)
	}
	
	@Test
	def agregarDestino(){
		
		comentarioService.crearPerfil(charlie,"Titulo")
		var Destino dest = new Destino()
		comentarioService.agregarDestino(charlie,dest)
		var Query query = DBQuery.in("usuarioPerfil", charlie)
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPerfil.destinos.get(0).id, dest.id)
		
	}
	
	@Test
	def agregarComentarioAlDestinoDelPerfil(){
		
		comentarioService.crearPerfil(charlie,"Titulo")
		var Destino dest = new Destino()
		comentarioService.agregarDestino(charlie,dest)
		var Comentario comentario = new Comentario =>[
			usuarioDelComentario = nico
			textoComentario = "genial"
		]
		comentarioService.agregarComentarioAlPerfilDe(charlie,dest,comentario)
		
		var Query query = DBQuery.in("usuarioPerfil", charlie)
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPerfil.destinos.get(0).comentarios.get(0).textoComentario, comentario.textoComentario )
		
	}
	
		@Test
	def agregarMeGustaAlDestino(){
		
		comentarioService.crearPerfil(charlie,"Titulo")
		var Destino dest = new Destino()
		comentarioService.agregarDestino(charlie,dest)
		comentarioService.agregarMeGustaAlPerfilDe(charlie,dest,nico)
		
		var Query query = DBQuery.in("usuarioPerfil", charlie)
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPerfil.destinos.get(0).cantMeGusta, 1 )
		
	}	
		
	
	@After
	def dropAll(){
		
		BDJDBC.removeUser(charlie)
		BDJDBC.removeUser(ricky)
		BDJDBC.removeUser(nico)
		BDJDBC.removeUser(miami)
		BDJDBC.removeUser(ezequiel)
		
//		repositorioService.eliminarUsuario(charlie)
//		repositorioService.eliminarUsuario(ezequiel)
//	 	repositorioService.eliminarUsuario(nico)
//		repositorioService.eliminarUsuario(ricky)
//		repositorioService.eliminarUsuario(miami)
//		
		homePerfil.mongoCollection.drop
		
		
	}
}
	