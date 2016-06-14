package ar.edu.unq.epers.aterrizar.persistencia.cassandra

import ar.edu.unq.epers.aterrizar.exception.PerfilMapperException

class CacheHome {
	
	CassandraManager manager = new CassandraManager
	
	def save(PerfilMapper perfilMapper){
		manager.mapper.save(perfilMapper)
	}

	def getPerfilMapper(String nombreUsuario) throws PerfilMapperException{
		
			val perfilMapper  = manager.mapper.get(nombreUsuario)
				if(perfilMapper != null){
					return perfilMapper
			} else {
				throw new PerfilMapperException
				("No hay un usuario con un perfil que tenga ese nombre")
		}
	}

	def update(PerfilMapper perfilMapper){
		delete(perfilMapper)
		save(perfilMapper)
	}
	
	def delete(PerfilMapper perfilMapper){

		manager.mapper.delete(perfilMapper)
	}
}