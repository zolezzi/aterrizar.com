package ar.edu.unq.epers.aterrizar.persistencias

import java.sql.Connection;
import java.sql.DriverManager;
import org.eclipse.xtext.xbase.lib.Functions.Function1
import ar.edu.unq.epers.aterrizar.modelo.Usuario

//prueba basica de query
class Persistencia {
		
	boolean bValidado = false
	Usuario usuario
	
	def insertUser(Usuario usuario, int validado){
		excecute[conn|
			val ps = conn.prepareStatement("INSERT INTO users (nombreusuario, nombre, apellido, email, fechadenacimiento, contrasenia, validado) VALUES (?,?,?,?,?,?,?)")
			ps.setString(1, usuario.nombreUsuario)
			ps.setString(2, usuario.nombre)
			ps.setString(3, usuario.apellido)
			ps.setString(4, usuario.email)
			ps.setString(5, usuario.fechaNacimiento)
			ps.setString(6, usuario.contrasenia)
			ps.setInt(7, validado)
			ps.execute()
			ps.close()	
			null
		]	
	}
	
	
	def updateUser(Usuario usuario){
		excecute[conn|
			val ps = conn.prepareStatement("UPDATE users SET contrasenia = ? WHERE nombreusuario = ?")
			ps.setString(1, usuario.contrasenia)
			ps.setString(2, usuario.nombreUsuario)
			ps.execute()
			ps.close()	
			null
		]	
	}
	
	def Usuario selectUser(String nombreDeUsuario){
		
		excecute[conn| 
			val ps = conn.prepareStatement("SELECT iduser,nombreUsuario FROM users WHERE nombreUsuario = ?")
			ps.setString(1, nombreDeUsuario)
			val rs = ps.executeQuery()
			while(rs.next()){
				val nombreUsuario = rs.getString("nombreusuario")
				if(nombreUsuario == nombreDeUsuario){
					val vNombredeusuario =rs.getString(1)
					val vNombre = rs.getString(2)
					val vApellido = rs.getString(3)
					val vEmail =rs.getString(4)
					val vFechadenacimiento =rs.getString(5)
					val vContrasenia = rs.getString(6)
					val vValidado = rs.getInt(7)
					
					if(vValidado == 1){
						bValidado = true
					}
					usuario = new Usuario =>[
				 	  nombre = vNombre
					  apellido = vApellido
					  it.nombreUsuario = vNombredeusuario
					  email = vEmail
					  fechaNacimiento = vFechadenacimiento
					  contrasenia = vContrasenia
					  logeado = false 
	]					
				}		
			}
			
			ps.close();
			null			
		]
		return usuario
	}
	
	def void excecute(Function1<Connection, Object> closure){
		var Connection conn = null
		try{
			conn = this.connection
			closure.apply(conn)
		}finally{
			if(conn != null)
				conn.close();
		}
	}

	def getConnection() {
		Class.forName("com.mysql.jdbc.Driver");
		//modificar la ruta, para la BD nuestra
		return DriverManager.getConnection("jdbc:mysql://localhost:8889/Epers_Ej1?user=root&password=root")
	}
	
	
}