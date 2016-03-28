package ar.edu.unq.epers.testModelo

import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.Test
import ar.edu.unq.epers.aterrizar.modelo.ValidadorUsuario
import org.junit.Assert

class TestValidadorUsuario {
	
	var Usuario usuario
	var Usuario usuarioinvalido
	var ValidadorUsuario validador
	
	def setUp(){
		usuario = new Usuario =>[
				 	  nombre = "carlos"
					  apellido = "albar"
					  it.nombreUsuario = "c_albar"
					  email = "c_alabar@hotmail.com"
					  fechaNacimiento = "12/3/1990"
					  contrasenia = "albar"
					  logeado = false 
	]				
	
		usuarioinvalido = new Usuario =>[
				 	  nombre = null
					  apellido = "albar"
					  it.nombreUsuario = "c_albar"
					  email = "c_alabar@hotmail.com"
					  fechaNacimiento = "12/3/1990"
					  contrasenia = "calbar"
					  logeado = false 
	]				
	
		validador = new ValidadorUsuario
		validador.guardarUsuarioAValidar("clave",usuario)
	}
	
	@Test
	def testvalidarClaveDeUsuario(){
		this.setUp()
		Assert.assertTrue(validador.validarClaveDeUsuario("clave"))
		Assert.assertFalse(validador.validarClaveDeUsuario("clave2"))
	}
	
	@Test
	def testobtenerUsuarioDeClave(){
		this.setUp()
		Assert.assertEquals(validador.obtenerUsuarioDeClave("clave"),usuario)
	}
	
	@Test
	def testesUsuarioValido(){
		this.setUp()
		Assert.assertTrue(validador.esUsuarioValido(usuario))
		Assert.assertFalse(validador.esUsuarioValido(usuarioinvalido))
	}
	
}