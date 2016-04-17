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
import ar.edu.unq.epers.aterrizar.modelo.Asiento
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.modelo.CategoriaTurista
import org.junit.rules.ExpectedException
import org.junit.Rule
import ar.edu.unq.epers.aterrizar.persistencia.home.TramoHome
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
		
		var Tramo tramo = new Tramo =>[
			asientos = new ArrayList<Asiento>
			origen = "Argentina"
			destino = "Chile"
			hora_llegada = null 
			hora_salida = null
			precio_base = 150
		]
		
		var Asiento asiento = new Asiento =>[
			categoria = new CategoriaTurista()
			usuario = null
			origen = "Argentina"
			destino = "Chile"
			fechaSalida = new Date (2016,5,12)
			fechaLlegada = new Date (2016,5,13)
			precio = 150
		]
		tramo.agregarAsiento(asiento)
		vuelo1.agregarUnTramo(tramo)
		
		var aerolinea = new SistemaRegistroAerolineas().registrarAerolinea("Aerolinea Payaso")
		new SistemaRegistroAerolineas().agregaVuelo(aerolinea, vuelo1)
	}
	
	@Rule
	public ExpectedException thrown = ExpectedException.none()
  
	@Test
	def void consultarSiSeRegistroUnaAerolinea() {
		SessionManager.runInSession([
		var aerolinea = new SistemaRegistroAerolineas().consultarAerolineaPor("nombreAerolinea","Aerolinea Payaso");
		Assert.assertEquals(aerolinea.vuelos.size, 1)
		null
		])
	}
 
	@Test (expected = Exception) 
	def void RegistroUsuarioAUnAsientoInvalidodeTramo(){
		new SistemaRegistroAerolineas().reservarAsientoDeTramo("Argentina","Chile",0,new Usuario())
		thrown.expectMessage("No se encontro un Tramo para esa busqueda") 
	}
	 
	@Test (expected = Exception) 
	def void RegistroUsuarioAUnTramoInvalido(){
		new SistemaRegistroAerolineas().reservarAsientoDeTramo("Argentina","Peru",1,new Usuario())
		thrown.expectMessage("No se encontro un Tramo para esa busqueda") 
	}
	
	@Test
	def void RegistroUsuarioAUnTramoValido(){
		var Usuario usuario = new Usuario()
		new SistemaRegistroAerolineas().reservarAsientoDeTramo("Argentina","Chile",1,usuario)
		SessionManager.runInSession([
			var Tramo tramo = new TramoHome().getBy("origen","Argentina","destino","Chile")
			Assert.assertEquals(tramo.asientos.get(0).reservado, true) 
			null
		])
	}

	@Test
	def void RegistroUsuarioAUnAsientoValidodeTramo(){
		var Usuario usuario = new Usuario()
		new SistemaRegistroAerolineas().reservarAsientoDeTramo("Argentina","Chile",1,usuario)
		SessionManager.runInSession([
			var Tramo tramo = new TramoHome().getBy("origen","Argentina","destino","Chile")
			Assert.assertEquals(tramo.asientos.get(0).reservado, true) 
			null
		])
	}
	
	@After
	def void dropData(){
		new SistemaRegistroAerolineas().eliminarAerolineaPor("nombreAerolinea","Aerolinea Payaso")
	}
	
	
}