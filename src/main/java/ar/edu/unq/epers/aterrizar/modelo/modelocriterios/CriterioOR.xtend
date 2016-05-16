package ar.edu.unq.epers.aterrizar.modelo.modelocriterios
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.epers.aterrizar.modelo.modelocriterios.CriteriosCompuestos

@Accessors
class CriterioOR extends CriteriosCompuestos{
	
	new(Criterios izquierda, Criterios derecha) {
		super(izquierda, derecha)
	}
	
	def override darQuery(){
		izq.darQuery() + " or " + der.darQuery()
	}
	
}