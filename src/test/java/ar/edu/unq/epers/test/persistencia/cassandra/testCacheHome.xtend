package ar.edu.unq.epers.test.persistencia.cassandra

import ar.edu.unq.epers.aterrizar.exception.PerfilMapperException
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencia.cassandra.CacheHome
import ar.edu.unq.epers.aterrizar.persistencia.cassandra.PerfilMapper
import ar.edu.unq.epers.aterrizar.servicios.mongoDB.PerfilService
import ar.edu.unq.epers.aterrizar.servicios.neo4j.AmigosService
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.rules.ExpectedException

class testCacheHome {

	Usuario charly
	Usuario eze

	AmigosService repositorioService = new AmigosService
	PerfilService perfilService = new PerfilService

	Perfil charlyPerfil
	Destino bariloche
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
		bariloche = new Destino() => [
			tituloDestino = "Viaje de Egresados"
			origen = "Buenos Aires"
			destino = "Bariloche"
			nombreAerolinea = "Aerolineas Payaso"
		]
		perfilService.crearPerfil(eze, "El perfil de Eze")

		charlyPerfil = perfilService.mostrarPerfil(charly,charly)
		charlyPerfil.agregarDestino(bariloche)
		charlyPerfil.darMeGusta(bariloche,eze.nombreUsuario)
		charlyPerfilMapper = new PerfilMapper(	charlyPerfil.usuarioPerfil,
												charlyPerfil.titulo, charlyPerfil.destinos)
	}

	@Rule
	public ExpectedException thrown = ExpectedException.none()

	@Test
	def void testSavePerfilMapper(){
		
		cacheHome.save(charlyPerfilMapper)
		
		var query = cacheHome.getPerfilMapper("Charly")
		
		Assert.assertEquals(query.nombreUsuario,charlyPerfilMapper.nombreUsuario)
		Assert.assertEquals(query.destinosDelPerfil.size,1)
	}

	@Test
	def void testUpdatePerfilMapper(){

		cacheHome.save(charlyPerfilMapper)
		charlyPerfilMapper.setNombreUsuario = "Carlos"
		charlyPerfilMapper.setTitulo = "El perfil de Carlos"

		cacheHome.update(charlyPerfilMapper)
		
		var query = cacheHome.getPerfilMapper("Carlos")

		Assert.assertEquals(query.nombreUsuario,charlyPerfilMapper.nombreUsuario)
		Assert.assertEquals(query.destinosDelPerfil.size,1)
		Assert.assertEquals(query.destinosDelPerfil.get(0).tituloDestino,"Viaje de Egresados")
	}
	
	@Test (expected = PerfilMapperException)
	def void testGetPerfilMapperException(){

		cacheHome.getPerfilMapper("David")
		thrown.expectMessage("No hay un usuario con un perfil que tenga ese nombre")
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