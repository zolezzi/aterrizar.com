package ar.edu.unq.epers.aterrizar.modelo

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Mensaje {
	String emisor
	String receptor
	String texto
	Integer idMensaje
}