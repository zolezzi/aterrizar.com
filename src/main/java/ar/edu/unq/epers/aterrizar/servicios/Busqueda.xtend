package ar.edu.unq.epers.aterrizar.servicios

import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import java.util.List
import ar.edu.unq.epers.aterrizar.modelo.Aerolinea
import java.util.Date

class Busqueda {
	var ArrayList <String> criterios = new ArrayList<String>()
	var String orden = " "
	var String query = " "
	var String queryFinal
	String queryinicial = "select distinct aerolinea from Aerolinea as aerolinea join aerolinea.vuelos as vuelos join vuelos.tramos as tramos join tramos.asientos as asientos "
	
	def agregarCriterioAerolinea(String aerolinea){
		criterios.add("aerolinea.nombreAerolinea = '" + aerolinea + "'")
	}
	//to do: falta definir bien como persistir categorias para poder filtrarlas
	// son libres de inventar :P
	def agregarCriterioCategoriaBusiness(){
		
	}
	
	def agregarCriterioCategoriaPrimera(){
		
	}
	
	def agregarCriterioCategoriaTurista(){
		
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
		orden = ("order by vuelos.precio desc")
	}
	
	def ordenadoPorMenorEscala(){
		orden = ("order by vuelos.tramos.size asc")
	}
	
	def ordenadoPorMenorDuracion(){
		orden = ("order by vuelos.duracion desc")
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
			return SessionManager.getSession().createQuery(queryFinal).list() as List<Aerolinea>
		])
	}
}
