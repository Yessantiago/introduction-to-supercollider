// ===============================
//        Envolventes
// ===============================

// Crea una envolvente con 4 puntos de amplitud: [0, 0.5, 1, 0]
// Con tiempos de transición entre ellos: [0.2, 0.5, 2] segundos
Env([0, 0.5, 1, 0], [0.2, 0.5, 2]).plot


// Envolvente percusiva: ataque 0s, liberación 1s, nivel máximo 1, curva -8
Env.perc (0, 1, 1, -8).plot


// ===============================
//        SynthDef
// ===============================

// Definición de un sintetizador llamado \gallito
( 
SynthDef (\gallito, {arg freqFil = 500;

	var oscilador, lfo, filtro, salida;
	var freq = LFNoise2.kr ([20, 22, 45], 300, 600); // Genera 3 frecuencias aleatorias
	var ampl = SinOsc.kr (5, 0, 0.1);
	var env = EnvGen.kr (Env.perc (0, 1), doneAction:2); //doneAction, para eliminar el synth una vez concluida la envolvente

	oscilador = Saw.ar (freq, ampl);
	filtro = RLPF.ar (oscilador, freqFil, 0.1);
	salida = filtro * env;
	salida = Splay.ar (salida);//splay, mezcla n número de canales a salida estereo

	Out.ar (0, salida)
}).add
)



[ 1  ]       [  2  ]

         🙋🏽‍♀

[ 3  ]       [  4  ]



Synth (\gallito, [\freqFil, 8800])




(
SynthDef (\gallito2, {arg freqFil = 500;

	var oscilador, lfo, filtro, salida;
	var freq = LFNoise2.kr (20, 300, 600);
	var ampl = SinOsc.kr (5, 0, 0.1);
	var env = EnvGen.kr (Env.linen (1, 3, 5), doneAction:2);

	oscilador = Saw.ar (freq, ampl);
	filtro = RLPF.ar (oscilador, freqFil, 0.1);
	salida = filtro * env;
	salida = Pan2.ar (salida, Line.kr (-1, 1, 10)); // Paneo estereo
	Out.ar (0, salida)
}).add
)



// ===============================
//         Uso de Buffers
// ===============================

// Carga un archivo de audio desde el sistema de archivos
~buffer = Buffer.loadDialog 

~buffer.numChannels // Consulta el número de canales del buffer
~buffer.duration // Duración total del archivo en segundos

~buffer.play
~audio1 = Buffer.read (s, "/Users/.../Audios/audio1.wav")// Cargar un archivo específico

~audio1.play


// ===============================
//       PlayBuf - reproducción
// ===============================
(
// Reproduce un buffer de audio con control de velocidad y posición
x = {arg gate = 1, rate = 2;
	var sig = PlayBuf.ar (1, ~buffer, 1, Impulse.kr([10,11]), BufFrames.kr (~buffer) * MouseX.kr (0, 1), 1, doneAction: 2);
	sig * EnvGen.kr (Env.asr (0, 1, 1), gate, doneAction: 2)
}.play
)

x.set(\gate, 0) // Detiene la reproducción


// ===============================
//      GrainBuf - Granular
// ===============================
(//GrainBuf, utilizado para síntesis granular
x = { arg gate = 1;
	var sig = GrainBuf.ar (2, Impulse.kr(10), 0.1, ~buffer, 1, MouseX.kr, 2, 0, -1);
	sig * EnvGen.kr (Env.asr (5, 1, 10, [4,-4]), gate, doneAction: 2);

}.play
)

x.set (\gate, 0)

Env.asr (5, 1, 10, [4, -4]).plot // Ataque, Sustein Release


// ===============================
//         Sampler SynthDef
// ===============================

(
SynthDef (\sampler, {
	arg rate= 1, loop= 1, pos= 1, t_go= 1, gate= 0;
	var sig, env;
	sig= PlayBuf.ar (
		~buffer.numChannels,
		~buffer.bufnum,
		rate, t_go, pos, loop);
	env = EnvGen.ar (Env.asr(sustainLevel: 0.5), gate, doneAction: 2);
	Out. ar (0, sig * env)
}).add
)

j= Synth (\sampler,[\gate,1])

j.set (\rate, 1)
j.set (\pos, rrand (0,~buffer.numFrames), \t_go, 1, \rate,rrand(0.5,2))


// ===============================
//       MIDI y Mapeo
// ===============================
rrand (90, 100) // genera número aleatorios entre un rango específico


MIDIClient.init;     // Inicializa los dispositivos MIDI
MIDIIn.connectAll;   // Conecta todos los dispositivos disponibles

MIDIFunc();          // Para crear funciones asociadas a eventos MIDI
MIDIdef();           // Para definir comportamientos personalizados con nombre


// ===============================
//        Control MIDI
// ===============================

(
var notas, n;
notas= Array.newClear(127); // Array para guardar Synths por nota MIDI

MIDIFunc.noteOn({arg...msg;
	var nota;
	nota = msg[1].postIn;
	n = nota;
	notas.put( nota, Synth (\sampler,[\gate,1,\rate,nota.midiratio,
		\pos,rrand(0,~buffer.numFrames)
	]))
});


MIDIFunc.noteOff( {	arg...msg;
	var nota;
	nota=msg[1].postIn;
	notas[nota].set(\gate,0)
})
)


// ===============================
//        Fade In/Out Rústico
// ===============================

// Reproduce una onda sinusoidal con fade-in de 10 segundos
x = { SinOsc.ar(200, 0, 0.1) }.play(s, 0, 10); // (server, salida, fade-in)

// Aplica un fade-out de 10 segundos
x.release(10);


// ===============================
//      Recursos Web
// ===============================

// Abre una página de código en el navegador
"https://sccode.org".openOS;