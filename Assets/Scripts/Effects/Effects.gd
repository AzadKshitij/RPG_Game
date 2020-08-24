extends AnimatedSprite

func _ready():
	connect("animation_finished",self,"_on_animation_finished")
	playing = true
	frame = 0
	play("Animate")

func _on_animation_finished():
	queue_free()
