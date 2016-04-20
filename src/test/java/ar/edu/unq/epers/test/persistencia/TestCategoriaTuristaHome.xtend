package ar.edu.unq.epers.test.persistencia

import org.junit.Before
import org.junit.Test
import ar.edu.unq.epers.aterrizar.modelo.CategoriaTurista
import ar.edu.unq.epers.aterrizar.persistencia.home.CategoriaTuristaHome
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import org.junit.Assert
import org.junit.After

class TestCategoriaTuristaHome {
	
	CategoriaTurista categoriaTurista
	
	CategoriaTuristaHome categoriaTuristaHome = new CategoriaTuristaHome
	
	@Before
	def void setUp(){
		
		categoriaTurista = new CategoriaTurista()
	}

	@Test
	def void testSaveCategoriaTurista(){
		
		SessionManager.runInSession([
			categoriaTuristaHome.save(categoriaTurista)
			var categoriaTuristaPersistida = categoriaTuristaHome.get(categoriaTurista.id)
			Assert.assertEquals(categoriaTuristaPersistida,categoriaTurista)
			null
		])
	}
	
	@Test
	def void testDeleteCategoriaTurista(){
		
		SessionManager.runInSession([
			categoriaTuristaHome.save(categoriaTurista)
			categoriaTuristaHome.delete(categoriaTurista)
			var categoriaTuristaPersistida = categoriaTuristaHome.get(categoriaTurista.id)
			Assert.assertEquals(categoriaTuristaPersistida,null)
			null
		])
	}
	
	@After
	def void setDown(){
		SessionManager.runInSession([
			SessionManager.getSession.createSQLQuery("USE aterrizar_p2").executeUpdate
			SessionManager.getSession.createSQLQuery("SET SQL_SAFE_UPDATES=0").executeUpdate
			SessionManager.getSession.createSQLQuery("DELETE FROM categoria_turista").executeUpdate
		])
	}
}