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
import ar.edu.unq.epers.aterrizar.persistencia.home.AsientoHome
import java.util.List
import ar.edu.unq.epers.aterrizar.persistencia.home.UsuarioHome

class TestSistemaRegistroVuelos {
	
	Usuario usuario
	Usuario usuarioII
	
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
		
		var Asiento asientoII = new Asiento =>[
			categoria = new CategoriaTurista()
			usuario = null
			origen = "Argentina"
			destino = "Peru"
			fechaSalida = new Date (2016,5,12)
			fechaLlegada = new Date (2016,5,13)
			precio = 150		
		]
		
		var Asiento asientoIII = new Asiento =>[
			categoria = new CategoriaTurista()
			usuario = null
			origen = "Peru"
			destino = "Panama"
			fechaSalida = new Date (2016,5,12)
			fechaLlegada = new Date (2016,5,13)
			precio = 150		
		]
		
		usuario = new Usuario =>[
			nombre = "Juan"
			apellido = "pepito"
			nombreUsuario = "juan08"
			email = "juan@hotmail.com"
			fechaNacimiento = "12/10/90"
			contrasenia = "blabla"
			codValidacion = "000000"
		]
		
		usuarioII = new Usuario =>[
			nombre = "Juan"
			apellido = "pepito"
			nombreUsuario = "juan09"
			email = "juan@hotmail.com"
			fechaNacimiento = "12/10/90"
			contrasenia = "blabla"
			codValidacion = "000000"
		]
		tramo.agregarAsiento(asiento)
		tramo.agregarAsiento(asientoII)
		tramo.agregarAsiento(asientoIII)
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
	
	@Test
	def void RegistroUsuarioAUnAsientoValidodeTramo(){
		new SistemaRegistroAerolineas().reservarAsientoDeTramo("Argentina","Chile",1,usuarioII)
		SessionManager.runInSession([
			var Tramo tramo = new TramoHome().getBy("origen","Argentina","destino","Chile")
			Assert.assertEquals(tramo.asientos.get(0).reservado, true) 
			null
		])
	}

	 
	@Test (expected = Exception) 
	def void RegistroUsuarioAUnTramoInvalido(){
		new SistemaRegistroAerolineas().reservarAsientoDeTramo("Argentina","Peru",1, usuario)
		thrown.expectMessage("No se encontro un Tramo para esa busqueda") 
	}
		
	@Test
	def void ReservarAsientos(){
		new SistemaRegistroAerolineas().reservarAsientos(3,usuario)

		SessionManager.runInSession([
			var List<Asiento> asientos = new AsientoHome().getRange(3)
			(asientos).forEach[asiento | 
					Assert.assertTrue(asiento.reservado == true)
					Assert.assertTrue(asiento.usuario == usuario)
				]
			null
		])
	}
	
	@Test (expected = Exception) 
	def void RegistroUsuarioAUnAsientoInvalidodeTramo(){
		new SistemaRegistroAerolineas().reservarAsientoDeTramo("Argentina","Chile",0,usuario)
		thrown.expectMessage("No se encontro un Tramo para esa busqueda") 
	}
	
	@Test
	def void RegistroUsuarioAUnTramoValido(){
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