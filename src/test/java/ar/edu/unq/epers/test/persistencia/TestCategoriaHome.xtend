package ar.edu.unq.epers.test.persistencia

import ar.edu.unq.epers.aterrizar.modelo.CategoriaBusiness
import ar.edu.unq.epers.aterrizar.modelo.CategoriaPrimera
import ar.edu.unq.epers.aterrizar.modelo.CategoriaTurista
import ar.edu.unq.epers.aterrizar.persistencia.home.CategoriaHome
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class TestCategoriaHome {
	
	CategoriaTurista categoriaTurista
	CategoriaPrimera categoriaPrimera
	CategoriaBusiness categoriaBusiness
	
	CategoriaHome categoriaHome
	
	@Before
	def void setUp(){
		
		categoriaTurista = new CategoriaTurista
		categoriaPrimera = new CategoriaPrimera
		categoriaBusiness = new CategoriaBusiness
		
		categoriaHome = new CategoriaHome
	}
	
	@Test
	def void testSaveCategoria(){
		
		SessionManager.runInSession([
			categoriaHome.save(categoriaTurista)
			var categoriaPersistida = categoriaHome.get(categoriaTurista.id)
			Assert.assertEquals(categoriaTurista,categoriaPersistida)
			null
		])
	}
	
	@Test
	def void testDeleteCategoria(){
		
		SessionManager.runInSession([
			categoriaHome.save(categoriaPrimera)
			categoriaHome.delete(categoriaPrimera)
			var categoriaPersistida = categoriaHome.get(categoriaPrimera.id)
			Assert.assertEquals(categoriaPersistida,null)
			null
		])
	}
	
	@Test
	def void testGetBy(){
		
		SessionManager.runInSession([
			categoriaHome.save(categoriaBusiness)
			var categoriaPersistida = categoriaHome.getBy("tipo", "Business")
			Assert.assertEquals(categoriaPersistida,categoriaBusiness)
			null
		])
	}
}