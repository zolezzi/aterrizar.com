package ar.edu.unq.epers.test.persistencia

import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.Before
import ar.edu.unq.epers.aterrizar.modelo.Vuelo
import ar.edu.unq.epers.aterrizar.modelo.Tramo
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.modelo.Asiento
import java.util.Date
import java.util.Timer
import ar.edu.unq.epers.aterrizar.modelo.CategoriaTurista
import ar.edu.unq.epers.aterrizar.modelo.CategoriaBusiness
import ar.edu.unq.epers.aterrizar.servicios.SistemaRegistroAerolineas
import ar.edu.unq.epers.aterrizar.modelo.Busqueda
import ar.edu.unq.epers.aterrizar.servicios.BusquedaService
import org.junit.Test
import ar.edu.unq.epers.aterrizar.modelo.CriterioAerolinea
import ar.edu.unq.epers.aterrizar.modelo.Criterios
import java.util.List
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.modelo.CriterioOrigen
import org.junit.After
import ar.edu.unq.epers.aterrizar.modelo.CriterioDestino
import ar.edu.unq.epers.aterrizar.modelo.OrdenCosto
import ar.edu.unq.epers.aterrizar.modelo.Orden
import ar.edu.unq.epers.aterrizar.modelo.OrdenEscala
import ar.edu.unq.epers.aterrizar.modelo.CriterioAsientoBusiness
import ar.edu.unq.epers.aterrizar.modelo.CriterioAsientoTurista
import ar.edu.unq.epers.aterrizar.modelo.CriterioAsientoPrimera
import ar.edu.unq.epers.aterrizar.modelo.CriterioAND

class TestBusquedaService {
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
		var BusquedaService buscador = new BusquedaService()
		var Busqueda busqueda = new Busqueda()
		var Criterios criterio = new CriterioAerolinea("Aerolinea Payaso")
		busqueda.agregarCriterioBusqueda(criterio)
		var List<Vuelo> result = buscador.EjecutarBusqueda(busqueda)
		Assert.assertEquals(result.size(), 2)		
	}
	
	@Test
	def void busquedaPorOrigen(){
		var BusquedaService buscador = new BusquedaService()
		var Busqueda busqueda = new Busqueda()
		var Criterios criterio = new CriterioOrigen("Argentina")
		busqueda.agregarCriterioBusqueda(criterio)
		var List<Vuelo> result = buscador.EjecutarBusqueda(busqueda)
		
		Assert.assertEquals(result.size(), 2)
		Assert.assertEquals(result.get(0).origen, "Argentina")		
	}
	
	@Test
	def void busquedaPorDestino(){
		var BusquedaService buscador = new BusquedaService()
		var Busqueda busqueda = new Busqueda()
		var Criterios criterio = new CriterioDestino("Mexico")
		busqueda.agregarCriterioBusqueda(criterio)
		var List<Vuelo> result = buscador.EjecutarBusqueda(busqueda)
		
		Assert.assertEquals(result.size(), 1)
		Assert.assertEquals(result.get(0).destino,"Mexico")		
	}
	
	@Test
	def void ordenadoPorCosto(){
		
		var BusquedaService buscador = new BusquedaService()
		var Busqueda busqueda = new Busqueda()
		busqueda.orden = new OrdenCosto()
		var List<Vuelo> result = buscador.EjecutarBusqueda(busqueda)
		Assert.assertEquals(result.size(), 2)		
		Assert.assertEquals(result.get(0).precio, 1000)
		Assert.assertEquals(result.get(1).precio, 1500)
		
	}
	
	@Test
	def void ordenadoPorMenosEscalas(){
		
		var BusquedaService buscador = new BusquedaService()
		var Busqueda busqueda = new Busqueda()
		busqueda.orden = new OrdenEscala()
		var List<Vuelo> result = buscador.EjecutarBusqueda(busqueda)
		
		Assert.assertEquals(result.size(), 2)		
		Assert.assertEquals(result.get(0).destino, "Panama")
		Assert.assertEquals(result.get(1).destino, "Mexico")
	}
	
	@Test
	def void vuelosConAsientosBusiness(){
		var BusquedaService buscador = new BusquedaService()
		var Busqueda busqueda = new Busqueda()
		var Criterios criterio = new CriterioAsientoBusiness()
		busqueda.agregarCriterioBusqueda(criterio)
		var List<Vuelo> result = buscador.EjecutarBusqueda(busqueda)
		Assert.assertEquals(result.size(),1)
	}
		
	@Test
	def void vuelosConAsientosTrusita(){
		var BusquedaService buscador = new BusquedaService()
		var Busqueda busqueda = new Busqueda()
		var Criterios criterio = new CriterioAsientoTurista()
		busqueda.agregarCriterioBusqueda(criterio)
		var List<Vuelo> result = buscador.EjecutarBusqueda(busqueda)
		Assert.assertEquals(result.size(),1)
	}
	
	@Test
	def void vuelosConAsientosPrimera(){
		var BusquedaService buscador = new BusquedaService()
		var Busqueda busqueda = new Busqueda()
		var Criterios criterio = new CriterioAsientoPrimera()
		busqueda.agregarCriterioBusqueda(criterio)
		var List<Vuelo> result = buscador.EjecutarBusqueda(busqueda)
		Assert.assertEquals(result.size(),0)
	}
	
	@Test
	def void busquedaCompuesta(){
		var BusquedaService buscador = new BusquedaService()
		var Busqueda busqueda = new Busqueda()
		var Criterios criterio = new CriterioAerolinea("Aerolinea Payaso")
		var Criterios criterio2= new CriterioDestino("Mexico")
		var Criterios criterio3= new CriterioOrigen("Argentina")
		var Criterios andCrit = new CriterioAND(criterio, criterio2)
		var Criterios andCrit2 = new CriterioAND(andCrit,criterio3)
		busqueda.agregarCriterioBusqueda(andCrit2)
		var List<Vuelo> result = buscador.EjecutarBusqueda(busqueda)
	
		Assert.assertEquals(result.size(), 1)
		Assert.assertEquals(result.get(0).destino,"Mexico")	
		Assert.assertEquals(result.get(0).origen,"Argentina")	
	}
	
	@Test
	def void guardarHistorialBusquedasEnUsuario(){
		var BusquedaService buscador = new BusquedaService()
		var Busqueda busqueda = new Busqueda()
		var Criterios criterio = new CriterioAsientoPrimera()
		busqueda.agregarCriterioBusqueda(criterio)
		buscador.EjecutarBusqueda(busqueda)
		usuario.guardarBusqueda(busqueda)
		Assert.assertEquals(usuario.obtenerUltimaBusqueda, busqueda)		
	}
	
	
	@After
	def void dropData(){
		new SistemaRegistroAerolineas().eliminarAerolineaPor("nombreAerolinea","Aerolinea Payaso")
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}