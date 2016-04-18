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
	
	AerolineaHome aerolineaHome = new AerolineaHome
	
	Query query
	
	@Before
	def void setUp(){
		
		aerolineasPayaso = new Aerolinea () => [
			
			nombreAerolinea = "Aerolineas Payaso"
		]
	}

	@Test
	def void testSavaAerolinea() {
		
		SessionManager.runInSession([
			aerolineaHome.save(aerolineasPayaso)
			var aerolineaPersistida = aerolineaHome.get(aerolineasPayaso.id)
			Assert.assertEquals(aerolineasPayaso,aerolineaPersistida)
			null
		])
	}
	
	@Test
	def void testDeleteAerolinea() {
		
		SessionManager.runInSession([
			aerolineaHome.save(aerolineasPayaso)
			aerolineaHome.delete(aerolineasPayaso)
			var aerolineaPersistida = aerolineaHome.get(aerolineasPayaso.id)
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
			SessionManager.getSession.createSQLQuery("USE aterrizar_p2").executeUpdate
			SessionManager.getSession.createSQLQuery("SET SQL_SAFE_UPDATES=0").executeUpdate
			SessionManager.getSession.createSQLQuery("DELETE FROM usuarios").executeUpdate
			SessionManager.getSession.createSQLQuery("DELETE FROM aerolineas").executeUpdate
		])
	}
}