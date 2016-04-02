package ar.edu.unq.epers.testModelo

import org.junit.Test
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.Assert
import org.junit.Before

class TestUsuario {
	
	var Usuario usuario
	@Before
	def void setUp(){
		usuario = 
		new Usuario =>[
				 	  nombre = "carlos"
					  apellido = "albar"
					  it.nombreUsuario = "c_albar"
					  email = "c_alabar@hotmail.com"
					  fechaNacimiento = "12/3/1990"
					  contrasenia = "albar"
					  logeado = false 
	]					
	}
	
	@Test(expected = Exception)
	def testCambiarContrasenia(){
		Assert.assertEquals(usuario.cambiarContrasenia("albar"),Exception)
		Assert.assertNotEquals(usuario.cambiarContrasenia("calbar"), Exception)
	}
	
	@Test
	def testValidarContrasenia(){
		Assert.assertTrue(usuario.validarContrasenia("albar"))
	}
}