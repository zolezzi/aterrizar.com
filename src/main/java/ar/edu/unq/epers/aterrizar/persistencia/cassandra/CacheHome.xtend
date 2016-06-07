package ar.edu.unq.epers.aterrizar.persistencia.cassandra

class CacheHome {
	
	CassandraManager manager = new CassandraManager
	
	def save(PerfilMapper perfilMapper){
		manager.mapper.save(perfilMapper)
	}

	def getPerfilMapper(String nombreUsuario, String titulo){
		manager.mapper.get(nombreUsuario, titulo)
	}

	def update(PerfilMapper perfilMapper){
		delete(perfilMapper)
		save(perfilMapper)
	}
	
	def delete(PerfilMapper perfilMapper){
		manager.mapper.delete(perfilMapper)
	}
}