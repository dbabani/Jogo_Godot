extends Sprite

const PRE_PEDRA = preload("res://scenes/pedra.tscn")
var speed = 300
var instanciar = true

func _ready():
	pass

func _process(delta):
	speed += 10
	position.y += speed * delta
	
	if position.y > 500 and instanciar:
		spawn_pedra()
		instanciar = false
	
	if position.y > 800:
		queue_free()

func spawn_pedra():
	var pedra = PRE_PEDRA.instance()
	pedra.position.x = position.x
	pedra.position.y = -300
	get_parent().add_child(pedra)
