extends Node

var vidas = 1
var coracoes = 5
var pontos = 0
var meta = 10

func somarPontos(valor):
	pontos += valor

func resetarPontos():
	pontos = 0
	
func perderVidas():
	vidas -= 1

func perderCoracoes():
	coracoes -= 1

func resetarCoracoes():
	coracoes = 5

func resetar():
	vidas = 3
	pontos = 0
	coracoes = 5

func ganharVida():
	if pontos >= meta:
		vidas += 1
		meta += 10
