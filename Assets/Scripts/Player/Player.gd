extends KinematicBody2D

# Export can be seen in inspector
export var  MAXSPEED = 80
export var ACCELARATION = 500 
export var FRICTION = 500

enum {
	ROLL
	MOVE
	ATTACK
}

# variables
var speed := Vector2.ZERO
var input_vector := Vector2.ZERO
var roll_vector := Vector2.DOWN
var state = MOVE
var states = PlayerStates

const EnemyHitEffect = preload("res://Assets/Scenes/Indivitual/Effacts/EnemyHitEffect.tscn")

# Onready Variables
onready var animationPlayer = $AnimationPlayer 
onready var animationTree = $AnimationTree
onready var swardHitBox = $Position2D/SwardHitBox
onready var hurtBox = $HurtBox
onready var playerSprite = $PlayerSprite
onready var animationState = animationTree.get("parameters/playback")


func _ready():
	states.connect("has_no_health",self,"queue_free")
	swardHitBox.knockback_vector = roll_vector
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
		swardHitBox.knockback_vector = input_vector 
		speed = speed.move_toward(input_vector*MAXSPEED,ACCELARATION * delta)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", roll_vector)
		animationState.travel("Run")
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

func _on_HurtBox_area_entered(_area):
	var enemyHitEffect = EnemyHitEffect.instance()
	get_parent().add_child(enemyHitEffect)
	enemyHitEffect.global_position = global_position 
	hurtBox.start_invincibility(0.5)
	playerSprite.material
	states.health -= 1
