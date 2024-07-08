extends Control


func _ready():
	pass


func _on_start_pressed():
	get_tree().change_scene("res://scenes/fase1.tscn")


func _on_quit_pressed():
	get_tree().quit()
