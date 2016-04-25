package ar.edu.unq.epers.aterrizar.servicios

import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import java.util.Date
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Busqueda {
	var ArrayList <String> criterios = new ArrayList<String>()
	var String orden = " "
	var String query = " "
	var String queryFinal
	String queryinicial = "select distinct vuelos from Aerolinea as aerolinea join aerolinea.vuelos as vuelos left join vuelos.tramos as tramos left join tramos.asientos as asientos "
	
	def agregarCriterioAerolinea(String aerolinea){
		criterios.add("aerolinea.nombreAerolinea = '" + aerolinea + "'")
	}

	def agregarCriterioCategoriaBusiness(){
		criterios.add("asiento.categoria = 'Business'")
	}
	
	def agregarCriterioCategoriaPrimera(){
		criterios.add("asiento.categoria = 'Primera'")
	}
	
	def agregarCriterioCategoriaTurista(){
	    criterios.add("asiento.categoria = 'Turista'")	
	}
	
	def agregarCriteroFechaSalida(Date fecha){
		criterios.add("vuelos.fechaSalida = '" + fecha + "'")
	}
	
	def agregarCriterioFechaLlegada(Date fecha){
		criterios.add("vuelos.fechaLlegada = '" + fecha + "'")
	}
	
	def agregarCriterioOrigen(String origen){
		criterios.add("vuelos.origen = '" + origen + "'")
	}
	
	def agregarCriterioDestino(String destino){
		criterios.add("vuelos.destino = '" + destino + "'")
	}
	
	def ordenadoPorMenorCosto(){
		orden = ("order by vuelos.precio asc")
	}
	
	def ordenadoPorMenorEscala(){
		orden = ("order by vuelos.tramos.size asc")
	}
	
	def ordenadoPorMenorDuracion(){
		orden = ("order by vuelos.duracion asc")
	}
	
	def formarQuery(){
		var Integer posicion = criterios.length
		query = " where "
		for (String c : criterios) {
			if(posicion > 1){
  			query = query + c + " and "  			 			
  			}else{
  				query = query + c + " " 
  			}
  			posicion --
		}
		if(criterios.length == 0){
			query = " "
		}
		return queryinicial + query
	}
	
	def buscar(){
		queryFinal = formarQuery() + orden
		println(queryFinal)
		SessionManager.runInSession([
			var r = SessionManager.getSession().createQuery(queryFinal).list()
			println("!!!!!!!!!!!!!!!!!!!!!!!SIZE:" +r.size)
			r
		])
	}
}
