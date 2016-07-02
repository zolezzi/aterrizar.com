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
	
	def savePerfil(Perfil perfil, String visibilidad,boolean actualizado){
		save(convertToPerfilMapper(perfil, visibilidad, actualizado))
	}
	
	def updatePerfil(Perfil perfil, String visibilidad){
		update(convertToPerfilMapper(perfil, visibilidad,true))
	}
	
	private def convertToPerfilMapper(Perfil perfil, String visibilidad,boolean actualizado){
		var perfilMapper = new PerfilMapper => [
			it.nombreUsuario = perfil.usuarioPerfil
			it.titulo = perfil.titulo
			it.destinosDelPerfil = perfil.destinos
			it.visibilidad = visibilidad
			it.actualizado = actualizado
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
	
	def perfilEnCache(String nombreUsuario,String visibilidad){
		manager.mapper.get(nombreUsuario,visibilidad)!=null
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
	
	def perfilDesactualizado(String nombreUsuario) {
		var PerfilMapper pmPrivado = manager.mapper.get(nombreUsuario,"privado")
		var PerfilMapper pmAmigo = manager.mapper.get(nombreUsuario,"amigo")
		var PerfilMapper pmPublico = manager.mapper.get(nombreUsuario,"publico")
		
		if(pmPrivado != null){
			pmPrivado.actualizado = false
			save(pmPrivado)
		}
		
		if(pmAmigo != null){
			pmAmigo.actualizado = false
			save(pmAmigo)
		}
		
		if(pmPublico!=null){
			pmPublico.actualizado = false
			save(pmPublico)
		}
		
	}
	
	def void truncateAll(){
		manager.truncateAll()
	}
	
	def perfilUsuarioActualizado(String nombreUsuario, String visibilidad) {
		manager.mapper.get(nombreUsuario,visibilidad).actualizado
	}
	
	
}