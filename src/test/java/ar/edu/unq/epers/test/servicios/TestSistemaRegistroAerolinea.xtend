package ar.edu.unq.epers.test.servicios

import org.junit.Before
import ar.edu.unq.epers.aterrizar.servicios.SistemaRegistroAerolineas
import org.junit.After
import org.junit.Assert
import org.junit.Test

class TestSistemaRegistroAerolinea {
		
	@Before
	def void startUp(){
		new SistemaRegistroAerolineas().registrarAerolinea("Aerolinea Payaso")
	}
 
	@Test
	def testResgistroDeAerolineaYLePreguntoSuNombre() {
		var aerolinea = new SistemaRegistroAerolineas().consultarAerolineaPor("nombreAerolinea","Aerolinea Payaso");
		Assert.assertEquals("Aerolinea Payaso", aerolinea.getNombreAerolinea)
	}
	
	@After
	def void dropData(){
		new SistemaRegistroAerolineas().eliminarAerolineaPor("nombreAerolinea","Aerolinea Payaso")
	}
	
	
}