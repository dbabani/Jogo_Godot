extends KinematicBody2D

const GRAVIDADE = 4000
var velocidade = Vector2(0,0)
var vel_max = 600
var was_falling = false

#câmera
var master_room = false
var zoom = 1.2
var time = 0
var open_count = false

#câmera offset
var offset_cam = 0
var offset_max_value = 250

#player hit
var hit = false

#pulo
#var jump_force = 1200
var jump_count = 2

func _ready():
	$sprite.flip_h = true
	pass

func _process(delta):
	#movimentação da câmera
	$cam.limit_left = $"../pos_inicial".position.x
	$cam.limit_right = $"../pos_final".position.x
	
	#Aplicação da gravidade
	velocidade.y += GRAVIDADE * delta
	
	#aplicação do zoom
	if open_count:
		time += delta
		if time > 1:
			master_room = true
			$"../pos_inicial".position.x = $"../limit_left".position.x - 750
			open_count = false
#	time += delta
#	if time > 5:
#		master_room = true
#	if time > 10:
#		master_room = false
	
	if master_room:
		zoom = lerp(zoom, 1.5, 0.05)
	else:
		zoom = lerp(zoom, 1.2, 0.05)
	$cam.zoom = Vector2(zoom,zoom)
	
	#definindo direção do player
	var dir = Input.get_axis("left", "right")
	#velocidade.x = dir * vel_max
	
	#aceleração do player
	if dir != 0 and !hit:
		velocidade.x = lerp(velocidade.x, dir * vel_max, 0.1)
	else:
		if is_on_floor():
			velocidade.x = lerp(velocidade.x, 0, 0.1)
		else:
			velocidade.x = lerp(velocidade.x, 0, 0.001)
	
	#câmera offset
	if dir != 0:
		if $sprite.flip_h: #direita
			offset_cam = lerp(offset_cam, offset_max_value, 0.03)
		else: #esquerda
			offset_cam = lerp(offset_cam, -offset_max_value, 0.03)
	$cam.offset.x = offset_cam
	
	#player está no chão
	if is_on_floor() and !hit:
		$sombra.visible = true
		jump_count = 2
		
		#para onde o player olha
		if dir < 0:
			$sprite.flip_h = false
		if dir > 0:
			$sprite.flip_h = true
			
		if was_falling:
			$anim.play("jump3")
		else:
			#animação do player
			if dir != 0:
				$anim.play("running")
			else:
				$anim.play("idle")
	else:
		was_falling = true
	
	#personagem pulando
	if Input.is_action_just_pressed("jump") and jump_count > 0 and !hit:
		jump_count -= 1
		jump(1200)
		
	if is_on_floor() and dir != 0:
		$smoke.emitting = true
	else:
		$smoke.emitting = false
	
	#movimentação
	velocidade = move_and_slide(velocidade,Vector2.UP,true)
	pass

func jump(jump_force):
	$anim.play("jump1")
	$sombra.visible = false
	velocidade.y = -jump_force
	hit = false
	
func jump2():
	$anim.play("jump2")

func is_falling():
	was_falling = false


func _on_limit_left_body_entered(body):
	if body.name == "player":
		open_count = true
	pass # Replace with function body.

func hitted(force):
	hit = true
	$anim.play("hit")
	velocidade.x = force
	velocidade.y = -800
	$sombra.visible = false

func end_hit():
	hit = false
