package ar.edu.unq.epers.test.persistencia

import org.junit.Before
import ar.edu.unq.epers.aterrizar.persistencia.home.BusquedaHome
import ar.edu.unq.epers.aterrizar.modelo.modelobusqueda.Busqueda
import org.junit.After
import org.junit.Test
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.CriterioAerolinea
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import ar.edu.unq.epers.aterrizar.modelo.modeloorden.OrdenCosto

class TestBusquedaHome {
	
	BusquedaHome home
	Busqueda busqueda
	
	@Before
	def void startup(){
		 home = new BusquedaHome
		 busqueda = new Busqueda
		 busqueda.agregarCriterioBusqueda(new CriterioAerolinea("Aerolinea Payaso"))
		 busqueda.orden = new OrdenCosto
	}
	
	@Test
	def void TestSave(){
		SessionManager.runInSession([
		home.save(this.busqueda)
		null
		])
	}
	
	
	@After
	def void dropData(){
		SessionManager.runInSession([
		home.delete(this.busqueda)
		null
		])
	}

}