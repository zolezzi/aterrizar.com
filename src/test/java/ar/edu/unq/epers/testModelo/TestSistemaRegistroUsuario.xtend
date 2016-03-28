package ar.edu.unq.epers.testModelo

import org.junit.Test
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.modelo.SistemaRegistroUsuario
import org.junit.Assert
import org.junit.Before

class TestSistemaRegistroUsuario {
	Usuario usuario
	SistemaRegistroUsuario sistemaRegistroUsuario
	
	@Before
	def void setUp(){
		usuario = new Usuario =>[
				 	  nombre = "Ricky"
					  apellido = "Fort"
					  nombreUsuario = "Ricky_Miamee"
					  email = "ricky_miame2002@hotmail.com"
					  fechaNacimiento = "05/11/1968"
					  contrasenia = "miameeeee"
					  logeado = false ]	
	    sistemaRegistroUsuario = new SistemaRegistroUsuario()				
	}
	
	
	@Test
	def testRegistrarCodigo(){
		var expected = ""
		expected = sistemaRegistroUsuario.generarCod(usuario)
		Assert.assertTrue(expected == "cod1")
		
	}
	
	@Test(expected = Exception)
	def testCrearUsuarioConUnoDeSusCampoInvalido(){			
		Assert.assertEquals(sistemaRegistroUsuario.crearUsuario(null,"ejemplo","juan_08","juan_08@hotmail.com","17/02/1990","123456"), Exception)		
	}

	@Test(expected = Exception)
	def testLogearUnUsuarioValido(){
		sistemaRegistroUsuario.crearUsuario("juan","ejemplo","juan_08","juan_08@hotmail.com","17/02/1990","123456")
		sistemaRegistroUsuario.logear(usuario.nombreUsuario, usuario.contrasenia)
		Assert.assertTrue(usuario.logeado == true)
	}

}