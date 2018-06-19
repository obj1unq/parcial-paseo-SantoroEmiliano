//Nota 9(nueve): En general muy bien, más allá de algunos detalles. Muy buenos tests.

//1) MB-. Detalles menores
//2) MB
//3) MB- Al igual que el punto uno tiene detalles producto de la forma de armar la herencia de prendas.
//4) B Problemas al usar un atributo directamente donde las subclases necesitan redefinir comportamiento.
//5) MB
//6) MB
//7) B (delegar mejor el conocimiento de cuando un niño es pequeño)
//8) R+: La herencia de prendas y las variantes de usar con y sin parámetros no son consistentes.


class Prenda {
	var property talle = null
	var property desgaste = 0 // Este atributo está mal ubicado, porque no sirve para todas las subclases.
	var property abrigo = 1
	
	
	method comodidad(unNinio) = self.talleAdecuado(unNinio) -  self.comodidadDesgaste()

	// Por qué no es comodidadPorTalleAdecuado?	
	method talleAdecuado(ninio) = if ( talle == ninio.talle() ) {8} else {0}
	
	method comodidadDesgaste() = if (desgaste>3) {3} else { self.desgaste() }
	
	// MAL, usa un atributo "abrigo", debería ser un mensaje para que subclases puedan redefinir
	method calidad(unNinio) = self.comodidad(unNinio) + abrigo 
	
	method usar(uso){
		desgaste += uso
	}
	
}

class PrendaPar inherits Prenda {
	var property prendaIzq = null
	var property prendaDer = null
	
	method desgaste() = (prendaIzq.desgaste() + prendaDer.desgaste()) / 2
	
	override method comodidad(unNinio) = super(unNinio) - self.comodidadChiquito(unNinio)
	
	method comodidadChiquito(unNinio) = if (unNinio.edad() < 4) {1} else {0}
	
	method intercambiar(otroPar){ if (self.puedeIntercambiar(otroPar)) {self.intercambio(otroPar)}
		// Si no realiza la acción pedida, terminar con excepción.
		
	}
	
	method intercambio(otroPar) {
		//guarda la nueva prenda derecha en una variable para evitar sobreescribrila en el intercambio
		var nuevaPrenda = otroPar.prendaDer()
		otroPar.prendaDer(prendaDer)
		prendaDer = nuevaPrenda
		
		
		
	}
	
	method puedeIntercambiar(otroPar) = (talle == otroPar.talle())
	
	method abrigo() = prendaIzq.abrigo() + prendaDer.abrigo()
	
	 method usar() {
		prendaIzq.usar(0.8)
		prendaDer.usar(1.2)
		
	}
}

class PrendaLiviana inherits Prenda{
	override method comodidad(unNinio) = super(unNinio) + 2
	
	method abrigo() = abrigoLivianas.abrigo()
	
	method usar() {
		desgaste += 1
	}
}

class PrendaPesada inherits Prenda{
	method usar() {
		desgaste += 1 // Repite código
	}
	
}

class Familia {
	var property ninios = #{}
	
	method aptaSalir() = ninios.all({ninio => ninio.estaListo()})
	
	method infaltables() = ninios.map({ninio => ninio.mejorPrenda()}).asSet()
	
	method chiquitos() = ninios.filter({ninio => ninio.edad() < 4}) // Se pide que no repitas esta condición!
	
	method pasear() {
		if (self.aptaSalir()){
		ninios.forEach({ninio => ninio.salirDePaseo()}) } else 
		{self.error("No esta lista para salir")} 
	}
}

class Ninio {
	var property edad = 0
	var prendas = []
	var property talle = null
	
	// Nombres poco descriptivos: cantidadPrendas, calidadPrendas
	method estaListo() = self.cantidadPrendas() and self.tienePrendaAbrigada() and self.calidadPrendas()
	
	method cantidadPrendas() = prendas.size() >= 5
	
	method tienePrendaAbrigada() = prendas.any({prenda =>prenda.abrigo() >= 3})
	
	method calidadPrendas() = (self.calidadPrendasTotal() / prendas.size()) > 8
	
	method calidadPrendasTotal() =  prendas.sum({prenda =>prenda.calidad(self)})
	
	method mejorPrenda() = prendas.max({prenda => prenda.calidad(self)})
	
	method salirDePaseo() {
		prendas.forEach({prenda => prenda.usar()})
	}
}

class NinioProblematico inherits Ninio {
	var juguete = null
	
	override method cantidadPrendas() = prendas.size() >= 4
	
	override method estaListo() = super() and self.jugueteAcorde()

	// Sería mejor delegar en juguete.	
	method jugueteAcorde() = (edad < juguete.edadMaxima()) and (edad > juguete.edadMinima())
}

class Juguete {
	var property edadMaxima = 0
	var property edadMinima = 0
}

object abrigoLivianas {
	var property abrigo = 1
}

//Objetos usados para los talles
object xs {
}

object s {
}
object m {
	
}
object l{
	
}
object xl{
	
}