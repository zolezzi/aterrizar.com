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

	Perfil perfilEze
	Perfil ezePerfil
	Destino bariloche
	Destino rioDeJaneiro
	PerfilMapper charlyPerfilMapper
	PerfilMapper ezePerfilMapper

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
		rioDeJaneiro = new Destino() => [
			tituloDestino = "Mochileando"
			origen = "Bariloche"
			destino = "Rio de Janeiro"
			nombreAerolinea = "Aerolineas Payaso"
		]	
		
		perfilService.crearPerfil(eze, "El perfil de Eze")
		
		bariloche.hacerSoloAmigos()
		rioDeJaneiro.hacerPublico()
		
		ezePerfil = perfilService.mostrarPerfil(eze,eze)
		ezePerfil = perfilService.mostrarPerfil(charly,eze)
		perfilService.agregarDestinoSinValidarDestino(eze,bariloche)
		perfilService.agregarDestinoSinValidarDestino(eze,rioDeJaneiro)
		perfilService.agregarMeGustaAlPerfilDe(eze,bariloche,charly) 
		perfilEze = perfilService.mostrarPerfil(eze,eze)
		charlyPerfilMapper = new PerfilMapper(	perfilEze.usuarioPerfil,
												perfilEze.titulo, perfilEze.destinos,
												"publico",true)
		ezePerfilMapper = new PerfilMapper(	ezePerfil.usuarioPerfil,
												ezePerfil.titulo, ezePerfil.destinos,
												"publico",true)
	}

	@Rule
	public ExpectedException thrown = ExpectedException.none()

	@Test
	def void testSavePerfilMapper(){
		
		cacheHome.save(ezePerfilMapper)
		
		var query = cacheHome.getPerfilMapper("Eze")
		
		Assert.assertEquals(query.nombreUsuario,ezePerfilMapper.nombreUsuario)
		Assert.assertEquals(query.destinosDelPerfil.size,0)
	}

	@Test
	def void testUpdatePerfilMapper(){

		cacheHome.save(charlyPerfilMapper)
		charlyPerfilMapper.setNombreUsuario = "Carlos"
		charlyPerfilMapper.setTitulo = "El perfil de Carlos"

		cacheHome.update(charlyPerfilMapper)
		
		var query = cacheHome.getPerfilMapper("Carlos")

		Assert.assertEquals(query.nombreUsuario,charlyPerfilMapper.nombreUsuario)
		Assert.assertEquals(query.destinosDelPerfil.size,3)
		Assert.assertEquals(query.destinosDelPerfil.get(0).tituloDestino,"Viaje de Egresados")
	}
	
	@Test (expected = PerfilMapperException)
	def void testGetPerfilMapperException(){

		cacheHome.getPerfilMapper("David")
		thrown.expectMessage("No hay un usuario con un perfil que tenga ese nombre")
	}
	
	@Test
	def void testMostrarPrivado(){
		
		var Perfil result
		result = cacheHome.mostrarParaPrivado(eze)
		
		Assert.assertEquals(result.destinos.size,0)
	}

	@Test
	def void testMostrarPublico(){
		
		var Perfil result
		var dummy = new Usuario => [
			nombreUsuario = "Dummy"
			nombre = "NombreDummy"
			apellido = "ApellidoDummy"
			email = "Dummy@gmail.com"
			contrasenia = "dummy"
			fechaNacimiento = "1/1/1"
			codValidacion = "0"
		]
		perfilService.mostrarPerfil(dummy,eze)
		result = cacheHome.mostrarParaPublico(eze)
		
		Assert.assertEquals(result.destinos.size,0)
	}
	
	@Test
	def void testMostrarParaAmigos(){
		
		var Perfil result
		var p = perfilService.mostrarPerfilMongoDB(charly,eze)
		result = cacheHome.mostrarParaAmigos(eze)
		
		Assert.assertEquals(p.destinos.size,1)
	}

	@After
	def void setDown(){
		
		repositorioService.eliminarUsuario(charly)
		repositorioService.eliminarUsuario(eze)
		
		repositorioService.getbase.removeUser(charly)
		repositorioService.getbase.removeUser(eze)

		perfilService.getHomePerfil.mongoCollection.drop
			
	}
}