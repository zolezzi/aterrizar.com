package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.modelo.Aerolinea
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import ar.edu.unq.epers.aterrizar.persistencia.home.AerolineaHome
import ar.edu.unq.epers.aterrizar.persistencia.home.VueloHome
import ar.edu.unq.epers.aterrizar.modelo.Vuelo
import ar.edu.unq.epers.aterrizar.persistencia.home.TramoHome
import ar.edu.unq.epers.aterrizar.modelo.Tramo
import ar.edu.unq.epers.aterrizar.modelo.Asiento
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencia.home.AsientoHome
import java.util.List
import java.util.ArrayList
import org.hibernate.SQLQuery
import org.hibernate.Query

class SistemaRegistroAerolineas {
	
	AerolineaHome aerolineaHome = new AerolineaHome()
	VueloHome vueloHome = new VueloHome()
	TramoHome tramoHome= new TramoHome()
	AsientoHome asientoHome = new AsientoHome()
	
		def registrarAerolinea(String nombre) {
		SessionManager.runInSession([
			var aerolinea = new Aerolinea => [
				it.nombreAerolinea = nombre
			]
			aerolineaHome.save(aerolinea)
			aerolinea
		]);
	}
	
		def eliminarAerolinea(int id){
		SessionManager.runInSession([
			var aerolinea = aerolineaHome.get(id)
			aerolineaHome.delete(aerolinea)
			null
		])
	}
	
	def eliminarAerolineaPor(String campo, String nombreAerolinea ){
		SessionManager.runInSession([
			var aerolinea = aerolineaHome.getBy (campo , nombreAerolinea)
			aerolineaHome.delete(aerolinea)
			null
		])
	}	
	
	def truncateTables(){
		SessionManager.runInSession([
			
			SessionManager.session.createSQLQuery("SET FOREIGN_KEY_CHECKS = 0").executeUpdate		
			SessionManager.session.createSQLQuery("TRUNCATE TABLE usuarios").executeUpdate
			SessionManager.session.createSQLQuery("TRUNCATE TABLE categorias").executeUpdate				
			SessionManager.session.createSQLQuery("TRUNCATE TABLE orden").executeUpdate			
			SessionManager.session.createSQLQuery("TRUNCATE TABLE tramos").executeUpdate			
			SessionManager.session.createSQLQuery("TRUNCATE TABLE criterios").executeUpdate			
			SessionManager.session.createSQLQuery("TRUNCATE TABLE vuelos").executeUpdate			
			SessionManager.session.createSQLQuery("TRUNCATE TABLE busqueda").executeUpdate			
			SessionManager.session.createSQLQuery("TRUNCATE TABLE asiento").executeUpdate			
			SessionManager.session.createSQLQuery("TRUNCATE TABLE aerolineas").executeUpdate
			SessionManager.session.createSQLQuery("SET FOREIGN_KEY_CHECKS = 1").executeUpdate
			null
		])
	}
	
		def consultarAerolineaPor(String campo, String valor){
			SessionManager.runInSession([
				aerolineaHome.getBy(campo,valor)
			])
	}
	
		def actualizar(Aerolinea aerolinea) {
			SessionManager.runInSession([
			aerolineaHome.save (aerolinea)
			null
		])
	}
	
	def agregaVuelo(Aerolinea aerolinea, Vuelo vuelo) {
		SessionManager.runInSession([
			aerolinea.registrarUnVuelo(vuelo)
			aerolineaHome.save(aerolinea)
			null
		])
	}
	
	def agregaTramoA(Vuelo vuelo, Tramo tramo) {
		SessionManager.runInSession([
			vuelo.agregarUnTramo(tramo)
			vueloHome.save(vuelo)
			null
		])
	}
	
	def reservarAsientoDeTramo(String origen, String destino, String numeroAsiento, Usuario usuario){
		SessionManager.runInSession([
			var Tramo tramo = tramoHome.getBy("origen", origen, "destino", destino)
			if(tramo != null){
				var Asiento asiento
				
				for (Asiento a : tramo.asientos) {
  					if(a.numeroAsiento == numeroAsiento){
  						asiento = a
  					}
				}
				
				if(asiento!=null){
					asiento.reservado = true
					asiento.usuario = usuario
					tramoHome.save(tramo)
				}else{
					throw new Exception("El Asiento en esa posición no está disponible para el Tramo solicitado")
				}
			}else{
				throw new Exception("No se encontro un Tramo para esa busqueda")
			}			
			null
		])
	}
	
	def contains(ArrayList<String>numeroAsientos,List<Asiento>asientosDisponibles){
			var estaContenido = true
			for(String nro: numeroAsientos){
				if(estaContenido){
					var estaDentro = false
					for(Asiento a: asientosDisponibles){
						if(!estaDentro){
							estaDentro = a.numeroAsiento == nro
						}
					}
					estaContenido = estaDentro
				}
			}
			estaContenido		
	}
	
	def reservarAsientos(ArrayList<String> numeroAsientos, ArrayList<Usuario> usuarios, String origen, String destino){
		SessionManager.runInSession([
			var Tramo tramo = tramoHome.getBy("origen", origen, "destino", destino)
			var List<Asiento> asientosDisponibles = null
			var puedeReservar=true;
			if(tramo != null){
			 	asientosDisponibles = this.consultarAsientosLibresDeTramo(tramo)
			}else{
				throw new Exception("No se encontro un Tramo para esa busqueda")
			}
			
			puedeReservar = contains(numeroAsientos,asientosDisponibles)
			
			if(puedeReservar){
				var n = 0
				for(String nro:numeroAsientos){
					this.reservarAsientoDeTramo(origen,destino,numeroAsientos.get(n),usuarios.get(n))
					n++
				}
			}else{
				throw new Exception("No hay suficientes asientos libres")
			}
			null
		])
	}
	
	
	def consultarAsientosLibresDeTramo(Tramo tramo){
		SessionManager.runInSession([
			var List<Asiento> asientos = asientoHome.getFreeSeatsOfSection("origen", tramo.origen,"destino",tramo.destino)
			asientos
		])
	}
	
}
