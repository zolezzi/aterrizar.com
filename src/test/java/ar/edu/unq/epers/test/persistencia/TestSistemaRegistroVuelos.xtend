package ar.edu.unq.epers.test.persistencia

import org.junit.Before
import org.junit.Test
import org.junit.After
import ar.edu.unq.epers.aterrizar.servicios.SistemaRegistroAerolineas
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.modelo.Tramo
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.modelo.Vuelo
import java.util.Date
import java.util.Timer
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager

class TestSistemaRegistroVuelos {
	
	
	@Before
	def void startUp(){
		var Vuelo vuelo1 = new Vuelo => [
			tramos = new ArrayList<Tramo>
			origen = "Argentina"
			destino = "Panama"
			fechaSalida = new Date()
			fechaLlegada = new Date()
			duracion = new Timer()
			precio = 1000
		]
		
		var aerolinea = new SistemaRegistroAerolineas().registrarAerolinea("Aerolinea Payaso")
		new SistemaRegistroAerolineas().agregaVuelo(aerolinea, vuelo1)
	}
 
	@Test
	def void consultarSiSeRegistroUnaAerolinea() {
		SessionManager.runInSession([
		var aerolinea = new SistemaRegistroAerolineas().consultarAerolineaPor("nombreAerolinea","Aerolinea Payaso");
		Assert.assertEquals(aerolinea.vuelos.size, 1)
		null
		])
	}
	
	@After
	def void dropData(){
		new SistemaRegistroAerolineas().eliminarAerolineaPor("nombreAerolinea","Aerolinea Payaso")
	}
	
	
}