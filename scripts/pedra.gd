extends Area2D

var speed = 300

func _ready():
	pass

func _process(delta):
	speed += 10
	position.y += speed * delta
	
	if position.y > 800:
		queue_free()


func _on_pedra_body_entered(body):
	if body.position.x < position.x:
		body.hitted(-800)
	else:
		body.hitted(800)
