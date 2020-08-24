extends Node

export(int) var max_health = 1
onready var health = max_health  setget set_health

signal has_no_health
signal health_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed",health)
	if health <= 0:
		emit_signal("has_no_health")

