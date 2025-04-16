s.boot

(
// ===============================
//        Talea y Color
// ===============================
// Combinación de un patrón melódico (color) y un patrón rítmico (talea),

Pbind(
    // Patrón melódico (color): una secuencia de alturas en semitonos relativos
    \note, Pseq([0, 3, 7, 8, -1], inf),

    // Patrón rítmico (talea): una secuencia de duraciones (en beats)
    \dur, Pseq([1, 0.5, 0.5, 1], inf)
).play;
)


// ===============================
//        Tonal / Serialismo
// ===============================

// Genera una permutación aleatoria del total cromático (0 a 11)
// Esto es útil para ver una serie dodecafónica (12 tonos sin repetir)
Pshuf((..11)).asStream.all;  // Ejecuta y muestra una permutación completa en consola



(
// ====================================
//  Serialismo Aleatorio con Pbind
// ===================================
// Se generan dos permutaciones aleatorias del total cromático (12 notas),
// luego se repiten indefinidamente con duración constante.
// Esto simula una técnica serial.

// Pshuf((..11), 2) → dos permutaciones del total cromático
// Pn(..., inf) → se repiten infinitamente
// .trace → muestra en consola las notas generadas

Pbind(
    \note, Pn(Pshuf((..11), 2), inf).trace,
    \dur, 0.2  // Duración fija de cada nota
).play;
)


(
Pbind (
	\note, Pwrand([0,2,4,5,7,9,11],[0.4,0.05,0.2,0.05,0.2,0.05, 0.05], inf).trace, //'.trace' imprime el valor en la terminal
	\dur, 0.25
).play
)


// ===========================
//    Generación de acordes
// ===========================

(
Pbind(
	\note, Prand([[0,4,7], [4,7,9,12], [2,5,6,11]],inf),
	\dur, 1,
	\amp, 0.1,
	\octave, 4
).play
)

// ===========================
//     Ejercicio: Scale
// ===========================

// Scale -> Objeto con un acervo de escalas.


Scale.openCodeFile; //Abre el código fuente para ver todo el acervo de las escalas.

(
Pbind(
	\scale, Scale.hungarianMinor,
	\degree, Prand ([[0,2,4],[4,6,0],[2,6,7],0,1,2,3,4,5,6,7], inf).trace,
	\dur, 0.2 //Es recomendable variar la duración para hacer ritmos.
).play
)


// =================================
//         Funciones Estocásticas
// ================================

// Aleatoriedad estocástica: se generan valores aleatorios controlados usando
// SuperCollider ofrece objetos como Prand, Pwrand, Pwhite, etc. para crear
// secuencias aleatorias con distintas propiedades estadísticas.
// Estos permiten controlar el comportamiento del azar en patrones musicales.

Pn(Pshuf())

Pshuf ([0,1,2,3,4,5,6,7,8,9,10,11])

Pshuf((..11)).asStream.all

Pwhite(0,1,200).asStream.all.plot //plot sirve para gráficar
// Presionar la tecla 'M' en la ventana de la gráfica cambia el tipo de visualización (línea, barras, puntos, etc.)

Pexprand(length:200).asStream.all.plot
Pgauss(0,1,200).asStream.all.plot
Pbrown(0,10,1,200).asStream.all.plot
Pbeta(0,1,0.1,0.1,200).asStream.all.plot

Pwrand
Prand


(
Pbind(
	\scale, Scale.minor,
	//\degree, Pbrown (0,7,1,inf),
	//\degree, Pwhite (0,7).trace,
	//\degree, Pgauss (5,10,inf).round.trace, //suena cul xd
	\degree, Pbeta(0,12,0.1,0.1).round.trace,
	\dur, 0.25
).play
)




