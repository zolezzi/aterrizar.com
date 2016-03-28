package ar.edu.unq.epers.testPersistencia

import org.junit.Test
import org.junit.Assert
import org.junit.Before
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencias.Persistencia
import org.junit.After

class TestPersistencia {
	
	Persistencia baseDeDatos
	Usuario usuario
	
	@Before
	def void setUp(){
		baseDeDatos = new Persistencia
		usuario = new Usuario =>[
			nombre = "Jose"
			apellido = "Garcia"
			nombreUsuario = "JGarcia2020"
			email = "jose_garcia@gmail.com"
			fechaNacimiento = "17/8/1980"
			contrasenia = "pepe"
		]
		
		baseDeDatos.insertUser(usuario,1)
	}
	
	@Test
	def testInsertarUsuario(){
		
		var Usuario usuarioRegistrado = baseDeDatos.selectUser("JGarcia2020")

		Assert.assertEquals(usuario.getNombre,usuarioRegistrado.getNombre)
	}
	
	@Test
	def testActualizarUsuario(){
		
		usuario.cambiarContrasenia("hola")
		baseDeDatos.updateUser(usuario)
		
		var Usuario usuarioActualizado = baseDeDatos.selectUser("JGarcia2020")
		
		Assert.assertEquals(usuario.getContrasenia,usuarioActualizado.getContrasenia)
	}
	
	@After
	def void setDown(){
		baseDeDatos.removeUser(usuario)
	}
}