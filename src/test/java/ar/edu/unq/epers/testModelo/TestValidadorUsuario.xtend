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
		usuario = new Usuario("carlos","albar","c_albar","c_albar@hotmail.com","12/3/1990","albar",false)
		usuarioinvalido = new Usuario(null,"albar","c_albar","c_albar@hotmail.com","12/3/1990","albar",false)
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