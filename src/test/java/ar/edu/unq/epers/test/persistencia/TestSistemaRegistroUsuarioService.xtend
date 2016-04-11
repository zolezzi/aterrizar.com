package ar.edu.unq.epers.test.persistencia


import org.junit.Before
import org.junit.Test
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.servicios.SistemaRegistroUsuarioService

class TestSistemaRegistroUsuarioService {
	
	
	@Before
	def void startUp(){
		new SistemaRegistroUsuarioService().crearUsuario("Juan","Perez","juancito08","juan_08@hotmail.com","18/2/1991","juan123",1,"cod1")
	}
 
	@Test
	def consultar() {
		var usuario = new SistemaRegistroUsuarioService().consultarUsuario(1);
		Assert.assertEquals("Perez", usuario.getApellido());
	}

	@Test
	def modificar() {
		var jugador = new SistemaRegistroUsuarioService().cambiarContrasenia(1,"Juancho");
		Assert.assertEquals("Perez", jugador.getApellido())
		Assert.assertEquals("Juancho", jugador.getNombre())
	}
}