extends Node

var max_health = 5
var cur_health = max_health

var base_weakness = 1
var red_weakness = 0
var blue_weakness = 0
var green_weakness = 0

var base_attack_power = 1
var bonus_attack = 0

var red_multiplier = 0.0
var blue_multiplier = 0.0
var green_multiplier = 0.0

signal death

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func take_damage(bullet_stats):
	var damage = 0
	damage += base_weakness * bullet_stats.base_damage
	damage += red_weakness * bullet_stats.red_damage
	damage += blue_weakness * bullet_stats.blue_damage
	damage += green_weakness * bullet_stats.green_damage
	cur_health -= damage
	if cur_health <= 0:
		emit_signal("death")