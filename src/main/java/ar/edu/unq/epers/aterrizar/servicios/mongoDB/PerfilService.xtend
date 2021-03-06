package ar.edu.unq.epers.aterrizar.servicios.mongoDB

import ar.edu.unq.epers.aterrizar.exception.ExceptionUsuario
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Comentario
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.modelo.Vuelo
import ar.edu.unq.epers.aterrizar.modelo.modelobusqueda.Busqueda
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.CriterioAND
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.CriterioAerolinea
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.CriterioAsientoUsuario
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.CriterioDestino
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.CriterioOrigen
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.Criterios
import ar.edu.unq.epers.aterrizar.persistencia.cassandra.CacheHome
import ar.edu.unq.epers.aterrizar.persistencia.cassandra.IHomePerfil
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.ComentariosHome
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.SistemDB
import ar.edu.unq.epers.aterrizar.servicios.BusquedaService
import ar.edu.unq.epers.aterrizar.servicios.neo4j.AmigosService
import java.util.ArrayList
import java.util.List
import org.eclipse.xtext.xbase.lib.Functions.Function4
import java.util.Map
import java.util.HashMap

class PerfilService {
	
	AmigosService serviceAmigos = new AmigosService
	ComentariosHome<Destino> homeDestino = SistemDB.instance().collection(Destino)
	ComentariosHome<Perfil> homePerfil = SistemDB.instance().collection(Perfil)
	BusquedaService servicioBusqueda = new BusquedaService
	CacheHome cacheHome = new CacheHome
	
	def getHomePerfil(){
		homePerfil
	}
	
	def getDestinoHome(){
		homeDestino
	}
	
	def crearPerfil(Usuario usuario, String tituloPerfil){
		
		var Perfil perfil = new Perfil => [
			usuarioPerfil = usuario.nombreUsuario
			titulo = tituloPerfil
			destinos = new ArrayList<Destino>
		]
		homePerfil.insertPerfilAUsuario(usuario,perfil)
	}
	
	def traerPerfilDestino(Usuario usuario, Destino destino){
		validarPerfil(usuario)
		var Perfil res = homePerfil.traerDestinoDe(usuario, destino)
		res
	}
	
	def validarPerfil(Usuario usuario){
		var Perfil res = homePerfil.getPerfilDeUsuario(usuario)
		if(res == null){
			this.crearPerfil(usuario, "Perfil " + usuario.nombreUsuario)
		}
	}	
	
	
	def validarDestino(Destino destino, Usuario usuario){
		
		var Busqueda busqueda = new Busqueda()
		var Criterios criterio = new CriterioAerolinea(destino.nombreAerolinea)
		var Criterios criterio2= new CriterioDestino(destino.destino)
		var Criterios criterio3= new CriterioOrigen(destino.origen)
		var Criterios criterio4= new CriterioAsientoUsuario(usuario.nombreUsuario)
		var Criterios andCrit = new CriterioAND(criterio, criterio2)
		var Criterios andCrit2 = new CriterioAND(andCrit,criterio3)
		var Criterios andCrit3= new CriterioAND(andCrit2,criterio4)
		busqueda.agregarCriterioBusqueda(andCrit3)
		var List<Vuelo> result = servicioBusqueda.ejecutarBusqueda(busqueda)
		!result.empty
	}
	
	//solo para testing de CacheHome, cassandra side.
	def agregarDestinoSinValidarDestino(Usuario usuario, Destino destino){
			validarPerfil(usuario)
			var Perfil res = homePerfil.getPerfilDeUsuario(usuario)
			res.destinos.add(destino)
			homePerfil.updateDestinoPerfil(usuario,res);
	}
	
	def agregarDestino(Usuario usuario, Destino destino){
		validarPerfil(usuario)
		if(validarDestino(destino,usuario)){
			var Perfil res = homePerfil.getPerfilDeUsuario(usuario)
			res.destinos.add(destino)
			homePerfil.updateDestinoPerfil(usuario,res);
		}else{
			throw new ExceptionUsuario("No posee un vuelo registrado para ese destino")
		}
		
	}
	
	
	var(Usuario, Destino, Function4<Perfil,Destino,String,Comentario,Boolean> , Comentario) => void aplicarFuncionAPerfil=[usuario, destino, toApply,comentario|
		validarPerfil(usuario)
		var perfilConDestinosAModificar = traerPerfilDestino(usuario,destino)
		toApply.apply(perfilConDestinosAModificar,destino,usuario.nombreUsuario,comentario)
		var perfilEnBD = homePerfil.getPerfilDeUsuario(usuario)
		perfilEnBD.insertDestinos(perfilConDestinosAModificar.destinos)
		homePerfil.updateDestinoPerfil(usuario,perfilEnBD)
		cacheHome.perfilDesactualizado(usuario.nombreUsuario)
	]
	

	
	def agregarMeGustaAlPerfilDe(Usuario usuario, Destino destino, Usuario usuarioMeGusta){
		
		var  f = [Perfil p, Destino d, String n, Comentario c|
			p.darMeGusta(d,n)
		]		
		aplicarFuncionAPerfil.apply(usuario,destino,f,null)	
				
	}
	
	
	def agregarNoMeGustaAlPerfilDe(Usuario usuario, Destino destino, Usuario usuarioMeGusta){
		var  f = [Perfil p, Destino d, String n, Comentario c|
			p.darNoMeGusta(d,n)
		]		
		aplicarFuncionAPerfil.apply(usuario,destino, f, null)	
	}
	
	def agregarComentarioAlPerfilDe(Usuario usuario, Destino destino, Comentario comentario){
		
		var  f = [Perfil p, Destino d, String n,Comentario c|
			p.agregarComentarioADestino(c,d)
		]		
		aplicarFuncionAPerfil.apply(usuario,destino,f,comentario)		
				
	}
	
	def mostrarPerfil(Usuario visitante, Usuario visitado){
		
		var String visibilidad = this.definirVisibilidad(visitante,visitado) 
		validarPerfil(visitado)
		var boolean estaEnCache = cacheHome.perfilEnCache(visitado.nombreUsuario,visibilidad) 
		if(!estaEnCache){		
			var perfil = filtrarPerfilPara(homePerfil,visitante,visitado,visibilidad)
			cacheHome.savePerfil(perfil, visibilidad)
			return perfil
		} else {
			filtrarPerfilPara(cacheHome,visitante,visitado,visibilidad)
		}
	}
	
	def filtrarPerfilPara(IHomePerfil home, Usuario visitante, Usuario visitado,String visibilidad){	
		
		switch(visibilidad){
			case "amigo": mostrarParaAmigos(home,visitado)
			case "privado": mostrarParaPrivado(home,visitado)
			case "publico": mostrarParaPublico(home,visitado)
		}
	}
	
	def mostrarParaAmigos(IHomePerfil home,Usuario visitado){
		home.mostrarParaAmigos(visitado)
		
	}
	
	def mostrarParaPrivado(IHomePerfil home,Usuario visitado){
		home.mostrarParaPrivado(visitado)
	}
	
	def mostrarParaPublico(IHomePerfil home,Usuario visitado){
		home.mostrarParaPublico(visitado)
	}
	
	def definirVisibilidad(Usuario visitante, Usuario visitado){
			var String visibilidad  = "amigo"
			
			if(serviceAmigos.esAmigo(visitante,visitado)){
				visibilidad = "amigo"
			}else{
				if(visitante == visitado){
					visibilidad = "privado"
				}else{
					visibilidad = "publico"
				}
			}
			
			return visibilidad
	}
}

