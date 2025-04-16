s.boot;
// ===============================
//           Funciones
// ===============================

(
f = { arg x;
	var resultado;
	resultado = x + 2;
	("El resultado es:" + resultado).postln;
};
)

// Paso de argumentos a la función
f.value(7);





// ===============================
//      UGen - Unit Generator
// ===============================

// Abrir un video con información adicional
"https://www.youtube.com/watch?v=0h-RhyopUmc".openOS;

// ----------- SISTEMA MONO -------------
{ SinOsc.ar(300, 0, 0.2) ! 2 }.play;
// !2: duplica el canal (izq y der)

// Parámetros:
// mul → volumen
// add → valor constante añadido a la señal

// Envío manual a la salida (canal 0)  → salida de audio
{ Out.ar(0, SinOsc.ar(300, 0, 0.2)) }.play;

// SinOsc con envolvente añadida a la amplitud
{ SinOsc.ar(432, 0, 100, 500) }.plot;



// ----------- SISTEMA ESTÉREO -----------

{ SinOsc.ar([300, 307], 0, 0.2) ! 2 }.play;
// [Izquierda, Derecha]

// Abre osciloscopio del servidor
s.scope;

// Muestras por bloque (útil para conocer latencia)
s.sampleRate / 64;

// Salidas en Out.ar:
// 0 = canal izquierdo
// 1 = canal derecho
// 2+ = más canales si hay


// ===============================
//         Formas de onda
// ===============================

{ Saw.ar([350, 600], 0.25, 0.1) ! 2 }.play;
{ Pulse.ar([200, 40], 0.2, 0.2, 0) ! 2 }.play;

// UGen básicos:
Saw.ar();    // Diente de sierra
Pulse.ar();  // Pulso/cuadrada
LFTri.ar();  // Triangular de baja frecuencia



// ===============================
//             Filtros
// ===============================

// Tipos disponibles:
LPF;   // Pasa bajos
HPF;   // Pasa altos
BPF;   // Pasa banda
RLPF;  // Pasa bajos con resonancia


// ===============================
//             Ejemplos
// ===============================
(
{
	var oscilador, lfo, filtro;
	var freq = LFNoise2.kr ([20, 22], 300, 600);
	var ampl = SinOsc.kr ( 5, 0, 0.1);
	oscilador = Saw.ar (freq, ampl);
//	filtro = LPF.ar (oscilador, MouseX.kr(100, 2000).poll);
//	filtro = BPF.ar (oscilador, MouseX.kr(100, 2000).poll, 0.1);
	filtro = RLPF.ar (oscilador, MouseX.kr(100, 2000).poll, 0.1);
	filtro
}.play
)


(
{
    var osc1, osc2, osc3, lfo, filtro, mezcla;
    var freq = LFNoise2.kr([20, 22], 300, 600); // Generador de frecuencias caóticas
    var ampl = SinOsc.kr(5, 0, 0.1); // LFO de amplitud (sin cambios)

    // Osciladores modificados (misma amplitud pero con variaciones):
    osc1 = Saw.ar(freq, ampl); // Oscilador base (sin cambios)
    osc2 = Pulse.ar(freq * 0.99, width: 0.3, mul: ampl * 0.7); // Pulso con ancho estrecho
    osc3 = SinOsc.ar(freq * 1.01, 0, ampl * 0.5); // Sinusoidal suavizante

    // Mezcla de osciladores (sin aumentar volumen total):
    mezcla = Mix([osc1 * 0.4, osc2 * 0.3, osc3 * 0.3]);

    // Filtro dinámico (sin cambios en el volumen):
    filtro = RLPF.ar(
        mezcla,
        MouseX.kr(100, 2000).poll, // Control con ratón
        MouseY.kr(0.01, 0.5).poll   // Ancho de banda controlado por eje Y
    );

    filtro = Balance2.ar(filtro[0], filtro[1], 0); // Estéreo equilibrado
    filtro * 1.0 // Aseguramos que no hay ganancia de volumen
}.play;
)

(
{
	var oscilador, lfo, filtro;
	var freq = LFNoise2.kr ([20, 23], 80, 500);
	var ampl = SinOsc.kr (MouseY.kr (0,20) , 0, 0.1);
	oscilador = Saw.ar (freq, ampl);
//	filtro = LPF.ar (oscilador, MouseX.kr(100, 2000).poll);
//	filtro = BPF.ar (oscilador, MouseX.kr(100, 2000).poll, 0.1);
	filtro = RLPF.ar (oscilador, MouseX.kr(100, 2000).poll, 0.1);
	filtro
}.play
)


//Ejemplo 
(
{
	var oscilador, lfo, filtro;
	var freq = LFNoise1.kr ([20,30]).range(400, 700);
	var ampl = SinOsc.kr ( 5,10,freq);
	oscilador = Pulse.ar (freq, ampl,0.5,1);//cuando se utiliza kr mul seria el rango y hay que tener cuidado porque actua como volumen/amplitud
	//filtro = LPF.ar (oscilador, MouseX.kr(100, 2000).poll);
	//filtro = BPF.ar (oscilador, MouseX.kr(100, 2000).poll,0.1);
	filtro = RLPF.ar (oscilador, MouseX.kr(100, 2000).poll,0.01);
	filtro
}.play
)

// ===============================
//        Modulación en anillo
// ===============================

// Ejemplos de combinaciones matemáticas:
// a * b                           → a * b
// (a * b) + a                     → a ring1: b
// (a * b) + a + b                 → a ring2: b
// a * a * b                       → a ring3: b
// (a * a * b) - (a * b * b)       → a ring4: b


Phasor
Sweep

// ----------- EJEMPLO DE MODULACIÓN EN ANILLO CON INPUT -----------

{ SoundIn.ar(0) }.play;

(
{
	var a, b;
	a = SoundIn.ar(0); // Entrada del micrófono
	b = SinOsc.ar(MouseX.kr(1, 1000).poll, 0, 0.7); // Oscilador portadora

	(a ring4: b) * 0.3 ! 2; // Efecto de ring modulation estéreo
}.play;
)
