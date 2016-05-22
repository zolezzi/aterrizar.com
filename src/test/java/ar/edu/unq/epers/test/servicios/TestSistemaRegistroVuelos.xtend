package ar.edu.unq.epers.test.servicios

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
	Usuario usuarioIII 
	Usuario usuarioIV
	Tramo tramo
	ArrayList<String> asientos = new ArrayList<String>
	ArrayList<Usuario> usuarios = new ArrayList<Usuario>
	
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
		
		tramo = new Tramo =>[
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
			numeroAsiento = "A1"
			fechaSalida = new Date (2016,5,12)
			fechaLlegada = new Date (2016,5,13)
			precio = 150		
		]
		
		var Asiento asientoII = new Asiento =>[
			categoria = new CategoriaTurista()
			usuario = null
			origen = "Argentina"
			destino = "Chile"
			numeroAsiento = "A2"
			fechaSalida = new Date (2016,5,12)
			fechaLlegada = new Date (2016,5,13)
			precio = 150		
		]
		
		var Asiento asientoIII = new Asiento =>[
			categoria = new CategoriaTurista()
			usuario = null
			origen = "Argentina"
			destino = "Chile"
			numeroAsiento = "A3"
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
		
		usuarioIII = new Usuario =>[
			nombre = "Juan"
			apellido = "pepito"
			nombreUsuario = "juan10"
			email = "juan@hotmail.com"
			fechaNacimiento = "12/10/90"
			contrasenia = "blabla"
			codValidacion = "000000"
		]
		
		usuarioIV = new Usuario =>[
			nombre = "Juan"
			apellido = "pepito"
			nombreUsuario = "juan11"
			email = "juan@hotmail.com"
			fechaNacimiento = "12/10/90"
			contrasenia = "blabla"
			codValidacion = "000000"
		]
		tramo.agregarAsiento(asiento)
		tramo.agregarAsiento(asientoII)
		tramo.agregarAsiento(asientoIII)
		vuelo1.agregarUnTramo(tramo)
		asientos.add("A1")
		asientos.add("A2")
		usuarios.add(usuario)
		usuarios.add(usuarioII)
		
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
		new SistemaRegistroAerolineas().reservarAsientoDeTramo("Argentina","Chile","A1",usuarioIV)
		SessionManager.runInSession([
			var Tramo tramo = new TramoHome().getBy("origen","Argentina","destino","Chile")
			Assert.assertEquals(tramo.asientos.get(0).reservado, true) 			
			null
		])
	}
 	

	 
	@Test (expected = Exception) 
	def void RegistroUsuarioAUnTramoInvalido(){
		new SistemaRegistroAerolineas().reservarAsientoDeTramo("Argentina","Peru","A1", usuario)
		thrown.expectMessage("No se encontro un Tramo para esa busqueda") 
	}
 
	@Test
	def void ReservarAsientos(){
		new SistemaRegistroAerolineas().reservarAsientos(asientos,usuarios,"Argentina","Chile")

		SessionManager.runInSession([
			var tramo = new TramoHome().getBy("origen","Argentina","destino","Chile")
			for(Asiento asiento: tramo.asientos)  
				if(asiento.numeroAsiento=="A1" || asiento.numeroAsiento == "A2"){
					Assert.assertTrue(asiento.reservado == true)
				}else{
					Assert.assertTrue(asiento.reservado == false)
				}
			null
		])
	}
	  
	@Test (expected = Exception) 
	def void ReservarAsientosYaReservados(){
		new SistemaRegistroAerolineas().reservarAsientos(asientos,usuarios,"Argentina","Chile")
		new SistemaRegistroAerolineas().reservarAsientos(asientos,usuarios,"Argentina","Chile")
		thrown.expectMessage("El asiento solicitado ya esta reservado")

	}
	
	@Test (expected = Exception) 
	def void ReservarMasAsientosDeLosDisponibles(){
		asientos.add("A3")
		asientos.add("A4")
		usuarios.add(usuario)
		usuarios.add(usuario)
		new SistemaRegistroAerolineas().reservarAsientos(asientos,usuarios,"Argentina","Chile")
		thrown.expectMessage("No hay suficientes asientos libres")
	}
	
	
	
	@Test (expected = Exception) 
	def void RegistroUsuarioAUnAsientoInvalidodeTramo(){
		new SistemaRegistroAerolineas().reservarAsientoDeTramo("Argentina","Chile","A10",usuario)
		thrown.expectMessage("El Asiento en esa posición no está disponible para el Tramo solicitado") 
	}
	
	@Test
	def void RegistroUsuarioAUnTramoValido(){
		new SistemaRegistroAerolineas().reservarAsientoDeTramo("Argentina","Chile","A1",usuarioIII)
		SessionManager.runInSession([
			var Tramo tramo = new TramoHome().getBy("origen","Argentina","destino","Chile")
			var Asiento asiento
			for(Asiento a : tramo.asientos){
				if (a.numeroAsiento == "A1"){
					asiento = a
				}
			}
			Assert.assertEquals(asiento.reservado, true) 
			null
		])
	}
	
	@Test
	def void asientosLibres(){
		var asientos = new SistemaRegistroAerolineas().consultarAsientosLibresDeTramo(tramo)
		Assert.assertEquals(asientos.length,3);
	}
	
	@Test
	def void noHayAsientosLibres(){
		tramo.origen = "Peru"
		tramo.origen = "Panama"
		var asientos = new SistemaRegistroAerolineas().consultarAsientosLibresDeTramo(tramo)
		Assert.assertEquals(asientos.length,0);
	}
	
	 
	@After
	def void dropData(){
		new SistemaRegistroAerolineas().eliminarAerolineaPor("nombreAerolinea","Aerolinea Payaso")

	}
	 
	
}