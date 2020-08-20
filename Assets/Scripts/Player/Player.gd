extends KinematicBody2D

# constants
const MAXSPEED = 80
const ACCELARATION = 500 
const FRICTION = 500

enum {
	ROLL
	MOVE
	ATTACK
}

var state = MOVE

# variables
var speed := Vector2.ZERO

# Onready Variables
onready var animationPlayer = $AnimationPlayer 
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


func _ready():
	animationTree.active = true


func _process(delta):
	match state:
		MOVE:
			move_player(delta)
		ROLL:
			roll(delta)
		ATTACK:
			attack(delta)
			
	
	
	
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
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		speed = speed.move_toward(input_vector*MAXSPEED,ACCELARATION * delta)
	else:
		animationState.travel("Idle")
		speed = speed.move_toward(Vector2.ZERO,FRICTION * delta)
	
	speed = move_and_slide(speed)
	
	
	if Input.is_action_pressed("ak_attack"):
		state = ATTACK

func attack(delta):
	animationState.travel("Attack")

func roll(delta):
	pass
	
func change_state(num):
	state = num
