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

var in_game = true
var stage_clear = false
var controle = true

#pulo
#var jump_force = 1200
var jump_count = 2

func _ready():
	Sounds.play_background()
	$sprite.flip_h = true

func _process(delta):
	if position.y >= 900 and controle and in_game:
		in_game = false
		controle = false
		die()
	
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
	var dir = 0
	if controle:
		dir = Input.get_axis("left", "right")
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
	if is_on_floor() and !hit and Game.vidas > 0:
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
	if Input.is_action_just_pressed("jump") and jump_count > 0 and !hit and Game.vidas > 0 and controle:
		jump_count -= 1
		jump(1200)
		Sounds.play_jump()
		
	if is_on_floor() and dir != 0 and Game.vidas > 0 and controle:
		$smoke.emitting = true
		Sounds.play_running()
	else:
		Sounds.stop_running()
		$smoke.emitting = false
	
	#movimentação
	if Game.vidas > 0 and controle:
		velocidade = move_and_slide(velocidade,Vector2.UP,true)
	
	#animação do player quando perde todas as vidas
	if !Game.vidas > 0 and in_game:
		die()
		in_game = false
		
	if is_on_floor() and stage_clear:
		controle = false

func jump(jump_force):
	$anim.play("jump1")
	$sombra.visible = false
	velocidade.y = -jump_force
	hit = false
	
func jump2():
	$anim.play("jump2")

func is_falling():
	was_falling = false

# função para aplicar o zoom quando o player passa pela parede invisível
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
	
	if Game.coracoes > 1:
		Game.perderCoracoes()
	else:
		Game.perderVidas()
		if !Game.vidas > 0:
			Game.perderCoracoes()
		else:
			Game.resetarCoracoes()

func end_hit():
	hit = false

func die():
	$anim.play("die")
	Sounds.play_player_defeat()

func game_over():
	get_tree().change_scene("res://scenes/game_over.tscn")
	Sounds.play_game_over()
