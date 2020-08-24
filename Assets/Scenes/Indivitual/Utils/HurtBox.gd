extends Area2D

var invincible = false setget set_invincible

onready var timer  = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible: emit_signal("invincibility_started")
	else: emit_signal("invincibility_ended")
		
	
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false

func _on_HurtBox_invincibility_ended():
	self.set_deferred("monitorable",false)

func _on_HurtBox_invincibility_started():
	set_deferred("monitorable",true)
