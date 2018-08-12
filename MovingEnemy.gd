extends "res://Enemy.gd"

var direction = Vector2(1, 0)
var speed = 40

func _ready():
	direction = direction.rotated(randf()*2*PI)

func _process(delta):
	move_and_slide(speed*direction)
	
	# var game = get_parent()
	# position.x = clamp(position.x, game.left_wall, game.right_wall)

func set_level(level):
	$Stats.max_health = 3*level
	$Stats.cur_health = $Stats.max_health

func _on_change_direction_timer_timeout():
	direction = direction.rotated(randf()*2*PI)
