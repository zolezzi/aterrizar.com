package ar.edu.unq.epers.aterrizar.persistencia.cassandra

class CacheHome {
	
	CassandraManager manager = new CassandraManager
	
	def save(PerfilMapper perfilMapper){
		manager.mapper.save(perfilMapper)
	}

	def getPerfilMapper(String nombreUsuario){
		manager.mapper.get(nombreUsuario)
	}

	def update(PerfilMapper perfilMapper){
		delete(perfilMapper)
		save(perfilMapper)
	}
	
	def delete(PerfilMapper perfilMapper){
		manager.mapper.delete(perfilMapper)
	}
}