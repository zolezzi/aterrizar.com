package ar.edu.unq.epers.aterrizar.servicios

import ar.edu.unq.epers.aterrizar.modelo.Aerolinea
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import ar.edu.unq.epers.aterrizar.persistencia.home.AerolineaHome
import ar.edu.unq.epers.aterrizar.persistencia.home.VueloHome
import ar.edu.unq.epers.aterrizar.modelo.Vuelo

class SistemaRegistroAerolineas {
	
	AerolineaHome aerolineaHome = new AerolineaHome()
	VueloHome vueloHome = new VueloHome()
	
	
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
			//SessionManager.runInSession([
				aerolineaHome.getBy(campo,valor)
			//])
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
	
}
