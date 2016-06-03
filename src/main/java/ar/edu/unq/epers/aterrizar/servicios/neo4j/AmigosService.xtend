package ar.edu.unq.epers.aterrizar.servicios.neo4j

import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencia.neo4j.RepositorioUsuariosHome
import ar.edu.unq.epers.aterrizar.persistencias.RepositorioUsuarios
import java.util.List
import ar.edu.unq.epers.aterrizar.modelo.Mensaje

class AmigosService {

	RepositorioUsuariosHome repositorioHome
	RepositorioUsuarios basesDeDatosUsuarios = new RepositorioUsuarios

	private def createHome(GraphDatabaseService graph) {
		repositorioHome = new RepositorioUsuariosHome(graph)		
	}	
	
	def getbase(){
		return basesDeDatosUsuarios
	}
	
	def getRepositorioHome(){
		repositorioHome
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
			createHome(it).formarNodo(amigo)
			createHome(it).formarNodo(usuarioADevolver) 
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
	
		
	def esAmigo(Usuario usuario , Usuario usuarioAmigo){
		GraphServiceRunner::run[
			val sonAmigos = createHome(it).esAmigoDe(usuario, usuarioAmigo)
			return sonAmigos
		]
	}
	
	def cuantosConozco(Usuario u){
		amigosDeUsuario(u).length
	}
	
	def eliminarMensajesDeUsuario(Usuario usuario) {
		GraphServiceRunner::run[
			createHome(it).eliminarMensajesDeUsuario(usuario)
			null
		]
	}
			
	def eliminarMensaje(Mensaje m){
		GraphServiceRunner::run[
			createHome(it).eliminarMensajes(m)
			null
		]
	}
	
	def void enviarMensajeAUnUsuario(Usuario emisor, Usuario receptor, Mensaje m){
		GraphServiceRunner::run[
			createHome(it).enviarMensaje(emisor, m, receptor)
		]
	}
	
	def List<Mensaje> buscarMensajesEnviados(Usuario u){
		GraphServiceRunner::run[
			createHome(it).mensajesEnviados(u).toList
		]
	}

	def List<Mensaje> buscarMensajesRecibidos(Usuario u){
		GraphServiceRunner::run[
			createHome(it).mensajesRecibidos(u).toList
		]
	}
	
}