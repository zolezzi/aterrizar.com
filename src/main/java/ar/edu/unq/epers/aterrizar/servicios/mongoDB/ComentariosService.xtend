package ar.edu.unq.epers.aterrizar.servicios.mongoDB

import ar.edu.unq.epers.aterrizar.servicios.neo4j.AmigosService
import ar.edu.unq.epers.aterrizar.persistencia.home.UsuarioHome
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.ComentariosHome
import org.mongojack.DBQuery
import org.mongojack.DBQuery.Query
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Visibilidad
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Comentario
import org.mongojack.Aggregation
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.SistemDB

class ComentariosService {
	
	AmigosService serviceAmigos = new AmigosService
	UsuarioHome usuarioHome = new UsuarioHome
	ComentariosHome<Destino> homeDestino = SistemDB.instance().collection(Destino)
	ComentariosHome<Perfil> homePerfil = SistemDB.instance().collection(Perfil)
	
	def getHomePerfil(){
		homePerfil
	}
	
	def getDestinoHome(){
		homeDestino
	}
	
	def crearPerfil(Usuario usuario, String tituloPerfil){
		
		//chequear si el usuario ya tiene perfil
		
		var Perfil perfil = new Perfil => [
			usuarioPerfil = usuario
			titulo = tituloPerfil
		]
		homePerfil.insert(perfil)
		
	}
	
	//destino se crea en otro metodo o clase, ahi ya tiene la visibilidad seteada (trabajarlo despues)
	//posible exception
	def agregarDestino(Usuario usuario, Destino destino){
		
		var Query query = DBQuery.in("usuarioPerfil", usuario)
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		if(resQueryPerfil != null){
			resQueryPerfil.destinos.add(destino)
			homePerfil.update(query, resQueryPerfil)
		}
		
	}
	
	//destino y comentario se crea en otro metodo o clase, ahi ya tiene la visibilidad seteada (trabajarlo despues)
	//Se asume que el comentario ya tiene al usuario que hizo el comentario.
	//posible exception
	def agregarComentarioAlPerfilDe(Usuario usuario, Destino destino, Comentario comentario){
		
		
		var Query query = DBQuery.in("usuarioPerfil", usuario)
		var Perfil res = homePerfil.mongoCollection.find(query).next() as Perfil;
		if(res != null){
			res.agregarComentarioADestino(comentario,destino)
			homePerfil.update(query,res)
		}		
	}
	
	def agregarMeGustaAlPerfilDe(Usuario usuario, Destino destino, Usuario usuarioMeGusta){
		
		
		var Query query = DBQuery.in("usuarioPerfil", usuario)
		var Perfil res = homePerfil.mongoCollection.find(query).next() as Perfil;
		if(res != null){
			res.darMeGusta(destino, usuarioMeGusta)
			homePerfil.update(query,res)
		}		
	}
	
	
}