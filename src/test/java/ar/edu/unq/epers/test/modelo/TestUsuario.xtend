package ar.edu.unq.epers.test.modelo

import org.junit.Test
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.Assert
import org.junit.Before
import org.junit.Rule
import org.junit.rules.ExpectedException

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
					 ]					
	}
	
	@Rule
	public ExpectedException thrown = ExpectedException.none()
	
	@Test(expected = Exception) 
	def testCambiarContrasenia(){
		usuario.cambiarContrasenia("albar")	
		thrown.expectMessage("Contraseña invalida") 
	}
	
	@Test
	def testUsuarioCambiaContraseniaValida(){
		usuario.cambiarContrasenia("ricky")
		Assert.assertEquals(usuario.contrasenia, "ricky")	
	}

	@Test
	def testValidarContrasenia(){
		Assert.assertTrue(usuario.validarContrasenia("albar"))
	}
	

	
}
