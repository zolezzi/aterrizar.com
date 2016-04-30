package ar.edu.unq.epers.test.persistencia
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.After
import ar.edu.unq.epers.aterrizar.servicios.Busqueda
import ar.edu.unq.epers.aterrizar.servicios.SistemaRegistroAerolineas
import java.util.List
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.modelo.Tramo
import ar.edu.unq.epers.aterrizar.modelo.Vuelo
import java.util.Date
import java.util.Timer
import ar.edu.unq.epers.aterrizar.modelo.Asiento
import ar.edu.unq.epers.aterrizar.modelo.CategoriaTurista
import ar.edu.unq.epers.aterrizar.modelo.CategoriaBusiness
import ar.edu.unq.epers.aterrizar.modelo.Usuario

class TestBusquedas {
	
	var Usuario usuario 				
	
	@Before
	def void startUp(){
		
		var Vuelo vuelo1 = new Vuelo => [
			tramos = new ArrayList<Tramo>
			origen = "Argentina"
			destino = "Panama"
			fechaSalida = new Date(2016,1,1)
			fechaLlegada = new Date(2016,1,2)
			duracion = new Timer() 
			precio = 1000
		]
		
		var Vuelo vuelo2 = new Vuelo => [
			tramos = new ArrayList<Tramo>
			origen = "Argentina"
			destino = "Mexico"
			fechaSalida = new Date(2016,1,1)
			fechaLlegada = new Date(2016,1,2)
			duracion = new Timer() 
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
		var Asiento asiento2 = new Asiento =>[
			categoria = new CategoriaBusiness()
			usuario = null
			origen = "Argentina"
			destino = "Chile"
			fechaSalida = new Date (2016,5,12)
			fechaLlegada = new Date (2016,5,13)
			precio = 200		
		]
		
		usuario = new Usuario =>[
				 	  nombre = "carlos"
					  apellido = "albar"
					  it.nombreUsuario = "c_albar"
					  email = "c_alabar@hotmail.com"
					  fechaNacimiento = "12/3/1990"
					  contrasenia = "albar" 
					 ]	

					 				
		tramo.agregarAsiento(asiento)
		tramo2.agregarAsiento(asiento2)
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
		var List<Vuelo> result = busqueda.buscar()
		Assert.assertEquals(result.size(), 2)		
	}
	
	@Test
	def void busquedaPorOrigen(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioOrigen("Argentina")
		var List<Vuelo> result = busqueda.buscar()
		Assert.assertEquals(result.size(), 2)
		Assert.assertEquals(result.get(0).origen, "Argentina")		
	}
	
	@Test
	def void busquedaPorDestino(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioDestino("Mexico")
		var List<Vuelo> result = busqueda.buscar()
		Assert.assertEquals(result.size(), 1)
		Assert.assertEquals(result.get(0).destino,"Mexico")		
	}

 
	@Test
	def void busquedaCompuesta(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioAerolinea("Aerolinea Payaso")
		busqueda.agregarCriterioDestino("Mexico")
		busqueda.agregarCriterioOrigen("Argentina")
		var List<Vuelo> result = busqueda.buscar()
		Assert.assertEquals(result.size(), 1)
		Assert.assertEquals(result.get(0).destino,"Mexico")	
		Assert.assertEquals(result.get(0).origen,"Argentina")	
	}

	@Test
	def void ordenadoPorCosto(){
		var Busqueda busqueda = new Busqueda()
		busqueda.ordenadoPorMenorCosto()
		var List<Vuelo> result = busqueda.buscar()
		Assert.assertEquals(result.size(), 2)		
		Assert.assertEquals(result.get(0).precio, 1000)
		Assert.assertEquals(result.get(1).precio, 1500)
	}
	
	@Test
	def void ordenadoPorMenosEscalas(){
		var Busqueda busqueda = new Busqueda()
		busqueda.ordenadoPorMenorEscala()
		var List<Vuelo> result = busqueda.buscar()
		Assert.assertEquals(result.size(), 2)		
		Assert.assertEquals(result.get(0).destino, "Panama")
		Assert.assertEquals(result.get(1).destino, "Mexico")
	}
	
	@Test
	def void vuelosConAsientosBusiness(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioCategoriaBusiness()
		var List<Vuelo> result = busqueda.buscar()
		Assert.assertEquals(result.size(),1)
	}	
	
	@Test
	def void vuelosConAsientosTrusita(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioCategoriaTurista()
		var List<Vuelo> result = busqueda.buscar()
		Assert.assertEquals(result.size(),1)
	}
	
	@Test
	def void vuelosConAsientosPrimera(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioCategoriaPrimera()
		var List<Vuelo> result = busqueda.buscar()
		Assert.assertEquals(result.size(),0)
	}
	
	@Test
	def void guardarHistorialBusquedasEnUsuario(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioCategoriaPrimera()
		var List<Vuelo> result = busqueda.buscar()
		usuario.guardarBusqueda(busqueda)
		Assert.assertEquals(usuario.obtenerUltimaBusqueda, busqueda.queryFinal)		
	}
	
	@Test
	def void ejecutarQueryDeHistorial(){
		var Busqueda busqueda = new Busqueda()
		busqueda.agregarCriterioCategoriaPrimera()
		var List<Vuelo> result = busqueda.buscar()
		usuario.guardarBusqueda(busqueda)
		var List<Vuelo> result2 = busqueda.buscarQuery(usuario.obtenerUltimaBusqueda)
		Assert.assertEquals(result.size(),result2.size())		
	}

	@After
	def void dropData(){
		new SistemaRegistroAerolineas().eliminarAerolineaPor("nombreAerolinea","Aerolinea Payaso")
	}
	
}