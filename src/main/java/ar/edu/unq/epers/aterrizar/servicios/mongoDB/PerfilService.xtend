package ar.edu.unq.epers.aterrizar.servicios.mongoDB

import ar.edu.unq.epers.aterrizar.servicios.neo4j.AmigosService
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.ComentariosHome
import org.mongojack.DBQuery
import org.mongojack.DBQuery.Query
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Comentario
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.SistemDB
import com.mongodb.BasicDBObject

class PerfilService {
	
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
		
		
		var Query query = DBQuery.in("usuarioPerfil.nombreUsuario", usuario.nombreUsuario)
		var Perfil res = traerDestinoDe(usuario,destino)
		if(res != null){
			res.agregarComentarioADestino(comentario,destino)
			homePerfil.update(query,res)
		}
				
	}
	
	
	def agregarMeGustaAlPerfilDe(Usuario usuario, Destino destino, Usuario usuarioMeGusta){
		
		
		var Query query = DBQuery.in("usuarioPerfil", usuario)
		var Perfil res = traerDestinoDe(usuario,destino)
		if(res != null){
			res.darMeGusta(destino, usuarioMeGusta)
			homePerfil.update(query,res)
		}		
	}
	
	def agregarNoMeGustaAlPerfilDe(Usuario usuario, Destino destino, Usuario usuarioMeGusta){
			
		var Query query = DBQuery.in("usuarioPerfil", usuario)
		var Perfil res = traerDestinoDe(usuario,destino)
		if(res != null){
			res.darNoMeGusta(destino, usuarioMeGusta)
			homePerfil.update(query,res)
		}		
	}
	
	def mostrarPerfil(Usuario visitante, Usuario visitado){
		
		if(serviceAmigos.esAmigo(visitante,visitado)){
			mostrarParaAmigos(visitado)
		}else{
			if(visitante == visitado){
				mostrarParaPrivado(visitado)
			}else{
				mostrarParaPublico(visitado)
			}
		}
	}
	
	
	def baseQuery(Usuario visitado){
		var preQuery = homePerfil.aggregate
				   	   .match("usuarioPerfil.nombre",visitado.nombre)
				       .project
				       .rtn("id")
				       .rtn("usuarioPerfil")
				       .rtn("titulo")
				       .filter("destinos")
		preQuery
	}
	
	def traerDestinoDe(Usuario visitado, Destino destino){
		var result = baseQuery(visitado).or(#[ [it.eq("tituloDestino",destino.tituloDestino)]])
					 .execute
		result.get(0) as Perfil
	}
	
	def mostrarParaPublico(Usuario visitado){
			var result = baseQuery(visitado).or(#[ [it.eq("publico",true)]])
				       .execute
			result.get(0) as Perfil
	}
	
	def mostrarParaAmigos(Usuario visitado){
			var result = baseQuery(visitado)
						 .or(#[ [it.eq("publico",true)],[it.eq("soloAmigos",true)] ])
				         .execute
			result.get(0) as Perfil
	}
	
	def mostrarParaPrivado(Usuario visitado){
		var result = baseQuery(visitado)
					 .or(#[ [it.eq("publico",true)],[it.eq("soloAmigos",true)],[it.eq("privado",true)] ])
				      .execute
		return result.get(0) as Perfil
	}
	
}