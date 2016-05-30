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
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.SistemDB
import org.mongojack.MapReduce

import org.mongojack.Id
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.util.List
import org.mongojack.DBSort
import org.mongojack.DBProjection
import com.mongodb.BasicDBObject
import org.mongojack.Aggregation
import org.mongojack.Aggregation.Group
import com.mongodb.BasicDBList

class ComentariosService {
	
	AmigosService serviceAmigos = new AmigosService
	ComentariosHome<Destino> homeDestino = SistemDB.instance().collection(Destino)
	ComentariosHome<Perfil> homePerfil = SistemDB.instance().collection(Perfil)
	
	def getHomePerfil(){
		homePerfil
	}
	
	def getDestinoHome(){
		homeDestino
	}
	
	def crearPerfil(Usuario usuario, String tituloPerfil){
		
		var Perfil perfil = new Perfil => [
			usuarioPerfil = usuario
			titulo = tituloPerfil
		]
		var Query query = DBQuery.in("usuarioPerfil.nombreUsuario", usuario.nombreUsuario)
		var resQueryPerfil = homePerfil.mongoCollection.find(query);
		if(resQueryPerfil.length == 0){
			homePerfil.insert(perfil)
		}
		
	}
	

	def agregarDestino(Usuario usuario, Destino destino){
		
		var Query query = DBQuery.in("usuarioPerfil", usuario)
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		if(resQueryPerfil != null){
			resQueryPerfil.destinos.add(destino)
			homePerfil.update(query, resQueryPerfil)
		}
		
	}
	
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
	
	def agregarNoMeGustaAlPerfilDe(Usuario usuario, Destino destino, Usuario usuarioMeGusta){
			
		var Query query = DBQuery.in("usuarioPerfil", usuario)
		var Perfil res = homePerfil.mongoCollection.find(query).next() as Perfil;
		if(res != null){
			res.darNoMeGusta(destino, usuarioMeGusta)
			homePerfil.update(query,res)
		}		
	}
	
	//Se envia el query como esta comentado en el codigo via BasicDBObject, pero trae un solo elemento que machea con ese valor,
	// si hay mas los ignora. Es Decir Trae un perfil con un solo destino que sea Publico.
	// Probe la  query que esta comentada en la consola de mongo, con 3 elementos, en los cuales 2 tienen publico: true,
	// tambien devuelve 1 solo elemento.
	def mostrarPerfil2(Usuario visitante, Usuario visitado){
		
		//db.Perfil.find({"usuarioPerfil.nombre": "carlos"}, {destinos : {$elemMatch :{publico : true}} })
		
		val usuarioquery = new BasicDBObject('usuarioPerfil.nombre',visitado.nombre)
		
		val vis = new BasicDBObject('publico',true)
		val elemMatch = new BasicDBObject('$elemMatch',vis)
		val dest = new BasicDBObject('destinos',elemMatch)
		
		var res = homePerfil.mongoCollection.find(usuarioquery,dest).next() as Perfil; 
		println(res.destinos.size)	
	}
	
}