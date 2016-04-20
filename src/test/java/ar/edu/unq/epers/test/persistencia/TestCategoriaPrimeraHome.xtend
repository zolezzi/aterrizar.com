package ar.edu.unq.epers.test.persistencia

import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import org.junit.After
import org.junit.Assert
import org.junit.Test
import ar.edu.unq.epers.aterrizar.persistencia.home.CategoriaPrimeraHome
import org.junit.Before
import ar.edu.unq.epers.aterrizar.modelo.CategoriaPrimera

class TestCategoriaPrimeraHome {
	
	CategoriaPrimeraHome categoriaPrimeraHome = new CategoriaPrimeraHome
	
	CategoriaPrimera categoriaPrimera
	
	@Before
	def void setUp(){
		
		categoriaPrimera = new CategoriaPrimera
	}

	@Test
	def void testSaveCategoriaBusiness(){
		
		SessionManager.runInSession([
			categoriaPrimeraHome.save(categoriaPrimera)
			var categoriaBusinessPersistida = categoriaPrimeraHome.get(categoriaPrimera.id)
			Assert.assertEquals(categoriaBusinessPersistida,categoriaPrimera)
			null
		])
	}

	@Test
	def void testDeleteCategoriaBusiness(){
		
		SessionManager.runInSession([
			categoriaPrimeraHome.save(categoriaPrimera)
			categoriaPrimeraHome.delete(categoriaPrimera)
			var categoriaBusinessPersistida = categoriaPrimeraHome.get(categoriaPrimera.id)
			Assert.assertEquals(categoriaBusinessPersistida,null)
			null
		])
	}

	@After
	def void setDown(){
		SessionManager.runInSession([
			SessionManager.getSession.createSQLQuery("USE aterrizar_p2").executeUpdate
			SessionManager.getSession.createSQLQuery("SET SQL_SAFE_UPDATES=0").executeUpdate
			SessionManager.getSession.createSQLQuery("DELETE FROM categoria_primera").executeUpdate
		])
	}
}