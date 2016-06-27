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
import java.util.List
import org.mongojack.DBQuery
import org.mongojack.DBQuery.Query
import org.junit.Rule
import org.junit.rules.ExpectedException
import ar.edu.unq.epers.aterrizar.servicios.SistemaRegistroAerolineas
import ar.edu.unq.epers.aterrizar.modelo.Vuelo
import ar.edu.unq.epers.aterrizar.modelo.Tramo
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.modelo.Asiento
import ar.edu.unq.epers.aterrizar.modelo.Aerolinea

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
	Destino dest
	Destino dest2
	Destino dest3
	Destino dest4
	
	AmigosService repositorioService
	SistemaRegistroAerolineas aerolineasService = new SistemaRegistroAerolineas
	
	
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
		

		
		var Tramo tramo= new Tramo=>[
			origen = "Argentina"
			destino = "Miami"
		]
	
		
		var ArrayList<Tramo> tramos = new ArrayList<Tramo>()
		var ArrayList<Asiento> asientos = new ArrayList<Asiento>()
		
		var Vuelo vuelo = new Vuelo =>[
			origen = "Argentina"
			destino = "Miami"
		]
		
		
		var Asiento asiento = new Asiento=>[
			origen = "Argentina"
			destino = "Miami"
			numeroAsiento = "A1"
			reservado = false
		]
		
		var Asiento asiento2 = new Asiento=>[
			origen = "Argentina"
			destino = "Miami"
			numeroAsiento = "A2"
			reservado = false
		]
		
		var Asiento asiento3 = new Asiento=>[
			origen = "Argentina"
			destino = "Miami"
			numeroAsiento = "A3"
			reservado = false
		]
		
		var Asiento asiento4 = new Asiento=>[
			origen = "Argentina"
			destino = "Miami"
			numeroAsiento = "A4"
			reservado = false
		]
		
		asientos.add(asiento)
		tramo.asientos = asientos
		asiento.tramo = tramo
		tramo.agregarAsiento(asiento)
		tramo.agregarAsiento(asiento2)
		tramo.agregarAsiento(asiento3)
		tramo.agregarAsiento(asiento4)
		tramos.add(tramo)
		vuelo.tramos = tramos
		
		dest = new Destino()
		dest.origen="Argentina"
		dest.destino="Miami"
		dest.nombreAerolinea = "Aerolineas Payaso"
		
		dest2 = new Destino()
		dest2.origen="Argentina"
		dest2.destino="Miami"
		dest2.nombreAerolinea = "Aerolineas Payaso"
		
		dest3 = new Destino()
		dest3.origen="Argentina"
		dest3.destino="Miami"
		dest3.nombreAerolinea = "Aerolineas Payaso"
		
		dest4 = new Destino()
		dest4.origen="Argentina"
		dest4.destino="Miami"
		dest4.nombreAerolinea = "Aerolineas Payaso"
		
		aerolineasService.registrarAerolinea("Aerolineas Payaso")
		var Aerolinea a = aerolineasService.consultarAerolineaPor("nombreAerolinea", "Aerolineas Payaso")
		aerolineasService.agregaVuelo(a,vuelo)
		aerolineasService.reservarAsientoDeTramo("Argentina","Miami","A1",charlie)
		aerolineasService.reservarAsientoDeTramo("Argentina","Miami","A2",ezequiel)
		aerolineasService.reservarAsientoDeTramo("Argentina","Miami","A3",nico)
		aerolineasService.reservarAsientoDeTramo("Argentina","Miami","A4",miami)
		
		repositorioService.agregarAmigo(charlie, ezequiel)		
		repositorioService.agregarAmigo(ezequiel, nico)
		repositorioService.agregarAmigo(nico, miami)
	}
	
	
	
	@Rule
	public ExpectedException thrown = ExpectedException.none()
	
	@Test
	def testCrearPerfil(){
		perfilService.crearPerfil(charlie,"Titulo")
		var Perfil resQueryPerfil = homePerfil.getPerfilDeUsuario(charlie)
		Assert.assertEquals(resQueryPerfil.titulo, "Titulo")
		Assert.assertEquals(resQueryPerfil.usuarioPerfil, charlie.nombreUsuario)
		perfilService.crearPerfil(charlie,"Titulo2")
		resQueryPerfil = homePerfil.getPerfilDeUsuario(charlie)
		Assert.assertEquals(resQueryPerfil.titulo,"Titulo")
	}
	
	@Test
	def agregarDestino(){
		
		perfilService.agregarDestino(charlie,dest)
		var Perfil resQueryPerfil = homePerfil.getPerfilDeUsuario(charlie)
		Assert.assertEquals(resQueryPerfil.destinos.get(0).id, dest.id)
		
	}
	
	@Test(expected = Exception)
	def agregarDestinoSinRegistro(){
		
		var Destino dest = new Destino()
		dest.origen="Argentina"
		dest.destino="Canada"
		dest.nombreAerolinea = "Aerolineas Payaso"
		perfilService.agregarDestino(charlie,dest)
		thrown.expectMessage("No posee un vuelo registrado para ese destino")
		
	}
	
	@Test
	def agregarComentarioAlDestinoDelPerfil(){
		
		dest.tituloDestino = "viaje a miami"
		perfilService.agregarDestino(charlie,dest)
		var Comentario comentario = new Comentario =>[
			usuarioDelComentario = nico.nombreUsuario
			textoComentario = "genial"
		]
		
		perfilService.agregarComentarioAlPerfilDe(charlie,dest,comentario)
		
		var Perfil resQueryPerfil = homePerfil.getPerfilDeUsuario(charlie)
		Assert.assertEquals(resQueryPerfil.destinos.get(0).comentarios.get(0).textoComentario, comentario.textoComentario )
		
	}
	
	@Test
	def agregarMeGustaAlDestino(){
		
		dest.tituloDestino = "viaje a miami"
		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarMeGustaAlPerfilDe(charlie,dest,nico)
		
		var Perfil resQueryPerfil = homePerfil.getPerfilDeUsuario(charlie)
		Assert.assertEquals(resQueryPerfil.destinos.get(0).cantMeGusta, 1 )
		
	}
	
	@Test(expected = Exception)
	def darDosVecesMeGustaAlMismoDestinoYUsuario(){
		
		dest.tituloDestino = "viaje a miami"
		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarMeGustaAlPerfilDe(charlie,dest,nico)
		perfilService.agregarMeGustaAlPerfilDe(charlie,dest,nico)
		thrown.expectMessage("Ya diste tu opinion")
		
	}
	
	@Test(expected = Exception)
	def darDosVecesNoMeGustaAlMismoDestinoYUsuario(){
		
		dest.tituloDestino = "viaje a miami"
		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarNoMeGustaAlPerfilDe(charlie,dest,nico)
		perfilService.agregarNoMeGustaAlPerfilDe(charlie,dest,nico)
		thrown.expectMessage("Ya diste tu opinion")
		
	}
	
	@Test
	def agregarNoMeGustaAlDestino(){
		
		dest.tituloDestino = "viaje a miami"
		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarNoMeGustaAlPerfilDe(charlie,dest,nico)
		
		var Perfil resQueryPerfil = homePerfil.getPerfilDeUsuario(charlie)
		Assert.assertEquals(resQueryPerfil.destinos.get(0).cantNoMeGusta, 1 )
		
	}
	
	@Test
	def void mostrarDestinosPublico(){
		dest.hacerPrivado

		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarDestino(charlie,dest2)
		perfilService.agregarDestino(charlie,dest3)
		perfilService.agregarDestino(ezequiel,dest4)
		
		var perfil = perfilService.mostrarPerfil(nico,charlie)
		Assert.assertEquals(perfil.destinos.size, 2)
		Assert.assertEquals(perfil.usuarioPerfil, "charlie")
		Assert.assertEquals(perfil.titulo, "Perfil charlie")
		Assert.assertEquals(perfil.destinos.get(0).publico, true)
		Assert.assertEquals(perfil.destinos.get(1).publico, true)
	}
	
	@Test
	def void mostrarDestinosParaAmigos(){
		
		dest.hacerPrivado
		dest2.hacerSoloAmigos

		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarDestino(charlie,dest2)
		perfilService.agregarDestino(charlie,dest3)
		perfilService.agregarDestino(ezequiel,dest4)
		
		var perfil = perfilService.mostrarPerfil(ezequiel,charlie)
		
		Assert.assertEquals(perfil.destinos.size, 2)
		Assert.assertEquals(perfil.usuarioPerfil, "charlie")
		Assert.assertEquals(perfil.titulo, "Perfil charlie")

	}
	
	@Test
	def void mostarDestinoPrivado(){
		dest.hacerPrivado
		dest2.hacerSoloAmigos
		perfilService.agregarDestino(charlie,dest)
		perfilService.agregarDestino(charlie,dest2)
		perfilService.agregarDestino(charlie,dest3)
		perfilService.agregarDestino(ezequiel,dest4)
		
		var perfil = perfilService.mostrarPerfil(charlie,charlie)
		
		Assert.assertEquals(perfil.destinos.size, 3)
		Assert.assertEquals(perfil.usuarioPerfil, "charlie")
		Assert.assertEquals(perfil.titulo, "Perfil charlie")
	}
	

	@After
	def void dropAll(){
		
		repositorioService.eliminarUsuario(charlie)
		repositorioService.eliminarUsuario(ezequiel)
	 	repositorioService.eliminarUsuario(nico)
		repositorioService.eliminarUsuario(miami)
		
		homePerfil.mongoCollection.drop
		
		new SistemaRegistroAerolineas().truncateTables
	}
}
	