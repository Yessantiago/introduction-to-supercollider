
Patrones:


Patterns -> Secuenciador

Funcionan con los objetos.

Pattern

s.boot
//s.options.outDevices
//ServerOptions.outDevices -> Para seleccionar correctamente los dispositivos con el nombre
// s.options.outDevices = "nombre"

Prand -> otro patron XD

(
Pbind(
	\note, Pseq([0,2,4,5,7,9,11,12]) //secuencia de notas
).play
)

(
Pbind(
	\note, Pseq([0,2],2) //(secuencia, repetición)
).play
)

(
Pbind(
	\note, Pseq([0, Pseq[9,8,7],])
).play
)


//silencios
(
Pbind(
	\note, Pseq([0, \, 2],2)
).play
)

métodos

//reverso
[0,2,4,0].reverse

//desorden random
[0,2,4,0].scramble



// ********* EJERCICIO MARTINILLO *****

(
~velocidad = 0.25;

a = Pbind(
	//notas
	\note, Pseq([
		Pseq([0,2,4,0].scramble,2), //1 y 2 compas
		Pseq([4,5,7].scramble,2), //3 y 4 compas
		Pseq([7,9,7,5,4,0].scramble,2), //5 y 6
		Pseq([0,-5,0].scramble,2) //7 y 8
	]),

	//duracion de las notas
	\dur, Pseq([
		Pseq([1,1,1,1],2), //1 y 2 compas
		Pseq([1,1,2],2), //3 y 4 compas
		Pseq([0.5,0.5,0.5,0.5,1,1],2), //5 y 6 compas
		Pseq([1,1,2],2) //7 y 8 compas
	])*(1*~velocidad),

	\octave, Prand([5,6,4], inf), //inf = infinito //se reproduce el numero menor

	\amp, Pwhite(0.2, 0.5) //va de 0 a 1 -> Pwhite genera numero aleeatorio en rangos
);

Routine{
	2.do{
		a.play;
		(8*~velocidad).wait;
		a.play;
		(8*~velocidad).wait;
		a.play;
		(8*~velocidad).wait;
		a.play;
	}
}.play
)


// ***** Objetos

Array.fib(10, 0,1);




