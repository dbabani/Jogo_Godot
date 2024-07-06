extends CanvasLayer

const PRE_ICONE_FUNDO = preload("res://scenes/c1_fundo.tscn")
const PRE_ICONE_FRENTE = preload("res://scenes/c1_frente.tscn")

func _ready():
	for i in Game.coracoes:
		var icone1 = PRE_ICONE_FUNDO.instance()
		var icone2 = PRE_ICONE_FRENTE.instance()
		$hbox_fundo.add_child(icone1)
		$hbox_frente.add_child(icone2)

func _process(delta):
	$txt_vidas.text = "x" + str(Game.vidas)
	$txt_pontos.text = str(Game.pontos)
	exibir_coracoes_frente()

func exibir_coracoes_frente():
	for i in $hbox_frente.get_child_count():
		$hbox_frente.get_child(i).visible = Game.coracoes > i
