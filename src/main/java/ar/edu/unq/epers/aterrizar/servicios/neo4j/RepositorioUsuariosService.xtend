package ar.edu.unq.epers.aterrizar.servicios.neo4j

import org.neo4j.graphdb.GraphDatabaseService
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencia.neo4j.RepositorioUsuariosHome

class RepositorioUsuariosService {


	private def createHome(GraphDatabaseService graph) {
		new RepositorioUsuariosHome(graph)
	}	
	
	def eliminarUsuario(Usuario u) {
		GraphServiceRunner::run[
			createHome(it).eliminarNodo(u)
			null
		]
	}
	
	def agregarAmigo(Usuario usuario, Usuario UsuarioAgregar){
		
		
		
	}
}