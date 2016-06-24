package ar.edu.unq.epers.aterrizar.persistencia.cassandra

import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.modelo.Usuario

interface IHomePerfil {
	
	def Perfil mostrarParaAmigos(Usuario usuario)
	
	def Perfil mostrarParaPrivado(Usuario usuario)
	
	def Perfil mostrarParaPublico(Usuario usuario)
	
}