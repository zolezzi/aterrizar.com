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
	
	def reservarAsientoDeTramo(String origen, String destino, int posicionAsiento, Usuario usuario){
		SessionManager.runInSession([
			var Tramo tramo = tramoHome.getBy("origen", origen, "destino", destino)
			if(tramo != null ){
				var Asiento asiento = tramo.asientos.get(posicionAsiento - 1)
				asiento.reservado = true
				asiento.usuario = usuario
				tramoHome.save(tramo)
			}else{
				throw new Exception("No se encontro un Tramo para esa busqueda")
			}			
			null
		])
	}
	
	def reservarAsientos(Integer cantidadAsientos, Usuario usuario){
		SessionManager.runInSession([
			var List<Asiento> asientos = asientoHome.getRange(cantidadAsientos)
			if(asientos.length == cantidadAsientos){
				(asientos).forEach[asiento | 
					asiento.reservado = true
					asiento.usuario = usuario
				]
				(asientos).forEach[asiento | 
					asientoHome.save(asiento)
				]			
			}else{
				throw new Exception("No hay suficientes asientos libres")
			}
			null
		])
	}
	
}
