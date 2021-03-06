package ar.edu.unq.epers.aterrizar.persistencia.neo4j

import ar.edu.unq.epers.aterrizar.modelo.Mensaje
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.relacion.TipoDeMensaje
import ar.edu.unq.epers.aterrizar.relacion.TipoDeRelacion
import org.neo4j.graphdb.Direction
import org.neo4j.graphdb.DynamicLabel
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.RelationshipType
import org.neo4j.graphdb.traversal.Evaluators
import org.neo4j.graphdb.traversal.Uniqueness
import java.util.List

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
		node.setProperty("nombre", u.nombre)
		node.setProperty("apellido", u.apellido)
		node.setProperty("email", u.email)
		node.setProperty("fechaNacimiento", u.fechaNacimiento)
		node.setProperty("contrasenia", u.contrasenia)
		node.setProperty("codValidacion", u.codValidacion)
		node.setProperty("id", u.id)
	}
	
	def relacionarAmistad(Usuario usuario, Usuario usuarioAmigo) {
		relacionar(usuario, usuarioAmigo, TipoDeRelacion.AMIGO)
		relacionar(usuarioAmigo, usuario, TipoDeRelacion.AMIGO)
	}	
	
	def esAmigoDe(Usuario u, Usuario u2){
		val amigos = getAmigos(u)
		var lista = amigos.toList
		
		return this.estaContenido(lista, u2)
	}
	
	def estaContenido(List<Usuario> listaDeUsuarios, Usuario u){
		var encontreUsuario = false
		for (usuario : listaDeUsuarios){
			encontreUsuario = encontreUsuario || usuario.nombreUsuario == u.nombreUsuario
		}
		return encontreUsuario
	}
	
	def getAmigos(Usuario u){
	//	val nodoUsuario = getNodo(u)
		val nodoUsuario = this.formarNodo(u)
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
			nombre = node.getProperty("nombre") as String
			apellido = node.getProperty("apellido") as String
			email = node.getProperty("email") as String
			fechaNacimiento = node.getProperty("fechaNacimiento") as String
			contrasenia = node.getProperty("contrasenia") as String
			codValidacion = node.getProperty("codValidacion") as String
			id = node.getProperty("id") as Integer
		]
	}
	
	def formarNodo(Usuario usuario) {
		var u = getNodo(usuario)
		if(u == null){
			u = this.crearNodo(usuario)
		}
		return u
	}
 	
	def eliminarMensajes(Mensaje msj) {
		eliminarNodo(msj)
	}
	
	def enviarMensaje(Usuario emisor, Mensaje msj, Usuario receptor) {
		relacionEnviarMensaje(emisor, msj, receptor)
	}
	
	def crearNodo(Mensaje m){
		val node = graph.createNode(mensajeLabel)
		agregarPropiedadesMensaje(node, m)
		node
	}
	
	def eliminarNodo(Mensaje m){
		val nodo = getNodo(m)
		borrarRelaciones(nodo)
	}
	
	def agregarPropiedadesMensaje(Node node, Mensaje m){
		node.setProperty("emisor", m.emisor)
		node.setProperty("receptor", m.receptor)
		node.setProperty("texto", m.texto)
		node.setProperty("idMensaje", m.idMensaje)
	}
	
		
	def mensajeLabel() {
		DynamicLabel.label("Mensaje")
	}

	def getNodo(Mensaje m){
		graph.findNodes(mensajeLabel, "idMensaje", m.idMensaje).head			
	}
	
		
	def toMensaje(Node node) {
		new Mensaje() => [
			emisor = node.getProperty("emisor") as String
			receptor = node.getProperty("receptor") as String
			texto = node.getProperty("texto") as String
			idMensaje = node.getProperty("idMensaje") as Integer
		]
	}
	
	
	def eliminarMensajesDeUsuario(Usuario usuario) {
		eliminarMensajesEnviados(usuario)
		eliminarMensajesRecibidos(usuario)
	}

	def eliminarMensajesEnviados(Usuario u){
		val nodoUsuario = getNodo(u)
		nodosRelacionados(nodoUsuario,TipoDeMensaje.EMISOR, Direction.OUTGOING).forEach[delete]		
	}
	
	def eliminarMensajesRecibidos(Usuario u){
		val nodoUsuario = getNodo(u)
		nodosRelacionados(nodoUsuario,TipoDeMensaje.RECEPTOR, Direction.INCOMING).forEach[delete]		
	}

	def relacionEnviarMensaje(Usuario emisor, Mensaje msjAEnviar, Usuario receptor){
		val nodoEmisor = getNodo(emisor)
		val nodoMensaje = crearNodo(msjAEnviar)
		val nodoReceptor = getNodo(receptor)
		relacionar(nodoEmisor, nodoMensaje, TipoDeMensaje.EMISOR)
		relacionar(nodoReceptor, nodoMensaje, TipoDeMensaje.RECEPTOR)
	}
	
	def mensajesEnviados(Usuario usuario) {
		val nodoEmisor = getNodo(usuario)
		nodosRelacionados(nodoEmisor, TipoDeMensaje.EMISOR, Direction.OUTGOING).map[toMensaje(it)].toSet
	}
	
	def mensajesRecibidos(Usuario usuario) {
		val nodoReceptor = getNodo(usuario)
		nodosRelacionados(nodoReceptor, TipoDeMensaje.RECEPTOR, Direction.INCOMING).map[toMensaje(it)].toSet
	}	
}