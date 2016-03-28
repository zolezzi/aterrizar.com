package ar.edu.unq.epers.testPersistencia

import org.junit.Test
import org.junit.Assert
import org.junit.Before
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencias.Persistencia
import org.junit.After

class TestPersistencia {
	
	Persistencia baseDeDatos
	Usuario usuario0
	Usuario usuario1
	
	@Before
	def void setUp(){
		baseDeDatos = new Persistencia
		usuario0 = new Usuario =>[
			nombre = "Jose"
			apellido = "Garcia"
			nombreUsuario = "JGarcia2020"
			email = "jose_garcia@gmail.com"
			fechaNacimiento = "17/8/1980"
			contrasenia = "pepe"
		]
		usuario1 = new Usuario =>[
			nombre = "Juan"
			apellido = "Perez"
			nombreUsuario = "Juancito"
			email = "juancapo@yahoo.com.ar"
			fechaNacimiento = "4/1/2000"
			contrasenia = "adivinala"
		]
		
		baseDeDatos.insertUser(usuario0,1)
	}
	
	@Test
	def testInsertarUsuario(){
		
		baseDeDatos.insertUser(usuario1,2)
		
		var Usuario usuarioRegistrado = baseDeDatos.selectUser("Juancito")

		Assert.assertEquals(usuario1.getNombre,usuarioRegistrado.getNombre)
	}

	@Test
	def testActualizarUsuario(){
		
		usuario0.cambiarContrasenia("hola")
		baseDeDatos.updateUser(usuario0)
		
		var Usuario usuarioActualizado = baseDeDatos.selectUser("JGarcia2020")
		
		Assert.assertEquals(usuario0.getContrasenia,usuarioActualizado.getContrasenia)
	}
	
	@Test
	def testQuitarUsuario(){
	
		baseDeDatos.removeUser(usuario0)
		
		var Usuario usuarioQueEstabaRegistrado = baseDeDatos.selectUser("JGarcia2020")
		
		Assert.assertEquals(usuarioQueEstabaRegistrado, null)
	}
	
	@Test
	def testSeleccionarUsuarioInexistente(){
		
		Assert.assertEquals(baseDeDatos.selectUser("Don2doSombra"), null)
	}
	
	@After
	def void setDown(){
		baseDeDatos.removeUser(usuario0)
	}
}