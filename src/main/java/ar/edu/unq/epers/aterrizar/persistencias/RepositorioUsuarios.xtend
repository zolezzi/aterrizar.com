package ar.edu.unq.epers.aterrizar.persistencias

import java.sql.Connection;
import java.sql.DriverManager;
import org.eclipse.xtext.xbase.lib.Functions.Function1
import ar.edu.unq.epers.aterrizar.modelo.Usuario


class RepositorioUsuarios {
		
	boolean bValidado = false
	
	def insertUser(Usuario usuario, int validado){
		excecute[conn|
			val ps = conn.prepareStatement("INSERT INTO users (nombreusuario, nombre, apellido, email, fechanacimiento, contrasenia, validado, codvalidacion) VALUES (?,?,?,?,?,?,?,?)")
			ps.setString(1, usuario.nombreUsuario)
			ps.setString(2, usuario.nombre)
			ps.setString(3, usuario.apellido)
			ps.setString(4, usuario.email)
			ps.setString(5, usuario.fechaNacimiento)
			ps.setString(6, usuario.contrasenia)
			ps.setInt(7, validado)
			ps.setString(8, usuario.codValidacion)
			ps.execute()
			ps.close()	
			null
		]	
	}
	
	def removeUser(Usuario usuario){
		excecute[conn|
			val ps = conn.prepareStatement("DELETE FROM users WHERE nombreusuario = ?")
			ps.setString(1, usuario.nombreUsuario)
			ps.execute()
			ps.close()
			null
		]
	}
	
	def validateUser(Usuario usuario){
		excecute[conn|
			val ps = conn.prepareStatement("UPDATE users SET validado = ? WHERE nombreusuario = ?")
			ps.setInt(1, 1)
			ps.setString(2, usuario.nombreUsuario)
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
			val ps = conn.prepareStatement("SELECT * FROM users WHERE nombreUsuario = ?")
			ps.setString(1, nombreDeUsuario)
			val rs = ps.executeQuery()
			var Usuario usuario = null
			if(rs.next()){
				val nombreUsuario = rs.getString("nombreusuario")
				if(nombreUsuario == nombreDeUsuario){
					val vNombredeusuario =rs.getString("nombreUsuario")
					val vNombre = rs.getString("Nombre")
					val vApellido = rs.getString("apellido")
					val vEmail =rs.getString("email")
					val vFechadenacimiento =rs.getString("FechaNacimiento")
					val vContrasenia = rs.getString("contrasenia")
					val vCodValidacion = rs.getString("codvalidacion")
					val vValidado = rs.getInt("validado")
					
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
					  codValidacion = vCodValidacion
					]
				}		
			}
			ps.close();
			usuario 			
		] 
		
	}
	
	def <T> T excecute(Function1<Connection, T> closure){
		var Connection conn = null
		try{
			conn = this.connection
			return closure.apply(conn)
		}finally{
			if(conn != null)
				conn.close();
		}
	}
	
	def truncateUser(){
		excecute[conn|
			val ps = conn.prepareStatement("TRUNCATE TABLE users")
			ps.execute()
			ps.close()	
			null
		]	
	}

	def getConnection() {
		Class.forName("com.mysql.jdbc.Driver");
		return DriverManager.getConnection("jdbc:mysql://localhost:3306/aterrizar_schema?user=root&password=root")
	}
}