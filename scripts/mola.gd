extends Area2D


func _ready():
	pass


func _on_mola_area_entered(area):
	area.get_parent().jump(2000)
	$anim.play("mola")
