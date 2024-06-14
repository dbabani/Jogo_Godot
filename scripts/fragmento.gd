extends Sprite

var speed = 300

func _ready():
	pass

func _process(delta):
	speed += 10
	position.y += speed * delta
	
	if position.y > 800:
		queue_free()
