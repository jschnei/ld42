extends KinematicBody2D

export (float) var SPEED = 200
var direction = Vector2(0, -1)

func _ready():
	pass

func _process(delta):
	var collision = move_and_collide(direction*SPEED*delta)
	if collision:
		var collider = collision.collider
		if collider.has_method("take_damage"):
			collider.take_damage($BulletStats)
		queue_free()

func _on_Timer_timeout():
	queue_free()
	
