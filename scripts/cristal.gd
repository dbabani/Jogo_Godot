extends Area2D


func _ready():
	pass


func _on_cristal_body_entered(body):
	queue_free()
