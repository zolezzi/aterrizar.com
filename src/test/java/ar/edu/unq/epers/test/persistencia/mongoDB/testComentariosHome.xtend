package ar.edu.unq.epers.test.persistencia.mongoDB

import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.SistemDB
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Comentario
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.ComentariosHome
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.Before
import org.junit.After
import org.mongojack.DBQuery
import org.mongojack.DBQuery.Query
import org.junit.Assert
import org.junit.Test

class testComentariosHome {
	
	ComentariosHome<Perfil> homePerfil
	var Perfil perfil
	var Perfil perfilII
	var Usuario josePerez
	var Destino destinoAmigos
	var Destino destinoPublico
	var Destino destinoPrivado
	@Before
	def void startUP(){
		homePerfil = SistemDB.instance().collection(Perfil)
		
		josePerez = new Usuario => [
		nombre = "José"
		apellido = "Pérez"
		nombreUsuario = "pepePérez"
		]
		
		perfil = new Perfil =>[
			titulo = "perfilTest"
			usuarioPerfil = josePerez.nombreUsuario
		]
		
		perfilII = new Perfil =>[
			titulo = "perfilTestII"
		]
		
		destinoAmigos = new Destino()
		destinoPublico = new Destino()
		destinoPrivado = new Destino()
		
		destinoAmigos.tituloDestino = "destino1"
		destinoPublico.tituloDestino="destino2"
		destinoPrivado.tituloDestino="destino3"
		
		destinoAmigos.hacerSoloAmigos
		destinoPublico.hacerPublico
		destinoPrivado.hacerPrivado
		
		var Comentario comentario = new Comentario =>[
			textoComentario = "hola test"
		]		

		
		comentario.usuarioDelComentario = josePerez.nombreUsuario
		destinoAmigos.comentarios.add(comentario)
		perfil.usuarioPerfil = josePerez.nombreUsuario
		perfil.destinos.add(destinoAmigos)
		perfil.destinos.add(destinoPublico)	
		perfil.destinos.add(destinoPrivado)		
			
	
	}
	
	@Test
	def testInsert(){
		homePerfil.insert(perfil)
		var Query query = DBQuery.in("titulo", "perfilTest")
		var Perfil resQueryPefil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPefil.titulo, perfil.titulo)
		Assert.assertEquals(resQueryPefil.usuarioPerfil, "pepePérez")
		Assert.assertFalse(resQueryPefil.destinos.isEmpty)
		Assert.assertEquals(resQueryPefil.destinos.get(0).cantMeGusta, 0)
		Assert.assertEquals(resQueryPefil.destinos.get(0).cantNoMeGusta, 0)
		Assert.assertEquals(resQueryPefil.destinos.get(0).comentarios.size, 1)
		Assert.assertEquals(resQueryPefil.destinos.get(0).comentarios.get(0).textoComentario, "hola test")
		
	}
	
	@Test
	def testDelete(){
		homePerfil.insert(perfil)
		homePerfil.insert(perfilII)
		var Query query = DBQuery.in("titulo", "perfilTest")
		homePerfil.remove(query)
		query = DBQuery.in("titulo", "perfilTestII")
		var Perfil resQueryPefil = homePerfil.mongoCollection.find(query).next() as Perfil;
		Assert.assertEquals(resQueryPefil.titulo, "perfilTestII")
	}
	
	@Test
	def insertPerfilAUsuario(){
		homePerfil.insertPerfilAUsuario(josePerez,perfil)
		var Query query = DBQuery.in("usuarioPerfil", josePerez.nombreUsuario)
		var resQueryPerfil = homePerfil.mongoCollection.find(query)
		Assert.assertEquals(resQueryPerfil.next.usuarioPerfil,"pepePérez")
	}
	
	@Test
	def getPerfilDeUsuarioConDestino(){
		homePerfil.insertPerfilAUsuario(josePerez, perfil)
		var Perfil perfil = homePerfil.traerDestinoDe(josePerez,destinoAmigos)
		Assert.assertEquals(perfil.destinos.size,1)
		Assert.assertEquals(perfil.destinos.get(0).tituloDestino,"destino1")
	}
	
	@Test
	def getPerfilDeUsuario(){
		homePerfil.insertPerfilAUsuario(josePerez, perfil)
		var Perfil perfil = homePerfil.getPerfilDeUsuario(josePerez)
		Assert.assertEquals(perfil.destinos.size,3)
		
	}
	
	@Test
	def mostrarParaPublico(){
		homePerfil.insertPerfilAUsuario(josePerez, perfil)
		var Perfil perfil = homePerfil.mostrarParaPublico(josePerez)
		Assert.assertEquals(perfil.destinos.size,1)
		Assert.assertEquals(perfil.destinos.get(0).tituloDestino,"destino2")
	}
	
	@Test
	def mostrarParaAmigos(){
		homePerfil.insertPerfilAUsuario(josePerez, perfil)
		var Perfil perfil = homePerfil.mostrarParaAmigos(josePerez)
		Assert.assertEquals(perfil.destinos.size,2)
		Assert.assertEquals(perfil.destinos.get(0).tituloDestino,"destino1")
		Assert.assertEquals(perfil.destinos.get(1).tituloDestino,"destino2")
	}
	
	@Test
	def mostrarParaPrivado(){
		homePerfil.insertPerfilAUsuario(josePerez, perfil)
		var Perfil perfil = homePerfil.mostrarParaPrivado(josePerez)
		Assert.assertEquals(perfil.destinos.size,3)
		Assert.assertEquals(perfil.destinos.get(0).tituloDestino,"destino1")
		Assert.assertEquals(perfil.destinos.get(1).tituloDestino,"destino2")
		Assert.assertEquals(perfil.destinos.get(2).tituloDestino,"destino3")
	}
	
	@After
	def dropData(){
		homePerfil.mongoCollection.drop
	}
}