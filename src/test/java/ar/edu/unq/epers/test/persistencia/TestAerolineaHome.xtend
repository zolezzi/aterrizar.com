package ar.edu.unq.epers.test.persistencia

import ar.edu.unq.epers.aterrizar.modelo.Aerolinea
import ar.edu.unq.epers.aterrizar.persistencia.home.AerolineaHome
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.After
import org.hibernate.Query

class TestAerolineaHome {
	
	Aerolinea aerolineasPayaso
	Aerolinea aerolineasPayaso2
	AerolineaHome aerolineaHome = new AerolineaHome
	
	Query query
	
	@Before
	def void setUp(){
		
		aerolineasPayaso = new Aerolinea () => [
			
			nombreAerolinea = "Aerolineas Payaso"
		]
		aerolineasPayaso2 = new Aerolinea () => [
			
			nombreAerolinea = "Aerolineas Payaso 2"
		]
	}

	@Test
	def void testSave() {
		
		SessionManager.runInSession([
			aerolineaHome.save(aerolineasPayaso)
			var aerolineaPersistida = aerolineaHome.get(aerolineasPayaso.id)
			Assert.assertEquals(aerolineasPayaso,aerolineaPersistida)
			null
		])
	}
	
	@Test
	def void testDelete() {
		
		SessionManager.runInSession([
			aerolineaHome.save(aerolineasPayaso2)
			aerolineaHome.delete(aerolineasPayaso2)
			var aerolineaPersistida = aerolineaHome.get(aerolineasPayaso2.id)
			Assert.assertEquals(aerolineaPersistida,null)
			null
		])
	}
	
	@Test
	def void testGetBy() {
		
		SessionManager.runInSession([
			aerolineaHome.save(aerolineasPayaso)
			var aerolineaPersistida = aerolineaHome.getBy("nombreAerolinea",aerolineasPayaso.nombreAerolinea)
			Assert.assertEquals(aerolineasPayaso,aerolineaPersistida)
			null
		])
	}
	
	@After
	def void setDown(){
		SessionManager.runInSession([
			aerolineaHome.delete(aerolineasPayaso)
			null
		])
	}
}