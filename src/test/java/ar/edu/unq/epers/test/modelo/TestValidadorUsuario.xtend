package ar.edu.unq.epers.test.modelo

import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.Test
import ar.edu.unq.epers.aterrizar.modelo.ValidadorUsuario
import org.junit.Assert
import org.junit.Before
import ar.edu.unq.epers.aterrizar.persistencias.RepositorioUsuarios
import org.junit.After

class TestValidadorUsuario {
	
	var Usuario usuario
	var Usuario usuarioinvalido
	var ValidadorUsuario validador
	
	@Before
	def void setUp(){
		usuario = new Usuario =>[
				 	  nombre = "carlos"
					  apellido = "albar"
					  it.nombreUsuario = "c_albar_j"
					  email = "c_alabar@hotmail.com"
					  fechaNacimiento = "12/3/1990"
					  contrasenia = "albar"
					  codValidacion = "cod01" 
	]				
	
		usuarioinvalido = new Usuario =>[
				 	  nombre = null
					  apellido = "albar"
					  it.nombreUsuario = "c_albar_j"
					  email = "c_alabar@hotmail.com"
					  fechaNacimiento = "12/3/1990"
					  contrasenia = "calbar"
					  codValidacion = "codNaN"
	]				
	
		validador = new ValidadorUsuario
		validador.basesDeDatos = new RepositorioUsuarios
		validador.guardarUsuarioAValidar(usuario, 0)
	}
	
	@Test
	def testvalidarClaveDeUsuario(){
		Assert.assertTrue(validador.validarClaveDeUsuario(usuario,"cod01"))
		Assert.assertFalse(validador.validarClaveDeUsuario(usuario,"clave2"))
	}
	
	@Test
	def testesUsuarioValido(){
		Assert.assertTrue(validador.esUsuarioValido(usuario))
		Assert.assertFalse(validador.esUsuarioValido(usuarioinvalido))
	}
	
	@After
	def void dropUser(){
		new RepositorioUsuarios().removeUser(usuario)
	}
}
