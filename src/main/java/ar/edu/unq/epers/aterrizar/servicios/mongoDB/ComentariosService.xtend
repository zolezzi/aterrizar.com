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
import org.mongojack.MapReduce

import org.mongojack.Id
import org.eclipse.xtend.lib.annotations.Accessors
import org.mongojack.ObjectId
import com.fasterxml.jackson.annotation.JsonProperty
import java.util.ArrayList

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
		
		//chequear si el usuario ya tiene perfil
		
		var Perfil perfil = new Perfil => [
			usuarioPerfil = usuario
			titulo = tituloPerfil
		]
		homePerfil.insert(perfil)
		
	}
	
	//posible exception
	def agregarDestino(Usuario usuario, Destino destino){
		
		var Query query = DBQuery.in("usuarioPerfil", usuario)
		var Perfil resQueryPerfil = homePerfil.mongoCollection.find(query).next() as Perfil;
		if(resQueryPerfil != null){
			resQueryPerfil.destinos.add(destino)
			homePerfil.update(query, resQueryPerfil)
		}
		
	}
	
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
	
	def agregarNoMeGustaAlPerfilDe(Usuario usuario, Destino destino, Usuario usuarioMeGusta){
			
		var Query query = DBQuery.in("usuarioPerfil", usuario)
		var Perfil res = homePerfil.mongoCollection.find(query).next() as Perfil;
		if(res != null){
			res.darNoMeGusta(destino, usuarioMeGusta)
			homePerfil.update(query,res)
		}		
	}
	
	
	def mostrarPerfil(Usuario visitante, Usuario visitado){
		
		val map = '''
			function() { 
					emit(this.id, this.destinos);
			}
		'''

		val reduce = '''
			function(key, values) {
				var returndests = [];
				for(var i in values) {
					if(values[i].publico){
						returndest.push(values[i]);
					}
				}
				return returndests;
			}
		'''

		val command = MapReduce.build(map, reduce, 
			MapReduce.OutputType.REPLACE, "destinos", 
			PerfilScan, String)

		command.query = DBQuery.in("usuarioPerfil",visitado)

		val output = homePerfil.mongoCollection.mapReduce(command)
		
			output.results().forEach[
				println('''Perfil de Â«id» muestra destinos $Â«value»''')
			]
		
	}
	
	
	
	
}

@Accessors
public class PerfilScan {
	@Id
	public String id;
	public ArrayList<Destino> value;
}