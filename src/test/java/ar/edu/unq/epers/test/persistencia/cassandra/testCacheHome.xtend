package ar.edu.unq.epers.test.persistencia.cassandra

import org.junit.Test
import ar.edu.unq.epers.aterrizar.persistencia.cassandra.CacheHome
import ar.edu.unq.epers.aterrizar.persistencia.cassandra.PerfilMapper
import org.junit.Before
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.servicios.mongoDB.PerfilService
import org.junit.Assert
import org.junit.After
import ar.edu.unq.epers.aterrizar.servicios.neo4j.AmigosService

class testCacheHome {

	Usuario charly
	Usuario eze

	AmigosService repositorioService = new AmigosService
	PerfilService perfilService = new PerfilService

	Perfil charlyPerfil
	PerfilMapper charlyPerfilMapper
		
	CacheHome cacheHome = new CacheHome

	@Before
	def void setUp(){

		charly = new Usuario => [
			nombreUsuario = "Charly"
			nombre = "Carlos"
			apellido = "Cardozo"
			email = "carlos@gmail.com"
			contrasenia = "cardozo"
			fechaNacimiento = "1/1/1"
			codValidacion = "0"
		]
		eze = new Usuario => [
			nombreUsuario = "Eze"
			nombre = "Ezequiel"
			apellido = "Luna"
			email = "eze@microsoft.edu"
			contrasenia = "luna"
			fechaNacimiento = "2/2/2"
			codValidacion = "0"
		]
		
		repositorioService.getbase.insertUser(charly , 1)
		repositorioService.getbase.insertUser(eze, 1)

		repositorioService.agregarAmigo(charly, eze)

		perfilService.crearPerfil(charly, "El perfil de Charly")
		perfilService.crearPerfil(eze, "El perfil de Eze")

		charlyPerfil = perfilService.mostrarPerfil(eze,charly)
		charlyPerfilMapper = new PerfilMapper(	charlyPerfil.usuarioPerfil,
												charlyPerfil.titulo, charlyPerfil.destinos)
	}
	
	@Test
	def void testSavePerfilMapper(){
		
		cacheHome.save(charlyPerfilMapper)
		
		Assert.assertEquals(cacheHome.getPerfilMapper("Charly","El perfil de Charly"),charlyPerfilMapper)
	}

	@Test
	def void testUpdatePerfilMapper(){

		cacheHome.save(charlyPerfilMapper)
		charlyPerfilMapper.setNombreUsuario = "Carlos"
		charlyPerfilMapper.setTitulo = "El perfil de Carlos"

		cacheHome.update(charlyPerfilMapper)

		Assert.assertEquals(cacheHome.getPerfilMapper("Carlos","El perfil de Carlos"),charlyPerfilMapper)
	}

	@After
	def void setDown(){
		
		repositorioService.eliminarUsuario(charly)
		repositorioService.eliminarUsuario(eze)
		
		repositorioService.getbase.removeUser(charly)
		repositorioService.getbase.removeUser(eze)

		perfilService.getHomePerfil.mongoCollection.drop
		cacheHome.delete(charlyPerfilMapper)		
	}
}