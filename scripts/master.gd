extends KinematicBody2D

const PRE_ICONE_FUNDO = preload("res://scenes/c1_fundo.tscn")
const PRE_ICONE_FRENTE = preload("res://scenes/c1_frente.tscn")
const PRE_FRAGMENTO = preload("res://scenes/fragmento.tscn")
const GRAVIDADE = 4000
var velocidade = Vector2.ZERO #Vector2(0,0)
var speed = 300

var estado = 1 #estado 1 -> alguns comportamentos 2 -> outros comportamentos
var comportamento = 0 #idle e walk #idle, running e fury

#controlando o tempo para a troca de comportamento
var time_comportamento = 0
var ciclo = 0 #voltas do mestre de fase
var dir = -1 #definir para onde olha o mestre de fase

#interação player e master
var master_ativo = false
var hit = false
var vidas = 10

func _ready():
	randomize()
	pass

func _process(delta):
	#aplicando a gravidade
	velocidade.y += GRAVIDADE * delta
	
	if master_ativo:
		if !hit:
			if estado == 1:
				if comportamento == 0:
					idle(delta)
				if comportamento == 1:
					walk()
			else:
				if comportamento == 0:
					idle(delta)
				if comportamento == 1:
					running()
				if comportamento == 2:
					fury()
	
	if vidas < 1 and master_ativo:
		$anim.play("die")
		master_ativo = false
		$"../player".stage_clear = true
	
	#movimentação do boss
	velocidade = move_and_slide(velocidade,Vector2.UP,true)
	
	if is_on_floor():
		$sombra.visible = true
	
	if vidas <= 5:
		estado = 2
		
	exibir_coracoes_frente()

func idle(delta):
	$anim.play("idle")
	velocidade.x = 0
	time_comportamento += delta
	if time_comportamento > 5:
		time_comportamento = 0
		if estado == 1:
			comportamento = 1
		else:
			comportamento = int(rand_range(1,3))

func walk():
	$anim.play("walk")
	if ciclo < 2:
		if dir == -1:
			velocidade.x = -speed
		if dir == 1:
			velocidade.x = speed
			
		if position.x <= $"../limite_master/left".position.x:
			if dir == -1:
				dir = 1
				ciclo += 1
				flip()
		if position.x >= $"../limite_master/right".position.x:
			if dir == 1:
				dir = -1
				ciclo += 1
				flip()
	else:
		comportamento = 0
		ciclo = 0

func running():
	$anim.play("running")
	if ciclo < 2:
		if dir == -1:
			velocidade.x = -speed * 2.5
		if dir == 1:
			velocidade.x = speed * 2.5
			
		if position.x <= $"../limite_master/left".position.x:
			if dir == -1:
				dir = 1
				ciclo += 1
				flip()
		if position.x >= $"../limite_master/right".position.x:
			if dir == 1:
				dir = -1
				ciclo += 1
				flip()
	else:
		comportamento = 0
		ciclo = 0
	
func fury():
	$anim.play("fury")
	
func jump():
	velocidade.y = -1200
	$sombra.visible = false
	
func retornar_comportamento():
	comportamento = 0
	
func call_tremor():
	$"../player/anim_cam".play("shake")

func flip():
	scale.x *= -1


func _on_area_cabeca_master_area_entered(area):
	if vidas > 0:
		hitted()
		area.get_parent().jump(1200)
		if estado == 1:
			$anim.play("hit_walk")
			velocidade.x = 0
		else: #estado 2
			if comportamento == 0:
				$anim.play("hit_walk")
			else:
				$anim.play("hit_running")
				velocidade.x = 0

func hitted():
	hit = true
	vidas -= 1
	Sounds.play_impact()

func end_hit():
	hit = false


func _on_area_corpo_master_body_entered(body):
	if Game.vidas > 0:
		if vidas > 0:
			if body.position.x < position.x:
				body.hitted(-800)
			else:
				body.hitted(800)


func _on_notifier_screen_entered():
	if !master_ativo:
		for i in vidas:
			var icone1 = PRE_ICONE_FUNDO.instance()
			var icone2 = PRE_ICONE_FRENTE.instance()
			$"../hud/hbox_fundo_master".add_child(icone1)
			$"../hud/hbox_frente_master".add_child(icone2)
	master_ativo = true

func spawn_fragmento():
	fragmento()
	
func fragmento():
	for i in range(5):
		var frag = PRE_FRAGMENTO.instance()
		frag.position.x = position.x -300 * (i+1)
		frag.position.y = -300
		get_parent().add_child(frag)

func exibir_coracoes_frente():
	for i in $"../hud/hbox_frente_master".get_child_count():
		$"../hud/hbox_frente_master".get_child(i).visible = vidas > i

func sound_fury():
	Sounds.play_fury()
