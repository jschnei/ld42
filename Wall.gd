extends StaticBody2D

var strength = 1

func _ready():
	pass

func weaken_wall():
	strength -= 1
	if strength == 0:
		queue_free()
		

func doomify():
	queue_free()