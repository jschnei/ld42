extends Node

var max_health = 5
var cur_health = max_health

var base_attack_power = 1
var bonus_attack = 0

signal death

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func take_damage(damage):
	cur_health -= damage
	if cur_health <= 0:
		emit_signal("death")