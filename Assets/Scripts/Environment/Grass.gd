extends Node2D
const GrassEffect = preload("res://Assets/Scenes/Indivitual/Effacts/GrassEffect.tscn")

func instantiate_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_HurtBox_area_entered(_area):
	instantiate_grass_effect()
	queue_free()
