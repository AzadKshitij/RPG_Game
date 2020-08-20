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
var input_vector := Vector2.ZERO
var roll_vector := Vector2.RIGHT

# Onready Variables
onready var animationPlayer = $AnimationPlayer 
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


func _ready():
	animationTree.active = true

func _process(delta):
	input_vector = get_input()
	

func _physics_process(delta):
	match state:
		MOVE:
			move_player(delta)
		ROLL:
			roll()
		ATTACK:
			attack()
	
	
func move_player(delta):
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		speed = speed.move_toward(input_vector*MAXSPEED,ACCELARATION * delta)
	else:
		animationState.travel("Idle")
		speed = speed.move_toward(Vector2.ZERO,FRICTION * delta)
	
	speed = move_and_slide(speed)
	
	
func get_input():
	# Move Input
	if input_vector.y == 0:
		input_vector.x =  Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	if input_vector.x == 0:
		input_vector.y =  Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Attack Input
	if Input.is_action_pressed("ak_attack"):
		state = ATTACK
	if Input.is_action_pressed("ak_roll"):
		state = ROLL
		
	return input_vector

func attack():
	animationState.travel("Attack")

func roll():
	speed = move_and_slide(roll_vector * MAXSPEED)
	animationState.travel("Roll")
	
func change_state(num):
	state = num



















