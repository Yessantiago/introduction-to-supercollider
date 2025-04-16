1.play // Ejecuta el canal 1 de audio (puede ser un altavoz o salida específica)

ServerOptions.devices // Lista los dispositivos de entrada/salida de audio disponibles
s.options.outDevice = "ZoomAudioD" // Selecciona ZoomAudioD como salida de audio
s.options.outDevice = "OCTA-CAPTURE" // Cambia la salida de audio a OCTA-CAPTURE

s.reboot // Reinicia el servidor con la nueva configuración

s.scope // Muestra el osciloscopio para visualizar la señal de audio
EnvGen.kr(Env.linen) // Generador de envolvente en el dominio del control con forma lineal

// ===================
//      SynthDefs
// ===================
(
SynthDef(\fm, { |freq=300, freqM=50, depth=100, amp=0.2, atk=0.1, sus=1, rel=1, curve=-4, pan=0|
    // Síntesis FM simple con envolvente
    var fm = SinOsc.ar(freqM, 0, depth); // Oscilador modulador
    var sig = SinOsc.ar(freq + fm, 0, amp); // Oscilador portador modulado en frecuencia
    sig = sig * Env.linen(atk, sus, rel, 1, curve).kr(2); // Aplicar envolvente
    sig = Pan2.ar(sig, pan); // Paneo estéreo
    Out.ar(0, sig); // Enviar señal a la salida
}).add;

SynthDef(\verb, {|amp=1 mix=0.8 room=0.8 damp=0.8|
    // Efecto de reverberación
    var sig = FreeVerb.ar(In.ar(0, 2), mix, room, damp, amp);
    Out.ar(0, sig);
}).add
)

// ===================
//     Ejecutar Synths
// ===================
Synth(\fm) // Ejecutar sintetizador con parámetros por defecto
Synth(\fm, [\freq, 200, \freqM, 10, \depth, 300]) // Variar los parámetros
Synth(\fm, [\freq, 200, \freqM, 5, \depth, 4])

s.scope // Visualiza la señal nuevamente

Pgeom(1, 0.9, 10).asStream.all // Genera una secuencia geométrica decreciente
Pgeom(0.5, 1.06, 10).asStream.all // Secuencia geométrica creciente

// ===================
//     Clases clave
// ===================
SynthDef // Definición de sintetizadores
Pdef     // Definición de patrones
MIDIdef  // Definición de acciones MIDI
Tdef     // Definición de tareas
Ndef     // Definición de nodos (sintetizadores dinámicos)

// ===================
//  Patrón Pdef (\zaz)
// ===================
(
Pdef(\zaz,
	~fm = Pbind(
		\instrument, \fm,
		\scale, Scale.minor,
		\degrees, Pbrown(0, 12, 1), // Movimiento browniano en grados de escala
		\octave, Pbeta(2, 7, 0.1, 0.1, inf).round.trace, // Distribución beta de octavas
		\dur, 0.3, // Duración fija
		\freqM, Pwhite(20, 1000), // Frecuencia del modulador
		\depth, 550, // Profundidad de modulación
		\amp, Pwhite(0.3, 0.4), // Amplitud aleatoria
		\atk, 0, \sus, 0, \rel, 0.1, // Envolvente rápida
		\curve, Prand([4, 2, -4, -2], inf), // Curva aleatoria
		\pan, Pwhite(-1.0, 1.0) // Paneo aleatorio
	);
	Pfx(~fm, \verb) // Aplica efecto de reverberación
).play
)

s.meter // Muestra el medidor de nivel de audio

// ===============================
//     Otro patrón tipo FM
// ===============================
(
~fm = Pbind(
	\instrument, \fm,
	\scale, Scale.minor,
	\degree, Pbrown(0, 12, 1),
	\octave, Prand([2, 3, 4, 5], inf),
	\dur, Prand([
		Pseq([1]),
		Pseq([0.5], 2),
		Pseq([1/3], 3),
		Pseq([1/4], 4)
	], inf) / (120/60), // Conversión a tempo
	\freqM, Pwhite(20, 800),
	\depth, Pwhite(100, 600),
	\amp, Pwhite(0.1, 0.4),
	\atk, Pexprand(0.001, 0.5),
	\sus, Pexprand(0.05, 0.3),
	\rel, Pexprand(0.05, 0.6),
	\curve, Prand([0, -4, 4, -2, 2], inf),
	\pan, Pwhite(-1.0, 1.0)
);
Pfx(~fm, \verb).play;
)

// ============================
//  SynthDef (\x) más complejo
// ============================
(
SynthDef(\x, {arg freq=200, fm=120, depth=100, amp=0.2, atk=1, sus=1, rel=2, cIn=4, cOut=4, pan=0;
	var sig = SinOsc.ar(freq + SinOsc.ar(fm, 0, depth), 0, amp);
	sig = sig * Env.linen(atk, sus, rel, 1, [cIn, 0, cOut]).kr(2); // Envolvente con curva personalizada
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add
)

// Reverberación para \x
SynthDef(\verb, {|amp=1, room=1, damp| Out.ar(0, FreeVerb.ar(In.ar(0, 2), room, damp)) }).add

Synth(\x) // Ejecutar Synth \x

// =========================
// Pdef (\k) con Synth \x
// =========================
(
Pdef(\k,
	~fm = Pbind(
		\instrument, \x,
		\scale, Scale.minor,
		\degree, Pbrown(0, 12, 1),
		\octave, Prand((3..8), inf),
		\fm, Pwhite(100, 1000),
		\depth, Pwhite(30, 1000),
		\amp, Pwhite(0.1, 0.3),
		\atk, 0, \sus, 0, \rel, 0.01,
		\cIn, 4, \cOut, -8,
		\dur, 0.0625/2, // Duración corta
		\pan, Pwhite(-1.0, 1.0)
	);
	Pfx(~fm, \verb, \amp, 1, \room, 1, \damp, 0.5) // Aplica reverberación
).play
)

Pdef(\k).stop // Detiene la ejecución del patrón
