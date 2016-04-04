package ar.edu.unq.aterrizar.servicios

import java.util.HashMap
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.persistencias.RepositorioUsuarios
import ar.edu.unq.aterrizar.utils.EnviadorEmails
import ar.edu.unq.epers.aterrizar.modelo.ValidadorUsuario
import ar.edu.unq.epers.aterrizar.modelo.Usuario

@Accessors
class SistemaRegistroUsuario {
	//C = nombreUsuario, V = Usuario	
	HashMap <String,Usuario> usuarios
	EnviadorEmails enviadorEmails
	ValidadorUsuario validadorUsuario
	RepositorioUsuarios basesDeDatos
	int codigo = 0
	
	new(){
		usuarios = new HashMap<String, Usuario>()
		basesDeDatos = new RepositorioUsuarios()
		validadorUsuario = new ValidadorUsuario
		validadorUsuario.basesDeDatos = this.basesDeDatos
	}
	
	def generarCod(Usuario usuario){
		codigo ++
		return "cod"+codigo.toString
	}

	def logear(String nombreUsuario, String contrasenia){
		
		var Usuario usuario
		if(usuarios.containsKey(nombreUsuario)){
			usuario = usuarios.get(nombreUsuario)
		}else{
			usuario = basesDeDatos.selectUser(nombreUsuario)
			if(usuario != null){
				guardarUsuario(usuario)
			}
		}
		
		if(usuario != null && usuario.validarContrasenia(contrasenia)){
			usuario.logeado = true		
		}else{
			throw new Exception("No pudo conectarse al sistema")
		}		
	}
	
	def crearUsuario(String pNombre, String apellidoDeUsuario, String nombreDeUsuario, String emailDeUsuario, String fechaDeNacimiento, String contraseniaDeUsuario){
		var usuario = new Usuario =>[
				 	  nombre = pNombre
					  apellido = apellidoDeUsuario
					  nombreUsuario = nombreDeUsuario
					  email = emailDeUsuario
					  fechaNacimiento = fechaDeNacimiento
					  contrasenia = contraseniaDeUsuario					  
	]
		if(validadorUsuario.esUsuarioValido(usuario)){			
			usuario.clave = this.generarCod(usuario)
			basesDeDatos.insertUser(usuario,0)
			this.enviarCodigo(usuario)
		}
		else {
			 throw new Exception ("usuario invalido")
		}	
	}
	
	def validarClaveDeUsuario(String nombreUsuario, String clave){
		
		var usuario = basesDeDatos.selectUser(nombreUsuario)
		
		if(validadorUsuario.validarClaveDeUsuario(usuario, clave)){
			basesDeDatos.validateUser(usuario)
		}else{
			throw new Exception("Clave invalida")
		}
	}
	
	def guardarUsuario(Usuario usuario){
		usuarios.put(usuario.nombreUsuario, usuario)
	}
	
	def enviarCodigo (Usuario usuario){
		enviadorEmails.enviarCodigoUsuario(usuario)
	}
	
	def cambiarContrasenia (String nuevaContrasenia, Usuario usuario){
		
		var Usuario usuarioAModificar = basesDeDatos.selectUser(usuario.nombreUsuario)
		if(usuario == null){
			throw new Exception	("Usuario no existe en la BD")
		}			
		usuarioAModificar.cambiarContrasenia(nuevaContrasenia)
		basesDeDatos.updateUser(usuarioAModificar)
	}
	
}
