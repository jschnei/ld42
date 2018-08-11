extends KinematicBody2D

export (float) var SPEED = 200
var direction = Vector2(0, -1)

func _ready():
	pass

func _process(delta):
	move_and_slide(direction*SPEED)

func _on_Timer_timeout():
	queue_free()
	
