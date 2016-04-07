package ar.edu.unq.epers.test.persistencia

import ar.edu.unq.aterrizar.servicios.SistemaRegistroUsuarioService
import org.junit.Before
import org.junit.Test
import org.junit.Assert

class TestSistemaRegistroUsuarioService {
	
	
	@Before
	def void startUp(){

		new SistemaRegistroUsuarioService().crearUsuario("Juan","Perez","juancito08","juan_08@hotmail.com","18/2/1991","juan123","cod1")
	}

	@Test
	def consultar() {
		var usuario = new SistemaRegistroUsuarioService().consultarJugador(1);
		Assert.assertEquals("Perez", usuario.getApellido());
			}
	
	@Test
	def modificar() {
		var jugador = new SistemaRegistroUsuarioService().cambiarContrasenia(1,"Juanca");
		Assert.assertEquals("Perez", jugador.getApellido())
		Assert.assertEquals("Juan", jugador.getNombre())
	}
}