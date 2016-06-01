package ar.edu.unq.epers.aterrizar.persistencia.mongoDB

import java.util.List
import org.mongojack.AggregationResult
import org.mongojack.DBQuery.Query
import org.mongojack.JacksonDBCollection
import org.mongojack.MapReduce


class ComentariosHome<T> {
	private JacksonDBCollection<T, String> mongoCollection
	var Class<T> entityType
	
	new(JacksonDBCollection<T, String> collection, Class<T> entityType){
		this.mongoCollection = collection
		this.entityType = entityType
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
