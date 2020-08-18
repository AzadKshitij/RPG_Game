extends KinematicBody2D

var speed := Vector2.ZERO

func _ready():
	pass

func _process(delta):
	get_speed()
	move_and_collide(speed * delta)
	
func get_speed():
	var input_vector := Vector2.ZERO
	input_vector.x =  Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	input_vector.y =  Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if Input.is_key_pressed(KEY_D):
		input_vector.x = 1
	if Input.is_key_pressed(KEY_A):
		input_vector.x = -1
	if Input.is_key_pressed(KEY_W):
		input_vector.y = -1
	if Input.is_key_pressed(KEY_S):
		input_vector.y = 1
	if input_vector != Vector2.ZERO:
		speed = input_vector * 40
	else: speed = Vector2.ZERO
	
	
