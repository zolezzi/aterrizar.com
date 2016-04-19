package ar.edu.unq.epers.test.persistencia
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.After
import ar.edu.unq.epers.aterrizar.servicios.Busqueda
import ar.edu.unq.epers.aterrizar.servicios.SistemaRegistroAerolineas
import ar.edu.unq.epers.aterrizar.modelo.Aerolinea
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.modelo.Tramo
import ar.edu.unq.epers.aterrizar.modelo.Vuelo
import java.util.Date
import java.util.Timer
import ar.edu.unq.epers.aterrizar.modelo.Asiento
import ar.edu.unq.epers.aterrizar.modelo.CategoriaTurista

class TestBusquedas {
	@Before
	def void startUp(){
		
		var Vuelo vuelo1 = new Vuelo => [
			tramos = new ArrayList<Tramo>
			origen = "Argentina"
			destino = "Panama"
			fechaSalida = new Date(2016,1,1)
			fechaLlegada = new Date(2016,1,2)
			duracion = new Timer() //cambiar a otro tipo, no soporta timer la BD
			precio = 1000
		]
		
		var Vuelo vuelo2 = new Vuelo => [
			tramos = new ArrayList<Tramo>
			origen = "Argentina"
			destino = "Mexico"
			fechaSalida = new Date(2016,1,1)
			fechaLlegada = new Date(2016,1,2)
			duracion = new Timer() //cambiar a otro tipo, la BD no soporta timer
			precio = 1500
		]
		
		var Tramo tramo = new Tramo =>[
			asientos = new ArrayList<Asiento>
			origen = "Argentina"
			destino = "Chile"
			hora_llegada = null 
			hora_salida = null
			precio_base = 150
		]
		
		var Tramo tramo2 = new Tramo =>[
			asientos = new ArrayList<Asiento>
			origen = "Chile"
			destino = "Mexico"
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
		vuelo2.agregarUnTramo(tramo)
		vuelo2.agregarUnTramo(tramo2)
		var aerolinea = new SistemaRegistroAerolineas().registrarAerolinea("Aerolinea Payaso")
		new SistemaRegistroAerolineas().agregaVuelo(aerolinea, vuelo1)
		new SistemaRegistroAerolineas().agregaVuelo(aerolinea, vuelo2)
		
	}
	 
	@Test
	def void busquedaPorAerolinea(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioAerolinea("Aerolinea Payaso")
		var List<Aerolinea> result = busqueda.buscar()
		Assert.assertEquals(result.size(), 1)
		
	}
	
	@Test
	def void busquedaPorOrigen(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioOrigen("Argentina")
		var List<Aerolinea> result = busqueda.buscar()
		Assert.assertEquals(result.size(), 1)		
	}
	
	@Test
	def void busquedaPorDestino(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioDestino("Mexico")
		var List<Aerolinea> result = busqueda.buscar()
		Assert.assertEquals(result.size(), 1)		
	}

	
	@Test
	def void busquedaCompuestaSinOrden(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioAerolinea("Aerolinea Payaso")
		busqueda.agregarCriterioDestino("Mexico")
		busqueda.agregarCriterioOrigen("Argentina")
		var List<Aerolinea> result = busqueda.buscar()
		Assert.assertEquals(result.size(), 1)		
	}
	
	@Test
	def void ordenadoPorCosto(){
		var Busqueda busqueda = new Busqueda()
		busqueda.ordenadoPorMenorCosto()
		var List<Aerolinea> result = busqueda.buscar()
		Assert.assertEquals(result.get(0).vuelos.size(), 2)		
		Assert.assertEquals(result.get(0).vuelos.get(0).precio, 1000)
	}
	
	@Test
	def void ordenadoPorMenosEscalas(){
		var Busqueda busqueda = new Busqueda()
		busqueda.ordenadoPorMenorEscala()
		var List<Aerolinea> result = busqueda.buscar()
		Assert.assertEquals(result.get(0).vuelos.size(), 2)		
		Assert.assertEquals(result.get(0).vuelos.get(0).destino, "Panama")
	}
	
	 
	@After
	def void dropData(){
		new SistemaRegistroAerolineas().eliminarAerolineaPor("nombreAerolinea","Aerolinea Payaso")
	}
	
}