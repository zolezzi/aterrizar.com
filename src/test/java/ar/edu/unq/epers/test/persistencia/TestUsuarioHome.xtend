package ar.edu.unq.epers.test.persistencia

import org.junit.Before
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.persistencia.home.UsuarioHome
import org.junit.Test
import org.junit.Assert
import ar.edu.unq.epers.aterrizar.persistencia.home.SessionManager
import org.junit.After

class TestUsuarioHome {
	
	var Usuario usuario
	var Usuario usuario2
	var Usuario compareUsuario
	var usuarioHome = new UsuarioHome
	
	@Before
	def void startUp(){
		usuario = 
		new Usuario =>[
				 	  nombre = "carlos"
					  apellido = "albar"
					  it.nombreUsuario = "c_albar"
					  email = "c_alabar@hotmail.com"
					  fechaNacimiento = "12/3/1990"
					  contrasenia = "albar" 
					  codValidacion = "codTst"
					 ]
		usuario2 = 	new Usuario =>[
				 	  nombre = "carlos"
					  apellido = "albar"
					  it.nombreUsuario = "c2_albar"
					  email = "c_alabar@hotmail.com"
					  fechaNacimiento = "12/3/1990"
					  contrasenia = "albar" 
					  codValidacion = "cod2Tst"
					 ]							
		
	}
	
	@Test
	def guardarUsuario(){
		SessionManager.runInSession([
			 usuarioHome.save(usuario)
			 compareUsuario = usuarioHome.get(usuario.id)
			 null
		])
		Assert.assertEquals(usuario,compareUsuario)
	}
	
	@Test
	def void borrarUsuario(){
		SessionManager.runInSession([			 
			 usuarioHome.save(usuario)
			 usuarioHome.save(usuario2)
			 usuarioHome.delete(usuario2)
			 var result = usuarioHome.get(usuario2.id)
			 Assert.assertEquals(result,null)
			 null
		])
		
	}
	
	@After
	def void dropData(){
		SessionManager.runInSession([
			usuarioHome.delete(usuario)
			null
		])	
	}
}