extends KinematicBody2D

export var ACCELERATION = 200
export var MAX_SPEED = 50
export var FRICTION = 200

const EnemyHitEffect = preload("res://Assets/Scenes/Indivitual/Effacts/EnemyHitEffect.tscn")
const EnemyDeathEffect = preload("res://Assets/Scenes/Indivitual/Effacts/EnemyDeathEffect.tscn")

onready var sprite = $"Bat Anim"
onready var states = $States
onready var PlayerDetectionZone = $PlayerDitectionZone
onready var softBosyCollision = $SoftCollision
onready var wonderController = $WonderController

enum {
	IDLE
	WONDER
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wonderController.get_time_left() == 0:
				state = choose_random_state([IDLE,WONDER])
				wonderController.start_timer(rand_range(1,3))
		WONDER:
			seek_player()
			if wonderController.get_time_left() == 0:
				state = choose_random_state([IDLE,WONDER])
				wonderController.start_timer(rand_range(1,3))
			var direction = global_position.direction_to(wonderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, FRICTION * delta)
			sprite.flip_h = velocity.x < 0
			if global_position.distance_to(wonderController.target_position) <= 4:
				state = choose_random_state([IDLE,WONDER])
				wonderController.start_timer(rand_range(1,3))
		CHASE:
			var player = PlayerDetectionZone.player 
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, FRICTION * delta)
			else : state = IDLE
	sprite.flip_h = velocity.x < 0
	
	if softBosyCollision.is_colliding():
		velocity = softBosyCollision.get_push_vector() * delta * FRICTION
	velocity = move_and_slide(velocity)

func seek_player():
	if PlayerDetectionZone.can_see_player():
		state =  CHASE

func choose_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func instantiate_grass_effect():
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position 

func _on_HurtBox_area_entered(area):
	var enemyHitEffect = EnemyHitEffect.instance()
	get_parent().add_child(enemyHitEffect)
	enemyHitEffect.global_position = global_position 
	states.health -= area.damage
	knockback = area.knockback_vector * 120

func _on_States_has_no_health():
	instantiate_grass_effect()
	queue_free()
