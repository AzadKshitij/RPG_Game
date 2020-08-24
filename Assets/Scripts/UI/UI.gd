extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var emptyHeart = $HeartEmpty
onready var fullHeart = $HeartFUll

func set_hearts(value):
	hearts = clamp(value,0,max_hearts)
	if hearts%5 == 0:
		fullHeart.rect_size.x -= 15

func set_max_hearts(value):
	max_hearts = max(value,0)
#	fullHeart.rect_size.x = 15 * int(max_hearts/5)
	print(max_hearts/5)
	print(fullHeart.rect_size.x)

func _ready():
	self.max_hearts = PlayerStates.max_health
	self.hearts = PlayerStates.health
	fullHeart.rect_size.x = 15 * int(max_hearts/5)
	emptyHeart.rect_size.x = 15 * int(max_hearts/5)
	PlayerStates.connect("health_changed",self,"set_hearts")
