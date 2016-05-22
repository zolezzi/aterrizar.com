package ar.edu.unq.epers.test.persistencia.neo4j

import org.junit.Test
import ar.edu.unq.epers.aterrizar.persistencia.neo4j.RepositorioUsuariosHome
import ar.edu.unq.epers.aterrizar.modelo.Usuario
import org.junit.Before
import org.junit.Assert
import org.junit.After
import ar.edu.unq.epers.aterrizar.servicios.neo4j.GraphServiceRunner

class TestRepositorioUsuariosHome {
	
	RepositorioUsuariosHome repositorioUsuariosHome = new RepositorioUsuariosHome(GraphServiceRunner.graphDb)
	Usuario josePerez = new Usuario => [
		nombre = "José"
		apellido = "Pérez"
		nombreUsuario = "pepePérez"
	]
	Usuario juanQwerty = new Usuario => [
		nombre = "Juan"
		apellido = "Qwerty"
		nombreUsuario = "juanQwerty"
	]
	Usuario mariaLaDelBarrio = new Usuario => [
		nombre = "María"
		apellido = "Pérez"
		nombreUsuario = "maríaLDB"
	]
	Usuario jasonKrueger = new Usuario => [
		nombre = "Jason"
		apellido = "Krueger"
		nombreUsuario = "jasonKrujiente"
	]
	Usuario mafaldaArgento = new Usuario => [
		nombre = "Mafalda"
		apellido = "Argento"
		nombreUsuario = "mafeArgento"
	]
	Usuario soledadSolari = new Usuario => [
		nombre = "Soledad"
		apellido = "Solari"
		nombreUsuario = "soleSola"
	]

	@Before
	def void setUp(){

		repositorioUsuariosHome.crearNodo(josePerez)
		repositorioUsuariosHome.crearNodo(juanQwerty)
		repositorioUsuariosHome.crearNodo(mariaLaDelBarrio)
		repositorioUsuariosHome.crearNodo(jasonKrueger)
		repositorioUsuariosHome.crearNodo(mafaldaArgento)
		repositorioUsuariosHome.crearNodo(soledadSolari)

		repositorioUsuariosHome.relacionarAmistad(josePerez,juanQwerty)
		repositorioUsuariosHome.relacionarAmistad(josePerez,mariaLaDelBarrio)
		repositorioUsuariosHome.relacionarAmistad(juanQwerty,mariaLaDelBarrio)
		repositorioUsuariosHome.relacionarAmistad(mariaLaDelBarrio,jasonKrueger)
		repositorioUsuariosHome.relacionarAmistad(juanQwerty,mafaldaArgento)
		//soledadSolari no está incluida en ninguna relación de Amistad
	}

	@Test
	def testGetAmigos(){

		Assert.assertEquals(repositorioUsuariosHome.getAmigos(josePerez).size,2)
		Assert.assertEquals(repositorioUsuariosHome.getAmigos(jasonKrueger).size,1)
		Assert.assertEquals(repositorioUsuariosHome.getAmigos(soledadSolari).size,0)
	}
	
	@Test
	def testGetAmigosDeMisAmigos(){
		
		Assert.assertEquals(repositorioUsuariosHome.getAmigosDeMisAmigos(josePerez).size,4)
		Assert.assertEquals(repositorioUsuariosHome.getAmigosDeMisAmigos(jasonKrueger).size,4)
		Assert.assertEquals(repositorioUsuariosHome.getAmigosDeMisAmigos(soledadSolari).size,0)
	}
	
	@After
	def void setDown(){

		repositorioUsuariosHome.eliminarNodo(josePerez)
		repositorioUsuariosHome.eliminarNodo(juanQwerty)
		repositorioUsuariosHome.eliminarNodo(mariaLaDelBarrio)
		repositorioUsuariosHome.eliminarNodo(jasonKrueger)
		repositorioUsuariosHome.eliminarNodo(mafaldaArgento)
		repositorioUsuariosHome.eliminarNodo(soledadSolari)
	}
}