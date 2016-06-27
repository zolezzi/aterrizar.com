package ar.edu.unq.epers.aterrizar.persistencia.cassandra

import ar.edu.unq.epers.aterrizar.exception.PerfilMapperException
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.modelo.Usuario

class CacheHome implements IHomePerfil {
	
	CassandraManager manager = new CassandraManager
	
	def save(PerfilMapper perfilMapper){
		manager.mapper.save(perfilMapper)
	}
	
	def savePerfil(Perfil perfil){
		save(convertToPerfilMapper(perfil))
	}
	
	def updatePerfil(Perfil perfil){
		update(convertToPerfilMapper(perfil))
	}
	
	private def convertToPerfilMapper(Perfil perfil){
		var perfilMapper = new PerfilMapper => [
			it.nombreUsuario = perfil.usuarioPerfil
			it.titulo = perfil.titulo
			it.destinosDelPerfil = perfil.destinos
		]
		perfilMapper
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
	
	def perfilEnCache(String nombreUsuario){
		
		return manager.mapper.get(nombreUsuario)!=null
	}

	def update(PerfilMapper perfilMapper){
		delete(perfilMapper)
		save(perfilMapper)
	}
	
	def delete(PerfilMapper perfilMapper){

		manager.mapper.delete(perfilMapper)
	}
	
	override mostrarParaAmigos(Usuario usuario) {
		manager.mostrarParaAmigos(usuario.nombreUsuario).toPerfil
	}
	
	override mostrarParaPrivado(Usuario usuario) {
		getPerfilMapper(usuario.nombreUsuario).toPerfil
	}
	
	override mostrarParaPublico(Usuario usuario) {
		manager.mostrarParaPublico(usuario.nombreUsuario).toPerfil
	}
}