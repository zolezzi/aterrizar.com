package ar.edu.unq.epers.test.modelo

import org.junit.Test
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.Assert
import org.junit.Before
import org.junit.Rule
import org.junit.rules.ExpectedException
import ar.edu.unq.epers.aterrizar.servicios.SistemaRegistroUsuario

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
					  contrasenia = "miameeeee"]	
	    sistemaRegistroUsuario = new SistemaRegistroUsuario()				
	}
	@Rule
	public ExpectedException thrown = ExpectedException.none()
	
	@Test(expected = Exception) 
	def testCrearUsuarioConUnoDeSusCampoInvalido(){
		sistemaRegistroUsuario.crearUsuario(null,"ejemplo","juan_08","juan_08@hotmail.com","17/02/1990","123456")
		thrown.expectMessage("Usuario invalido") 
	}
	
	@Test
	def testRegistrarCodigo(){
		var expected = ""
		expected = sistemaRegistroUsuario.generarCod(usuario)
		Assert.assertTrue(expected == "cod1")
		
	}

	@Test(expected = Exception)
	def testLogearUnUsuarioValido(){
		sistemaRegistroUsuario.crearUsuario("juan","ejemplo","juan_08","juan_08@hotmail.com","17/02/1990","123456")
		sistemaRegistroUsuario.logear(usuario.nombreUsuario, usuario.contrasenia)
		Assert.assertTrue(usuario.logeado)
	}
	

	@Test(expected = Exception)
	def testValidarClaveDeUsuarioQueNoEstaRegistradoEnSistema(){	
		sistemaRegistroUsuario.validarClaveDeUsuario("Ricky_Miamee" , "falseCod")
		thrown.expectMessage("Clave invalida") 	
	}
	
	@Test(expected = Exception)
	def testCambiarContraseniaDeUnUsuarioValido(){
		sistemaRegistroUsuario.cambiarContrasenia("pepito",usuario)
		Assert.assertTrue(usuario.contrasenia == "pepito")
	}
	
		@Test(expected = Exception)
	def testCambiarContraseniaDeUnUsuarioInvalido(){
		sistemaRegistroUsuario.cambiarContrasenia("pepito",usuario)
		thrown.expectMessage("Usuario no existe en la BD") 	
	}
}
		