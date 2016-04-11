package ar.edu.unq.epers.test.persistencia


import org.junit.Before
import org.junit.Test
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.servicios.SistemaRegistroUsuarioService
import org.junit.After
import ar.edu.unq.epers.aterrizar.modelo.Usuario

class TestSistemaRegistroUsuarioService {
	
	
	@Before
	def void startUp(){
		new SistemaRegistroUsuarioService().crearUsuario("Juan","Perez","juancito08","juan_08@hotmail.com","18/2/1991","juan123","cod1")
	}
	
 
	@Test
	def consultar() {
		var usuario = new SistemaRegistroUsuarioService().consultarUsuarioPor("nombreUsuario","Juancito08");
		Assert.assertEquals("Perez", usuario.getApellido());
	}

	@Test
	def modificar() {
		new SistemaRegistroUsuarioService().cambiarContraseniaDe("Juancito08","Juan1234");
		var usuario = new SistemaRegistroUsuarioService().consultarUsuarioPor("nombreUsuario","Juancito08")
		Assert.assertEquals("Perez", usuario.getApellido())
		Assert.assertEquals("Juan1234", usuario.contrasenia)
	}
	
	@After
	def void dropData(){
		new SistemaRegistroUsuarioService().eliminarUsuarioPor("nombreUsuario","Juancito08")
	}
	
	
	
}