package ar.edu.unq.epers.testModelo

import org.junit.Test
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.Assert

class TestUsuario {
	
	var Usuario usuario
	// new (String nombre, String apellido, String nombreUsuario, String email, String fechaNacimiento, 
	//	 String contrasenia, Boolean logeado)
	def setUp(){
		usuario = new Usuario("carlos","albar","c_albar","c_albar@hotmail.com","12/3/1990","albar",false)
	}
	
	@Test(expected = Exception)
	def testCambiarContrasenia(){
		this.setUp
		Assert.assertEquals(usuario.cambiarContrasenia("albar"),Exception)
		Assert.assertNotEquals(usuario.cambiarContrasenia("calbar"), Exception)
	}
	
	@Test
	def testValidarContrasenia(){
		this.setUp
		Assert.assertTrue(usuario.validarContrasenia("albar"))
	}
}