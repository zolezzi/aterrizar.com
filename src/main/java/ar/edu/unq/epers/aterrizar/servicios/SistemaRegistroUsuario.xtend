package ar.edu.unq.epers.aterrizar.servicios

import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistencias.RepositorioUsuarios
import ar.edu.unq.epers.aterrizar.modelo.ValidadorUsuario
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import ar.edu.unq.epers.aterrizar.utils.EnviadorEmails
import ar.edu.unq.epers.aterrizar.exception.ExceptionUsuario

@Accessors
class SistemaRegistroUsuario {
	//C = nombreUsuario, V = Usuario
	EnviadorEmails enviadorEmails
	ValidadorUsuario validadorUsuario
	RepositorioUsuarios basesDeDatos
	int codigo = 0
	
	new(){
		basesDeDatos = new RepositorioUsuarios()
		validadorUsuario = new ValidadorUsuario
		validadorUsuario.basesDeDatos = this.basesDeDatos
		enviadorEmails = new EnviadorEmails()
	}
	
	def generarCod(Usuario usuario){
		codigo ++
		return "cod"+codigo.toString
	}

	def logear(String nombreUsuario, String contrasenia){
		
		var Usuario usuario
			usuario = basesDeDatos.selectUser(nombreUsuario)
			if(usuario != null && usuario.validarContrasenia(contrasenia)){
				usuario.logeado = true		
			}else{
				throw new ExceptionUsuario("No pudo conectarse al sistema")
		}		
	}
	
	def crearUsuario(String pNombre, String apellidoDeUsuario, String nombreDeUsuario,
		String emailDeUsuario, String fechaDeNacimiento, String contraseniaDeUsuario
								) throws ExceptionUsuario {
		
		var usuario = new Usuario =>[
				 	  nombre = pNombre
					  apellido = apellidoDeUsuario
					  nombreUsuario = nombreDeUsuario
					  email = emailDeUsuario
					  fechaNacimiento = fechaDeNacimiento
					  contrasenia = contraseniaDeUsuario					  
	]
		if(validadorUsuario.esUsuarioValido(usuario)){			
			usuario.codValidacion = this.generarCod(usuario)
			basesDeDatos.insertUser(usuario,0)
			this.enviarCodigo(usuario)
		}
		else {
			 throw new ExceptionUsuario ("Usuario invalido")
		}	
	}
	
	def validarClaveDeUsuario(String nombreUsuario, String clave) throws ExceptionUsuario {
		
		var usuario = basesDeDatos.selectUser(nombreUsuario)
		
		if(validadorUsuario.validarClaveDeUsuario(usuario, clave)){
			basesDeDatos.validateUser(usuario)
		}else{
			throw new ExceptionUsuario("Clave invalida")
		}
	}
	
	
	def enviarCodigo (Usuario usuario){
		enviadorEmails.enviarCodigoUsuario(usuario)
	}
	
	def cambiarContrasenia (String nuevaContrasenia, Usuario usuario) throws ExceptionUsuario {
		
		var Usuario usuarioAModificar = basesDeDatos.selectUser(usuario.nombreUsuario)
		if(usuarioAModificar == null){
			throw new ExceptionUsuario ("Usuario no existe en la BD")
		}			
		usuarioAModificar.cambiarContrasenia(nuevaContrasenia)
		basesDeDatos.updateUser(usuarioAModificar)
	}
	
}
