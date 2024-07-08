extends CanvasLayer

func _on_button_retry_pressed():
	get_tree().change_scene("res://scenes/fase1.tscn")
	Game.resetar()
	Sounds.stop_game_over()
