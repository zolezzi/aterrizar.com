package ar.edu.unq.epers.persistencias

import java.sql.Connection;
import java.sql.DriverManager;
import org.eclipse.xtext.xbase.lib.Functions.Function1
import ar.edu.unq.epers.aterrizar.modelo.Usuario

//prueba basica de query
class Persistencia {
	//new Usuario(nombre,apellido,nombreDeUsuario,email,fechaDeNacimiento,contrasenia,false)
		
	boolean bValidado = false
	Usuario usuario
	
	def InsertUser(String nombre, String apellido, String nombreDeUsuario, String email, String fechaDeNacimiento, String contrasenia, int validado){
		excecute[conn|
			val ps = conn.prepareStatement("INSERT INTO users (nombreusuario, nombre, apellido, email, fechadenacimiento, contrasenia, validado) VALUES (?,?,?,?,?,?,?)")
			ps.setString(1, nombreDeUsuario)
			ps.setString(2, nombre)
			ps.setString(3, apellido)
			ps.setString(4, email)
			ps.setString(5, fechaDeNacimiento)
			ps.setString(6, contrasenia)
			ps.setInt(7, validado)
			ps.execute()
			ps.close()	
			null
		]	
	}
	
	def SelectUser(String nombreDeUsuario){
		
		excecute[conn| 
			val ps = conn.prepareStatement("SELECT iduser,nombreUsuario FROM users WHERE nombreUsuario = ?")
			ps.setString(1, nombreDeUsuario)
			val rs = ps.executeQuery()
			while(rs.next()){
				val nombreUsuario = rs.getString("nombreusuario")
				if(nombreUsuario == nombreDeUsuario){
					val nombredeusuario =rs.getString(1)
					val nombre = rs.getString(2)
					val apellido = rs.getString(3)
					val email =rs.getString(4)
					val fechadenacimiento =rs.getString(5)
					val contrasenia = rs.getString(6)
					val validado = rs.getInt(7)
					
					if(validado == 1){
						bValidado = true
					}
					usuario = new Usuario(nombre,apellido,nombredeusuario,email,fechadenacimiento,contrasenia,bValidado);					
				}		
			}
			
			ps.close();
			usuario
		]
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
		return DriverManager.getConnection("jdbc:mysql://localhost:8889/Epers_Ej1?user=root&password=root")
	}
	
	
}