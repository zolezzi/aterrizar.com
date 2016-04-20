package ar.edu.unq.epers.test.persistencia

import org.junit.Test
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import ar.edu.unq.epers.aterrizar.persistencia.home.CategoriaBusinessHome
import org.junit.Before
import ar.edu.unq.epers.aterrizar.modelo.CategoriaBusiness
import org.junit.Assert
import org.junit.After

class TestCategoriaBusinessHome {
	
	CategoriaBusinessHome categoriaBusinessHome = new CategoriaBusinessHome
	
	CategoriaBusiness categoriaBusiness
	
	@Before
	def void setUp(){
		
		categoriaBusiness = new CategoriaBusiness
	}
	
	@Test
	def void testSaveCategoriaBusiness(){
		
		SessionManager.runInSession([
			categoriaBusinessHome.save(categoriaBusiness)
			var categoriaBusinessPersistida = categoriaBusinessHome.get(categoriaBusiness.id)
			Assert.assertEquals(categoriaBusinessPersistida,categoriaBusiness)
			null
		])
	}

	@Test
	def void testDeleteCategoriaBusiness(){
		
		SessionManager.runInSession([
			categoriaBusinessHome.save(categoriaBusiness)
			categoriaBusinessHome.delete(categoriaBusiness)
			var categoriaBusinessPersistida = categoriaBusinessHome.get(categoriaBusiness.id)
			Assert.assertEquals(categoriaBusinessPersistida,null)
			null
		])
	}

	@After
	def void setDown(){
		SessionManager.runInSession([
			SessionManager.getSession.createSQLQuery("USE aterrizar_p2").executeUpdate
			SessionManager.getSession.createSQLQuery("SET SQL_SAFE_UPDATES=0").executeUpdate
			SessionManager.getSession.createSQLQuery("DELETE FROM categoria_business").executeUpdate
		])
	}
}