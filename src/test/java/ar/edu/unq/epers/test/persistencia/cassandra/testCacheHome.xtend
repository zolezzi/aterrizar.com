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

class testCacheHome {

	Usuario charly
	Usuario eze

	PerfilService perfilService = new PerfilService

	Perfil charlyPerfil
	PerfilMapper charlyPerfilMapper
		
	CacheHome cacheHome = new CacheHome

	@Before
	def void setUp(){

		charly = new Usuario => [nombreUsuario = "Charly"]
		eze = new Usuario => [nombreUsuario = "Eze"]

		perfilService.crearPerfil(charly, "El perfil de Charly")
		perfilService.crearPerfil(eze, "El perfil de Eze")

		charlyPerfil = perfilService.mostrarPerfil(eze,charly)
		charlyPerfilMapper = new PerfilMapper(	charlyPerfil.usuarioPerfil.nombre,
												charlyPerfil.titulo, charlyPerfil.destinos)
	}
	
	@Test
	def void testSavePerfilMapper(){
		
		cacheHome.save(charlyPerfilMapper)
		
		Assert.assertEquals(cacheHome.getPerfilMapper("Charly","El perfil de Charly"),charlyPerfilMapper)
	}
	
	@After
	def void setDown(){
		
		perfilService.getHomePerfil.mongoCollection.drop
		cacheHome.delete(charlyPerfilMapper)		
	}
}