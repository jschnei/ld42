extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var left_wall 
var right_wall

func _ready():
	left_wall = $Floor.position.x - $Floor.region_rect.end.x/2
	right_wall = $Floor.position.x + $Floor.region_rect.end.x/2

func _process(delta):
	$Player.position.x = clamp($Player.position.x, left_wall, right_wall)
	pass
