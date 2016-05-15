package ar.edu.unq.epers.test.modelo

import org.junit.Test
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.Assert
import org.junit.Before
import org.junit.Rule
import org.junit.rules.ExpectedException
import ar.edu.unq.epers.aterrizar.servicios.SistemaRegistroUsuario
import ar.edu.unq.epers.aterrizar.exception.ExceptionUsuario
import ar.edu.unq.epers.aterrizar.persistencias.RepositorioUsuarios

class TestSistemaRegistroUsuario {
	Usuario usuario
	SistemaRegistroUsuario sistemaRegistroUsuario
	RepositorioUsuarios basesDeDatos
	
	@Before
	def void setUp(){
		
		basesDeDatos = new RepositorioUsuarios()
		
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
	

	
	@Test
	def testRegistrarCodigo(){
		var expected = ""
		expected = sistemaRegistroUsuario.generarCod(usuario)
		Assert.assertTrue(expected == "cod1")
		
	}

	@Test(expected = ExceptionUsuario)
	def testLogearUnUsuarioValido(){
		sistemaRegistroUsuario.crearUsuario("juan","ejemplo","juan_08","juan_08@hotmail.com","17/02/1990","123456")
		sistemaRegistroUsuario.logear(usuario.nombreUsuario, usuario.contrasenia)
		Assert.assertTrue(usuario.logeado)
	}
	

	@Test(expected = ExceptionUsuario)
	def testValidarClaveDeUsuarioQueNoEstaRegistradoEnSistema(){	
		sistemaRegistroUsuario.validarClaveDeUsuario("Ricky_Miamee" , "falseCod")
		thrown.expectMessage("Clave invalida") 	
	}
	
	@Test
	def testCambiarContraseniaDeUnUsuarioValido(){
		sistemaRegistroUsuario.crearUsuario("nico","capo","nico2000","nicokapo@hotmail.com","17/02/2000","123456")
		var usuarioValido = basesDeDatos.selectUser("nico2000")
		//sistemaRegistroUsuario.cambiarContrasenia("hola",usuarioValido)
		//basesDeDatos.updateUser(usuarioValido)
		Assert.assertTrue(usuarioValido.contrasenia == "hola")
	}
	
	@Test(expected = ExceptionUsuario)
	def testCambiarContraseniaDeUnUsuarioInvalido(){
		sistemaRegistroUsuario.cambiarContrasenia("pepito",usuario)
		thrown.expectMessage("Usuario no existe en la BD") 	
	}
	
	@Test(expected = ExceptionUsuario) 
	def testCrearUsuarioConUnoDeSusCampoInvalido(){
		sistemaRegistroUsuario.crearUsuario(null,"ejemplo","juan_08","juan_08@hotmail.com","17/02/1990","123456")
		thrown.expectMessage("Usuario invalido") 
	}
}
		