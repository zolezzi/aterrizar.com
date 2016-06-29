package ar.edu.unq.epers.aterrizar.persistencia.cassandra

import ar.edu.unq.epers.aterrizar.exception.PerfilMapperException
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.eclipse.xtend.lib.annotations.Accessors

class CacheHome implements IHomePerfil {
	
	CassandraManager manager = new CassandraManager
	@Accessors
	boolean desactualizado = true
	
	def save(PerfilMapper perfilMapper){
		manager.mapper.save(perfilMapper)
	}
	
	def savePerfil(Perfil perfil, String visibilidad){
		save(convertToPerfilMapper(perfil, visibilidad))
	}
	
	def updatePerfil(Perfil perfil, String visibilidad){
		update(convertToPerfilMapper(perfil, visibilidad))
	}
	
	private def convertToPerfilMapper(Perfil perfil, String visibilidad){
		var perfilMapper = new PerfilMapper => [
			it.nombreUsuario = perfil.usuarioPerfil
			it.titulo = perfil.titulo
			it.destinosDelPerfil = perfil.destinos
			it.visibilidad = visibilidad
		]
		perfilMapper
	}

	def getPerfilMapper(String nombreUsuario) throws PerfilMapperException{
		
			val perfilMapper  = manager.mapper.get(nombreUsuario, "privado")
				if(perfilMapper != null){
					return perfilMapper
			} else {
				throw new PerfilMapperException
				("No hay un usuario con un perfil que tenga ese nombre")
		}
	}
	
	def perfilEnCache(String nombreUsuario){
		
		var boolean	esAmigo = manager.mapper.get(nombreUsuario,"amigo")!=null
		var boolean esPublico = manager.mapper.get(nombreUsuario,"publico")!=null
		var boolean esPrivado = manager.mapper.get(nombreUsuario,"privado")!=null
		
		return esAmigo&&esPublico&&esPrivado
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
		manager.mostrarParaPrivado(usuario.nombreUsuario).toPerfil
	}
	
	override mostrarParaPublico(Usuario usuario) {
		manager.mostrarParaPublico(usuario.nombreUsuario).toPerfil
	}
	
	def estoyDesactualizado() {
		desactualizado = true
	}
	
	def estoyActualizado() {
		desactualizado = false
	}
}