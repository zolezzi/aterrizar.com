package ar.edu.unq.epers.test.persistencia

import ar.edu.unq.epers.aterrizar.persistencia.home.TramoHome
import ar.edu.unq.epers.aterrizar.modelo.Tramo
import org.junit.Before
import java.util.ArrayList
import ar.edu.unq.epers.aterrizar.modelo.Asiento
import org.junit.Test
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import org.junit.Assert
import org.junit.After

class TestTramoHome {
	
	TramoHome tramoHome = new TramoHome()
	Tramo tramo
	Tramo tramo2
	
	@Before
	def void startUp(){
		
		tramo = new Tramo =>[
			asientos = new ArrayList<Asiento>
			origen = "Argentina"
			destino = "China"
			hora_llegada = "00:00" 
			hora_salida = "23:00"
			precio_base = 1500
		]
		
		tramo2 = new Tramo =>[
			asientos = new ArrayList<Asiento>
			origen = "China"
			destino = "Ghana"
			hora_llegada = "23:00" 
			hora_salida = "15:00"
			precio_base = 1000
		]
	}
	
	@Test
	def void testSaveTramo(){
		SessionManager.runInSession([
			tramoHome.save(tramo)
			Assert.assertEquals(tramoHome.get(tramo.id).destino,"China")
			null
		])	
	}
	
	@Test
	def void testTramoDelete(){

		SessionManager.runInSession([
			tramoHome.save(tramo2)
			tramoHome.delete(tramo2)
			Assert.assertNull(tramoHome.get(tramo2.id))
			null
		])	
	}
	
	@Test
	def void testTramoGetBy(){
		SessionManager.runInSession([
			tramoHome.save(tramo)
			tramoHome.save(tramo2)
			var tramoAux = tramoHome.getBy("origen", "Argentina")
			Assert.assertEquals(tramoAux.destino, tramo.destino)
			null
		])	
	}
	
	@Test
	def void testTramoGetByCon2CamposY2Valores(){
		SessionManager.runInSession([
			tramoHome.save(tramo)
			tramoHome.save(tramo2)
			var tramoAux = tramoHome.getBy("origen", "Argentina","destino","China")
			Assert.assertTrue(tramoAux.precio_base == 1500)
			null
		])	
	}
	
	@After
	def void dropData(){
		SessionManager.runInSession([
			tramoHome.delete(tramo)
			null
		])	
	}
}