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
	
	@Before
	def void startUP(){
		homePerfil = SistemDB.instance().collection(Perfil)
		
		perfil = new Perfil =>[
			titulo = "perfilTest"
		]
		
		perfilII = new Perfil =>[
			titulo = "perfilTestII"
		]
		
		var Destino destino = new Destino()
		
		var Comentario comentario = new Comentario =>[
			textoComentario = "hola test"
		]
		comentario.hacerPrivado
		
		var Usuario josePerez = new Usuario => [
		nombre = "José"
		apellido = "Pérez"
		nombreUsuario = "pepePérez"
		]
		
		comentario.usuarioDelComentario = josePerez.nombreUsuario
		destino.comentarios.add(comentario)
		perfil.usuarioPerfil = josePerez.nombreUsuario
		perfil.destinos.add(destino)		
			
	
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
		Assert.assertFalse(resQueryPefil.destinos.get(0).comentarios.get(0).publico)
		Assert.assertFalse(resQueryPefil.destinos.get(0).comentarios.get(0).soloAmigos)
		Assert.assertTrue(resQueryPefil.destinos.get(0).comentarios.get(0).privado)
		
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
	
	@After
	def dropData(){
		homePerfil.mongoCollection.drop
	}
}