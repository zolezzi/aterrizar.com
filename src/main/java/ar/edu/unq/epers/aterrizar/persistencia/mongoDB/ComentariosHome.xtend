package ar.edu.unq.epers.aterrizar.persistencia.mongoDB

import ar.edu.unq.epers.aterrizar.exception.ExceptionUsuario
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencia.cassandra.IHomePerfil
import java.util.List
import org.mongojack.AggregationResult
import org.mongojack.DBQuery
import org.mongojack.DBQuery.Query
import org.mongojack.JacksonDBCollection

class ComentariosHome<T> implements IHomePerfil{
	private JacksonDBCollection<T, String> mongoCollection
	var Class<T> entityType
	
	new(JacksonDBCollection<T, String> collection, Class<T> entityType){
		this.mongoCollection = collection
		this.entityType = entityType
	}
  	
  	def void insertPerfilAUsuario(Usuario usuario, T perfil){
  		var Query query = DBQuery.in("usuarioPerfil", usuario.nombreUsuario)
		var resQueryPerfil = this.mongoCollection.find(query);
		if(resQueryPerfil.length == 0){
			this.insert(perfil)
		}
  	}
  	
  	def getPerfilDeUsuario(Usuario usuario){
  		var Query query = DBQuery.in("usuarioPerfil", usuario.nombreUsuario)
		var resQueryPerfil = this.mongoCollection.find(query)
		if(resQueryPerfil.hasNext){
			resQueryPerfil.next
		}else{
			null
		}
  	}
  	
  	def baseQuery(Usuario visitado){
		var preQuery = this.aggregate
				   	   .match("usuarioPerfil",visitado.nombreUsuario)
				       .project
				       .rtn("id")
				       .rtn("usuarioPerfil")
				       .rtn("titulo")
				       .filter("destinos")
		preQuery
	}
	
	def  traerDestinoDe(Usuario visitado, Destino destino){
		var result = baseQuery(visitado).or(#[ [it.eq("tituloDestino",destino.tituloDestino)]])
					 .execute
		var perfil = result.get(0) as Perfil
		if(!perfil.destinos.empty){
			perfil
		}else{
			throw new ExceptionUsuario("No se encontraron destinos")
		}
	}
	
	override mostrarParaPublico(Usuario visitado){
			var result = baseQuery(visitado).or(#[ [it.eq("publico",true)]])
				       .execute
			result.get(0) as Perfil
	}
	
	override mostrarParaAmigos(Usuario visitado){
			var result = baseQuery(visitado)
						 .or(#[ [it.eq("publico",true)],[it.eq("soloAmigos",true)] ])
				         .execute
			result.get(0) as Perfil
	}
	
	override mostrarParaPrivado(Usuario visitado){
		var result = baseQuery(visitado)
					 .or(#[ [it.eq("publico",true)],[it.eq("soloAmigos",true)],[it.eq("privado",true)] ])
				      .execute
		return result.get(0) as Perfil
	}
	
  
	
	def insert(T object){
		return mongoCollection.insert(object);
    }
	
	def insert(List<T> object){
		return mongoCollection.insert(object);
    }
    
    def find(Query object){
		return mongoCollection.find(object);
    }
    
    def List<T> find(Aggregation<T> aggregation){
    	new AggregationResult<T>(mongoCollection, 
    		mongoCollection.dbCollection.aggregate(aggregation.build),
    		entityType
    	).results
    }
    
    def aggregate(){
    	new Aggregation(this)
    	
    }
    
    def updateDestinoPerfil(Usuario usuario, T updateElement){
		var Query query = DBQuery.in("usuarioPerfil", usuario.nombreUsuario)
    	this.update(query,updateElement)
    }
    
    def update(Query object, T changeObject ){
		mongoCollection.update(object,changeObject)
	}
	
    def remove(Query object){
		return mongoCollection.remove(object);
    }
    
	def getMongoCollection() {
		return mongoCollection;
	}
}
