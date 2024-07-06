extends KinematicBody2D

const PRE_EXPLOSION = preload("res://scenes/explosion.tscn")

const GRAVIDADE = 4000
var velocidade = Vector2.ZERO
var vel_max = 200
export(int,"left","right") var dir = 0
export(int,"type idle","type walk") var tipo = 0
var hitted = false

func _ready():
	if dir == 0: #esquerda
		$sprite.scale.x = 1
		$area_inimigo/shape.position.x = -50
		$ray.position.x = -88
	else: #direita
		$sprite.scale.x = -1
		$area_inimigo/shape.position.x = 50
		$ray.position.x = 88
	pass

func _process(delta):
	#aplicando a gravidade para o inimigo
	velocidade.y += GRAVIDADE * delta
	if tipo == 0 and !hitted: #type idle
		vel_max = 0
		$anim.play("idle")
	else: #type walk
		if $ray.is_colliding():
			if dir == 0: #esquerda
				vel_max = -200
			else: #direita
				vel_max = 200
		else:
			$ray.position.x *= -1
			if dir == 0:
				dir = 1
				$sprite.scale.x *= -1
				$area_inimigo/shape.position.x = 50
			else:
				dir = 0
				$sprite.scale.x *= -1
				$area_inimigo/shape.position.x = -50
		velocidade.x = vel_max
	if !hitted:
		velocidade = move_and_slide(velocidade, Vector2.UP, true)


func _on_area_inimigo_area_entered(area):
	area.get_parent().jump(1200)
	hitted()
	$area_inimigo.collision_layer = 1
	explosion()

#inimigo foi atingido
func hitted():
	hitted = true
	$anim.play("hit")
	Sounds.play_impact()

func explosion():
	var explosion = PRE_EXPLOSION.instance()
	explosion.emitting = true
	explosion.get_node("explosion").emitting = true
	explosion.global_position = global_position
	get_parent().add_child(explosion)

func destruir():
	queue_free()


func _on_area_inimigo_body_entered(body):
	if Game.vidas > 0:
		if body.position.x < position.x:
			body.hitted(-800)
		else:
			body.hitted(800)
