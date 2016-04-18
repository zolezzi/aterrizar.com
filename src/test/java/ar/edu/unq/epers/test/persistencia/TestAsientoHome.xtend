package ar.edu.unq.epers.test.persistencia

import ar.edu.unq.epers.aterrizar.modelo.Asiento
import ar.edu.unq.epers.aterrizar.modelo.CategoriaTurista
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencia.home.AsientoHome
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import java.util.Date
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.After

class TestAsientoHome {
	
	AsientoHome asientoHome = new AsientoHome()
	Asiento asiento
	Asiento asiento2
	Usuario usuario
	
	
	@Before
	def void startUp(){
		
		usuario = new Usuario =>[
			nombre = "Juan"
			apellido = "pepito"
			nombreUsuario = "juan08"
			email = "juan@hotmail.com"
			fechaNacimiento = "12/10/90"
			contrasenia = "blabla"
			codValidacion = "000000"
		]
		
		 asiento = new Asiento =>[
			categoria = new CategoriaTurista()
			usuario = usuario
			origen = "Argentina"
			destino = "Chile"
			fechaSalida = new Date (2016,5,12)
			fechaLlegada = new Date (2016,5,13)
			precio = 150					
		]

		 asiento2 = new Asiento =>[
			categoria = new CategoriaTurista()
			usuario = usuario
			origen = "Chile"
			destino = "España"
			fechaSalida = new Date (2016,5,13)
			fechaLlegada = new Date (2016,5,14)
			precio = 1050					
		]

	}
	
	@Test
	def void testSaveAsiento(){
		SessionManager.runInSession([
			asientoHome.save(asiento)
			Assert.assertEquals(asientoHome.get(asiento.id).precio, 150 )
			null
		])
	}
	
	@Test
	def void  testAsientoGetRange(){
		SessionManager.runInSession([
			asientoHome.save(asiento)
			asientoHome.save(asiento2)
			Assert.assertEquals(asientoHome.getRange(2).size,2)
			null
		])
	}
	
		@Test
	def void  testAsientoDelete(){
		SessionManager.runInSession([
			asientoHome.save(asiento)
			asientoHome.save(asiento2)
			asientoHome.delete(asiento2)
			Assert.assertEquals(asientoHome.getRange(2).size,1)
			null
		])
	}
	
	@After
	def void dropData(){
		SessionManager.runInSession([
			asientoHome.delete(asiento)
			asientoHome.delete(asiento2)
			null
		])	
	}
}