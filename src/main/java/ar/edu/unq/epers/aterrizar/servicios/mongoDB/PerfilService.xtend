package ar.edu.unq.epers.aterrizar.servicios.mongoDB

import ar.edu.unq.epers.aterrizar.exception.ExceptionUsuario
import ar.edu.unq.epers.aterrizar.modelo.Asiento
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Comentario
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Destino
import ar.edu.unq.epers.aterrizar.modelo.Comentarios.Perfil
import ar.edu.unq.epers.aterrizar.modelo.Tramo
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.modelo.Vuelo
import ar.edu.unq.epers.aterrizar.modelo.modelobusqueda.Busqueda
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.CriterioAND
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.CriterioAerolinea
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.CriterioDestino
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.CriterioOrigen
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.Criterios
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.ComentariosHome
import ar.edu.unq.epers.aterrizar.persistencia.mongoDB.SistemDB
import ar.edu.unq.epers.aterrizar.servicios.BusquedaService
import ar.edu.unq.epers.aterrizar.servicios.neo4j.AmigosService
import java.util.List
import ar.edu.unq.epers.aterrizar.persistencia.cassandra.CacheHome
import ar.edu.unq.epers.aterrizar.persistencia.cassandra.IHomePerfil

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
		var Criterios andCrit = new CriterioAND(criterio, criterio2)
		var Criterios andCrit2 = new CriterioAND(andCrit,criterio3)
		busqueda.agregarCriterioBusqueda(andCrit2)
		var List<Vuelo> result = servicioBusqueda.ejecutarBusqueda(busqueda)
		var boolean valido = false
		for(Vuelo v: result){
			for(Tramo t: v.tramos){
				for(Asiento a: t.asientos){
					if(!valido &&a.usuario.nombreUsuario == usuario.nombreUsuario){
						return true;
					}
				}
			}
		}
		
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
	
	def agregarComentarioAlPerfilDe(Usuario usuario, Destino destino, Comentario comentario){
		
		validarPerfil(usuario)
		var res = traerPerfilDestino(usuario,destino)
		res.agregarComentarioADestino(comentario ,destino)
		homePerfil.updateDestinoPerfil(usuario,res);		
				
	}
	
	
	def agregarMeGustaAlPerfilDe(Usuario usuario, Destino destino, Usuario usuarioMeGusta){
		var res = traerPerfilDestino(usuario,destino)
		res.darMeGusta(destino, usuarioMeGusta.nombreUsuario)
		homePerfil.updateDestinoPerfil(usuario,res);
				
	}
	
	def agregarNoMeGustaAlPerfilDe(Usuario usuario, Destino destino, Usuario usuarioMeGusta){
		var res = traerPerfilDestino(usuario,destino)
		res.darNoMeGusta(destino, usuarioMeGusta.nombreUsuario)
		homePerfil.updateDestinoPerfil(usuario,res);
	}
	
	def mostrarPerfil(Usuario visitante, Usuario visitado){
		
		var Perfil perfil = null

		if(!cacheHome.perfilEnCache(visitado.nombreUsuario)){
			validarPerfil(visitado)
			perfil = filtrarPerfilPara(homePerfil,visitante,visitado)
			cacheHome.savePerfil(perfil)
			return perfil
		} else {
			perfil = filtrarPerfilPara(cacheHome,visitante,visitado)
			return perfil
		}
	}
	
	def filtrarPerfilPara(IHomePerfil home, Usuario visitante, Usuario visitado){
		
		var Perfil perfil = null 
		
		if(serviceAmigos.esAmigo(visitante,visitado)){
				perfil = home.mostrarParaAmigos(visitado)
			}else{
				if(visitante == visitado){
					perfil = home.mostrarParaPrivado(visitado)
				}else{
					perfil = home.mostrarParaPublico(visitado)
				}
			}
		perfil
	}
}