extends Area2D

var pontos = 1

func _ready():
	pass


func _on_cristal_body_entered(body):
	Sounds.play_cristal()
	Game.somarPontos(pontos)
	Game.ganharVida()
	queue_free()
