extends KinematicBody2D

# constants
const MAXSPEED = 80
const ACCELARATION = 500 
const FRICTION = 500

# variables
var speed := Vector2.ZERO

# Onready Variables
onready var animationPlayer = $AnimationPlayer 
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _process(delta):
	move_player(delta)
	
func move_player(delta):
	var input_vector := Vector2.ZERO
	if input_vector.y == 0:
		input_vector.x =  Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	if input_vector.x == 0:
		input_vector.y =  Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationState.travel("Run")
		speed = speed.move_toward(input_vector*MAXSPEED,ACCELARATION * delta)
	else:
		animationState.travel("Idle")
		speed = speed.move_toward(Vector2.ZERO,FRICTION * delta)
	speed = move_and_slide(speed)
