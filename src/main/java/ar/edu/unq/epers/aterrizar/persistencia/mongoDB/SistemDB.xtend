package ar.edu.unq.epers.aterrizar.persistencia.mongoDB;

import com.mongodb.DB
import com.mongodb.MongoClient
import java.net.UnknownHostException
import org.mongojack.JacksonDBCollection

class SistemDB {
	static SistemDB INSTANCE;
	MongoClient mongoClient;
	DB db;

	synchronized def static SistemDB instance() {
		if (INSTANCE == null) {
			INSTANCE = new SistemDB();
		}
		return INSTANCE;
	}

	private new() {
		try {
			mongoClient = new MongoClient("localhost", 27017);
		} catch (UnknownHostException e) {
			throw new RuntimeException(e);
		}
		db = mongoClient.getDB("comentarios");
	}
	
	
	def <T> ComentariosHome<T> collection(Class<T> entityType){
		val dbCollection = db.getCollection(entityType.getSimpleName());
		new ComentariosHome<T>(JacksonDBCollection.wrap(dbCollection, entityType, String));
	}

}
