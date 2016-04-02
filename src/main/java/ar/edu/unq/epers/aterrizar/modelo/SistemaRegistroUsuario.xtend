package ar.edu.unq.epers.aterrizar.modelo

import java.util.HashMap
import ar.edu.unq.epers.aterrizar.persistencias.Persistencia
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class SistemaRegistroUsuario {
	//C = nombreUsuario, V = Usuario	
	HashMap <String,Usuario> usuarios
	EnviadorEmails enviadorEmails
	ValidadorUsuario validadorUsuario
	Persistencia basesDeDatos
	int codigo = 0
	
	new(){
		usuarios = new HashMap<String, Usuario>()
		basesDeDatos = new Persistencia()
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
			throw new Exception
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
					  logeado = false 
	]
		if(validadorUsuario.esUsuarioValido(usuario)){			
			usuario.clave = this.generarCod(usuario)
			basesDeDatos.insertUser(usuario,0)
			this.enviarCodigo(usuario)
		}
		else {
			 throw new Exception  
		}	
	}
	
	def validarClaveDeUsuario(String nombreUsuario, String clave){
		
		var usuario = basesDeDatos.selectUser(nombreUsuario)
		
		if(validadorUsuario.validarClaveDeUsuario(usuario, clave)){
			basesDeDatos.validateUser(usuario)
		}else{
			throw new Exception
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
			throw new Exception	
		}			
		usuarioAModificar.cambiarContrasenia(nuevaContrasenia)
		basesDeDatos.updateUser(usuarioAModificar)
	}
	
}