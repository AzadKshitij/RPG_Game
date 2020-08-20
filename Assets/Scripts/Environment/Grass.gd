extends Node2D
onready var GrassEffect = load("res://Assets/Scenes/Indivitual/Effacts/GrassEffect.tscn")

func instantiate_grass_effect():
	var grassEffect = GrassEffect.instance()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_HurtBox_area_entered(area):
	instantiate_grass_effect()
	queue_free()
