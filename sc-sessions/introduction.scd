s.boot; //enciende el server
// Supercollider es un lenguaje orientado a objetos

//Objetos generadores
Ugens

osciladores:

SinOsc //onda sinoidal
Saw // onda Diente de cierra
Pulse // onda cuadrada
LFTri // onda triangular

generadores de ruido:

WhiteNoise
PinkNoise

métodos:
.ar - audio
.kr - controlador de audio

parámetros:
//SinOsc.ar(20-2000,donde inicia el oscilador, amplitud, valor agregado a la amplitud de onda).play

agrupador de código ( ) // -> Sieve para organizar lineas que suenan al mismo tiempo

{SinOsc.ar(200,0,0.25,0)}.play;
{SinOsc.ar(400,0,0.25,0)}.play;
{SinOsc.ar(600,0,0.25,0)}.play;
{SinOsc.ar(800,0,0.25,0)}.play;



Declaración de variables:
1. Variable local:

(
{ var freq, amp;
	freq = 50;
	amp =0.7;
	Saw.ar(freq, amp)!2}.play;
)

(
{ var freq, amp;
	freq = MouseX.kr(10,1000);
	amp = SinOsc.kr(MouseY.kr(10,200),0,0.7);
	Saw.ar(freq, amp)!2}.play;
)

Objetos de control:

MouseX.kr (0,1)
MouseY.kr
MouseButton.kr


Variable global:
1. caracter unique

x = 10;
x;

2. palabra completa:

~variable = 3.5;
~variable;

// modulate numharmonics
{ Blip.ar(200,Line.kr(1,100,20),0.2) }.play;

(
b = Buffer.alloc(s, 512, 1, {arg buf; buf.sine1Msg(1.0/[1,2,3,4,5,6,7,8,9,10])});
{ COsc.ar(b.bufnum, 200, 0.7, 0.25) }.play;
)



(
r = Routine{
	//oscinadores a y b
	a = {SinOsc.ar (300, 0, SinOsc.ar (3,0,0.3))!2}.play (fadeTime:10);
	b = {SinOsc.ar (600, 0, SinOsc.ar (6,0,0.2))!2}.play (fadeTime:7);

	//chirrido
	c = {
		var m = MouseX.kr(0.1,0.9);
		Saw.ar (30, Pulse.ar(1200,m,0.1))!2}.play (fadetime:10);
	4.wait;

	d = {
		var button = MouseButton.kr (30,600);
		LFTri.ar (300, 0, SinOsc.ar(button, 0, 0.2))!2}.play (fadetime:3);

	//perc1

	e= {
		var freq = MouseY.kr (1,100);
		SinOsc.ar (300, LFTri.ar (freq, 0, 120), 0.2)}.play (fadetime:4);
	~percs = {SinOsc.ar (900, 0, Pulse.ar(4, 0.5, 0.02))!2}.play (fadetime:2);
	4.wait;

	//perc 2
	~noise = {PinkNoise.ar (Pulse.ar(2, 0.5,0.1))!2}.play (fadetime:4);
	5.wait;

	//apaga a y b, nuevo synth
	a.release(5);
	b.release(7);
	a = {SinOsc.ar(660,0, SinOsc.ar(20, 0, 0.3))!2}.play (fadetime:10);
	b = {SinOsc.ar(330, 0, SinOsc(40,0,0.2))!2}.play (fadetime:7);
	7.wait;

	//final
	a.release(5);
	b.release(6);
	c.release(4);
	d.release(8);
	e.release(10);

	~percs.release(4);
	~noise.release(3);
}
)

r.play;