extends Node2D

onready var start_position = global_position
onready var target_position = global_position
onready var timer = $Timer


func set_target_position():
	target_position = start_position + Vector2(rand_range(-32,32),rand_range(-32,32))

func start_timer(duration):
	timer.start(duration)

func get_time_left():
	return timer.time_left
	
func _on_Timer_timeout():
	set_target_position()































