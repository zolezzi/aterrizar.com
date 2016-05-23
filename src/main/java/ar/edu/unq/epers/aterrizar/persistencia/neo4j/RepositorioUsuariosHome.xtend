package ar.edu.unq.epers.aterrizar.persistencia.neo4j


import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.DynamicLabel
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.RelationshipType
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.relacion.TipoDeRelacion
import org.neo4j.graphdb.traversal.Evaluators
import org.neo4j.graphdb.traversal.Uniqueness

class RepositorioUsuariosHome {
	
	GraphDatabaseService graph
	
	new(GraphDatabaseService g){
		graph = g
	}
	
	def usuarioLabel() {
		DynamicLabel.label("Usuario")
	}
	
	
	def crearNodo(Usuario usuario){
		val node = graph.createNode(usuarioLabel)
		agregarValores(node, usuario)
		node
	}
	
	def void borrarRelaciones(Node nodo){
		nodo.relationships.forEach[delete]
		nodo.delete
	}
	
	def eliminarNodo(Usuario u){
		val nodo = getNodo(u)
		borrarRelaciones(nodo)
	}
	
	def getNodo(Usuario usuario){
		graph.findNodes(usuarioLabel, "nombreUsuario", usuario.nombreUsuario).head
	}
	
	def agregarValores(Node node, Usuario u){
		node.setProperty("nombreUsuario", u.nombreUsuario)
	}
	
	def relacionarAmistad(Usuario usuario, Usuario usuarioAmigo) {
		relacionar(usuario, usuarioAmigo, TipoDeRelacion.AMIGO)
		relacionar(usuarioAmigo, usuario, TipoDeRelacion.AMIGO)
	}	
	
	def getAmigos(Usuario u){
		val nodoUsuario = getNodo(u)
		val nodos = nodosRelacionados(nodoUsuario, TipoDeRelacion.AMIGO, Direction.OUTGOING)
		var amigos = nodos.map[toUsuario(it)].toSet
		//amigos.removeIf([it.nombreUsuario.equals(u.nombreUsuario)])
		return amigos
	}
	
	def getAmigosDeMisAmigos(Usuario u){
		val nodoUsuario = getNodo(u)
		val nodos = todasLasRelaciones(nodoUsuario, TipoDeRelacion.AMIGO, Direction.OUTGOING)
		val amigos = nodos.map[toUsuario(it)].toSet
		return amigos
	}

	def relacionar(Usuario relacionando, Usuario aRelacionar, TipoDeRelacion relacion){
		val nodoRelacionando = getNodo(relacionando)
		val nodoARelacionar = getNodo(aRelacionar)
		relacionar(nodoRelacionando,nodoARelacionar, relacion)
	}
		
	def relacionar(Node relacionando, Node aRelacionar, RelationshipType relacion){
		relacionando.createRelationshipTo(aRelacionar, relacion)
	}
	
	def nodosRelacionados(Node node, RelationshipType relacion, Direction direction) {
		node.getRelationships(relacion, direction).map[it.getOtherNode(node)]
	}
	
	def todasLasRelaciones(Node nodo, RelationshipType relacion, Direction direction){

		val traveler = graph.traversalDescription
			.depthFirst
			.relationships(relacion,direction)
			.evaluator(Evaluators.excludeStartPosition)
			.uniqueness(Uniqueness.NODE_GLOBAL)
			
		val nodos = traveler.traverse(nodo).nodes
		
		return nodos
	}

	def toUsuario(Node node) {
		new Usuario => [
			nombreUsuario = node.getProperty("nombreUsuario") as String
			id = node.getProperty("id") as Integer
		]
	}
	
	def formarNodo(Usuario usuario) {
		val u = getNodo(usuario)
		if(u == null){
			this.crearNodo(usuario)
		}
	}
}