extends "res://Enemy.gd"

var direction = Vector2(1, 0)
var speed = 40

func _ready():
	direction = direction.rotated(randf()*2*PI)

func _process(delta):
	move_and_slide(speed*direction)


func _on_change_direction_timer_timeout():
	direction = direction.rotated(randf()*2*PI)
