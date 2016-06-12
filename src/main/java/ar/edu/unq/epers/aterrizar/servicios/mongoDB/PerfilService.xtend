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
			usuarioPerfil = usuario.nombreUsuario
			titulo = tituloPerfil
		]
		homePerfil.insertPerfilAUsuario(usuario,perfil)
		
	}
	
	def validarPerfil(Usuario usuario){
		var Perfil res = homePerfil.getPerfilDeUsuario(usuario)
		if(res == null){
			this.crearPerfil(usuario, "Perfil " + usuario.nombreUsuario)
		}
	}	

	def agregarDestino(Usuario usuario, Destino destino){
		validarPerfil(usuario)
		var Perfil res = homePerfil.getPerfilDeUsuario(usuario)
		if(res != null){
			res.destinos.add(destino)
			homePerfil.updateDestinoPerfil(usuario,res);
		}
		
	}
	
	def agregarComentarioAlPerfilDe(Usuario usuario, Destino destino, Comentario comentario){
		validarPerfil(usuario)
		var Perfil res = homePerfil.traerDestinoDe(usuario, destino)
		if(res != null){
			res.agregarComentarioADestino(comentario ,destino)
			homePerfil.updateDestinoPerfil(usuario,res);
		}		
				
	}
	
	
	def agregarMeGustaAlPerfilDe(Usuario usuario, Destino destino, Usuario usuarioMeGusta){
		validarPerfil(usuario)
		var Perfil res = homePerfil.traerDestinoDe(usuario, destino)
		if(res != null){
			res.darMeGusta(destino, usuarioMeGusta.nombreUsuario)
			homePerfil.updateDestinoPerfil(usuario,res);
		}		
	}
	
	def agregarNoMeGustaAlPerfilDe(Usuario usuario, Destino destino, Usuario usuarioMeGusta){
		validarPerfil(usuario)
		var Perfil res = homePerfil.traerDestinoDe(usuario, destino)
		if(res != null){
			res.darNoMeGusta(destino, usuarioMeGusta.nombreUsuario)
			homePerfil.updateDestinoPerfil(usuario,res);
		}			
	}
	
	def mostrarPerfil(Usuario visitante, Usuario visitado){
		validarPerfil(visitado)
		if(serviceAmigos.esAmigo(visitante,visitado)){
			homePerfil.mostrarParaAmigos(visitado)
		}else{
			if(visitante == visitado){
				homePerfil.mostrarParaPrivado(visitado)
			}else{
				homePerfil.mostrarParaPublico(visitado)
			}
		}
	}
	
}