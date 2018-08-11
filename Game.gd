extends Node2D

var left_wall 
var right_wall

export (float) var catchup_margin = 400

func _ready():
	left_wall = $Floor.position.x - $Floor.region_rect.end.x/2
	right_wall = $Floor.position.x + $Floor.region_rect.end.x/2

func _process(delta):
	$Player.position.x = clamp($Player.position.x, left_wall, right_wall)
	
	if $Player.position.y < $EncroachingDoom.position.y - catchup_margin:
		$EncroachingDoom.speed = $EncroachingDoom.catchup_speed
	else:
		$EncroachingDoom.speed = $EncroachingDoom.normal_speed
