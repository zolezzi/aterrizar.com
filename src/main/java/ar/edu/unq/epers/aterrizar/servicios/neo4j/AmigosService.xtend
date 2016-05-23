package ar.edu.unq.epers.aterrizar.servicios.neo4j

import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencia.neo4j.RepositorioUsuariosHome
import ar.edu.unq.epers.aterrizar.persistencias.RepositorioUsuarios
import java.util.List

class AmigosService {

	RepositorioUsuariosHome repositorioHome
	RepositorioUsuarios basesDeDatosUsuarios = new RepositorioUsuarios

	private def createHome(GraphDatabaseService graph) {
		repositorioHome = new RepositorioUsuariosHome(graph)
		
	}	
	
	def getbase(){
		return basesDeDatosUsuarios
	}
	
	def eliminarUsuario(Usuario u) {
		GraphServiceRunner::run[
			createHome(it).eliminarNodo(u)
			null
		]
	}
	
	def agregarAmigo(Usuario usuario, Usuario UsuarioAgregar){
		
		val usuarioADevolver = basesDeDatosUsuarios.selectUser(usuario.nombreUsuario)
		val amigo = basesDeDatosUsuarios.selectUser(UsuarioAgregar.nombreUsuario)
		
		GraphServiceRunner::run[
			createHome(it).relacionarAmistad(usuarioADevolver, amigo)
			null
		]
	} 
		
		def List<Usuario> amigosDeUsuario(Usuario u){
		
		val usuario = basesDeDatosUsuarios.selectUser(u.nombreUsuario)
		
		GraphServiceRunner::run[
			val todosMisAmigos = createHome(it).getAmigosDeMisAmigos(usuario)
			todosMisAmigos.toList
		]
	}
		def cuantosConozco(Usuario u){
		amigosDeUsuario(u).length
	}
}