extends KinematicBody2D

export (float) var normal_speed = 30
export (float) var catchup_speed = 95

var speed = normal_speed

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	var collision = move_and_collide(Vector2(0, -speed)*delta)
	if collision:
		var collider = collision.collider
		if collider.has_method("doomify"):
			collider.doomify()
		else:
			collider.queue_free()